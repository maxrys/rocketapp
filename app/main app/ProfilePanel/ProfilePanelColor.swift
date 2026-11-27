
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    enum ProfilePanelColorSet {

        enum PickerColorSet {
            static let text                   = Color("color Profile Panel PickerCustom Text")
            static let border                 = Color("color Profile Panel PickerCustom Border")
            static let background             = Color("color Profile Panel PickerCustom Background")
            static let itemText               = Color("color Profile Panel PickerCustom Item Text")
            static let itemBackground         = Color("color Profile Panel PickerCustom Item Background")
            static let itemHoveringBackground = Color.accentColor.opacity(0.2)
            static let itemSelectedBackground = Color.accentColor.opacity(0.5)
        }

        static let titleText        = Color("color Profile Panel Title Text")
        static let groupBackground  = Color("color Profile Panel Group Background")
        static let buttonText       = Color("color Profile Panel Button Text")
        static let buttonBackground = Color("color Profile Panel Button Background")
        static let picker           = PickerColorSet.self
    }

    static let profilePanel = ProfilePanelColorSet.self

}
