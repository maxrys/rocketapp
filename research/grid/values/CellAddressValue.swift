
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct CellAddressValue: Equatable, Hashable {

    typealias Index = UInt8
    typealias Raw = UInt64

    static func keyPathToSector(keyPath: CellValuePath? = nil) -> CellAddressValue.Index {
        switch keyPath {
            case \.cell1: 1
            case \.cell2: 2
            case \.cell3: 3
            case \.cell4: 4
            default: 0
        }
    }

    static func sectorToKeyPath(sector: CellAddressValue.Index) -> CellValuePath? {
        switch sector {
            case 1: \.cell1
            case 2: \.cell2
            case 3: \.cell3
            case 4: \.cell4
            default: nil
        }
    }

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

    public func tokeyPath() -> CellValuePath? {
        Self.sectorToKeyPath(
            sector: self.sector
        )
    }

    public var raw: Raw {
        (Raw(self.toCellID().raw) << Index.bitWidth) | Raw(self.sector)
    }

    public var encode: String {
        "\(self.rowNum)|\(self.colNum)|\(self.sector)"
    }

}
