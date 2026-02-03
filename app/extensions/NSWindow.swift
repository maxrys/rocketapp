
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
                let steps: UInt = 10
                _ = Timer.Custom(
                    repeats: .count(steps),
                    delay: 0.01,
                    onTick: { timer in
                        let opacity = CGFloat(steps - timer.i - 1) * 0.1
                        window.alphaValue = opacity
                    },
                    onExpire: { _ in
                        window.close()
                    }
                )
            }
        }
    }

    func hideTitleButtons(isVisible: Bool = true) {
        self.standardWindowButton(.closeButton)?.isHidden       = !isVisible
        self.standardWindowButton(.miniaturizeButton)?.isHidden = !isVisible
        self.standardWindowButton(.zoomButton)?.isHidden        = !isVisible
    }

}
