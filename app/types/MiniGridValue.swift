
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

    init(
        cell1Value: AppValue? = nil,
        cell2Value: AppValue? = nil,
        cell3Value: AppValue? = nil,
        cell4Value: AppValue? = nil,
    ) {
        self.cell1 = cell1Value
        self.cell2 = cell2Value
        self.cell3 = cell3Value
        self.cell4 = cell4Value
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
