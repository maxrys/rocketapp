
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Color {

    enum TabCustomColorSet {
        static let headBackground              = Color.white.opacity(0.5)
        static let headBackgroundDark          = Color.black.opacity(0.2)
        static let headTitle                   = Color.black
        static let headTitleDark               = Color.white
        static let headTitleSelected           = Color.white
        static let headTitleSelectedDark       = Color.white
        static let headTitleBackground         = Color.clear
        static let headTitleSelectedBackground = Color.accentColor
        static let headTitleBorder             = Color.black.opacity(0.1)
        static let headTitleBorderDark         = Color.white.opacity(0.1)
        static let headTitleBorderHovering     = Color.black.opacity(0.5)
        static let headTitleBorderHoveringDark = Color.white.opacity(0.5)
    }

    static let tab = TabCustomColorSet.self

}
