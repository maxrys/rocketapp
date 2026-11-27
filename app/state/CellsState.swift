
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import SwiftData

@Observable final class CellsState {

    typealias SELF = CellsState

    static public private(set) var shared: CellsState!

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

    func selectAppValue(_ cellID: CellIDValue, from keyPath: CellValuePath? = nil) -> AppValue? {
        switch self.selectCellValue(cellID) {
            case .none:
                return nil
            case .main(let appValue):
                return appValue
            case .mini(let miniGrid):
                if let keyPath, let appValue = miniGrid[keyPath: keyPath] {
                    return appValue
                } else {
                    return nil
                }
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

}
