
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

enum Flexibility {

    case none
    case size(CGFloat)
    case infinity

}

extension View {

    @ViewBuilder func flexibility(_ value: Flexibility = .none) -> some View {
        switch value {
        case .size(let size): self.frame(width: size)
        case .infinity      : self.frame(maxWidth: .infinity)
        case .none          : self
        }
    }

}
