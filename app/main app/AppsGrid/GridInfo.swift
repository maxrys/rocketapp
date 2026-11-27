
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SpriteKit

final class GridInfo {

    public let cols: UInt8 = ThisApp.GRID_COLS
    public let rows: UInt8 = ThisApp.GRID_ROWS
    public let gridPadding: UInt = ThisApp.GRID_PADDING

    public var cellSize: UInt            = ThisApp.CELL_SIZE_DEFAULT
    public var cellSpacing: UInt         = ThisApp.CELL_SPACING_DEFAULT
    public var iconOnHoverZoom: Decimal  = ThisApp.HOVER_ZOOM_DEFAULT
    public var isShowIconTitle: Bool     = ThisApp.IS_SHOW_ICON_TITLE_DEFAULT
    public var background: ColorHSBValue = ThisApp.WINDOW_BACKGROUND_DEFAULT

    public var sceneSize: CGSize {
        CGSize(
            width : CGFloat(self.gridPadding * 2) + (CGFloat(self.cols) * CGFloat(self.cellSize)) + (CGFloat(self.cols - 1) * CGFloat(self.cellSpacing)),
            height: CGFloat(self.gridPadding * 2) + (CGFloat(self.rows) * CGFloat(self.cellSize)) + (CGFloat(self.rows - 1) * CGFloat(self.cellSpacing))
        )
    }

    public let onClickApp          : (CellAddressValue) -> Void
    public let onClickAppInsert    : (CellAddressValue) -> Void
    public let onClickAppDelete    : (CellAddressValue) -> Void
    public let onAppDrop           : (CellAddressValue, CellAddressValue) -> Void
    public let onAppDropFromOutside: (CellAddressValue, AppValue) -> Void

    init(
        onClickApp          : @escaping (CellAddressValue) -> Void,
        onClickAppInsert    : @escaping (CellAddressValue) -> Void,
        onClickAppDelete    : @escaping (CellAddressValue) -> Void,
        onAppDrop           : @escaping (CellAddressValue, CellAddressValue) -> Void,
        onAppDropFromOutside: @escaping (CellAddressValue, AppValue) -> Void,
    ) {
        self.onClickApp           = onClickApp
        self.onClickAppInsert     = onClickAppInsert
        self.onClickAppDelete     = onClickAppDelete
        self.onAppDrop            = onAppDrop
        self.onAppDropFromOutside = onAppDropFromOutside
    }

    internal func addressToPoint(_ address: CellAddressValue) -> CGPoint {
        let halfSize = CGFloat(self.cellSize) / 2.0
        let x =                         CGFloat(self.gridPadding) + CGFloat(address.colNum) * (CGFloat(self.cellSize) + CGFloat(self.cellSpacing))
        let y = self.sceneSize.height - CGFloat(self.gridPadding) - CGFloat(address.rowNum) * (CGFloat(self.cellSize) + CGFloat(self.cellSpacing)) - CGFloat(self.cellSize)
        switch address.sector {
            case  1: return CGPoint(x: x + halfSize * 0.5, y: y + halfSize * 1.5)
            case  2: return CGPoint(x: x + halfSize * 1.5, y: y + halfSize * 1.5)
            case  3: return CGPoint(x: x + halfSize * 0.5, y: y + halfSize * 0.5)
            case  4: return CGPoint(x: x + halfSize * 1.5, y: y + halfSize * 0.5)
            default: return CGPoint(x: x + halfSize      , y: y + halfSize      )
        }
    }

    internal func addressToSizeForAddButtonSprite(_ address: CellAddressValue) -> CGSize {
        address.sector == 0 ?
            CGSize(width: CGFloat(self.cellSize) * 0.30, height: CGFloat(self.cellSize) * 0.30) :
            CGSize(width: CGFloat(self.cellSize) * 0.20, height: CGFloat(self.cellSize) * 0.20)
    }

    internal func addressToSizeForAppSprite(_ address: CellAddressValue) -> CGSize {
        address.sector == 0 ?
            CGSize(width: CGFloat(self.cellSize) * 1.12, height: CGFloat(self.cellSize) * 1.12) :
            CGSize(width: CGFloat(self.cellSize) * 0.50, height: CGFloat(self.cellSize) * 0.50)
    }

}
