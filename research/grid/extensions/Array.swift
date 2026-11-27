
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension Array {

    static func depthOfEqualityObjects(_ lhs: Self, _ rhs: Self) -> Int where Element: AnyObject {
        zip(lhs, rhs).prefix { LItem, RItem in LItem === RItem }.count
    }

}
