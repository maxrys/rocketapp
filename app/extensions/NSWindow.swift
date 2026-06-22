
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

    func hideTitleButtons(_ isVisible: Bool = true) {
        self.standardWindowButton(.closeButton      )?.isHidden = !isVisible
        self.standardWindowButton(.miniaturizeButton)?.isHidden = !isVisible
        self.standardWindowButton(.zoomButton       )?.isHidden = !isVisible
    }

    var ID: String? {
        self.identifier?.rawValue
    }

    static private var onChangeCancellableBag: [
        String: AnyCancellable
    ] = [:]

    static func onChangeRect(_ ID: String, _ action: @escaping (NSWindow) -> Void) {
        Self.onChangeCancellableBag[ID]?.cancel()
        Self.onChangeCancellableBag[ID] = NotificationCenter.default.publisher(for: Self.didResizeNotification)
            .merge(with: NotificationCenter.default.publisher(for: Self.didMoveNotification))
            .compactMap { notification in notification.object as? Self }
            .filter { window in window.ID == ID }
            .sink { window in
                Task { @MainActor in
                    action(window)
                }
            }
    }

    static func removeOnChangeRect(_ ID: String) {
        Self.onChangeCancellableBag[ID]?.cancel()
        Self.onChangeCancellableBag[ID] = nil
    }

    static func centerWindowFrame(_ ID: String, frame: CGRect) -> CGRect {
        var result = frame
        if (result.w.isFinite && result.h.isFinite) {
            if let window = Self.get(ID) {
                if let screenFrame = window.screen?.visibleFrame {
                    result.x = screenFrame.origin.x + (screenFrame.w - result.w) / 2
                    result.y = screenFrame.origin.y + (screenFrame.h - result.h) / 2
                }
            }
        }
        return result
    }

}
