
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

    @ViewBuilder func ignoresSafeArea(isIgnore: Bool = true, _ regions: SafeAreaRegions = .all, edges: Edge.Set = .all) -> some View {
        if (isIgnore)
             { self.ignoresSafeArea(regions, edges: edges) }
        else { self }
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



/* ################################# */
/* ### windowChamelionBackground ### */
/* ################################# */

extension View {

    @ViewBuilder func windowChamelionBackground(
        windowID                   : String? = nil,
        backgroundTint             : Color = .NS[.windowBackgroundColor].opacity(0.7),
        backgroundTintDark         : Color = .NS[.windowBackgroundColor].opacity(0.7),
        backgroundColorFallback    : Color = .NS[.windowBackgroundColor],
        backgroundColorDarkFallback: Color = .NS[.windowBackgroundColor],
        isIgnoreSafeArea: Bool = true
    ) -> some View {
        self.ignoresSafeArea(
                isIgnore: isIgnoreSafeArea
            )
            .background(
                ChamelionBackground(
                    backgroundTint             : backgroundTint,
                    backgroundTintDark         : backgroundTintDark,
                    backgroundColorFallback    : backgroundColorFallback,
                    backgroundColorDarkFallback: backgroundColorDarkFallback
                )
            )
            .onAppear {
                if let windowID = windowID, let window = NSWindow.get(windowID) {
                    window.backgroundColor = .clear
                    window.alphaValue = 1.0
                }
            }
    }

}

struct ChamelionBackground: View {

    @Environment(\.colorScheme) private var colorScheme

    let backgroundTint: Color
    let backgroundTintDark: Color
    let backgroundColorFallback: Color
    let backgroundColorDarkFallback: Color

    public var body: some View {
        if #available(macOS 12.0, *) {
            if (self.colorScheme == .dark)
                 { Rectangle().fill(.ultraThinMaterial).overlay { self.backgroundTintDark } }
            else { Rectangle().fill(.ultraThinMaterial).overlay { self.backgroundTint     } }
        } else {
            if (self.colorScheme == .dark)
                 { self.backgroundColorDarkFallback }
            else { self.backgroundColorFallback     }
        }
    }

}



/* ##################### */
/* ### HoverBehavior ### */
/* ##################### */

extension View {

    @ViewBuilder func hoverBehavior(_ behavior: HoverBehavior, duration: TimeInterval = 0.3) -> some View {
        HoverBehaviorView(
            content: { self },
            behavior: behavior,
            duration: duration
        )
    }

}

enum HoverBehavior {

    case scaleEffect(
        from: Double,
        to  : Double
    )
    case changeForegroundColor(
        from: Color,
        to  : Color
    )
    case changeBackgroundColor(
        from: Color,
        to  : Color
    )
    case zIndex(
        to: Double
    )

}

struct HoverBehaviorView<Content: View>: View {

    @State private var isHovering = false

    private let content: () -> Content
    private let behavior: HoverBehavior
    private let duration: TimeInterval

    init(@ViewBuilder content: @escaping () -> Content, behavior: HoverBehavior, duration: TimeInterval) {
        self.content  = content
        self.behavior = behavior
        self.duration = duration
    }

    public var body: some View {
        switch self.behavior {

            case .scaleEffect(let from, let to):
                self.content()
                    .scaleEffect(self.isHovering ? to : from)
                    .onHover { isHovering in
                        withAnimation(.easeInOut(duration: self.duration)) {
                            self.isHovering = isHovering
                        }
                    }

            case .changeForegroundColor(let from, let to):
                self.content()
                    .foregroundStyle(self.isHovering ? to : from)
                    .onHover { isHovering in
                        withAnimation(.easeInOut(duration: self.duration)) {
                            self.isHovering = isHovering
                        }
                    }

            case .changeBackgroundColor(let from, let to):
                self.content()
                    .background(self.isHovering ? to : from)
                    .onHover { isHovering in
                        withAnimation(.easeInOut(duration: self.duration)) {
                            self.isHovering = isHovering
                        }
                    }

            case .zIndex(let to):
                self.content()
                    .zIndex(self.isHovering ? to : 0)
                    .onHover { isHovering in
                        withAnimation(.easeInOut(duration: self.duration)) {
                            self.isHovering = isHovering
                        }
                    }

        }
    }

}
