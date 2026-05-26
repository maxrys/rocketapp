
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
                    self.MainCellView()
                case .mini:
                    Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                        GridRow {
                            self.MiniCellView(keyPath: \.cell1).id(1).hoverBehavior(.zIndex(to: 1))
                            self.MiniCellView(keyPath: \.cell2).id(2).hoverBehavior(.zIndex(to: 1))
                        }
                        GridRow {
                            self.MiniCellView(keyPath: \.cell3).id(3).hoverBehavior(.zIndex(to: 1))
                            self.MiniCellView(keyPath: \.cell4).id(4).hoverBehavior(.zIndex(to: 1))
                        }
                    }.scaleEffect(0.89)
                case .none:
                    Color.clear
            }

        }
        .frame(width: self.size, height: self.size)
        .hoverBehavior(.zIndex(to: 1))
    }

    @ViewBuilder private func MainCellView() -> some View {
        ZStack {
            if case .main(let appValue) = self.value {
                if let appURL = URL(string: appValue.path) {
                    Button {
                        NSWindow.hideWithAnimation(ThisApp.WINDOW_MAIN_ID)
                        NSApplication.open(appURL)
                    } label: {
                        AppIcon_viewMode(
                            name: appValue.name,
                            icon: appValue.resolvedIcon,
                            size: self.size
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

    @ViewBuilder private func MiniCellView(keyPath: CellValuePath) -> some View {
        ZStack {
            if case .mini(let miniGrid) = self.value {
                if let appValue = miniGrid[keyPath: keyPath] {
                    if let appURL = URL(string: appValue.path) {
                        Button {
                            NSWindow.hideWithAnimation(ThisApp.WINDOW_MAIN_ID)
                            NSApplication.open(appURL)
                        } label: {
                            AppIcon_viewMode(
                                name: appValue.name,
                                icon: appValue.resolvedIcon,
                                size: self.sizeCellMini
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
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    @Previewable @State var mockForNone = CellsState.initMock(
        profileID: ThisApp.PREVIEW_PROFILE_ID
    )

    @Previewable @State var mockForMain: CellsState = {
        let data = CellsState.initMock(profileID: ThisApp.PREVIEW_PROFILE_ID)
        data.insertCellValue(0, .main(.init(
            bundleID: ThisApp.DEMO_BUNDLE_ID,
            name: ThisApp.DEMO_NAME,
            path: ThisApp.DEMO_PATH,
            icon: ThisApp.DEMO_ICON.tiffRepresentation
        )))
        return data
    }()

    @Previewable @State var mockForMini: CellsState = {
        let data = CellsState.initMock(profileID: ThisApp.PREVIEW_PROFILE_ID)
        data.insertCellValue(0, .mini(.init(
            cell1Value: .init(bundleID: ThisApp.DEMO_BUNDLE_ID, name: ThisApp.DEMO_NAME, path: ThisApp.DEMO_PATH, icon: nil),
            cell2Value: .init(bundleID: ThisApp.DEMO_BUNDLE_ID, name: ThisApp.DEMO_NAME, path: ThisApp.DEMO_PATH, icon: nil),
            cell3Value: .init(bundleID: ThisApp.DEMO_BUNDLE_ID, name: ThisApp.DEMO_NAME, path: ThisApp.DEMO_PATH, icon: nil),
            cell4Value: .init(bundleID: ThisApp.DEMO_BUNDLE_ID, name: ThisApp.DEMO_NAME, path: ThisApp.DEMO_PATH, icon: nil)
        )))
        return data
    }()

    Previewer(isHorizontal: true) {
        Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
            Cell_viewMode(ID: 0, size: ThisApp.CELL_SIZE).id(1).environment(\.cellsState, mockForNone)
            Cell_viewMode(ID: 0, size: ThisApp.CELL_SIZE).id(2).environment(\.cellsState, mockForMain)
            Cell_viewMode(ID: 0, size: ThisApp.CELL_SIZE).id(3).environment(\.cellsState, mockForMini)
        }.padding(10)
    }
}
