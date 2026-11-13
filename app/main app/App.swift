
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import SwiftData

final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldHandleReopen(_ app: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if let window = NSWindow.get(ThisApp.WINDOW_MAIN_ID) {
            window.show()
        }
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

}

@main struct ThisApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openWindow) private var openWindow

    static let NOT_APPLICABLE = "—"
    static let CONTAINER_PATH = "~/Library/Containers/maxrys.rocketapp"

    static let DEMO_BUNDLE_ID = "rysmax.demo"
    static let DEMO_PATH = "file:///System/Applications/Demo Application.app/"
    static let DEMO_NAME = "Demo Application"
    static let DEMO_ICON = NSImage(named: "AppIcon")!

    static let WINDOW_ABOUT_TITLE_LOCALIZED = String(format: NSLocalizedString("About %@" , comment: ""), NSApplication.appNameLocalized)
    static let WINDOW_ABOUT_ID = "about"
    static let WINDOW_MAIN_TITLE = "RocketApp"
    static let WINDOW_MAIN_ID = "mainGrid"
    static let WINDOW_FRAME_VIEW_MODE_DEFAULT = CGRect(x: 0, y: 0, w: 400, h: 300)
    static let WINDOW_FRAME_EDIT_MODE_DEFAULT = CGRect(x: 0, y: 0, w: 600, h: 300)
    static let WINDOW_BACKGROUND_DEFAULT      = ColorHSBValue(0.55, 0.15, 0.97, 0.70)
    static let WINDOW_BACKGROUND_DARK_DEFAULT = ColorHSBValue(0.67, 0.38, 0.28, 0.70)

    static let MESSAGE_NO_APPLICATIONS = NSLocalizedString("No Applications!", comment: "")
    static let MESSAGE_OPEN_SETTINGS = NSLocalizedString("open settings", comment: "")
    static let MESSAGE_SELECT_THIS_APPLICATION = NSLocalizedString("Select this application", comment: "")

    static let PREVIEW_PROFILE_ID: ProfileID = ProfileID.max
    static let EMBEDDED_PROFILE_ID: ProfileID = 0

    static let TITLE_DEFAULT: ProfileTitle = "My Profile"
    static let IS_SHOW_ICON_TITLE_DEFAULT = true
    static let IS_HIDE_ON_MISCLICK_DEFAULT = false
    static let IS_STICKY_GRID_DEFAULT = false
    static let IS_SHOW_WINDOW_TITLE_BUTTONS_DEFAULT = true

    static let GRID_COLS: UInt8 = 45
    static let GRID_ROWS: UInt8 = 45

    static let CELL_SIZE_MIN: UInt = 50
    static let CELL_SIZE_MAX: UInt = 150
    static let CELL_SIZE_DEFAULT: UInt = 100
    static let CELL_SIZE_STEP: UInt = 10

    static let CELL_SPACING_MIN: UInt = 0
    static let CELL_SPACING_MAX: UInt = 30
    static let CELL_SPACING_DEFAULT: UInt = 20
    static let CELL_SPACING_STEP: UInt = 5

    static let HOVER_ZOOM_MIN: Decimal = 1.0
    static let HOVER_ZOOM_MAX: Decimal = 1.5
    static let HOVER_ZOOM_DEFAULT: Decimal = 1.2
    static let HOVER_ZOOM_STEP: Decimal = 0.1

    private let profiles = EnvironmentValues().profilesState
    private let cells    = EnvironmentValues().cellsState

    @State private var isEditMode = ValueState<Bool>(false)

    init() {
        if let url = ModelContainer.shared.configurations.first?.url.path(percentEncoded: false) {
            Logger.customLog("Storage path: \(url)")
        }
        NSWindow.onChangeRect(Self.WINDOW_MAIN_ID) { [self] window in
            if (self.isEditMode.value) { self.profiles.current.winFrameEditMode = window.frame }
            else                       { self.profiles.current.winFrameViewMode = window.frame }
        }
    }

    public var body: some Scene {
        Window(Self.WINDOW_MAIN_TITLE, id: Self.WINDOW_MAIN_ID) {
            MainScene(isEditMode: self.$isEditMode.value)
                .ignoresSafeArea(.all)
                .gesture(WindowDragGesture())
                .onAppear {
                    if let window = NSWindow.get(Self.WINDOW_MAIN_ID) {
                        window.backgroundColor = .clear
                        window.alphaValue = 1.0
                        window.hideTitleButtons(self.profiles.current.isShowWinTitleButtons)
                        self.updateWindowFrame(self.isEditMode.value)
                    }
                }
                .onAppBecomeBackground {
                    if (!self.isEditMode.value) {
                        NSWindow.hideWithAnimation(
                            Self.WINDOW_MAIN_ID
                        )
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .restorationBehavior(.disabled)
        .environment(\.windowBackground    , self.profiles.current.background)
        .environment(\.windowBackgroundDark, self.profiles.current.backgroundDark)
        .environment(\.profilesState       , self.profiles)
        .environment(\.cellsState          , self.cells)
        .environment(\.layoutDirection, .leftToRight)
        .onChange(of: self.profiles.current, { _, value in
            self.cells.setProfileID(value.ID)
            Task { @MainActor in
                self.updateWindowFrame(self.isEditMode.value)
            }
        })
        .onChange(of: self.profiles.current.isShowWinTitleButtons) { _, value in
            if let window = NSWindow.get(Self.WINDOW_MAIN_ID) {
                window.hideTitleButtons(value)
            }
        }
        .onChange(of: self.isEditMode.value) { _, isEditMode in
            Task { @MainActor in
                self.updateWindowFrame(isEditMode)
            }
        }
        .commands {
            CommandGroup(after: .singleWindowList) {
                Button("Open Main Window") {
                    openWindow(id: Self.WINDOW_MAIN_ID)
                }
            }
        }

        Window(Self.WINDOW_ABOUT_TITLE_LOCALIZED, id: Self.WINDOW_ABOUT_ID) { About() }
            .windowResizability(.contentSize)
            .restorationBehavior(.disabled)
            .commands {
                CommandGroup(replacing: .appInfo) {
                    Button(Self.WINDOW_ABOUT_TITLE_LOCALIZED) {
                        openWindow(id: Self.WINDOW_ABOUT_ID)
                    }
                }
            }
    }

    private func updateWindowFrame(_ isEditMode: Bool) {
        if let window = NSWindow.get(ThisApp.WINDOW_MAIN_ID) {
            if (isEditMode) { window.setFrame(self.profiles.current.winFrameEditMode, display: true, animate: true) }
            else            { window.setFrame(self.profiles.current.winFrameViewMode, display: true, animate: true) }
        }
    }

}
