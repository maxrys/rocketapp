
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

nonisolated struct MiniGridValue: Equatable {

    public var cell1: AppValue?
    public var cell2: AppValue?
    public var cell3: AppValue?
    public var cell4: AppValue?

    init() {
    }

    init(keyPath: CellValuePath, value: AppValue) {
        self[keyPath: keyPath] = value
    }

    var isEmpty: Bool {
        self.cell1 == nil &&
        self.cell2 == nil &&
        self.cell3 == nil &&
        self.cell4 == nil
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.cell1 == rhs.cell1 &&
        lhs.cell2 == rhs.cell2 &&
        lhs.cell3 == rhs.cell3 &&
        lhs.cell4 == rhs.cell4
    }

    static func != (lhs: Self, rhs: Self) -> Bool {
        !(lhs == rhs)
    }

}
