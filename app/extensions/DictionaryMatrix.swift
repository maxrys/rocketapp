
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

extension Dictionary {

    struct Matrix where Key: UnsignedInteger & Comparable {

        typealias Index = CellID.Index

        struct GlobalKey {
            var y: Index
            var x: Index
        }

        struct Bounds: Equatable {
            var minY: Index
            var maxY: Index
            var minX: Index
            var maxX: Index
        }

        private var data: [Key: Value] = [:]

        public var flat: [Key: Value] {
            return self.data
        }

        public var multidimensional: [Index: [Index: Value]] {
            var result: [Index: [Index: Value]] = [:]
            for (localKey, value) in self.data {
                let globalKey = self.toGlobalKey(localKey)
                if (result[globalKey.y] == nil) { result[globalKey.y] = [:] }
                result[globalKey.y]?[globalKey.x] = value
            }
            return result
        }

        public var isEmpty: Bool {
            return self.data.isEmpty
        }

        public var bounds: Bounds? {
            guard let firstLocalKey = self.data.first?.key else { return nil }
            let globalKey = self.toGlobalKey(firstLocalKey)
            var result = Self.Bounds(
                minY: globalKey.y,
                maxY: globalKey.y,
                minX: globalKey.x,
                maxX: globalKey.x,
            )
            for (localKey, _) in self.data {
                let globalKey = self.toGlobalKey(localKey)
                result.minY = Swift.min(result.minY, globalKey.y)
                result.maxY = Swift.max(result.maxY, globalKey.y)
                result.minX = Swift.min(result.minX, globalKey.x)
                result.maxX = Swift.max(result.maxX, globalKey.x)
            }
            return result
        }

        private let toGlobalKey: (Key) -> GlobalKey = { local in
            let key = CellID(decodeFrom: CellID.Value(local))
            return GlobalKey(
                y: key.rowNum,
                x: key.colNum,
            )
        }

        private let toLocalKey: (Index, Index) -> Key = { (y, x) in
            Key(CellID(rowNum: y, colNum: x).value)
        }

        subscript(y: Index, x: Index) -> Value? {
            get { self.data[self.toLocalKey(y, x)] }
            set { self.data[self.toLocalKey(y, x)] = newValue }
        }

        subscript(ID: Key) -> Value? {
            get { self.data[ID] }
            set { self.data[ID] = newValue }
        }

    }

}
