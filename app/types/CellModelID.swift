
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct CellModelID: Equatable {

    typealias Value = UInt64

    var ID: CellID.Value
    var sector: CellSector

    init(ID: CellID.Value, sector: CellSector) {
        self.ID     = ID
        self.sector = sector
    }

    init(decodeFrom modelID: Value) {
        self.ID     = CellID.Value(modelID >> 8 & 0xffff)
        self.sector = CellSector  (modelID      & 0x00ff)
    }

    var value: Value {
        (Value(self.ID) << 8) | Value(self.sector)
    }

}
