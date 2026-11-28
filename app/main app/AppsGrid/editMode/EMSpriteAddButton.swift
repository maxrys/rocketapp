
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI
import SpriteKit

final class EMSpriteAddButton:
        LiveRootSprite,
        WithOnChangeCellSize,
        WithOnChangeCellSpacing,
        WithOnChangeBackground {

    private static let SPRITE_NAME = "addButton"
    private static let ACTION_NAME_FOR_ON_HOVER = "addButtonOnHover"
    private static let TEXTURE = SKTexture(image: NSImage(named: "addButton")!)
    private static let TEXTURE_FOR_BACKGROUND = SKTexture(image: NSImage(named: "addButton-background")!)

    public override var cursor: NSCursor { .pointingHand }
    public override var interactionShape: InteractionShape { .circle }
    public override var isDroppable: Bool { true }
    public override var acceptTypes: [SKSpriteNode.Type] { [EMSpriteApp.self] }

    private var backgroundSprite: SKSpriteNode!

    private var onClick: (CellAddressValue) -> Void = { _ in }

    public convenience init(
        gridInfo: GridInfo? = nil,
        address: CellAddressValue,
        size: CGSize,
        onClick: @escaping (CellAddressValue) -> Void
    ) {
        self.init(texture: Self.TEXTURE)
        self.name = Self.SPRITE_NAME
        self.gridInfo = gridInfo
        self.address = address
        self.size = size
        self.color = .black
        self.colorBlendFactor = 1.0
        self.onClick = onClick
        self.backgroundSprite = Self.BackgroundSprite(parentSize: size)
        self.addChild(self.backgroundSprite)
    }

    fileprivate static func BackgroundSprite(
        parentSize: CGSize
    ) -> SKSpriteNode {
        let sprite = SKSpriteNode(texture: Self.TEXTURE_FOR_BACKGROUND, color: .white, size: parentSize)
        sprite.position = CGPoint(x: 0, y: 0)
        sprite.size = parentSize
        sprite.colorBlendFactor = 1.0
        sprite.zPosition = -1
        return sprite
    }

    internal func onChangeCellSize(_ value: UInt) {
        if let info = self.gridInfo {
            self.position = info.addressToPoint(self.address)
            self.size = info.addressToSizeForAddButtonSprite(self.address)
            self.backgroundSprite.size = self.size
        }
    }

    internal func onChangeCellSpacing(_ value: UInt) {
        if let info = self.gridInfo {
            self.position = info.addressToPoint(self.address)
        }
    }

    internal func onChangeBackground(_ value: ColorHSBValue) {
        self.color                  = value.limitedOpacity(min: 1.0).accentBrightness.skColor
        self.backgroundSprite.color = value.limitedOpacity(min: 1.0).skColor
    }

    internal override func onMouseHover(sprite: LiveSprite) {
        super.onMouseHover(sprite: sprite)
        if (sprite.name == Self.SPRITE_NAME) {
            self.removeAction(forKey: Self.ACTION_NAME_FOR_ON_HOVER)
            self.run(
                .colorize(
                    with: .systemBlue,
                    colorBlendFactor: 1,
                    duration: 0.0),
                withKey: Self.ACTION_NAME_FOR_ON_HOVER
            )
        }
    }

    internal override func onMouseLeave(sprite: LiveSprite) {
        super.onMouseLeave(sprite: sprite)
        if (sprite.name == Self.SPRITE_NAME), let background = self.gridInfo?.background {
            self.removeAction(forKey: Self.ACTION_NAME_FOR_ON_HOVER)
            self.run(
                .colorize(
                    with: background.limitedOpacity(min: 1.0).accentBrightness.skColor,
                    colorBlendFactor: 1,
                    duration: 0.0),
                withKey: Self.ACTION_NAME_FOR_ON_HOVER
            )
        }
    }

    internal override func onClick(sprite: LiveSprite) {
        if (sprite.name == Self.SPRITE_NAME) {
            self.onClick(self.address)
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct AddButtonSprite_Previews: PreviewProvider {

    static private let SCENE_SIZE = CGSize(width: 200, height: 200)

    private final class PreviewScene: LiveScene {

        override init() {
            super.init(size: SCENE_SIZE)
            self.anchorPoint = .zero
            self.scaleMode = .fill
            self.backgroundColor = .gray
        }

        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        internal override func didMove(to view: SKView) {
            guard children.isEmpty else { return }
            view.window?.acceptsMouseMovedEvents = true
            let addButtonSprite = EMSpriteAddButton(
                address: CellAddressValue(rowNum: 0, colNum: 0, sector: 0),
                size: CGSize(width: 100, height: 100),
                onClick: { address in }
            )
            addButtonSprite.position = CGPoint(x: 100, y: 100)
            self.addChild(addButtonSprite)
            addButtonSprite.onChangeBackground(
                ThisApp.WINDOW_BACKGROUND_DEFAULT
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
