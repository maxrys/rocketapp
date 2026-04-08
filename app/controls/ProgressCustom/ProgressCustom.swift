
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

struct ProgressCustom: View {

    @Environment(\.colorScheme) private var colorScheme
    @Binding private var value: Double

    let isAnimatable: Bool
    let height: CGFloat
    let zebraSize: CGFloat
    let zebraSpeed: Double
    let valueFont: Font

    init(
        value: Binding<Double>,
        isAnimatable: Bool = true,
        height: CGFloat = 30.0,
        zebraSize: CGFloat = 30.0,
        zebraSpeed: Double = 50,
        valueFont: Font = .system(size: 14, weight: .bold)
    ) {
        self._value = value
        self.isAnimatable = isAnimatable
        self.height = height
        self.zebraSize = zebraSize
        self.zebraSpeed = zebraSpeed
        self.valueFont = valueFont
    }

    public var body: some View {
        Group {
            Color(self.colorScheme == .dark ? .black : .white)
                .overlay(alignment: .leading) { self.IndicatorView() }
                .overlay(alignment: .center ) { self.ValueView() }
        }
        .frame(height: self.height)
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }

    @ViewBuilder private func IndicatorView() -> some View {
        GeometryReader { geometry in
            let value = self.value.fixBounds(max: 1.0)
            let width = geometry.size.width * CGFloat(value)
            Rectangle()
                .fill(Color.accentColor.gradient)
                .animation(.linear, value: value)
                .frame(width: width)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .mask(self.ZebraView(width))
                        .frame(width: width)
                        .clipShape(Rectangle())
                }
        }
    }

    @ViewBuilder private func ZebraPathView(_ width: CGFloat) -> some View {
        Path { path in
            for i in -Int(self.zebraSize) ... Int(width / self.zebraSize) {
                let x = CGFloat(i) * self.zebraSize
                path.move   (to: CGPoint(x: x,        y: +20.0 + self.height))
                path.addLine(to: CGPoint(x: x + 40.0, y: -20.0))
            }
        }.stroke(.black, lineWidth: self.zebraSize / 2.2)
    }

    @ViewBuilder private func ZebraView(_ width: CGFloat) -> some View {
        if (self.isAnimatable) {
            TimelineView(.periodic(from: .now, by: Date.defaultFPS)) { _ in
                self.ZebraPathView(width)
                    .offset(x: Date.spin(max: UInt(self.zebraSize), speed: self.zebraSpeed))
            }
        } else {
            self.ZebraPathView(width)
        }
    }

    @ViewBuilder private func ValueView() -> some View {
        let value = self.value.fixBounds(max: 1.0)
        let formattedValue = Int(value * 100)
        Text("\(formattedValue) %")
            .font(self.valueFont)
            .foregroundStyle(.blue)
            .blendMode(.difference)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    VStack(spacing: 10) {
        ForEach(Array(stride(from: -0.1, through: 1.1, by: 0.1)), id: \.self) { value in
            ProgressCustom(
                value: .constant(value)
            )
        }
    }
    .padding(10)
    .frame(width: 300)
}
