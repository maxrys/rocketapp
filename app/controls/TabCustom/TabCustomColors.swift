
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    struct TabCustomColorSet {
        public let headBackground              = Color.white.opacity(0.5)
        public let headBackgroundDark          = Color.black.opacity(0.2)
        public let headTitle                   = Color.black
        public let headTitleDark               = Color.white
        public let headTitleSelected           = Color.white
        public let headTitleSelectedDark       = Color.white
        public let headTitleBackground         = Color.clear
        public let headTitleSelectedBackground = Color.accentColor
        public let headTitleBorder             = Color.black.opacity(0.1)
        public let headTitleBorderDark         = Color.white.opacity(0.1)
        public let headTitleBorderHovering     = Color.black.opacity(0.5)
        public let headTitleBorderHoveringDark = Color.white.opacity(0.5)
    }

    static let tab = TabCustomColorSet()

}
