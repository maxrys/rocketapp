
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct CellID: Equatable {

    typealias Value = UInt16

    var rowNum: GridAxisIndex
    var colNum: GridAxisIndex

    init(rowNum: GridAxisIndex, colNum: GridAxisIndex) {
        self.rowNum = rowNum
        self.colNum = colNum
    }

    init(decodeFrom value: Value) {
        self.rowNum = GridAxisIndex(value >> 8 & 0xff)
        self.colNum = GridAxisIndex(value      & 0xff)
    }

    var value: Value {
        (Value(self.rowNum) << 8) | Value(self.colNum)
    }

}
