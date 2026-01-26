
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import Foundation

extension Logger {

    nonisolated static func customLog(_ message: String) {
        #if DEBUG
            print(message)
        #endif
    }

}
