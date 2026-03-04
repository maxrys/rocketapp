
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    struct TextFieldCustomColorSet {
        public let titleText  = Color("color TextFieldCustom Title Text")
        public let text       = Color("color TextFieldCustom Text")
        public let border     = Color("color TextFieldCustom Border")
        public let background = Color("color TextFieldCustom Background")
    }

    static let textField = TextFieldCustomColorSet()

}
