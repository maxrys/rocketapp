
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

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
