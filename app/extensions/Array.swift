
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension Array {

    static func depthOfEquality(_ lhs: Self, _ rhs: Self) -> Int where Element: Equatable {
        zip(lhs, rhs).prefix { LItem, RItem in LItem == RItem }.count
    }

    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    subscript(safe index: Int, default value: Element) -> Element {
        indices.contains(index) ? self[index] : value
    }

}
