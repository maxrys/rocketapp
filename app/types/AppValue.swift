
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import AppKit
import UniformTypeIdentifiers

nonisolated struct AppValue: Equatable, Codable {

    static let APP_NO_ICON = NSImage(named: "AppNoIcon")!

    public var bundleID: String
    public var name: String
    public var path: String
    public var icon: Data?

    public var resolvedIcon: NSImage {
        if let iconData = self.icon, let nsImage = NSImage(data: iconData)
             { return nsImage }
        else { return Self.APP_NO_ICON }
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.bundleID == rhs.bundleID &&
        lhs.name     == rhs.name     &&
        lhs.path     == rhs.path     &&
        lhs.icon     == rhs.icon
    }

    static func != (lhs: Self, rhs: Self) -> Bool {
        !(lhs == rhs)
    }

    init(
        bundleID: String,
        name: String,
        path: String,
        icon: Data?
    ) {
        self.bundleID = bundleID
        self.name = name
        self.path = path
        self.icon = icon
    }

    init?(_ appURL: URL) {
        if let bundle = Bundle(url: appURL) {
            if let bundleID = bundle.bundleIdentifier {
                if let name = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String {
                    self.bundleID = bundleID
                    self.name = name
                    self.path = appURL.absoluteString
                    self.icon = NSWorkspace.shared.icon(forFile: appURL.path).tiffRepresentation
                    return
                }
            }
        }
        return nil
    }

    init?(_ appPath: String) {
        if let appURL = URL(string: appPath) {
            if let appValue = Self(appURL) {
                self = appValue
                return
            }
        }
        return nil
    }

    @MainActor static func fromDialog() -> Self? {
        let openPanel = NSOpenPanel()
            openPanel.allowsMultipleSelection = false
            openPanel.canChooseFiles = true
            openPanel.canChooseDirectories = false
            openPanel.canCreateDirectories = false
            openPanel.allowedContentTypes = [.application]
            openPanel.prompt = NSLocalizedString(ThisApp.MESSAGE_IN_OPEN_DIALOG, comment: "")
        if (openPanel.runModal() == .OK) {
            if let appURL = openPanel.url {
                return Self(appURL)
            }
        }
        return nil
    }

}
