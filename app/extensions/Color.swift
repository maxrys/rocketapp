
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol BackgroundColorResolvingProtocol {

    var colorScheme   : ColorScheme   { get }
    var background    : ColorHSBValue { get }
    var backgroundDark: ColorHSBValue { get }

    func colorBackgroundResolve      (minOpacity: Double) -> Color
    func colorBackgroundAccentResolve(minOpacity: Double) -> Color

}

extension BackgroundColorResolvingProtocol {

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

    private func accentComponent(_ value: Double) -> Double {
        switch value {
            case 0.0 ... 0.1: return value + 0.3
            case 0.1 ... 0.2: return value + 0.2
            case 0.2 ... 0.7: return value + 0.1
            case 0.7 ... 0.8: return value - 0.1
            case 0.8 ... 0.9: return value - 0.2
            case 0.9 ... 1.0: return value - 0.3
            default         : return value
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

/* TextFieldCustom */

extension Color {

    struct TextFieldCustomColorSet {
        public let titleText  = Color("color TextFieldCustom Title Text")
        public let text       = Color("color TextFieldCustom Text")
        public let border     = Color("color TextFieldCustom Border")
        public let background = Color("color TextFieldCustom Background")
    }

    static let textField = TextFieldCustomColorSet()

}

/* ButtonCustom */

extension Color {

    struct ButtonCustomColorSet {

        enum Style {

            case accent
            case danger
            case custom

            public var text: Color {
                switch self {
                    case .accent: Color.white
                    case .danger: Color.white
                    case .custom: Color("color ButtonCustom Text")
                }
            }

            public var background: Color {
                switch self {
                    case .accent: Color.accentColor
                    case .danger: Color("color ButtonCustom Background Danger")
                    case .custom: Color("color ButtonCustom Background")
                }
            }
        }

    }

}

/* Control Panel */

extension Color {

    struct CtrlPanelColorSet {

        struct StepperColorSet {
            public let titleText        = Color("color Control Panel Stepper Title Text")
            public let valueText        = Color("color Control Panel Stepper Value Text")
            public let groupBackground  = Color("color Control Panel Stepper Group Background")
            public let buttonText       = Color("color Control Panel Stepper Button Text")
            public let buttonBackground = Color("color Control Panel Stepper Button Background")
        }

        public let background       = Color("color Control Panel Background")
        public let buttonText       = Color("color Control Panel Button Text")
        public let buttonBackground = Color("color Control Panel Button Background")
        public let stepper          = StepperColorSet()
    }

    static let ctrlPanel = CtrlPanelColorSet()

}

/* ProfilePanel */

extension Color {

    struct ProfilePanelColorSet {

        struct PickerColorSet {
            public let text                   = Color("color Profile Panel PickerCustom Text")
            public let border                 = Color("color Profile Panel PickerCustom Border")
            public let background             = Color("color Profile Panel PickerCustom Background")
            public let itemText               = Color("color Profile Panel PickerCustom Item Text")
            public let itemBackground         = Color("color Profile Panel PickerCustom Item Background")
            public let itemHoveringBackground = Color.accentColor.opacity(0.2)
            public let itemSelectedBackground = Color.accentColor.opacity(0.5)
        }

        public let titleText        = Color("color Profile Panel Title Text")
        public let groupBackground  = Color("color Profile Panel Group Background")
        public let buttonText       = Color("color Profile Panel Button Text")
        public let buttonBackground = Color("color Profile Panel Button Background")
        public let picker           = PickerColorSet()
    }

    static let profilePanel = ProfilePanelColorSet()

}
