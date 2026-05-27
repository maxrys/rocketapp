
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct СhameleonView<Content: View>: View, BackgroundColorProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark

    private let radius: CGFloat
    private let minOpacity: Double
    private let shadowRadius: Double
    private let isFlat: Bool
    private let content: () -> Content

    init(
        radius: CGFloat = 20,
        minOpacity: Double = 0.9,
        shadowRadius: Double = 10,
        isFlat: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.radius = radius
        self.minOpacity = minOpacity
        self.shadowRadius = shadowRadius
        self.isFlat = isFlat
        self.content = content
    }

    public var body: some View {
        self.content()
            .foregroundStyle(self.AdaptiveForegroundShapeStyle())
            .background {
                if (self.shadowRadius > 0)
                     { self.AdaptiveShadowWrapperView(self.AdaptiveBackgroundView()) }
                else {                                self.AdaptiveBackgroundView()  }
            }
    }

    @ViewBuilder private func AdaptiveForegroundShapeStyle() -> some ShapeStyle {
        self.colorScheme == .dark ?
            (self.backgroundDark.isTinted == true ? Color.white : Color.black) :
            (self.background    .isTinted != true ? Color.black : Color.white)
    }

    @ViewBuilder private func AdaptiveBackgroundView() -> some View {
        if (self.isFlat)
             { RoundedRectangle(cornerRadius: self.radius).fill( self.backgroundHSB(minOpacity: self.minOpacity).color) }
        else { RoundedRectangle(cornerRadius: self.radius).fill( self.backgroundHSB(minOpacity: self.minOpacity).color.gradient) }
    }

    @ViewBuilder private func AdaptiveShadowWrapperView(_ view: some View) -> some View {
        view.shadow(
            color:
                self.colorScheme == .dark ?
                    (self.backgroundDark.isTinted == true ? Color.white.opacity(0.5) : Color.black.opacity(0.5)) :
                    (self.background    .isTinted != true ? Color.black.opacity(0.5) : Color.white.opacity(0.5)),
            radius: self.shadowRadius
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Previewer {
        СhameleonView(radius: 20, minOpacity: 0.9, shadowRadius: 10, isFlat: false) {
            Text("some text")
                .font(.system(size: 14))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(20)
        }.padding(20)
    }
}
