
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import CoreGraphics

extension CGRect {

    init(minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        self.init(
            x: minX,
            y: minY,
            width : maxX - minX,
            height: maxY - minY
        )
    }

}
