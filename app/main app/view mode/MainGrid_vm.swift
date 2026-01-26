
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainGrid_viewMode: View {

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
        var result: GridCustom.DataSource = [:]
        if let bounds = self.cells.bounds {
            for rowNum in bounds.minRowNum ... bounds.maxRowNum {
            for colNum in bounds.minColNum ... bounds.maxColNum {
                let rowNumFinal = rowNum - bounds.minRowNum
                let colNumFinal = colNum - bounds.minColNum
                if (result[rowNumFinal] == nil) { result[rowNumFinal] = [:] }
                result[rowNumFinal]![colNumFinal] = Cell_viewMode(
                    ID: CellID(rowNum: rowNum, colNum: colNum).value,
                    size: self.cellSize
                )
            }}
        }
        return result
    }

    public var body: some View {
        GridCustom(
            data: self.gridSource,
            cellSize: self.cellSize,
            cellSpacing: self.cellSpacing,
            isSticky: self.profiles.current.isStickyGrid,
            gridType: .grid
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    MainGrid_viewMode(
        cellSize: ThisApp.CELL_SIZE,
        cellSpacing: CGFloat(ThisApp.NEW_PROFILE_SPACING)
    ).frame(width: 300)
}
