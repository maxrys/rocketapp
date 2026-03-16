
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol BackgroundColorProtocol {

    var colorScheme   : ColorScheme   { get }
    var background    : ColorHSBValue { get }
    var backgroundDark: ColorHSBValue { get }

    func colorBackgroundResolve      (minOpacity: Double) -> Color
    func colorBackgroundAccentResolve(minOpacity: Double) -> Color

}

extension BackgroundColorProtocol {

    private func accentComponent(_ value: Double) -> Double {
        switch value {
            case 0.0 ... 0.1: value + 0.3
            case 0.1 ... 0.2: value + 0.2
            case 0.2 ... 0.7: value + 0.1
            case 0.7 ... 0.8: value - 0.1
            case 0.8 ... 0.9: value - 0.2
            case 0.9 ... 1.0: value - 0.3
            default         : value
        }
    }

    func colorBackgroundResolve(minOpacity: Double = 0.0) -> Color {
        if (self.colorScheme == .dark) {
            Color(
                hue       : self.backgroundDark.hue,
                saturation: self.backgroundDark.saturation,
                brightness: self.backgroundDark.brightness,
                opacity   : self.backgroundDark.opacity.fixBounds(min: minOpacity, max: 1.0)
            )
        } else {
            Color(
                hue       : self.background.hue,
                saturation: self.background.saturation,
                brightness: self.background.brightness,
                opacity   : self.background.opacity.fixBounds(min: minOpacity, max: 1.0)
            )
        }
    }

    func colorBackgroundAccentResolve(minOpacity: Double = 0.0) -> Color {
        if (self.colorScheme == .dark) {
            return Color(
                hue       : self.backgroundDark.hue,
                saturation: self.backgroundDark.saturation,
                brightness: accentComponent(self.backgroundDark.brightness),
                opacity   : self.backgroundDark.opacity.fixBounds(min: minOpacity, max: 1.0)
            )
        } else {
            return Color(
                hue       : self.background.hue,
                saturation: self.background.saturation,
                brightness: accentComponent(self.background.brightness),
                opacity   : self.background.opacity.fixBounds(min: minOpacity, max: 1.0)
            )
        }
    }

}
