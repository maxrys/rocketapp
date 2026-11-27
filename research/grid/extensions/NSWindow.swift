
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import AppKit
import Combine

extension NSWindow {

    static func get(_ ID: String) -> NSWindow? {
        for window in NSApplication.shared.windows {
            if let foundID = window.ID {
                if foundID == ID {
                    return window
                }
            }
        }
        return nil
    }

    static func hideWithAnimation(_ ID: String, onComplete: @escaping () -> Void = {}) {
        if let window = Self.get(ID) {
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
                        window.hide()
                        window.alphaValue = 1.0
                        onComplete()
                    }
                )
            }
        }
    }

    func show() { self.makeKeyAndOrderFront(nil) }
    func hide() { self.orderOut(nil) }

    var ID: String? {
        self.identifier?.rawValue
    }

}
