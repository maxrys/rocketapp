
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import SpriteKit

final class TestSprite: LiveRootSprite {

    private static let SPRITE_NAME = "root"
    private static let SPRITE_NAME_CHILD = "child"
    private static let SPRITE_NAME_CHILD_CHILD = "child_child"

    private var colorRoot      : ColorHSBValue = .black
    private var colorChild     : ColorHSBValue = .black
    private var colorChildChild: ColorHSBValue = .black

    public convenience init(
        position: CGPoint,
        size: CGSize,
        colorRoot: ColorHSBValue,
        colorChild: ColorHSBValue,
        colorChildChild: ColorHSBValue,
        positionOffsetIsPositive isRight: Bool
    ) {
        self.init(color: colorRoot.skColor)
        self.name = Self.SPRITE_NAME
        self.position = position
        self.size = size
        self.colorRoot = colorRoot
        self.colorChild = colorChild
        self.colorChildChild = colorChildChild
        let childSprite      = Self.ChildSprite     (parentSize: size, isRight: isRight, color: colorChild     .skColor, parents: self)
        let childChildSprite = Self.ChildChildSprite(parentSize: size, isRight: isRight, color: colorChildChild.skColor, parents: self, childSprite)
        self.addChild(childSprite)      /* chain: root -> child */
        self.addChild(childChildSprite) /* chain: root -> child -> childChild */
    }

    fileprivate static func ChildSprite(
        parentSize: CGSize,
        isRight: Bool,
        color: SKColor,
        parents: LiveSprite...
    ) -> LiveSprite {
        let sprite = LiveSprite(color: color, parents: parents)
        sprite.name = Self.SPRITE_NAME_CHILD
        sprite.position = CGPoint(x: parentSize.width * (isRight ? 0.15 : -0.15), y: 0)
        sprite.size = parentSize * 0.7
        return sprite
    }

    fileprivate static func ChildChildSprite(
        parentSize: CGSize,
        isRight: Bool,
        color: SKColor,
        parents: LiveSprite...
    ) -> LiveSprite {
        let sprite = LiveSprite(color: color, parents: parents)
        sprite.name = Self.SPRITE_NAME_CHILD_CHILD
        sprite.position = CGPoint(x: parentSize.width * (isRight ? 0.3 : -0.3), y: 0)
        sprite.size = parentSize * 0.4
        return sprite
    }

    internal override func onMouseHover(sprite: LiveSprite) {
        if (sprite.name == Self.SPRITE_NAME            ) { sprite.color = self.colorRoot      .highlighted.skColor }
        if (sprite.name == Self.SPRITE_NAME_CHILD      ) { sprite.color = self.colorChild     .highlighted.skColor }
        if (sprite.name == Self.SPRITE_NAME_CHILD_CHILD) { sprite.color = self.colorChildChild.highlighted.skColor }
        Logger.customLog("hover \(sprite.name ?? "-")")
    }

    internal override func onMouseLeave(sprite: LiveSprite) {
        if (sprite.name == Self.SPRITE_NAME            ) { sprite.color = self.colorRoot      .skColor }
        if (sprite.name == Self.SPRITE_NAME_CHILD      ) { sprite.color = self.colorChild     .skColor }
        if (sprite.name == Self.SPRITE_NAME_CHILD_CHILD) { sprite.color = self.colorChildChild.skColor }
        Logger.customLog("out \(sprite.name ?? "-")")
    }

    internal override func onClick(sprite: LiveSprite) {
        Logger.customLog("click \(sprite.name ?? "-")")
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct TestSprite_Previews: PreviewProvider {

    static private let SCENE_SIZE = CGSize(width: 350, height: 270)

    private final class PreviewScene: LiveScene {

        override init() {
            super.init(size: SCENE_SIZE)
            self.anchorPoint = .zero
            self.scaleMode = .fill
            self.backgroundColor = .white
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        internal override func didMove(to view: SKView) {
            guard children.isEmpty else { return }
            view.window?.acceptsMouseMovedEvents = true
            self.addChild(
                TestSprite(
                    position: CGPoint(x: 100, y: 170),
                    size: CGSize(width: 150, height: 150),
                    colorRoot      : ColorHSBValue(0.7, 0.6, 0.7, 1.0),
                    colorChild     : ColorHSBValue(0.7, 0.7, 0.7, 1.0),
                    colorChildChild: ColorHSBValue(0.7, 0.8, 0.7, 1.0),
                    positionOffsetIsPositive: true
                )
            )
            self.addChild(
                TestSprite(
                    position: CGPoint(x: 250, y: 100),
                    size: CGSize(width: 150, height: 150),
                    colorRoot      : ColorHSBValue(0.6, 0.6, 0.7, 1.0),
                    colorChild     : ColorHSBValue(0.6, 0.7, 0.7, 1.0),
                    colorChildChild: ColorHSBValue(0.6, 0.8, 0.7, 1.0),
                    positionOffsetIsPositive: false
                )
            )
        }

    }

    static public var previews: some View {
        SpriteView(
            scene: PreviewScene(),
            options: [.allowsTransparency]
        ).frame(width: SCENE_SIZE.width, height: SCENE_SIZE.height)
    }

}
