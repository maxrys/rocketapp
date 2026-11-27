
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI
import SpriteKit

@MainActor final class EMGridScene: LiveScene {

    private var addButtonsPool: [CellAddressValue: WeakValue<AddButtonSprite>] = [:]
    private var appSpritesPool: [CellAddressValue: WeakValue<AppSprite>] = [:]

    private let info: GridInfo

    init(info: GridInfo) {
        self.info = info
        super.init(size: info.sceneSize)
        self.anchorPoint = .zero
        self.scaleMode = .resizeFill
        self.backgroundColor = .clear
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func didMove(to view: SKView) {
        guard children.isEmpty else { return }
        view.window?.acceptsMouseMovedEvents = true
        for rowNum in 0 ..< self.info.rows {
        for colNum in 0 ..< self.info.cols {
            self.addButton_insert(to: CellAddressValue(rowNum: rowNum, colNum: colNum, sector: 1))
            self.addButton_insert(to: CellAddressValue(rowNum: rowNum, colNum: colNum, sector: 2))
            self.addButton_insert(to: CellAddressValue(rowNum: rowNum, colNum: colNum, sector: 3))
            self.addButton_insert(to: CellAddressValue(rowNum: rowNum, colNum: colNum, sector: 4))
            self.addButton_insert(to: CellAddressValue(rowNum: rowNum, colNum: colNum, sector: 0))
        }}
    }

    private func addButton_insert(to address: CellAddressValue) {
        let sprite = AddButtonSprite(
            gridInfo: self.info,
            address: address,
            size: self.info.addressToSizeForAddButtonSprite(address),
            onClick: self.info.onClickAppInsert)
        sprite.position = self.info.addressToPoint(address)
        self.addChild(sprite)
        self.addButtonsPool[address] = WeakValue<AddButtonSprite>(sprite)
    }

    private func appSprite_insert(_ appValue: AppValue, to address: CellAddressValue) {
        let sprite = AppSprite(
            gridInfo: self.info,
            dataHash: appValue.hashValue,
            image: appValue.resolvedIcon,
            title: appValue.name,
            address: address,
            size: self.info.addressToSizeForAppSprite(address),
            onClick: self.info.onClickApp,
            onClickDelete: self.info.onClickAppDelete,
            onDrop: self.info.onAppDrop)
        sprite.position = self.info.addressToPoint(address)
        self.addChild(sprite)
        self.appSpritesPool[address] = WeakValue<AppSprite>(sprite)
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
                    self.addButtonsPool[address]?.value?.isHidden = true
                }
                self.appSprite_insert(appValue, to: addresses[0])
            case .mini(let miniGrid):
                self.appSprite_delete(at: addresses[0])
                self.addButtonsPool[addresses[0]]?.value?.isHidden = true
                let apps = [
                    (appValue: miniGrid.cell1, address: addresses[1]),
                    (appValue: miniGrid.cell2, address: addresses[2]),
                    (appValue: miniGrid.cell3, address: addresses[3]),
                    (appValue: miniGrid.cell4, address: addresses[4]),
                ]
                for (appValue, address) in apps {
                    self.appSprite_delete(at: address)
                    if let appValue {
                        self.addButtonsPool[address]?.value?.isHidden = true
                        self.appSprite_insert(appValue, to: address)
                    } else {
                        self.addButtonsPool[address]?.value?.isHidden = false
                    }
                }
            case .none:
                for address in addresses {
                    self.appSprite_delete(at: address)
                    self.addButtonsPool[address]?.value?.isHidden = false
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
