
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import SwiftData

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}

@main struct ThisApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openWindow) private var openWindow

    static let NOT_APPLICABLE = "—"
    static let CONTAINER_PATH = "~/Library/Containers/maxrys.rocketapp"
    static let DEMO_BUNDLE_ID = "com.apple.calculator"
    static let DEMO_PATH = "file:///System/Applications/Calculator.app/"
    static let DEMO_NAME = "Calculator"
    static let DEMO_ICON = NSImage(named: "AppIcon")!
    static let MAIN_WINDOW_TITLE = "RocketApp"
    static let MAIN_WINDOW_ID = "mainGrid"
    static let MESSAGE_NO_APPLICATIONS = NSLocalizedString("No Applications", comment: "")
    static let MESSAGE_ADD_NEW_APPLICATIONS_THROUGH = NSLocalizedString("Add new applications through the", comment: "")
    static let MESSAGE_SETTINGS = NSLocalizedString("Settings", comment: "")
    static let MESSAGE_SELECT_THIS_APPLICATION = NSLocalizedString("Select this application", comment: "")
    static let PREVIEW_PROFILE_ID: ProfileID = ProfileID.max
    static let EMBEDDED_PROFILE_ID: ProfileID = 0
    static let NEW_PROFILE_TITLE: ProfileTitle = "My Profile"
    static let NEW_PROFILE_ZOOM: Decimal = 1.0
    static let NEW_PROFILE_SPACING: UInt = 20
    static let NEW_PROFILE_ICON_ON_HOVER_ZOOM: Decimal = 1.2
    static let NEW_PROFILE_IS_SHOW_ICON_TITLE = true
    static let NEW_PROFILE_IS_HIDE_ON_MISCLICK = false
    static let NEW_PROFILE_IS_STICKY_GRID = false
    static let NEW_PROFILE_BACKGROUND = ColorHSBValue(0.55, 0.0, 1.0, 0.92)
    static let NEW_PROFILE_BACKGROUND_DARK = ColorHSBValue(0.30, 0.0, 0.16, 0.92)
    static let NEW_PROFILE_BACKGROUND_ENCODED = Self.NEW_PROFILE_BACKGROUND.encode()!
    static let NEW_PROFILE_BACKGROUND_DARK_ENCODED = Self.NEW_PROFILE_BACKGROUND_DARK.encode()!
    static let NEW_PROFILE_IS_SHOW_WINDOW_TITLE_BUTTONS = true
    static let PROFILE_ICON_ON_HOVER_ZOOM_MIN: Decimal = 1.0
    static let PROFILE_ICON_ON_HOVER_ZOOM_MAX: Decimal = 1.5
    static let GRID_COLS_MAX: CellsByAxisCount = 30
    static let GRID_ROWS_MAX: CellsByAxisCount = 30
    static let CELL_SIZE: CGFloat = 100

    private let profiles = EnvironmentValues().profilesState
    private let cells    = EnvironmentValues().cellsState

    init() {
        if let url = ModelContainer.shared.configurations.first?.url.path(percentEncoded: false) {
            Logger.customLog("Storage path: \(url)")
        }
    }

    public var body: some Scene {
        Window(Self.MAIN_WINDOW_TITLE, id: Self.MAIN_WINDOW_ID) {
            MainScene()
                .ignoresSafeArea(.all)
                .gesture(WindowDragGesture())
                .onAppear {

                    /* hide window control buttons */

                    if let window = NSWindow.get(ID: Self.MAIN_WINDOW_ID) {
                        window.hideTitleButtons(isVisible: self.profiles.current.isShowWinTitleButtons)
                        window.backgroundColor = .clear
                        window.alphaValue = 1.0
                    }

                    /* add observer for the window focus lost event */

                    NotificationCenter.default.addObserver(forName: NSApplication.didResignActiveNotification, object: nil, queue: .main) { _ in
                        NSWindow.hideWithAnimation(
                            windowId: Self.MAIN_WINDOW_ID
                        )
                    }

                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self)
                }
        }
        .windowStyle(.hiddenTitleBar)
        .restorationBehavior(.automatic)
        .environment(\.windowBackground    , self.profiles.current.background)
        .environment(\.windowBackgroundDark, self.profiles.current.backgroundDark)
        .environment(\.profilesState       , self.profiles)
        .environment(\.cellsState          , self.cells)
        .environment(\.layoutDirection, .leftToRight)
        .onChange(of: self.profiles.current, { _, value in
            self.cells.setProfileID(value.ID)
        })
        .onChange(of: self.profiles.current.isShowWinTitleButtons) { _, value in
            if let window = NSWindow.get(ID: Self.MAIN_WINDOW_ID) {
                window.hideTitleButtons(isVisible: value)
            }
        }
        .commands {
            CommandGroup(after: .singleWindowList) {
                Button("Open Main Window") {
                    openWindow(id: Self.MAIN_WINDOW_ID)
                }
            }
        }
    }

}
