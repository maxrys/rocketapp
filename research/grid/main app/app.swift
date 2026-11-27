
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI

@main struct ThisApp: App {

    static let MOCK_APP_VALUE = AppValue(
        bundleID: "maxrys.demo",
        name: "App",
        path: "file:///Applications/App.app/",
        icon: nil
    )

    static let IS_MOCK_INSERTION_ENABLED = true
    static let IS_TEST_HOVER = false

    static let MESSAGE_SELECT_THIS_APPLICATION = NSLocalizedString("Select this application", comment: "")
    static let WINDOW_MAIN_TITLE = "RocketApp (Grid Research)"
    static let WINDOW_MAIN_ID = "mainGrid"
    static let WINDOW_BACKGROUND_DEFAULT     : ColorHSBValue = .init(0.55, 0.50, 0.50, 1.00)
    static let WINDOW_BACKGROUND_DARK_DEFAULT: ColorHSBValue = .init(0.67, 0.38, 0.28, 1.00)

    static let GRID_COLS: UInt8 = 45
    static let GRID_ROWS: UInt8 = 45
    static let GRID_PADDING: UInt = 20

    static let CELL_SIZE_MIN: UInt = 50
    static let CELL_SIZE_MAX: UInt = 150
    static let CELL_SIZE_DEFAULT: UInt = 100
    static let CELL_SIZE_STEP: UInt = 10

    static let CELL_SPACING_DEFAULT: UInt = 20
    static let HOVER_ZOOM_DEFAULT: Decimal = 1.0
    static let IS_SHOW_ICON_TITLE_DEFAULT: Bool = true

    private let profiles   = EnvironmentValues().profilesState
    private let cells      = EnvironmentValues().cellsState
    private let process    = EnvironmentValues().processState
    private let isEditMode = EnvironmentValues().isEditMode

    private var gridInfo: GridInfo!

    init() {
        self.gridInfo = GridInfo(
            onClickApp          : self.onClickApp,
            onClickAppInsert    : self.onClickAppInsert,
            onClickAppDelete    : self.onClickAppDelete,
            onAppDrop           : self.onAppDrop,
            onAppDropFromOutside: self.onAppDropFromOutside
        )
    }

    var body: some Scene {
        Window(Self.WINDOW_MAIN_TITLE, id: Self.WINDOW_MAIN_ID) {
            if (Self.IS_TEST_HOVER) {
                TestSprite_Previews.previews
            } else {
                VStack(spacing: 0) {
                    ControlPanel()
                    AppGrid(
                        gridInfo: self.gridInfo
                    )
                }
                .onAppear {
                    if let window = NSWindow.get(Self.WINDOW_MAIN_ID) {
                        window.backgroundColor = .clear
                        window.alphaValue = 1.0
                    }
                }
                .overlay {
                    if (self.process.inProgress) {
                        ProcessPanel()
                    }
                }
            }
        }
        .windowResizability(.automatic)
        .environment(\.windowBackground    , self.profiles.current.background)
        .environment(\.windowBackgroundDark, self.profiles.current.backgroundDark)
        .environment(\.profilesState       , self.profiles)
        .environment(\.cellsState          , self.cells)
        .environment(\.processState        , self.process)
        .environment(\.isEditMode          , self.isEditMode)
        .environment(\.layoutDirection, .leftToRight)
    }

    private func onClickApp(address: CellAddressValue) {
        if (Self.IS_MOCK_INSERTION_ENABLED) {
            print("onClickApp \(address.rowNum):\(address.colNum):\(address.sector)")
        } else {
            if let appValue = self.cells.selectAppValue(address.toCellID(), from: address.tokeyPath()) {
                if let appURL = URL(string: appValue.path) {
                    NSWindow.hideWithAnimation(ThisApp.WINDOW_MAIN_ID)
                    NSApplication.open(appURL)
                }
            }
        }
    }

    private func onClickAppInsert(address: CellAddressValue) {
        if (Self.IS_MOCK_INSERTION_ENABLED) {
            self.cells.insertAppValue(address.toCellID(), ThisApp.MOCK_APP_VALUE, to: address.tokeyPath())
        } else if let appValue = AppValue.fromDialog() {
            self.cells.insertAppValue(address.toCellID(), appValue, to: address.tokeyPath())
        }
    }

    private func onClickAppDelete(address: CellAddressValue) {
        self.cells.deleteAppValue(address.toCellID(), from: address.tokeyPath())
    }

    private func onAppDrop(from: CellAddressValue, to: CellAddressValue) {
        guard (0...4).contains(from.sector) else { return }
        guard (0...4).contains(to  .sector) else { return }
        if let appValue = self.cells.selectAppValue(from.toCellID(), from: from.tokeyPath()) {
            self.cells.deleteAppValue(from.toCellID(), from: from.tokeyPath())
            self.cells.insertAppValue(to.toCellID(), appValue, to: to.tokeyPath())
        }
    }

    private func onAppDropFromOutside(to: CellAddressValue, appValue: AppValue) {
        self.cells.insertAppValue(to.toCellID(), appValue, to: to.tokeyPath())
    }

}
