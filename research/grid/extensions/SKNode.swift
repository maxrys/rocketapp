
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SpriteKit

extension SKNode {

    func renderedTexture(in view: SKView = SKView(frame: .zero)) -> SKTexture? {
        view.texture(
            from: self,
            crop: self.calculateAccumulatedFrame()
        )
    }

}
