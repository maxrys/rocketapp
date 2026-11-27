
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SpriteKit

@MainActor class LiveScene: SKScene {

    private struct InteractionInfo {
        var root: LiveRootSprite
        var node: LiveSprite
    }

    private var interactionInfo: InteractionInfo?

    private func isPointInRectangle(_ point: CGPoint, in root: LiveRootSprite) -> Bool {
        let localPoint = root.convert(point, from: self)
        let bounds = CGRect(
            x: -root.anchorPoint.x * root.size.width,
            y: -root.anchorPoint.y * root.size.height,
            width : root.size.width,
            height: root.size.height)
        return bounds.contains(localPoint)
    }

    private func isPointInCircle(_ point: CGPoint, in root: LiveRootSprite) -> Bool {
        let localPoint = root.convert(point, from: self)
        let center = CGPoint(
            x: (0.5 - root.anchorPoint.x) * root.size.width,
            y: (0.5 - root.anchorPoint.y) * root.size.height)
        let radius = min(root.size.width, root.size.height) * 0.5
        let dx = localPoint.x - center.x
        let dy = localPoint.y - center.y
        return dx * dx + dy * dy <= radius * radius
    }

    /* ########################## */
    /* ### MARK: mouse events ### */
    /* ########################## */

    internal override func mouseDown(with event: NSEvent) {
        if case .sprite(let root, let node) = self.hoverMatch(location: event.location(in: self)) {
            self.interactionInfo = .init(root: root, node: node)
        }
    }

    internal override func mouseUp(with event: NSEvent) {
        guard let interactionInfo = self.interactionInfo else { return }
        if case .sprite(let root, _) = self.hoverMatch(location: event.location(in: self)) {
            let isInSelf = interactionInfo.root === root
            if (isInSelf) { /* click */
                interactionInfo.root.onClick(
                    sprite: interactionInfo.node
                )
            } else { /* drag and drop */
                if interactionInfo.root.isDraggable {
                    if root.acceptTypes.contains(where: { type(of: interactionInfo.root) == $0 }) {
                        interactionInfo.root.onDrop(
                            to: root
                        )
                    }
                }
            }
        }
        NSCursor.arrow.set()
        self.interactionInfo = nil
    }

    internal override func mouseMoved(with event: NSEvent) {
        self.hoverUpdate(
            at: event.location(in: self)
        )
    }

    internal override func mouseDragged(with event: NSEvent) {
        guard let interactionInfo = self.interactionInfo else { return }
        let (root, node): (LiveRootSprite?, LiveSprite?) =
            switch self.hoverMatch(location: event.location(in: self)) {
                case .sprite(let root, let node): (root, node)
                case .none: (nil, nil)
            }
        let isInSelf = interactionInfo.root === root
        let isDraggable = interactionInfo.root.isDraggable
        let isDroppable = root.ifNil(defaultValue: false) { root in
            root.isDroppable &&
            root.acceptTypes.contains(where: {
                type(of: interactionInfo.root) == $0
            })
        }
        self.hoverPoolOperation(
            !isInSelf && isDraggable && isDroppable ? node : nil
        )
        /* cursor */
        if (isInSelf != true && isDraggable != true) { NSCursor.arrow.set() }
        if (isInSelf != true && isDraggable == true && isDroppable == true) { NSCursor.dragCopy.set() }
        if (isInSelf != true && isDraggable == true && isDroppable != true) { NSCursor.operationNotAllowed.set() }
        if (isInSelf == true) { interactionInfo.root.cursor.set() }
    }

    /* ################### */
    /* ### MARK: hover ### */
    /* ################### */

    private enum HoverMatch {
        case sprite(LiveRootSprite, LiveSprite)
        case none
    }

    private var hoverPool: [LiveSprite] = []

    public func hoverUpdate(at point: CGPoint) {
        switch self.hoverMatch(location: point) {
            case .sprite(let root, let node):
                self.hoverPoolOperation(node)
                root.cursor.set()
            case .none:
                self.hoverPoolOperation(nil)
                NSCursor.arrow.set()
        }
    }

    public func hoverPoolCleanIfNotEmpty() {
        if !self.hoverPool.isEmpty {
            self.hoverPoolPopAll()
        }
    }

    private func hoverMatch(location point: CGPoint) -> HoverMatch {
        let node = self.nodes(at: point).first as? LiveSprite
        let root = node?.chain.root as? LiveRootSprite
        if let node, let root, root.interactionShape == .rectangle, self.isPointInRectangle(point, in: root) { return .sprite(root, node) }
        if let node, let root, root.interactionShape == .circle   , self.isPointInCircle   (point, in: root) { return .sprite(root, node) }
        return .none
    }

    internal func hoverPoolOperation(_ node: LiveSprite? = nil) {
        if (self.hoverPool.last === node) {
            return
        }

        if (node == nil) {
            self.hoverPoolPopAll()
            return
        }

        if let node {
            if let root = self.hoverPool.first {
                if node.chain.root !== root {
                    self.hoverPoolPopAll()
                    for chainNode in node.chain.nodes {
                        self.hoverPoolPush(chainNode)
                    }
                } else {
                    let depth = Array.depthOfEqualityObjects(self.hoverPool, node.chain.nodes)
                    while self.hoverPool.count > depth {
                        self.hoverPoolPop()
                    }
                    for chainNode in node.chain.nodes.dropFirst(depth) {
                        self.hoverPoolPush(chainNode)
                    }
                }
            } else {
                for chainNode in node.chain.nodes {
                    self.hoverPoolPush(chainNode)
                }
            }
        }
    }

    private func hoverPoolPush(_ node: LiveSprite) {
        if let root = node.chain.root as? LiveRootSprite {
            self.hoverPool.append(node)
            root.onMouseHover(sprite: node)
        }
    }

    private func hoverPoolPop() {
        if let lastNode = self.hoverPool.popLast() {
            if      let root = self.hoverPool.first as? LiveRootSprite { root.onMouseLeave(sprite: lastNode) }
            else if let root = lastNode             as? LiveRootSprite { root.onMouseLeave(sprite: lastNode) }
        }
    }

    private func hoverPoolPopAll() {
        while let lastNode = self.hoverPool.popLast() {
            if      let root = self.hoverPool.first as? LiveRootSprite { root.onMouseLeave(sprite: lastNode) }
            else if let root = lastNode             as? LiveRootSprite { root.onMouseLeave(sprite: lastNode) }
        }
    }

}
