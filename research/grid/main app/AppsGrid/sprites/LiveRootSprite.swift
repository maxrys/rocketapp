
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SpriteKit

class LiveRootSprite: LiveSprite {

    enum InteractionShape {
        case rectangle
        case circle
    }

    public var cursor: NSCursor { .arrow }
    public var interactionShape: InteractionShape { .rectangle }
    public var isDraggable: Bool { false }
    public var isDroppable: Bool { false }
    public var acceptTypes: [SKSpriteNode.Type] { [] }

    internal var gridInfo: GridInfo?

    internal func onMouseHover(sprite: LiveSprite) { self.cursor.set() }
    internal func onMouseLeave(sprite: LiveSprite) { NSCursor.arrow.set() }
    internal func onClick(sprite: LiveSprite) {}
    internal func onDrop(to: LiveRootSprite) {}

}

protocol WithOnChangeCellSize        { func onChangeCellSize       (_ value: UInt) }
protocol WithOnChangeCellSpacing     { func onChangeCellSpacing    (_ value: UInt) }
protocol WithOnChangeIconOnHoverZoom { func onChangeIconOnHoverZoom(_ value: Decimal) }
protocol WithOnChangeIsShowIconTitle { func onChangeIsShowIconTitle(_ value: Bool) }
protocol WithOnChangeBackground      { func onChangeBackground     (_ value: ColorHSBValue) }
