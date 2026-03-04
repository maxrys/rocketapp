
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import UniformTypeIdentifiers

struct Cell_editMode: View, CellProtocol, BackgroundColorResolvingProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark

    @Environment(\.cellsState) private var cells

    internal let ID: CellID.Value
    internal let size: CGFloat
    internal var isVisible: Bool

    private var sizeCellMini      : CGFloat { self.size / 2 }
    private var sizeCellMainButton: CGFloat { self.size * 0.3 }
    private var sizeCellMiniButton: CGFloat { self.sizeCellMini * 0.3 }

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
                        LazyVGrid(columns: self.miniGridColumns, spacing: 0) {
                            self.MiniCellView(keyPath: \.cell1)
                            self.MiniCellView(keyPath: \.cell2)
                            self.MiniCellView(keyPath: \.cell3)
                            self.MiniCellView(keyPath: \.cell4)
                        }
                    case .none:
                        LazyVGrid(columns: self.miniGridColumns, spacing: 0) {
                            self.MiniCellView(keyPath: \.cell1)
                            self.MiniCellView(keyPath: \.cell2)
                            self.MiniCellView(keyPath: \.cell3)
                            self.MiniCellView(keyPath: \.cell4)
                        }
                        self.MainCellView()
                }

            } else {
                self.FakeCellView()
            }
        }
        .frame(width: self.size, height: self.size)
    }

    @ViewBuilder private func FakeCellView() -> some View {
        ZStack {
            Image("Fake Cell Background")
                .resizable()
                .foregroundStyle(self.colorBackgroundAccentResolve(minOpacity: 0.3))
                .frame(width: self.size * 0.66, height: self.size * 0.66)
                .padding(.leading, self.size * 0.01)
                .padding(.top    , self.size * 0.01)
        }.frame(
            width : self.size,
            height: self.size
        )
    }

    @ViewBuilder private func MainCellView() -> some View {
        ZStack {
            switch self.value {
                case .none:
                    self.ButtonInsertView(self.sizeCellMainButton) {
                        if let appValue = AppValue.fromDialog() {
                            self.insert(appValue)
                        }
                    }
                case .main(let appValue):
                    Image(nsImage: appValue.resolvedIcon)
                        .resizable()
                        .onDrag({ self.onDragAppValue() }, preview: {
                            Image(nsImage: appValue.resolvedIcon)
                                .resizable()
                                .frame(width: 20, height: 20)
                        })
                        .overlay(alignment: .topTrailing) {
                            self.ButtonDeleteView(self.size * 0.25) {
                                self.delete()
                            }
                        }
                        .scaleEffect(1.15)
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
                            self.insert(appValue, to: keyPath)
                        }
                    }
                case .mini(let miniGrid):
                    if let appValue = miniGrid[keyPath: keyPath] {
                        Image(nsImage: appValue.resolvedIcon)
                            .resizable()
                            .onDrag({ self.onDragAppValue(from: keyPath) }, preview: {
                                Image(nsImage: appValue.resolvedIcon)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            })
                            .overlay(alignment: .topTrailing) {
                                self.ButtonDeleteView(self.size * 0.15) {
                                    self.delete(from: keyPath)
                                }
                            }
                    } else {
                        self.ButtonInsertView(self.sizeCellMiniButton, to: keyPath) {
                            if let appValue = AppValue.fromDialog() {
                                self.insert(appValue, to: keyPath)
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

    @ViewBuilder private func ButtonInsertView(_ size: CGFloat, to keyPath: CellValuePath? = nil, onClick: @escaping () -> Void) -> some View {
        Cell_editMode_ButtonInsert(
            size: size,
            foregroundStyle: self.colorBackgroundAccentResolve(minOpacity: 0.3),
            onClick: onClick,
            onDrop: { providers in
                self.onDropAppValue(providers, to: keyPath)
            }
        )
    }

    @ViewBuilder private func ButtonDeleteView(_ size: CGFloat, onClick: @escaping () -> Void) -> some View {
        ButtonRound(
            label: {
                Image(systemName: "minus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(size * 0.25)
            },
            foreground: { Color.ButtonCustomColorSet.Style.danger.text },
            background: { Circle().fill(Color.ButtonCustomColorSet.Style.danger.background.gradient) },
            size: size,
            onClick: onClick
        ).shadow(
            color: .black,
            radius: size * 0.1,
            y: size * 0.1
        )
    }

    private func insert(_ appValue: AppValue, to keyPath: CellValuePath? = nil) {
        if let keyPath {
            switch self.value {
                case .none:
                    self.cells.insert(
                        self.ID, .mini(
                            .init(keyPath: keyPath, value: appValue)
                        )
                    )
                case .mini(var miniGrid):
                    miniGrid[keyPath: keyPath] = appValue
                    self.cells.insert(
                        self.ID, .mini(miniGrid)
                    )
                default: break
            }
        } else {
            self.cells.insert(
                self.ID, .main(appValue)
            )
        }
    }

    private func delete(from keyPath: CellValuePath? = nil) {
        if let keyPath {
            if case .mini(var miniGrid) = self.value {
                miniGrid[keyPath: keyPath] = nil
                if (miniGrid.isEmpty)
                     { self.cells.delete(self.ID) }
                else { self.cells.insert(self.ID, .mini(miniGrid)) }
            }
        } else {
            self.cells.delete(
                self.ID
            )
        }
    }

    private func onDragAppValue(from keyPathFrom: CellValuePath? = nil) -> NSItemProvider {
        NSItemProvider(
            object: AppDragValue(
                ID: self.ID,
                keyPath: keyPathFrom
            )
        )
    }

    private func onDropAppValue(_ providers: [NSItemProvider], to keyPathTo: CellValuePath? = nil) -> Bool {
        if let provider = providers.first {
            provider.loadItem(forTypeIdentifier: "public.item", options: nil) { (item, error) in
                if let error = error {
                    Logger.customLog("onDropApp error: \(error.localizedDescription)")
                    return
                }
                Task { @MainActor in
                    if let appURL = item as? URL {
                        if let appValue = AppValue(appURL) {
                            if let keyPathTo
                                 { self.insert(appValue, to: keyPathTo) }
                            else { self.insert(appValue) }
                        }
                    }
                }
            }
            provider.loadObject(ofClass: AppDragValue.self) { object, error in
                if let error = error {
                    Logger.customLog("onDropApp error: \(error.localizedDescription)")
                    return
                }
                Task { @MainActor in
                    if let appDragValue = object as? AppDragValue {
                        if let cellValueFrom = self.cells.select(appDragValue.ID) {
                            switch appDragValue.position {
                                case .`mini_#1`, .`mini_#2`, .`mini_#3`, .`mini_#4`:
                                    if case .mini(var miniGridFrom) = cellValueFrom {
                                        if let keyPathFrom = appDragValue.keyPathResolve {
                                            if let appValueFrom = miniGridFrom[keyPath: keyPathFrom] {
                                                miniGridFrom[keyPath: keyPathFrom] = nil
                                                if (miniGridFrom.isEmpty)
                                                     { self.cells.delete(appDragValue.ID) }
                                                else { self.cells.insert(appDragValue.ID, .mini(miniGridFrom)) }
                                                self.insert(appValueFrom, to: keyPathTo)
                                            }
                                        }
                                    }
                                case .`main_#0`:
                                    if case .main(let appValue) = cellValueFrom {
                                        self.cells.delete(appDragValue.ID)
                                        self.insert(appValue, to: keyPathTo)
                                    }
                            }
                        }
                    }
                }
            }
            return true
        }
        return false
    }

}

struct Cell_editMode_ButtonInsert: View {

    @State private var isHovering = false

    public let size: CGFloat
    public let foregroundStyle: Color
    public let onClick: () -> Void
    public let onDrop: (_ providers: [NSItemProvider]) -> Bool

    public var body: some View {
        Image(systemName: "plus")
            .resizable()
            .foregroundStyle(self.isHovering ? Color.accentColor : self.foregroundStyle)
            .frame(width: self.size, height: self.size)
            .onTapGesture(count: 1, perform: self.onClick)
            .onHover { isHovering in self.isHovering = isHovering }
            .onDrop(of: [.application, UTType.appDragValue], isTargeted: self.$isHovering, perform: self.onDrop)
            .pointerStyle(.link)
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
        Cell_editMode(ID: 0, size: 100, isVisible: true).environment(\.cellsState, mockForNone).padding(10)
        Cell_editMode(ID: 0, size: 100, isVisible: true).environment(\.cellsState, mockForMain).padding(10)
        Cell_editMode(ID: 0, size: 100, isVisible: true).environment(\.cellsState, mockForMini).padding(10)
    }.padding(10)
}
