
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

extension Dictionary {

    public enum OrderBy {
        case keyAscending
        case keyDescending
        case valueAscending
        case valueDescending
    }

    public func sorted(
        order: Self.OrderBy = .keyAscending
    ) -> [Element] where Key: Comparable, Value: Comparable {
        self.sorted(by: { (lhs, rhs) in
            switch order {
                case .keyAscending   : lhs.key   < rhs.key
                case .keyDescending  : lhs.key   > rhs.key
                case .valueAscending : lhs.value < rhs.value
                case .valueDescending: lhs.value > rhs.value
            }
        })
    }

}

extension Dictionary where Key == CellIDValue {

    struct Bounds: Equatable {
        var minRow: CellIDValue.Index
        var maxRow: CellIDValue.Index
        var minCol: CellIDValue.Index
        var maxCol: CellIDValue.Index
    }

    internal var bounds: Bounds? {
        var result: Bounds?
        for (cellID, _) in self {
            if var bounds = result {
                bounds.minRow = Swift.min(bounds.minRow, cellID.rowNum)
                bounds.maxRow = Swift.max(bounds.maxRow, cellID.rowNum)
                bounds.minCol = Swift.min(bounds.minCol, cellID.colNum)
                bounds.maxCol = Swift.max(bounds.maxCol, cellID.colNum)
                result = bounds
            } else {
                result = Bounds(
                    minRow: cellID.rowNum,
                    maxRow: cellID.rowNum,
                    minCol: cellID.colNum,
                    maxCol: cellID.colNum
                )
            }
        }
        return result
    }

}
