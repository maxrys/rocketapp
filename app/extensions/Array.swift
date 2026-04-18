
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension Array {

    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    subscript(safe index: Int, default value: Element) -> Element {
        indices.contains(index) ? self[index] : value
    }

}
