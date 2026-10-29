
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import AppKit
import UniformTypeIdentifiers

nonisolated struct AppValue: Equatable, Codable {

    static let APP_NO_ICON = NSImage(named: "AppNoIcon")!
    static let ICON_RENDER_SIZE = CGSize(width: 200, height: 200)

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
                    let image = NSWorkspace.shared.icon(forFile: appURL.path)
                    guard let bitmap = NSBitmapImageRep(
                        bitmapDataPlanes: nil,
                        pixelsWide: Int(Self.ICON_RENDER_SIZE.width),
                        pixelsHigh: Int(Self.ICON_RENDER_SIZE.height),
                        bitsPerSample: 8,
                        samplesPerPixel: 4,
                        hasAlpha: true,
                        isPlanar: false,
                        colorSpaceName: .deviceRGB,
                        bytesPerRow: 0,
                        bitsPerPixel: 0
                    ), let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
                        return nil
                    }
                    NSGraphicsContext.saveGraphicsState()
                    NSGraphicsContext.current = context
                    context.imageInterpolation = .high
                    image.draw(
                        in: CGRect(x: 0, y: 0, width: Self.ICON_RENDER_SIZE.width, height: Self.ICON_RENDER_SIZE.height),
                        from: .zero,
                        operation: .copy,
                        fraction: 1
                    )
                    NSGraphicsContext.restoreGraphicsState()
                    self.icon = bitmap.tiffRepresentation
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
        openPanel.prompt = NSLocalizedString(ThisApp.MESSAGE_SELECT_THIS_APPLICATION, comment: "")

        guard openPanel.runModal() == .OK else {
            return nil
        }
        guard let appURL = openPanel.url else {
            return nil
        }
        return Self(appURL)
    }

}
