
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation
import AppKit

typealias CellValuePath = WritableKeyPath<MiniGridValue, AppValue?>
typealias CellID_CellValue_Pair = (cellID: CellID.Value, cellValue: CellValue)

enum CellValue {

    case main(AppValue)
    case mini(MiniGridValue)

    func modelInsert(_ ID: CellID.Value, _ profileID: ProfileID) -> Bool {
        var result = true
        switch self {

            case .main(let appValue):
                result &= Self.modelDelete(ID, profileID)
                result &= ModelCell.insert(
                    ModelCell(
                        ID: CellModelID(ID: ID, sector: 0).value,
                        profileID: profileID,
                        bundleID : appValue.bundleID,
                        name     : appValue.name,
                        path     : appValue.path,
                        icon     : appValue.icon
                    )
                )

            case .mini(let miniGrid):
                result &= Self.modelDelete(ID, profileID)
                if let appValue = miniGrid.cell1 { result &= ModelCell.insert(ModelCell(ID: CellModelID(ID: ID, sector: 1).value, profileID: profileID, bundleID: appValue.bundleID, name: appValue.name, path: appValue.path, icon: appValue.icon)) }
                if let appValue = miniGrid.cell2 { result &= ModelCell.insert(ModelCell(ID: CellModelID(ID: ID, sector: 2).value, profileID: profileID, bundleID: appValue.bundleID, name: appValue.name, path: appValue.path, icon: appValue.icon)) }
                if let appValue = miniGrid.cell3 { result &= ModelCell.insert(ModelCell(ID: CellModelID(ID: ID, sector: 3).value, profileID: profileID, bundleID: appValue.bundleID, name: appValue.name, path: appValue.path, icon: appValue.icon)) }
                if let appValue = miniGrid.cell4 { result &= ModelCell.insert(ModelCell(ID: CellModelID(ID: ID, sector: 4).value, profileID: profileID, bundleID: appValue.bundleID, name: appValue.name, path: appValue.path, icon: appValue.icon)) }

        }
        return result
    }

    static func modelDelete(_ ID: CellID.Value, _ profileID: ProfileID) -> Bool {
        ModelCell.delete(IDs: [
            CellModelID(ID: ID, sector: 0).value,
            CellModelID(ID: ID, sector: 1).value,
            CellModelID(ID: ID, sector: 2).value,
            CellModelID(ID: ID, sector: 3).value,
            CellModelID(ID: ID, sector: 4).value,
        ], profileID: profileID)
    }

    static func modelSelectMatrix(profileID: ProfileID) -> CellsDataSource {
        var result = CellsDataSource()
        for (cellModelIDValue, cellValue) in ModelCell.selectAll(profileID: profileID) {

            let cellModelID = CellModelID(decodeFrom: cellModelIDValue)
            let appValue = AppValue(
                bundleID: cellValue.bundleID,
                name: cellValue.name,
                path: cellValue.path,
                icon: cellValue.icon
            )

            switch cellModelID.sector {
                case 0: result[cellModelID.ID] = .main(appValue)
                case 1 ... 4:
                    if case .none = result[cellModelID.ID] {
                        if (cellModelID.sector == 1) { result[cellModelID.ID] = .mini(.init(keyPath: \.cell1, value: appValue)) }
                        if (cellModelID.sector == 2) { result[cellModelID.ID] = .mini(.init(keyPath: \.cell2, value: appValue)) }
                        if (cellModelID.sector == 3) { result[cellModelID.ID] = .mini(.init(keyPath: \.cell3, value: appValue)) }
                        if (cellModelID.sector == 4) { result[cellModelID.ID] = .mini(.init(keyPath: \.cell4, value: appValue)) }
                    }
                    if case .mini(var miniGrid) = result[cellModelID.ID] {
                        if (cellModelID.sector == 1) { miniGrid.cell1 = appValue; result[cellModelID.ID] = .mini(miniGrid) }
                        if (cellModelID.sector == 2) { miniGrid.cell2 = appValue; result[cellModelID.ID] = .mini(miniGrid) }
                        if (cellModelID.sector == 3) { miniGrid.cell3 = appValue; result[cellModelID.ID] = .mini(miniGrid) }
                        if (cellModelID.sector == 4) { miniGrid.cell4 = appValue; result[cellModelID.ID] = .mini(miniGrid) }
                    }
                default: break
            }

        }
        return result
    }

}
