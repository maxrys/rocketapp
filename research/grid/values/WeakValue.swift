
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

final class WeakValue<T> where T: AnyObject {

    weak var value: T?

    init(_ value: T) {
        self.value = value
    }

}
