
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    enum CtrlPanelColorSet {

        enum StepperColorSet {
            static let titleText        = Color("color Control Panel Stepper Title Text")
            static let valueText        = Color("color Control Panel Stepper Value Text")
            static let groupBackground  = Color("color Control Panel Stepper Group Background")
            static let buttonText       = Color("color Control Panel Stepper Button Text")
            static let buttonBackground = Color("color Control Panel Stepper Button Background")
        }

        static let background       = Color("color Control Panel Background")
        static let buttonText       = Color("color Control Panel Button Text")
        static let buttonBackground = Color("color Control Panel Button Background")
        static let stepper          = StepperColorSet.self
    }

    static let ctrlPanel = CtrlPanelColorSet.self

}
