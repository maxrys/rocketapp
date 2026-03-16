
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ButtonRound<L: View, F: ShapeStyle, B: View>: View {

    private let label: L
    private let foreground: F
    private let background: B
    private let isDisabled: Bool
    private let size: CGFloat
    private let onClick: () -> Void

    init(
        @ViewBuilder label: () -> L,
        @ViewBuilder foreground: () -> F = { Color.black },
        @ViewBuilder background: () -> B = { Color.white },
        isDisabled: Bool = false,
        size: CGFloat = 30.0,
        onClick: @escaping () -> Void = { }
    ) {
        self.label = label()
        self.foreground = foreground()
        self.background = background()
        self.isDisabled = isDisabled
        self.size = size
        self.onClick = onClick
    }

    public var body: some View {
        Button {
            self.onClick()
        } label: {
            if let image = self.label as? Image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(self.foreground)
                    .background(self.background)
                    .clipShape(Circle())
                    .contentShape(.focusEffect, Circle())
                    .hoverBehavior(.scaleEffect(from: 1.0, to: 1.1))
            } else {
                self.label
                    .frame(width: self.size, height: self.size)
                    .foregroundStyle(self.foreground)
                    .background(self.background)
                    .clipShape(Circle())
                    .contentShape(.focusEffect, Circle())
                    .hoverBehavior(.scaleEffect(from: 1.0, to: 1.1))
            }
        }
        .buttonStyle(.plain)
        .frame(width: self.size, height: self.size)
        .disabled(self.isDisabled)
        .pointerStyle(.link)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    VStack(spacing: 10) {
        ButtonRound( label: { Image(systemName: "plus.circle") } )
        ButtonRound( label: { Image(systemName: "plus.circle") }, isDisabled: true )
        ButtonRound(
            label: {
                Image(systemName: "minus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
            },
            foreground: { Color.white },
            background: {
                Circle()
                    .fill(Color.gray.gradient)
            },
            size: 30.0,
            onClick: { print("click") }
        ).shadow(
            color: .black,
            radius: 2,
            y: 1
        )
    }.padding(20)
}
