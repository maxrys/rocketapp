
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

    func insert(_ ID: CellID.Value, _ cellValue: CellValue) {
        switch cellValue {
            case .main, .mini:
                self.cache[ID] = cellValue
                Task {
                    _ = cellValue.modelInsert(ID, self.profileID)
                }
        }
    }

    func delete(_ ID: CellID.Value) {
        self.cache[ID] = nil
        Task {
            _ = CellValue.modelDelete(ID, self.profileID)
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

}
