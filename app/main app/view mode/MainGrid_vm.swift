
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
        var result = GridCustom.DataSource()
        for (cellID, _) in self.cells.data {
            result[cellID] = Cell_viewMode(
                ID: cellID,
                size: self.cellSize
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
    MainGrid_viewMode(
        cellSize: ThisApp.CELL_SIZE,
        cellSpacing: CGFloat(ThisApp.DEFAULT_SPACING)
    ).frame(width: 300)
}
