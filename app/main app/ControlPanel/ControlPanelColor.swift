
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

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
