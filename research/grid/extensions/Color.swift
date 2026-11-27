
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    struct NSColorSet {
        subscript(_ color: NSColor) -> Color {
            Color(color)
        }
    }

    static let NS = NSColorSet()

}



/* ############################### */
/* ### BackgroundColorProtocol ### */
/* ############################### */

@MainActor protocol BackgroundColorProtocol {

    var colorScheme   : ColorScheme   { get }
    var background    : ColorHSBValue { get }
    var backgroundDark: ColorHSBValue { get }

    func backgroundCurrent      (minOpacity: Double, maxOpacity: Double) -> ColorHSBValue
    func backgroundCurrentAccent(minOpacity: Double, maxOpacity: Double) -> ColorHSBValue

}

extension BackgroundColorProtocol {

    func backgroundCurrent(minOpacity: Double = 0.0, maxOpacity: Double = 1.0) -> ColorHSBValue {
        if (self.colorScheme == .dark) {
            self.backgroundDark.limitedOpacity(
                min: minOpacity,
                max: maxOpacity
            )
        } else {
            self.background.limitedOpacity(
                min: minOpacity,
                max: maxOpacity
            )
        }
    }

    func backgroundCurrentAccent(minOpacity: Double = 0.0, maxOpacity: Double = 1.0) -> ColorHSBValue {
        if (self.colorScheme == .dark) {
            self.backgroundDark.accentBrightness.limitedOpacity(
                min: minOpacity,
                max: maxOpacity
            )
        } else {
            self.background.accentBrightness.limitedOpacity(
                min: minOpacity,
                max: maxOpacity
            )
        }
    }

}
