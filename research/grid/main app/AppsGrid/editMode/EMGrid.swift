
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI
import SpriteKit
import UniformTypeIdentifiers

@MainActor struct EMGrid: View {

    internal let scene: EMGridScene
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
        .onDrop(
            of: [.application],
            delegate: DropFromOutside(
                scene: self.scene,
                onAppDropFromOutside: self.gridInfo.onAppDropFromOutside
            )
        )
    }

}



internal struct DropFromOutside: DropDelegate {

    enum DroppableMatch {
        case none
        case notDroppable(LiveSprite)
        case droppable   (LiveSprite)
    }

    let scene: EMGridScene
    let onAppDropFromOutside: (CellAddressValue, AppValue) -> Void

    internal func dropEntered(info: DropInfo) {
        let target = target(at: info.location)
        if case .none                = target { NSCursor.operationNotAllowed.set(); self.scene.hoverPoolOperation() }
        if case .notDroppable        = target { NSCursor.operationNotAllowed.set(); self.scene.hoverPoolOperation() }
        if case .droppable(let node) = target { NSCursor.dragCopy.set();            self.scene.hoverPoolOperation(node) }
    }

    internal func dropUpdated(info: DropInfo) -> DropProposal? {
        let target = target(at: info.location)
        if case .none                = target { NSCursor.operationNotAllowed.set(); self.scene.hoverPoolOperation() }
        if case .notDroppable        = target { NSCursor.operationNotAllowed.set(); self.scene.hoverPoolOperation() }
        if case .droppable(let node) = target { NSCursor.dragCopy.set();            self.scene.hoverPoolOperation(node) }
        return DropProposal(operation: .copy)
    }

    internal func dropExited(info: DropInfo) {
        NSCursor.arrow.set()
    }

    internal func performDrop(info: DropInfo) -> Bool {
        guard let provider = info.itemProviders(for: [.application]).first else {
            return false
        }
        let target = self.target(
            at: info.location
        )
        guard case .droppable(let node) = target else {
            return false
        }
        provider.loadItem(forTypeIdentifier: "public.item", options: nil) { item, error in
            if let error {
                Logger.customLog("onDropApp error: \(error.localizedDescription)")
                return
            }
            Task { @MainActor in
                guard let appURL = item as? URL       else { return }
                guard let appValue = AppValue(appURL) else { return }
                self.onAppDropFromOutside(node.address, appValue)
            }
        }
        return true
    }

    private func target(at dropPoint: CGPoint) -> DroppableMatch {
        guard let localPoint = self.toLocalPoint(dropPoint)                    else { return .none }
        guard let node = self.scene.nodes(at: localPoint).first as? LiveSprite else { return .none }
        guard let root = node.chain.root as? LiveRootSprite                    else { return .none }
        return root.isDroppable ? .droppable(node) : .notDroppable(node)
    }

    private func toLocalPoint(_ dropPoint: CGPoint) -> CGPoint? {
        guard let view = self.scene.view else {
            return nil
        }
        return self.scene.convertPoint(
            fromView: CGPoint(
                x: dropPoint.x,
                y: view.isFlipped ? dropPoint.y : view.bounds.height - dropPoint.y
            )
        )
    }

}
