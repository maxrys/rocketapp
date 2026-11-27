
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import SpriteKit

@MainActor struct VMGrid: View {

    internal let scene: VMGridScene
    private let gridInfo: GridInfo
    private var sceneFrame: ValueState<CGRect>

    public init(
        info: GridInfo,
        sceneFrame: ValueState<CGRect>
    ) {
        self.gridInfo = info
        self.sceneFrame = sceneFrame
        self.scene = .init(
            info: info
        )
    }

    public var body: some View {
        SpriteView(
            scene: self.scene,
            options: [
                .allowsTransparency
            ]
        )
        .frame(
            width : self.sceneFrame.value.width,
            height: self.sceneFrame.value.height
        )
        .onChange(of: self.sceneFrame.value) { _, _ in
            self.scene.camera?.position = CGPoint(
                x: self.sceneFrame.value.minX + (self.sceneFrame.value.width  / 2.0),
                y: self.sceneFrame.value.minY + (self.sceneFrame.value.height / 2.0)
            )
        }
    }

}
