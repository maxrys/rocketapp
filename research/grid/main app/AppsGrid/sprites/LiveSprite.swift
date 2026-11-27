
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SpriteKit

class LiveSprite: SKSpriteNode {

    struct Chain {

        private var references: [WeakValue<LiveSprite>] = []

        public private(set) var nodes: [LiveSprite] {
            get { self.references.compactMap(\.value) }
            set { self.references = newValue.map(WeakValue<LiveSprite>.init) }
        }

        public var root: LiveSprite? {
            self.references.first?.value
        }

        public init(_ parents: [LiveSprite], _ main: LiveSprite) {
            self.nodes = parents + [main]
        }

        public init(_ main: LiveSprite) {
            self.nodes = [main]
        }

    }

    internal var address = CellAddressValue(raw: 0)
    internal lazy var chain = Chain(self)

    public convenience init(texture: SKTexture?, parents: [LiveSprite] = []) {
        self.init(texture: texture)
        if (!parents.isEmpty)
             { self.chain = Chain(parents, self) }
        else { self.chain = Chain(self) }
    }

    public convenience init(color: NSColor, parents: [LiveSprite] = []) {
        self.init(color: color, size: .zero)
        if (!parents.isEmpty)
             { self.chain = Chain(parents, self) }
        else { self.chain = Chain(self) }
    }

    private override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
