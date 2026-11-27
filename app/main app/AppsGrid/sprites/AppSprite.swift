
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import SpriteKit

final class AppSprite: LiveRootSprite,
                       WithOnChangeCellSize,
                       WithOnChangeCellSpacing,
                       WithOnChangeBackground {

    private static let SPRITE_NAME = "app"
    private static let SPRITE_NAME_FOR_DELETE_BUTTON = "deleteButton"
    private static let SPRITE_NAME_FOR_TITLE = "title"
    private static let ACTION_NAME_FOR_ON_HOVER = "appOnHover"
    private static let TEXTURE_FOR_DELETE_BUTTON = SKTexture(image: NSImage(named: "deleteButton")!)
    private static let TEXTURE_FOR_TITLE_BACKGROUND = SKTexture(image: NSImage(named: "title-background")!)
    private static let TEXTURE_FOR_TITLE_SHADOW = SKTexture(image: NSImage(named: "title-shadow")!)
    private static let TEXTURE_FOR_TITLE_SIZE = CGSize(width: 265, height: 114)
    private static let HOVER_ZOOM_DURATION: CGFloat = 0.15

    public override var cursor: NSCursor { .pointingHand }
    public override var isDraggable: Bool { true }

    private var dataHash: Int = 0
    private var isEditMode: Bool = true

    private var deleteButtonSprite: LiveSprite?
    private var titleSprite: SKNode!
    private var titleLabelSprite: SKLabelNode!
    private var titleBackgroundSprite: SKSpriteNode!
    private var titleShadowSprite: SKSpriteNode!

    private var onClick      : (CellAddressValue) -> Void = { _ in }
    private var onClickDelete: (CellAddressValue) -> Void = { _ in }
    private var onDrop       : (CellAddressValue, CellAddressValue) -> Void = { _,_ in }

    public convenience init(
        gridInfo: GridInfo? = nil,
        dataHash: Int = 0,
        isEditMode: Bool = true,
        image: NSImage,
        title: String,
        address: CellAddressValue,
        size: CGSize,
        onClick      : @escaping (CellAddressValue) -> Void,
        onClickDelete: @escaping (CellAddressValue) -> Void,
        onDrop       : @escaping (CellAddressValue, CellAddressValue) -> Void
    ) {
        self.init(texture: SKTexture(image: image))
        self.name = Self.SPRITE_NAME
        self.gridInfo = gridInfo
        self.dataHash = dataHash
        self.isEditMode = isEditMode
        self.address = address
        self.size = size
        self.onClick = onClick
        self.onClickDelete = onClickDelete
        self.onDrop = onDrop
        if (isEditMode) {
            self.deleteButtonSprite = Self.DeleteButtonSprite(address: address, parentSize: size, parents: self)
            self.addChild(self.deleteButtonSprite!)
        }
        let (titleSprite, labelSprite, backgroundSprite, shadowSprite) = Self.TitleSprite(
            title: title,
            bckground: (self.gridInfo?.background ?? ThisApp.WINDOW_BACKGROUND_DEFAULT).limitedOpacity(min: 1.0),
            parentSize: self.size,
            parents: self
        )
        self.titleSprite = titleSprite
        self.titleLabelSprite = labelSprite
        self.titleBackgroundSprite = backgroundSprite
        self.titleShadowSprite = shadowSprite
        self.addChild(self.titleSprite)
    }

    fileprivate static func DeleteButtonSprite(
        address: CellAddressValue,
        parentSize: CGSize,
        parents: LiveSprite...
    ) -> LiveSprite {
        let sprite = LiveSprite(texture: Self.TEXTURE_FOR_DELETE_BUTTON, parents: parents)
        sprite.name = Self.SPRITE_NAME_FOR_DELETE_BUTTON
        sprite.position = CGPoint(x: parentSize.width * 0.4, y: parentSize.height * 0.4)
        sprite.size = CGSize(
            width : (parentSize.width  * 0.4).fixBounds(min: 20.0, max: 30.0),
            height: (parentSize.height * 0.4).fixBounds(min: 20.0, max: 30.0))
        sprite.isHidden = true
        sprite.address = address
        return sprite
    }

    fileprivate static func TitleSprite(
        title: String,
        bckground: ColorHSBValue,
        font: NSFont = .systemFont(ofSize: 13, weight: .regular),
        parentSize: CGSize? = nil,
        parents: LiveSprite...
    ) -> (SKNode, SKLabelNode, SKSpriteNode, SKSpriteNode) {
        let labelSprite = Self.TitleLabelSprite(text: title, font: font, bckground: bckground)
        let backgroundSprite = Self.TitleBackgroundSprite(minWidth: labelSprite.frame.width, bckground: bckground)
        let shadowSprite = Self.TitleShadowSprite(minWidth: labelSprite.frame.width, bckground: bckground)
        let composition = SKNode()
        composition.addChild(shadowSprite)
        composition.addChild(backgroundSprite)
        composition.addChild(labelSprite)
        composition.addChild({
            let touchPlace = LiveSprite(color: .clear, parents: parents)
            touchPlace.size = backgroundSprite.size
            touchPlace.name = Self.SPRITE_NAME_FOR_TITLE
            touchPlace.zPosition = 3
            return touchPlace
        }())
        composition.isHidden = true
        composition.position = CGPoint(x: 0, y: parentSize.ifNil(
            defaultValue: 0, { size in
                -size.height * 0.4
            })
        )
        return (
            composition,
            labelSprite,
            backgroundSprite,
            shadowSprite
        )
    }

    fileprivate static func TitleLabelSprite(
        text: String,
        maxLength: Int = 30,
        font: NSFont,
        bckground: ColorHSBValue
    ) -> SKLabelNode {
        let sprite = SKLabelNode(
            text: text.count > maxLength ?
                  text.prefix(maxLength) + "..." :
                  text
        )
        sprite.fontName = font.fontName
        sprite.fontSize = font.pointSize
        sprite.fontColor = .white
        sprite.color = bckground.isTinted ? .white : .black
        sprite.colorBlendFactor = 1.0
        sprite.horizontalAlignmentMode = .center
        sprite.verticalAlignmentMode = .baseline
        sprite.position = CGPoint(x: 0, y: font.pointSize * -0.4)
        sprite.zPosition = 2
        return sprite
    }

    fileprivate static func TitleBackgroundSprite(
        minWidth: CGFloat,
        bckground: ColorHSBValue
    ) -> SKSpriteNode {
        let rawSprite = SKSpriteNode(texture: Self.TEXTURE_FOR_TITLE_BACKGROUND)
        let rawSpriteSize = rawSprite.size
        let capWidth = rawSpriteSize.height / 2
        rawSprite.centerRect = CGRect( /* 9-slice mechanism */
            x: capWidth / rawSpriteSize.width, y: 0,
            width: (rawSpriteSize.width - 2 * capWidth) / rawSpriteSize.width,
            height: 1
        )
        rawSprite.size = CGSize(
            width: minWidth * 2 + Self.TEXTURE_FOR_TITLE_SIZE.height,
            height: Self.TEXTURE_FOR_TITLE_SIZE.height
        )
        let sprite = rawSprite.renderedTexture().ifNil(
            defaultValue: rawSprite
        ) { texture in
            SKSpriteNode(texture: texture)
        }
        sprite.size = sprite.size * 0.5
        sprite.color = bckground.skColor
        sprite.colorBlendFactor = 1.0
        sprite.zPosition = 1
        return sprite
    }

    fileprivate static func TitleShadowSprite(
        minWidth: CGFloat,
        bckground: ColorHSBValue
    ) -> SKSpriteNode {
        let rawSprite = SKSpriteNode(texture: Self.TEXTURE_FOR_TITLE_SHADOW)
        let rawSpriteSize = rawSprite.size
        let capWidth = rawSpriteSize.height / 2
        rawSprite.centerRect = CGRect( /* 9-slice mechanism */
            x: capWidth / rawSpriteSize.width, y: 0,
            width: (rawSpriteSize.width - 2 * capWidth) / rawSpriteSize.width,
            height: 1
        )
        rawSprite.size = CGSize(
            width: minWidth * 2 + Self.TEXTURE_FOR_TITLE_SIZE.height,
            height: Self.TEXTURE_FOR_TITLE_SIZE.height
        )
        let sprite = rawSprite.renderedTexture().ifNil(
            defaultValue: rawSprite
        ) { texture in
            SKSpriteNode(texture: texture)
        }
        sprite.size = sprite.size * 0.5
        sprite.color = bckground.isTinted ? .white : .black
        sprite.colorBlendFactor = 1.0
        sprite.zPosition = 0
        return sprite
    }

    internal func onChangeCellSize(_ value: UInt) {
        if let info = self.gridInfo {
            self.position = info.addressToPoint(self.address)
            self.size = info.addressToSizeForAppSprite(self.address)
            self.deleteButtonSprite?.position = CGPoint(
                x: self.size.width  * 0.4,
                y: self.size.height * 0.4
            )
            self.deleteButtonSprite?.size = CGSize(
                width : (self.size.width  * 0.4).fixBounds(min: 20.0, max: 30.0),
                height: (self.size.height * 0.4).fixBounds(min: 20.0, max: 30.0)
            )
            self.titleSprite.position = CGPoint(
                x: 0, y: -self.size.height * 0.4
            )
        }
    }

    internal func onChangeCellSpacing(_ value: UInt) {
        if let info = self.gridInfo {
            self.position = info.addressToPoint(self.address)
        }
    }

    internal func onChangeBackground(_ value: ColorHSBValue) {
        self.titleLabelSprite     .color = value.isTinted ? .white : .black
        self.titleBackgroundSprite.color = value.limitedOpacity(min: 1.0).skColor
        self.titleShadowSprite    .color = value.isTinted ? .white : .black
    }

    internal override func onMouseHover(sprite: LiveSprite) {
        super.onMouseHover(sprite: sprite)
        if (sprite.name == Self.SPRITE_NAME) {
            self.zPosition = 1
            self.deleteButtonSprite?.isHidden = false
            if let info = self.gridInfo {
                if (info.isShowIconTitle == true) {
                    self.titleSprite.isHidden = false
                }
                if (info.iconOnHoverZoom > 1.0) {
                    self.removeAction(forKey: Self.ACTION_NAME_FOR_ON_HOVER)
                    self.run(
                        .scale(to: info.iconOnHoverZoom.double, duration: Self.HOVER_ZOOM_DURATION),
                        withKey: Self.ACTION_NAME_FOR_ON_HOVER
                    )
                }
            }
        }
    }

    internal override func onMouseLeave(sprite: LiveSprite) {
        super.onMouseLeave(sprite: sprite)
        if (sprite.name == Self.SPRITE_NAME) {
            self.zPosition = 0
            self.deleteButtonSprite?.isHidden = true
            if let info = self.gridInfo {
                if (info.isShowIconTitle == true) {
                    self.titleSprite.isHidden = true
                }
                if (info.iconOnHoverZoom > 1.0) {
                    self.removeAction(forKey: Self.ACTION_NAME_FOR_ON_HOVER)
                    self.run(
                        .scale(to: 1.0, duration: Self.HOVER_ZOOM_DURATION),
                        withKey: Self.ACTION_NAME_FOR_ON_HOVER
                    )
                }
            }
        }
    }

    internal override func onClick(sprite: LiveSprite) {
        if (sprite.name == Self.SPRITE_NAME                  ) { self.onClick      (self.address) }
        if (sprite.name == Self.SPRITE_NAME_FOR_TITLE        ) { self.onClick      (self.address) }
        if (sprite.name == Self.SPRITE_NAME_FOR_DELETE_BUTTON) { self.onClickDelete(self.address) }
    }

    internal override func onDrop(to: LiveRootSprite) -> Void {
        self.onDrop(self.address, to.address)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

struct AppSprite_Previews: PreviewProvider {

    static private let SCENE_SIZE = CGSize(width: 200, height: 400)

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

            let addButtonSprite = AddButtonSprite(
                address: CellAddressValue(rowNum: 0, colNum: 0, sector: 0),
                size: CGSize(width: 50, height: 50),
                onClick: { address in }
            )
            addButtonSprite.position = CGPoint(x: 100, y: 300)
            self.addChild(addButtonSprite)

            let appSprite1 = AppSprite(
                image: ThisApp.MOCK_APP_VALUE.resolvedIcon,
                title: "Test App",
                address: CellAddressValue(rowNum: 1, colNum: 0, sector: 0),
                size: CGSize(width: 100, height: 100),
                onClick      : self.onClickApp,
                onClickDelete: self.onClickAppDelete,
                onDrop       : self.onAppDrop
            )
            appSprite1.position = CGPoint(x: 100, y: 200)
            self.addChild(appSprite1)

            let appSprite2 = AppSprite(
                image: ThisApp.MOCK_APP_VALUE.resolvedIcon,
                title: "Test App",
                address: CellAddressValue(rowNum: 2, colNum: 0, sector: 0),
                size: CGSize(width: 100, height: 100),
                onClick      : self.onClickApp,
                onClickDelete: self.onClickAppDelete,
                onDrop       : self.onAppDrop
            )
            appSprite2.position = CGPoint(x: 100, y: 100)
            self.addChild(appSprite2)

            self.children.compactMap { node in node as? WithOnChangeBackground }.forEach { sprite in
                sprite.onChangeBackground(
                    ThisApp.WINDOW_BACKGROUND_DEFAULT
                )
            }
        }

        private func onClickApp(address: CellAddressValue) {
            Logger.customLog("onClickApp on \(address.encode)")
        }

        private func onClickAppDelete(address: CellAddressValue) {
            Logger.customLog("onClickAppDelete on \(address.encode)")
        }

        private func onAppDrop(fromAddress: CellAddressValue, toAddress: CellAddressValue) {
            Logger.customLog("onAppDrop from \(fromAddress.encode) to \(toAddress.encode)")
        }

    }

    static public var previews: some View {
        SpriteView(
            scene: PreviewScene(),
            options: [.allowsTransparency]
        ).frame(width: SCENE_SIZE.width, height: SCENE_SIZE.height)
    }

}



struct AppSprite_Title_Previews: PreviewProvider {

    static private let SCENE_SIZE = CGSize(width: 300, height: 200)

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

            let (title1, _, _, _) = AppSprite.TitleSprite(
                title: "Some Title",
                bckground: ColorHSBValue(0.5, 0.5, 0.9, 1.0))
            title1.position = CGPoint(
                x: self.frame.width  / 2,
                y: self.frame.height / 2 + 20)
            title1.isHidden = false
            self.addChild(title1)

            let (title2, _, _, _) = AppSprite.TitleSprite(
                title: "Some Long Long Long Long Long Long Title",
                bckground: ColorHSBValue(0.5, 0.5, 0.3, 1.0))
            title2.position = CGPoint(
                x: self.frame.width  / 2,
                y: self.frame.height / 2 - 20)
            title2.isHidden = false
            self.addChild(title2)
        }

    }

    static public var previews: some View {
        SpriteView(
            scene: PreviewScene(),
            options: [.allowsTransparency]
        ).frame(width: SCENE_SIZE.width, height: SCENE_SIZE.height)
    }

}
