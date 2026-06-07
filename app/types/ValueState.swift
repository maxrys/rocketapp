
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Observation

@Observable final class ValueState<T> {

    var value: T

    init(_ value: T) {
        self.value = value
    }

    deinit {
    }

}
