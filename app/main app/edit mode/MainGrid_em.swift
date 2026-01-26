
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainGrid_editMode: View {

    @Environment(\.profilesState) private var profiles
    @Environment(\.cellsState)    private var cells

    private let cellSize: CGFloat
    private let cellSpacing: CGFloat

    init(
        cellSize: CGFloat,
        cellSpacing: CGFloat
    ) {
        self.cellSize = cellSize
        self.cellSpacing = cellSpacing
    }

    private var gridSource: GridCustom.DataSource {
        var result = GridCustom.DataSource()
        if let bounds = self.cells.data.bounds {
            for rowNum in 0 ... (bounds.maxY + 3).fixBounds(max: ThisApp.GRID_ROWS_MAX - 1) {
            for colNum in 0 ... (bounds.maxX + 3).fixBounds(max: ThisApp.GRID_COLS_MAX - 1) {
                let rowNum = CellID.Index(rowNum)
                let colNum = CellID.Index(colNum)
                let cellID = CellID(rowNum: rowNum, colNum: colNum)
                result[rowNum, colNum] = Cell_editMode(
                    ID: cellID.value,
                    size: self.cellSize,
                    isVisible: true
                )
            }}
        } else {
            result[0] = Cell_editMode(
                ID: 0,
                size: self.cellSize,
                isVisible: true
            )
        }
        return result
    }

    public var body: some View {
        GridCustom(
            data: self.gridSource,
            cellSize: self.cellSize,
            cellSpacing: self.cellSpacing,
            isSticky: self.profiles.current.isStickyGrid,
            gridType: .lazyVGrid
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    MainGrid_editMode(
        cellSize: ThisApp.CELL_SIZE,
        cellSpacing: CGFloat(ThisApp.NEW_PROFILE_SPACING)
    ).frame(width: 300, height: 500)
}
