
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension Date {

    static var defaultFPS = 1.0 / 24

    static func spin(max: UInt, speed: Double) -> Double {
        Double(UInt(Self().timeIntervalSince1970 * speed) % max)
    }

}
