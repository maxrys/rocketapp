
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation
import AppKit

enum CellValue {

    case main(AppValue)
    case mini(MiniGridValue)

    func modelInsert(_ cellID: CellIDValue, _ profileID: ProfileID) -> Bool {
        var result = true
        switch self {

            case .main(let appValue):
                result &= Self.modelDelete(cellID, profileID)
                result &= ModelCell.insert(
                    ModelCell(
                        ID: GridPlaceIDValue(cellID: cellID, sector: 0).raw,
                        profileID: profileID,
                        bundleID : appValue.bundleID,
                        name     : appValue.name,
                        path     : appValue.path,
                        icon     : appValue.icon
                    )
                )

            case .mini(let miniGrid):
                result &= Self.modelDelete(cellID, profileID)
                if let appValue = miniGrid.cell1 { result &= ModelCell.insert(ModelCell(ID: GridPlaceIDValue(cellID: cellID, sector: 1).raw, profileID: profileID, bundleID: appValue.bundleID, name: appValue.name, path: appValue.path, icon: appValue.icon)) }
                if let appValue = miniGrid.cell2 { result &= ModelCell.insert(ModelCell(ID: GridPlaceIDValue(cellID: cellID, sector: 2).raw, profileID: profileID, bundleID: appValue.bundleID, name: appValue.name, path: appValue.path, icon: appValue.icon)) }
                if let appValue = miniGrid.cell3 { result &= ModelCell.insert(ModelCell(ID: GridPlaceIDValue(cellID: cellID, sector: 3).raw, profileID: profileID, bundleID: appValue.bundleID, name: appValue.name, path: appValue.path, icon: appValue.icon)) }
                if let appValue = miniGrid.cell4 { result &= ModelCell.insert(ModelCell(ID: GridPlaceIDValue(cellID: cellID, sector: 4).raw, profileID: profileID, bundleID: appValue.bundleID, name: appValue.name, path: appValue.path, icon: appValue.icon)) }

        }
        return result
    }

    static func modelDelete(_ cellID: CellIDValue, _ profileID: ProfileID) -> Bool {
        ModelCell.delete(IDs: [
            GridPlaceIDValue(cellID: cellID, sector: 0).raw,
            GridPlaceIDValue(cellID: cellID, sector: 1).raw,
            GridPlaceIDValue(cellID: cellID, sector: 2).raw,
            GridPlaceIDValue(cellID: cellID, sector: 3).raw,
            GridPlaceIDValue(cellID: cellID, sector: 4).raw,
        ], profileID: profileID)
    }

    static func modelSelect(profileID: ProfileID) -> CellsDataSource {
        var result = CellsDataSource()
        for (placeID, cellValue) in ModelCell.selectAll(profileID: profileID) {

            let placeIDValue = GridPlaceIDValue(raw: placeID)
            let cellIDValue = placeIDValue.toCellID()
            let sector = placeIDValue.sector
            let appValue = AppValue(
                bundleID: cellValue.bundleID,
                name: cellValue.name,
                path: cellValue.path,
                icon: cellValue.icon
            )

            switch sector {
                case 0: result[cellIDValue] = .main(appValue)
                case 1 ... 4:
                    if case .none = result[cellIDValue] {
                        if (sector == 1) { result[cellIDValue] = .mini(.init(keyPath: \.cell1, value: appValue)) }
                        if (sector == 2) { result[cellIDValue] = .mini(.init(keyPath: \.cell2, value: appValue)) }
                        if (sector == 3) { result[cellIDValue] = .mini(.init(keyPath: \.cell3, value: appValue)) }
                        if (sector == 4) { result[cellIDValue] = .mini(.init(keyPath: \.cell4, value: appValue)) }
                    }
                    if case .mini(var miniGrid) = result[cellIDValue] {
                        if (sector == 1) { miniGrid.cell1 = appValue; result[cellIDValue] = .mini(miniGrid) }
                        if (sector == 2) { miniGrid.cell2 = appValue; result[cellIDValue] = .mini(miniGrid) }
                        if (sector == 3) { miniGrid.cell3 = appValue; result[cellIDValue] = .mini(miniGrid) }
                        if (sector == 4) { miniGrid.cell4 = appValue; result[cellIDValue] = .mini(miniGrid) }
                    }
                default: break
            }

        }
        return result
    }

}
