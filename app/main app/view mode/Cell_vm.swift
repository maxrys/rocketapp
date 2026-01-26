
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct Cell_viewMode: View, CellProtocol {

    @Environment(\.cellsState) private var cells

    internal let ID: CellID.Value
    internal let size: CGFloat
    internal var isVisible: Bool

    private var sizeCellMini: CGFloat { self.size / 2 }
    private var value: CellValue? {
        self.cells.select(self.ID)
    }

    init(
        ID: CellID.Value,
        size: CGFloat
    ) {
        self.ID = ID
        self.size = size
        self.isVisible = true
    }

    public var body: some View {
        ZStack {

            switch self.value {
                case .main:
                    self.mainCell
                case .mini:
                    Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                        GridRow {
                            self.miniCell(keyPath: \.cell1)
                            self.miniCell(keyPath: \.cell2)
                        }
                        GridRow {
                            self.miniCell(keyPath: \.cell3)
                            self.miniCell(keyPath: \.cell4)
                        }
                    }
                case .none:
                    Color.clear
            }

        }.frame(width: self.size, height: self.size)
    }

    @ViewBuilder private var mainCell: some View {
        ZStack {
            if case .main(let cell) = self.value {
                if let appURL = URL(string: cell.path) {
                    Button {
                        NSWindow.hideWithAnimation(windowId: ThisApp.MAIN_WINDOW_ID)
                        NSApplication.open(appURL)
                    } label: {
                        AppIcon(
                            name: cell.name,
                            icon: cell.resolvedIcon,
                            cellSize: self.size
                        )
                    }
                    .buttonStyle(.plain)
                    .pointerStyle(.link)
                }
            }
        }.frame(
            width : self.size,
            height: self.size
        )
    }

    @ViewBuilder private func miniCell(keyPath: CellValuePath) -> some View {
        ZStack {
            if case .mini(let miniGrid) = self.value {
                if let cell = miniGrid[keyPath: keyPath] {
                    if let appURL = URL(string: cell.path) {
                        Button {
                            NSWindow.hideWithAnimation(windowId: ThisApp.MAIN_WINDOW_ID)
                            NSApplication.open(appURL)
                        } label: {
                            AppIcon(
                                name: cell.name,
                                icon: cell.resolvedIcon,
                                cellSize: self.sizeCellMini,
                                isMiniGrid: true
                            )
                        }
                        .buttonStyle(.plain)
                        .pointerStyle(.link)
                    }
                }
            }
        }.frame(
            width : self.sizeCellMini,
            height: self.sizeCellMini
        ).hoverBehavior(.zIndex(to: 1))
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    @Previewable @State var mockForNone = CellsState.initMock(profileID: ThisApp.PREVIEW_PROFILE_ID)
    @Previewable @State var mockForMain: CellsState = {
        let data = CellsState.initMock(profileID: ThisApp.PREVIEW_PROFILE_ID)
        data.insert(0, CellValue.main(.init(
            bundleID: ThisApp.DEMO_BUNDLE_ID,
            name: ThisApp.DEMO_NAME,
            path: ThisApp.DEMO_PATH,
            icon: ThisApp.DEMO_ICON.tiffRepresentation
        )))
        return data
    }()
    @Previewable @State var mockForMini: CellsState = {
        let data = CellsState.initMock(profileID: ThisApp.PREVIEW_PROFILE_ID)
        data.insert(0, CellValue.mini(.init(keyPath: \.cell1, value: .init(
            bundleID: ThisApp.DEMO_BUNDLE_ID,
            name: ThisApp.DEMO_NAME,
            path: ThisApp.DEMO_PATH,
            icon: nil
        ))))
        return data
    }()
    VStack(spacing: 10) {
        Cell_viewMode(ID: 0, size: 100).environment(\.cellsState, mockForNone).padding(10)
        Cell_viewMode(ID: 0, size: 100).environment(\.cellsState, mockForMain).padding(10)
        Cell_viewMode(ID: 0, size: 100).environment(\.cellsState, mockForMini).padding(10)
    }
    .padding(10)
}
