
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

extension Numeric {

    func fixBounds(min: Self = 0, max: Self) -> Self where Self: Comparable {
        if (self < min) { return min }
        if (self > max) { return max }
        return self
    }

    func progress(max: Self) -> Double where Self: BinaryInteger {
        let result = Double(self) / Double(max)
        return result.isNaN ? 0 : result.fixBounds(
            min: 0.0,
            max: 1.0
        )
    }

}

extension Numeric where Self == Decimal {

    var double: Double {
        NSDecimalNumber(decimal: self).doubleValue
    }

}
