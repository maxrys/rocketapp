
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

enum Flexibility {

    case none
    case size(CGFloat)
    case infinity

}

extension View {

    @ViewBuilder func flexibility(_ value: Flexibility = .none) -> some View {
        switch value {
            case .size(let size): self.frame(width: size)
            case .infinity      : self.frame(maxWidth: .infinity)
            case .none          : self
        }
    }

    @ViewBuilder func onPressEnter(_ action: @escaping () -> Void) -> some View {
        self.onKeyPress(phases: .down) { press in
            if (press.key == .return) { action() }
            return .ignored
        }
    }

    @ViewBuilder func onPressEnterOrSpace(_ action: @escaping () -> Void) -> some View {
        self.onKeyPress(phases: .down) { press in
            if (press.key == .return || press.key == .space) { action() }
            return .ignored
        }
    }

    @ViewBuilder func onAppBecomeBackground(_ action: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification),
            perform: { _ in
                action()
            }
        )
    }

    @ViewBuilder func onAppBecomeForeground(_ action: @escaping () -> Void) -> some View {
        self.onReceive(
            NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification),
            perform: { _ in
                action()
            }
        )
    }

}
