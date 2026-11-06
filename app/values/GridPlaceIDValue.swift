
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct GridPlaceIDValue: Equatable, Hashable {

    typealias Index = UInt8
    typealias Raw = UInt64

    public var rowNum: Index
    public var colNum: Index
    public var sector: Index

    init(rowNum: Index, colNum: Index, sector: Index) {
        self.rowNum = rowNum
        self.colNum = colNum
        self.sector = sector
    }

    init(cellID: CellIDValue, sector: Index) {
        self.rowNum = cellID.rowNum
        self.colNum = cellID.colNum
        self.sector = sector
    }

    init(raw: Raw) {
        self.rowNum = Index(raw >> (Index.bitWidth * 2) & Raw(Index.max))
        self.colNum = Index(raw >> (Index.bitWidth * 1) & Raw(Index.max))
        self.sector = Index(raw                         & Raw(Index.max))
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.raw)
    }

    public func toCellID() -> CellIDValue {
        CellIDValue(
            rowNum: self.rowNum,
            colNum: self.colNum
        )
    }

    public var raw: Raw {
        (Raw(self.toCellID().raw) << Index.bitWidth) | Raw(self.sector)
    }

}
