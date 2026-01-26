
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

extension GraphicsContext {

    func drawRectangle(
        x: Double = 0,
        y: Double = 0,
        w: Double = 100,
        h: Double = 100,
        radius: Double = 0,
        lineWidth: Double = 0,
        colorLine: Color = .black,
        colorFill: Color = .white
    ) {
        let path = Path(
            roundedRect: CGRect(
                origin: CGPoint(x: x, y: y),
                size: CGSize(width: w, height: h)
            ).insetBy(
                dx: lineWidth / 2,
                dy: lineWidth / 2),
            cornerRadius: radius
        )
        self.stroke(path, with: .color(colorLine), lineWidth: lineWidth)
        self.fill  (path, with: .color(colorFill))
    }

}
