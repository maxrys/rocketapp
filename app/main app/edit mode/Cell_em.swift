
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import UniformTypeIdentifiers

struct Cell_editMode: View, CellProtocol, BackgroundColorProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark
    @Environment(\.cellsState) private var cells

    internal let ID: CellID.Value
    internal let size: CGFloat
    internal var isVisible: Bool

    private var sizeCellMini      : CGFloat { self.size / 2 }
    private var sizeCellMainButton: CGFloat { self.size * 0.3 }
    private var sizeCellMiniButton: CGFloat { self.sizeCellMini * 0.4 }

    private var value: CellValue? {
        self.cells.select(self.ID)
    }

    private var isCellWithValue: Bool {
        switch self.value {
            case .none: false; default: true
        }
    }

    private var miniGridColumns: [GridItem] {[
        GridItem(.fixed(self.sizeCellMini), spacing: 0),
        GridItem(.fixed(self.sizeCellMini), spacing: 0)
    ]}

    init(
        ID: CellID.Value,
        size: CGFloat,
        isVisible: Bool
    ) {
        self.ID = ID
        self.size = size
        self.isVisible = isVisible
    }

    public var body: some View {
        ZStack {
            if (self.isCellWithValue || self.isVisible) {

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
                        Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                            GridRow {
                                self.MiniCellView(keyPath: \.cell1).id(1).hoverBehavior(.zIndex(to: 1))
                                self.MiniCellView(keyPath: \.cell2).id(2).hoverBehavior(.zIndex(to: 1))
                            }
                            GridRow {
                                self.MiniCellView(keyPath: \.cell3).id(3).hoverBehavior(.zIndex(to: 1))
                                self.MiniCellView(keyPath: \.cell4).id(4).hoverBehavior(.zIndex(to: 1))
                            }
                        }
                        self.MainCellView()
                }

            } else {
                Cell_editMode_Fake(
                    size: self.size
                )
            }
        }
        .frame(width: self.size, height: self.size)
        .hoverBehavior(.zIndex(to: 1))
    }

    @ViewBuilder private func MainCellView() -> some View {
        ZStack {
            switch self.value {
                case .none:
                    self.ButtonInsertView(self.sizeCellMainButton) {
                        if let appValue = AppValue.fromDialog() {
                            self.cells.insertAppValue(self.ID, appValue)
                        }
                    }
                case .main(let appValue):
                    AppIcon_editMode(
                        name: appValue.name,
                        icon: appValue.resolvedIcon,
                        size: self.size,
                        onDelete: {
                            self.cells.deleteAppValue(self.ID)
                        }
                    )
                    .onDrag({ self.cells.onDrag(self.ID) }, preview: {
                        self.dragIcon(appValue)
                    })
                default:
                    Color.clear
            }
        }.frame(
            width : self.size,
            height: self.size
        )
    }

    @ViewBuilder private func MiniCellView(keyPath: CellValuePath) -> some View {
        ZStack {
            switch self.value {
                case .none:
                    self.ButtonInsertView(self.sizeCellMiniButton, to: keyPath) {
                        if let appValue = AppValue.fromDialog() {
                            self.cells.insertAppValue(self.ID, appValue, to: keyPath)
                        }
                    }
                case .mini(let miniGrid):
                    if let appValue = miniGrid[keyPath: keyPath] {
                        AppIcon_editMode(
                            name: appValue.name,
                            icon: appValue.resolvedIcon,
                            size: self.sizeCellMini,
                            onDelete: {
                                self.cells.deleteAppValue(self.ID, from: keyPath)
                            }
                        )
                        .onDrag({ self.cells.onDrag(self.ID, from: keyPath) }, preview: {
                            self.dragIcon(appValue)
                        })
                    } else {
                        self.ButtonInsertView(self.sizeCellMiniButton, to: keyPath) {
                            if let appValue = AppValue.fromDialog() {
                                self.cells.insertAppValue(self.ID, appValue, to: keyPath)
                            }
                        }
                    }
                default:
                    Color.clear
            }
        }.frame(
            width : self.sizeCellMini,
            height: self.sizeCellMini
        )
    }

    @ViewBuilder private func dragIcon(_ appValue: AppValue) -> some View {
        Image(nsImage: appValue.resolvedIcon)
            .resizable()
            .frame(width: 20, height: 20)
    }

    @ViewBuilder private func ButtonInsertView(_ size: CGFloat, to keyPath: CellValuePath? = nil, onClick: @escaping () -> Void) -> some View {
        Cell_editMode_ButtonInsert(
            size: size,
            onClick: onClick,
            onDrop: { providers in
                self.cells.onDrop(self.ID, providers, to: keyPath)
            }
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

    Previewer(axis: .horizontal) {
        Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
            Cell_editMode_Fake(size: ThisApp.CELL_SIZE).id(1)
            Cell_editMode(ID: 0, size: ThisApp.CELL_SIZE, isVisible: true).id(2).environment(\.cellsState, mockForNone)
            Cell_editMode(ID: 0, size: ThisApp.CELL_SIZE, isVisible: true).id(3).environment(\.cellsState, mockForMain)
            Cell_editMode(ID: 0, size: ThisApp.CELL_SIZE, isVisible: true).id(4).environment(\.cellsState, mockForMini)
        }.padding(10)
    }
}
