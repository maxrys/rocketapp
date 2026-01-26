
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct CellID: Equatable {

    typealias Index = UInt8
    typealias Value = UInt16

    var rowNum: Index
    var colNum: Index

    init(rowNum: Index, colNum: Index) {
        self.rowNum = rowNum
        self.colNum = colNum
    }

    init(decodeFrom value: Value) {
        self.rowNum = Index(value >> Index.bitWidth & Value(Index.max))
        self.colNum = Index(value                   & Value(Index.max))
    }

    var value: Value {
        (Value(self.rowNum) << Index.bitWidth) | Value(self.colNum)
    }

}
