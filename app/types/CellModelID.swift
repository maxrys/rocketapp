
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct CellModelID: Equatable {

    typealias CellSector = UInt8
    typealias Value = UInt64

    var ID: CellID.Value
    var sector: CellSector

    init(ID: CellID.Value, sector: CellSector) {
        self.ID     = ID
        self.sector = sector
    }

    init(decodeFrom modelID: Value) {
        self.ID     = CellID.Value(modelID >> CellSector.bitWidth & Value(CellID.Value.max))
        self.sector = CellSector  (modelID                        & Value(CellSector  .max))
    }

    var value: Value {
        (Value(self.ID) << CellSector.bitWidth) | Value(self.sector)
    }

}
