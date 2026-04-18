
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    struct NSColorSet {
        subscript(_ keyPath: KeyPath<NSColor.Type, NSColor>) -> Color {
            Color(NSColor.self[keyPath: keyPath])
        }
    }

    static let NS = NSColorSet()

}

protocol BackgroundColorProtocol {

    var colorScheme   : ColorScheme   { get }
    var background    : ColorHSBValue { get }
    var backgroundDark: ColorHSBValue { get }

    func backgroundHSB      (minOpacity: Double) -> ColorHSBValue
    func backgroundAccentHSB(minOpacity: Double) -> ColorHSBValue

}

extension BackgroundColorProtocol {

    func backgroundHSB(minOpacity: Double = 0.0) -> ColorHSBValue {
        if (self.colorScheme == .dark) {
            ColorHSBValue(
                self.backgroundDark.hue,
                self.backgroundDark.saturation,
                self.backgroundDark.brightness,
                self.backgroundDark.opacity.fixBounds(min: minOpacity, max: 1.0)
            )
        } else {
            ColorHSBValue(
                self.background.hue,
                self.background.saturation,
                self.background.brightness,
                self.background.opacity.fixBounds(min: minOpacity, max: 1.0)
            )
        }
    }

    func backgroundAccentHSB(minOpacity: Double = 0.0) -> ColorHSBValue {
        if (self.colorScheme == .dark) {
            ColorHSBValue(
                self.backgroundDark.hue,
                self.backgroundDark.saturation,
                self.shiftForAccent(self.backgroundDark.brightness),
                self.backgroundDark.opacity.fixBounds(min: minOpacity, max: 1.0)
            )
        } else {
            ColorHSBValue(
                self.background.hue,
                self.background.saturation,
                self.shiftForAccent(self.background.brightness),
                self.background.opacity.fixBounds(min: minOpacity, max: 1.0)
            )
        }
    }

    private func shiftForAccent(_ value: Double) -> Double {
        value < 0.5 ? 1.0 : 0.0
    }

}

/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct BackgroundColorProtocol_Previews: PreviewProvider {

    static let size: CGFloat = 150

    struct ColorPlateView: View, BackgroundColorProtocol {
        @Environment(\.colorScheme)          internal var colorScheme
        @Environment(\.windowBackground)     internal var background
        @Environment(\.windowBackgroundDark) internal var backgroundDark

        private var accentHSB: ColorHSBValue {
            self.backgroundAccentHSB(minOpacity: 1.0) /* magic result */
        }

        private var formattedHue       : String { self.accentHSB.hue       .formatted(.number.precision(.fractionLength(1))) }
        private var formattedSaturation: String { self.accentHSB.saturation.formatted(.number.precision(.fractionLength(1))) }
        private var formattedBrightness: String { self.accentHSB.brightness.formatted(.number.precision(.fractionLength(1))) }
        private var formattedOpacity   : String { self.accentHSB.opacity   .formatted(.number.precision(.fractionLength(1))) }

        public var body: some View {
            self.backgroundHSB().color
                .frame(width: size, height: size)
                .overlay {
                    VStack(spacing: 0) {
                        self.ResultColorView()
                        self.ValuesPlateView()
                    }.padding(size * 0.2)
                }
        }

        @ViewBuilder private func ResultColorView() -> some View {
            self.accentHSB.color
        }

        @ViewBuilder private func ValuesPlateView() -> some View {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                Text("H: \(self.formattedHue)")
                Text("S: \(self.formattedSaturation)")
                Text("B: \(self.formattedBrightness)")
                Text("O: \(self.formattedOpacity)")
            }
            .font(.system(size: 10, design: .monospaced))
            .foregroundStyle(Color.black)
            .background(Color.white)
        }
    }

    static public var previews: some View {

        let columns: [GridItem] = (0 ..< 3).map { _ in
            GridItem(.fixed(size), spacing: 0)
        }

        VStack(spacing: 5) {

            /* one color and different backgrounds */

            LazyVGrid(columns: columns, spacing: 0) {
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.1))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.2))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.3))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.4))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.5))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.6))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.7))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.8))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.9))
            }
            .environment(\.colorScheme, .light)
            .environment(\.windowBackground, ThisApp.NEW_PROFILE_BACKGROUND)

            LazyVGrid(columns: columns, spacing: 0) {
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.1))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.2))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.3))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.4))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.5))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.6))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.7))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.8))
                ColorPlateView().background(Color(hue: 0.0, saturation: 0.0, brightness: 0.9))
            }
            .environment(\.colorScheme, .dark)
            .environment(\.windowBackgroundDark, ThisApp.NEW_PROFILE_BACKGROUND_DARK)

            /* one background and different colors */

            let variableColorParts = {
                var result: [[Double]] = []
                let slots = SlotsEnumerator(slotsValues: [
                    [0.0, 0.5, 1.0], /* opacity */
                    [0.0, 0.5, 1.0], /* brightness */
                    [0.0, 0.5, 1.0], /* saturation */
                    [0.0, 0.5, 1.0], /* hue */
                ])
                if let slots {
                    for value in slots {
                        if let value = value as? [Double] {
                            result.append(value)
                        }
                    }
                }
                return result
            }()

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(variableColorParts.indices, id: \.self) { index in
                    ColorPlateView()
                        .environment(\.colorScheme, .light)
                        .environment(\.windowBackground, .init(
                            variableColorParts[index][3], /* hue */
                            variableColorParts[index][2], /* saturation */
                            variableColorParts[index][1], /* brightness */
                            variableColorParts[index][0], /* opacity */
                        ))
                }
            }

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(variableColorParts.indices, id: \.self) { index in
                    ColorPlateView()
                        .environment(\.colorScheme, .dark)
                        .environment(\.windowBackgroundDark, .init(
                            variableColorParts[index][3], /* hue */
                            variableColorParts[index][2], /* saturation */
                            variableColorParts[index][1], /* brightness */
                            variableColorParts[index][0], /* opacity */
                        ))
                }
            }

        }
        .padding(5)
        .background(Color.blue)

    }

}
