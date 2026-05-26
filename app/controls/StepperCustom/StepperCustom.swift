
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct StepperCustom<T>: View where T: Numeric & Comparable {

    typealias ColorSet = Color.CtrlPanelColorSet.StepperColorSet

    @Binding private var value: T

    private let range: ClosedRange<T>
    private let step: T
    private let colorSet: ColorSet

    init(
        _ value: Binding<T>,
        in range: ClosedRange<T>,
        step: T,
        colorSet: ColorSet = Color.ctrlPanel.stepper
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.colorSet = colorSet
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

            var formattedValue: String {
                if let value = self.value as? any BinaryFloatingPoint {
                    return Double(value).formatted(
                        .number.precision(
                            .fractionLength(1)
                        )
                    )
                }
                return "\(self.value)"
            }

            Text(formattedValue)
                .font(.system(size: 16, design: .monospaced))
                .lineLimit(1)
                .foregroundStyle(self.colorSet.valueText)
                .frame(minWidth: 30)

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
        .background(self.colorSet.groupBackground)
        .clipShape(Capsule())
    }

    @ViewBuilder private func ButtonView(image: Image, onClick: @escaping () -> Void) -> some View {
        ButtonRound(
            label     : { image },
            foreground: { self.colorSet.buttonText },
            background: { self.colorSet.buttonBackground },
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
    VStack(spacing: 10) {
        StepperCustom(
            $valueDecimal,
            in: 0.0 ... 1.0,
            step: 0.1
        )
        StepperCustom(
            $valueDouble,
            in: 0.0 ... 1.0,
            step: 0.1
        )
        StepperCustom(
            $valueUInt,
            in: 0 ... 10,
            step: 1
        )
        StepperCustom(
            $valueInt,
            in: -5 ... 5,
            step: 1
        )
    }
    .frame(width: 200)
    .padding(20)
}
