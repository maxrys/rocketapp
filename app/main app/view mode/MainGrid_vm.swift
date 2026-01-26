
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
        for (cellIDValue, _) in self.cells.data.flat {
            result[cellIDValue] = Cell_viewMode(
                ID: cellIDValue,
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
