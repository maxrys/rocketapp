
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import AppKit

extension NSWindow {

    static func get(ID: String) -> NSWindow? {
        for window in NSApplication.shared.windows {
            if let foundID = window.identifier {
                if foundID.rawValue == ID {
                    return window
                }
            }
        }
        return nil
    }

    static func hideWithAnimation(windowId: String) {
        if let window = Self.get(ID: windowId) {
            if (window.isVisible) {
                let steps: UInt16 = 10
                _ = Timer.Custom(
                    count: steps,
                    interval: 0.01,
                    onTick: { i in
                        let opacity = CGFloat(steps - i) * 0.1
                        window.alphaValue = opacity
                    },
                    onExpire: {
                        window.close()
                    }
                )
            }
        }
    }

}
