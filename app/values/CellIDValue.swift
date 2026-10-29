
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct CellIDValue: Equatable, Hashable, Codable {

    typealias Index = UInt8
    typealias Raw = UInt16

    static public var zero = CellIDValue(
        rowNum: 0,
        colNum: 0
    )

    public var rowNum: Index
    public var colNum: Index

    init(rowNum: Index, colNum: Index) {
        self.rowNum = rowNum
        self.colNum = colNum
    }

    init(raw: Raw) {
        self.rowNum = Index(raw >> Index.bitWidth & Raw(Index.max))
        self.colNum = Index(raw                   & Raw(Index.max))
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.raw)
    }

    public func toGridPlaceID(sector: GridPlaceIDValue.Index) -> GridPlaceIDValue {
        GridPlaceIDValue(
            rowNum: self.rowNum,
            colNum: self.colNum,
            sector: sector
        )
    }

    public var raw: Raw {
        (Raw(self.rowNum) << Index.bitWidth) | Raw(self.colNum)
    }

}
