
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI
import SpriteKit

@MainActor final class VMGridScene: LiveScene {

    private var appSpritesPool: [CellAddressValue: WeakValue<VMSpriteApp>] = [:]

    private let info: GridInfo

    init(info: GridInfo) {
        self.info = info
        super.init(size: info.sceneSize)
        self.anchorPoint = .zero
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
        let camera = SKCameraNode()
        camera.position = .zero
        self.addChild(camera)
        self.camera = camera
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func didMove(to view: SKView) {
        guard children.isEmpty else { return }
        view.window?.acceptsMouseMovedEvents = true
    }

    private func appSprite_insert(_ appValue: AppValue, to address: CellAddressValue) {
        let sprite = VMSpriteApp(
            gridInfo: self.info,
            dataHash: appValue.hashValue,
            image: appValue.resolvedIcon,
            title: appValue.name,
            address: address,
            size: self.info.addressToSizeForAppSprite(address),
            onClick: self.info.onClickApp)
        sprite.position = self.info.addressToPoint(address)
        self.addChild(sprite)
        self.appSpritesPool[address] = WeakValue<VMSpriteApp>(sprite)
    }

    private func appSprite_delete(at address: CellAddressValue) {
        if let reference = self.appSpritesPool[address] {
            self.hoverPoolCleanIfNotEmpty()
            self.appSpritesPool[address] = nil
            reference.value?.removeFromParent()
        }
    }

    public func appSprite_wiping() {
        for (address, _) in self.appSpritesPool {
            self.appSprite_delete(at: address)
        }
    }

    internal func renderCell(_ cellID: CellIDValue, value: CellValue?) {
        let addresses = (0 ... 4).map {
            cellID.toCellAddress(sector: $0)
        }
        switch value {
            case .main(let appValue):
                for address in addresses {
                    self.appSprite_delete(at: address)
                }
                self.appSprite_insert(appValue, to: addresses[0])
            case .mini(let miniGrid):
                self.appSprite_delete(at: addresses[0])
                let apps = [
                    (appValue: miniGrid.cell1, address: addresses[1]),
                    (appValue: miniGrid.cell2, address: addresses[2]),
                    (appValue: miniGrid.cell3, address: addresses[3]),
                    (appValue: miniGrid.cell4, address: addresses[4]),
                ]
                for (appValue, address) in apps {
                    self.appSprite_delete(at: address)
                    if let appValue {
                        self.appSprite_insert(appValue, to: address)
                    }
                }
            case .none:
                for address in addresses {
                    self.appSprite_delete(at: address)
                }
        }
    }

    internal func onChangeCellSize(_ value: UInt) {
        self.scene?.children.compactMap { node in node as? WithOnChangeCellSize }.forEach { sprite in
            sprite.onChangeCellSize(value)
        }
    }

    internal func onChangeCellSpacing(_ value: UInt) {
        self.scene?.children.compactMap { node in node as? WithOnChangeCellSpacing }.forEach { sprite in
            sprite.onChangeCellSpacing(value)
        }
    }

    internal func onChangeIconOnHoverZoom(_ value: Decimal) {
        self.scene?.children.compactMap { node in node as? WithOnChangeIconOnHoverZoom }.forEach { sprite in
            sprite.onChangeIconOnHoverZoom(value)
        }
    }

    internal func onChangeIsShowIconTitle(_ value: Bool) {
        self.scene?.children.compactMap { node in node as? WithOnChangeIsShowIconTitle }.forEach { sprite in
            sprite.onChangeIsShowIconTitle(value)
        }
    }

    internal func onChangeBackground(_ value: ColorHSBValue) {
        self.scene?.children.compactMap { node in node as? WithOnChangeBackground }.forEach { sprite in
            sprite.onChangeBackground(value)
        }
    }

}
