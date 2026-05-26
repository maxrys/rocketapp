
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import SwiftData

@Observable final class CellsState {

    typealias SELF = CellsState

    public static var shared: CellsState!
    public private(set) var isAuditInProgress = false
    public private(set) var auditProgress: Double = 0
    public private(set) var auditReport: [String] = []

    private var profileID: ProfileID
    private var cache = CellsDataSource()

    @ObservationIgnored public var data: CellsDataSource { self.cache }
    @ObservationIgnored public var isEmpty: Bool { self.cache.isEmpty }

    private init(profileID: ProfileID) {
        self.profileID = profileID
        self.reloadCache()
    }

    static func initShared(profileID: ProfileID) -> SELF {
        if let singleton = SELF.shared {
            return singleton
        } else {
            SELF.shared = SELF(profileID: profileID)
            return SELF.shared
        }
    }

    static func initMock(profileID: ProfileID) -> SELF {
        SELF(profileID: profileID)
    }

    func reloadCache() {
        self.cache = CellValue.modelSelectMatrix(
            profileID: self.profileID
        )
    }

    func getProfileID() -> ProfileID {
        self.profileID
    }

    func setProfileID(_ profileID: ProfileID) {
        self.profileID = profileID
        self.reloadCache()
    }

    func select(_ ID: CellID.Value) -> CellValue? {
        self.cache[ID]
    }

    func insertCellValue(_ ID: CellID.Value, _ cellValue: CellValue) {
        switch cellValue {
            case .main, .mini:
                self.cache[ID] = cellValue
                Task {
                    _ = cellValue.modelInsert(ID, self.profileID)
                }
        }
    }

    func insertAppValue(_ ID: CellID.Value, _ appValue: AppValue, to keyPath: CellValuePath? = nil) {
        if let keyPath {
            switch self.select(ID) {
                case .none:
                    self.insertCellValue(
                        ID, .mini(
                            .init(keyPath: keyPath, value: appValue)
                        )
                    )
                case .mini(var miniGrid):
                    miniGrid[keyPath: keyPath] = appValue
                    self.insertCellValue(
                        ID, .mini(miniGrid)
                    )
                default: break
            }
        } else {
            self.insertCellValue(
                ID, .main(appValue)
            )
        }
    }

    func deleteCellValue(_ ID: CellID.Value) {
        self.cache[ID] = nil
        Task {
            _ = CellValue.modelDelete(ID, self.profileID)
        }
    }

    func deleteAppValue(_ ID: CellID.Value, from keyPath: CellValuePath? = nil) {
        if let keyPath {
            if case .mini(var miniGrid) = self.select(ID) {
                miniGrid[keyPath: keyPath] = nil
                if (miniGrid.isEmpty)
                     { self.deleteCellValue(ID) }
                else { self.insertCellValue(ID, .mini(miniGrid)) }
            }
        } else {
            self.deleteCellValue(ID)
        }
    }

    func audit() {
        Task {
            await MainActor.run {
                self.isAuditInProgress = true
                self.auditProgress = 0
                self.auditReport.removeAll()
            }
            for await result in AuditSequence(profileID: self.profileID) {
                await MainActor.run {
                    self.auditProgress = result.progress
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
                }
            }
            try? await Task.sleep(
                nanoseconds: 2_000_000_000
            )
            await MainActor.run {
                self.isAuditInProgress = false
                self.auditReport.removeAll()
                self.reloadCache()
            }
        }
    }

    func onDrag(_ ID: CellID.Value, from keyPathFrom: CellValuePath? = nil) -> NSItemProvider {
        NSItemProvider(
            object: AppDragValue(
                ID: ID,
                keyPath: keyPathFrom
            )
        )
    }

    func onDrop(_ ID: CellID.Value, _ providers: [NSItemProvider], to keyPathTo: CellValuePath? = nil) -> Bool {
        if let provider = providers.first {
            provider.loadItem(forTypeIdentifier: "public.item", options: nil) { (item, error) in
                if let error = error {
                    Logger.customLog("onDropApp error: \(error.localizedDescription)")
                    return
                }
                Task { @MainActor in
                    if let appURL = item as? URL {
                        if let appValue = AppValue(appURL) {
                            self.insertAppValue(ID, appValue, to: keyPathTo)
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
                        if let cellValueFrom = self.select(appDragValue.ID) {
                            switch appDragValue.from {
                                case .`mini_#1`, .`mini_#2`, .`mini_#3`, .`mini_#4`:
                                    if case .mini(var miniGridFrom) = cellValueFrom {
                                        if let keyPathFrom = appDragValue.keyPathFrom {
                                            if let appValueFrom = miniGridFrom[keyPath: keyPathFrom] {
                                                miniGridFrom[keyPath: keyPathFrom] = nil
                                                if (miniGridFrom.isEmpty)
                                                     { self.deleteCellValue(appDragValue.ID) }
                                                else { self.insertCellValue(appDragValue.ID, .mini(miniGridFrom)) }
                                                self.insertAppValue(ID, appValueFrom, to: keyPathTo)
                                            }
                                        }
                                    }
                                case .`main_#0`:
                                    if case .main(let appValueFrom) = cellValueFrom {
                                        self.deleteCellValue(appDragValue.ID)
                                        self.insertAppValue(ID, appValueFrom, to: keyPathTo)
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
