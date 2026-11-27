
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct StepperCustom<T, R>: View where T: Numeric & Comparable, R: RangeExpression, R.Bound == Int {

    @Binding private var value: T

    private let range: ClosedRange<T>
    private let step: T
    private let prefix: String
    private let suffix: String
    private let fractionLength: R
    private let minWidth: CGFloat

    init(
        _ value: Binding<T>,
        prefix: String = "",
        suffix: String = "",
        in range: ClosedRange<T>,
        fractionLength: R = 0 ... 10,
        step: T,
        minWidth: CGFloat = 0.0
    ) {
        self._value = value
        self.prefix = prefix
        self.suffix = suffix
        self.range = range
        self.fractionLength = fractionLength
        self.step = step
        self.minWidth = minWidth
    }

    public var body: some View {
        HStack(spacing: 10) {

            self.ButtonView(image: Image(systemName: "minus.circle")) {
                let newValue = self.value - self.step
                self.value = newValue.fixBounds(
                    min: self.range.lowerBound,
                    max: self.range.upperBound
                )
            }.disabled(
                self.value <= self.range.lowerBound
            )

            self.ValueView()
                .frame(minWidth: self.minWidth)

            self.ButtonView(image: Image(systemName: "plus.circle")) {
                let newValue = self.value + self.step
                self.value = newValue.fixBounds(
                    min: self.range.lowerBound,
                    max: self.range.upperBound
                )
            }.disabled(
                self.value >= self.range.upperBound
            )

        }
        .padding(5)
        .background(Color.ctrlPanel.stepper.groupBackground)
        .clipShape(Capsule())
    }

    @ViewBuilder private func ValueView() -> some View {
        var formattedValue: String {
            if let value = self.value as? any BinaryFloatingPoint {
                return Double(value).formatted(
                    .number.locale(.current).precision(.fractionLength(self.fractionLength))
                )
            }
            if let value = self.value as? Decimal {
                return value.formatted(
                    .number.locale(.current).precision(.fractionLength(self.fractionLength))
                )
            }
            return "\(self.value)"
        }
        Text("\(self.prefix)\(formattedValue)\(self.suffix)")
            .font(.system(size: 16, design: .monospaced))
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: true)
            .foregroundStyle(Color.ctrlPanel.stepper.valueText)
            .frame(minWidth: 30)
    }

    @ViewBuilder private func ButtonView(image: Image, onClick: @escaping () -> Void) -> some View {
        ButtonRound(
            label     : { image },
            foreground: { Color.ctrlPanel.stepper.buttonText },
            background: { Color.ctrlPanel.stepper.buttonBackground },
            size: 25.0,
            onClick: onClick
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    @Previewable @State var valueDecimal: Decimal = 0.5
    @Previewable @State var valueDouble: Double = 0.5
    @Previewable @State var valueUInt: UInt = 5
    @Previewable @State var valueInt: Int = 0
    Previewer(padding: 20) {
        StepperCustom(
            $valueDecimal,
            prefix: "x",
            in: 0.0 ... 1.0,
            step: 0.1,
            minWidth: 50
        ).frame(width: 200)
        StepperCustom(
            $valueDouble,
            prefix: "x",
            in: 0.0 ... 1.0,
            step: 0.1,
            minWidth: 50
        )
        StepperCustom(
            $valueUInt,
            in: 0 ... 10,
            step: 1,
            minWidth: 50
        )
        StepperCustom(
            $valueInt,
            in: -5 ... 5,
            step: 1,
            minWidth: 50
        )
    }
}
