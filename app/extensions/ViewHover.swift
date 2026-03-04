
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

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

extension View {

    @ViewBuilder func hoverBehavior(_ behavior: HoverBehavior, duration: TimeInterval = 0.3) -> some View {
        HoverBehaviorView(
            content: { self },
            behavior: behavior,
            duration: duration
        )
    }

}

