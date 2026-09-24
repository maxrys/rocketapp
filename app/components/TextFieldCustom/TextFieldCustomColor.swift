
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    enum TextFieldCustomColorSet {
        static let titleText  = Color("color TextFieldCustom Title Text")
        static let text       = Color("color TextFieldCustom Text")
        static let border     = Color("color TextFieldCustom Border")
        static let background = Color("color TextFieldCustom Background")
    }

    static let textField = TextFieldCustomColorSet.self

}
