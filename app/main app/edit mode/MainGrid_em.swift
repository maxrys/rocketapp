
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
            for rowNum in 0 ... (bounds.maxRow + 3).fixBounds(max: ThisApp.GRID_ROWS_MAX - 1) {
            for colNum in 0 ... (bounds.maxCol + 3).fixBounds(max: ThisApp.GRID_COLS_MAX - 1) {
                let cellID = CellIDValue(rowNum: rowNum, colNum: colNum)
                result[cellID] = Cell_editMode(
                    ID: cellID,
                    size: self.cellSize,
                    isVisible: true
                )
            }}
        } else {
            result[CellIDValue.zero] = Cell_editMode(
                ID: CellIDValue.zero,
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
            gridType: profiles.current.isShowIconTitle ?
                .grid :
                .lazyVGrid
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    MainGrid_editMode(
        cellSize: ThisApp.CELL_SIZE,
        cellSpacing: CGFloat(ThisApp.DEFAULT_SPACING)
    ).frame(width: 300, height: 500)
}
