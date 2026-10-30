
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import SwiftData

@Observable final class CellsState {

    typealias SELF = CellsState

    static public private(set) var shared: CellsState!

    public private(set) var isAuditInProgress = false
    public private(set) var auditProgress: Double = 0
    public private(set) var auditReport: [String] = []
    public private(set) var data = CellsDataSource()

    private var profileID: ProfileID

    @ObservationIgnored public var isEmpty: Bool {
        self.data.isEmpty
    }

    private init(profileID: ProfileID) {
        self.profileID = profileID
        self.reload()
    }

    static func initShared(profileID: ProfileID) -> SELF {
        if let shared = SELF.shared { return shared }
        let state = SELF(profileID: profileID)
        SELF.shared = state
        return state
    }

    static func initMock(profileID: ProfileID) -> SELF {
        SELF(profileID: profileID)
    }

    func reload() {
        self.data = CellValue.modelSelect(
            profileID: self.profileID
        )
    }

    func getProfileID() -> ProfileID {
        self.profileID
    }

    func setProfileID(_ profileID: ProfileID) {
        self.profileID = profileID
        self.reload()
    }

    func selectCellValue(_ cellID: CellIDValue) -> CellValue? {
        self.data[cellID]
    }

    func insertCellValue(_ cellID: CellIDValue, _ cellValue: CellValue) {
        switch cellValue {
            case .main, .mini:
                self.data[cellID] = cellValue
                Task {
                    _ = cellValue.modelInsert(cellID, self.profileID)
                }
        }
    }

    func deleteCellValue(_ cellID: CellIDValue) {
        self.data[cellID] = nil
        Task {
            _ = CellValue.modelDelete(cellID, self.profileID)
        }
    }

    func insertAppValue(_ cellID: CellIDValue, _ appValue: AppValue, to keyPath: CellValuePath? = nil) {
        if let keyPath {
            switch self.selectCellValue(cellID) {
                case .none, .main:
                    self.insertCellValue(
                        cellID, .mini(
                            .init(keyPath: keyPath, value: appValue)
                        )
                    )
                case .mini(var miniGrid):
                    miniGrid[keyPath: keyPath] = appValue
                    self.insertCellValue(
                        cellID, .mini(miniGrid)
                    )
            }
        } else {
            self.insertCellValue(
                cellID, .main(appValue)
            )
        }
    }

    func deleteAppValue(_ cellID: CellIDValue, from keyPath: CellValuePath? = nil) {
        if let keyPath {
            if case .mini(var miniGrid) = self.selectCellValue(cellID) {
                miniGrid[keyPath: keyPath] = nil
                if (miniGrid.isEmpty)
                     { self.deleteCellValue(cellID) }
                else { self.insertCellValue(cellID, .mini(miniGrid)) }
            }
        } else {
            self.deleteCellValue(cellID)
        }
    }

    /* ############# */
    /* ### audit ### */
    /* ############# */

    func audit() {
        Task {
            let process: () async -> Void = {
                for await result in AuditSequence(profileID: self.profileID) {
                    switch result.pair.cellValue {

                        case .main(let appValue):
                            self.auditReport.insert(
                                "#\(result.pair.cellID): \(appValue.name)", at: 0
                            )

                        case .mini(let miniGrid):
                            var appNames: [String] = []
                            if let appValue = miniGrid.cell1 { appNames.append(appValue.name) }
                            if let appValue = miniGrid.cell2 { appNames.append(appValue.name) }
                            if let appValue = miniGrid.cell3 { appNames.append(appValue.name) }
                            if let appValue = miniGrid.cell4 { appNames.append(appValue.name) }
                            if (!appNames.isEmpty) {
                                self.auditReport.insert(
                                    "#\(result.pair.cellID): \(appNames.joined(separator: ", "))", at: 0
                                )
                            }

                    }
                    Logger.customLog(
                        "Audit process (\(result.i) from \(result.count) | " +
                        "\(Int(result.progress * 100))%) " +
                        "for cell with ID = \"\(result.pair.cellID)\" was done"
                    )
                    await MainActor.run {
                        self.auditProgress = result.progress
                    }
                }
            }

            await MainActor.run {
                self.isAuditInProgress = true
                self.auditProgress = 0
                self.auditReport.removeAll()
            }

            async let processResult: Void = await process()
            async let reliableDelay: Void = await Task.sleep(
                nanoseconds: 2_000_000_000
            )

            let _ = try? await (
                processResult,
                reliableDelay
            )

            await MainActor.run {
                self.isAuditInProgress = false
                self.auditReport.removeAll()
                self.reload()
            }
        }
    }

    /* ################# */
    /* ### Drag&Drop ### */
    /* ################# */

    func onDrag(_ cellID: CellIDValue, from keyPathFrom: CellValuePath? = nil) -> NSItemProvider {
        NSItemProvider(
            object: AppDragValue(
                cellID: cellID,
                keyPath: keyPathFrom
            )
        )
    }

    func onDrop(_ cellID: CellIDValue, _ providers: [NSItemProvider], to keyPathTo: CellValuePath? = nil) -> Bool {
        if let provider = providers.first {
            provider.loadItem(forTypeIdentifier: "public.item", options: nil) { (item, error) in
                if let error = error {
                    Logger.customLog("onDropApp error: \(error.localizedDescription)")
                    return
                }
                Task { @MainActor in
                    if let appURL = item as? URL {
                        if let appValue = AppValue(appURL) {
                            self.insertAppValue(cellID, appValue, to: keyPathTo)
                        }
                    }
                }
            }
            provider.loadObject(ofClass: AppDragValue.self) { object, error in
                if let error = error {
                    Logger.customLog("onDropApp error: \(error.localizedDescription)")
                    return
                }
                Task { @MainActor in
                    if let appDragValue = object as? AppDragValue {
                        if let cellValueFrom = self.selectCellValue(appDragValue.cellID) {
                            switch appDragValue.from {
                                case .`mini_#1`, .`mini_#2`, .`mini_#3`, .`mini_#4`:
                                    if case .mini(var miniGridFrom) = cellValueFrom {
                                        if let keyPathFrom = appDragValue.keyPathFrom {
                                            if let appValueFrom = miniGridFrom[keyPath: keyPathFrom] {
                                                miniGridFrom[keyPath: keyPathFrom] = nil
                                                if (miniGridFrom.isEmpty)
                                                     { self.deleteCellValue(appDragValue.cellID) }
                                                else { self.insertCellValue(appDragValue.cellID, .mini(miniGridFrom)) }
                                                self.insertAppValue(cellID, appValueFrom, to: keyPathTo)
                                            }
                                        }
                                    }
                                case .`main_#0`:
                                    if case .main(let appValueFrom) = cellValueFrom {
                                        self.deleteCellValue(appDragValue.cellID)
                                        self.insertAppValue(cellID, appValueFrom, to: keyPathTo)
                                    }
                            }
                        }
                    }
                }
            }
            return true
        }
        return false
    }

}
