
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

final class SlotsEnumerator: Sequence, IteratorProtocol {

    typealias Element = [Any]

    static let DEFAULT_DECIMAL_SLOT: [UInt] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    private var curValue: UInt = 0
    private var maxValue: UInt = 1
    private let slotsValues: [[Any]]

    init?(slotsValues: [[Any]] = []) {
        guard slotsValues.count > 0 else { return nil }
        guard slotsValues.count < 6 else { return nil }
        self.slotsValues = slotsValues
        for slotNumber in slotsValues.indices {
            self.maxValue *= self.slotDepth(UInt(slotNumber))
        }
    }

    private func slotDepth(_ slotNumber: UInt) -> UInt {
        let slotValues = self.slotsValues[safe: Int(slotNumber), default: Self.DEFAULT_DECIMAL_SLOT]
        return UInt(slotValues.count)
    }

    private func slotValue(_ slotNumber: UInt, position: UInt) -> Any {
        let slotValues = self.slotsValues[safe: Int(slotNumber), default: Self.DEFAULT_DECIMAL_SLOT]
        return slotValues[Int(position)]
    }

    private subscript(slotNumber: UInt) -> Any {
        if (slotNumber == 0) { return self.slotValue(0, position: (self.curValue                                                                                  ) % self.slotDepth(0)) }
        if (slotNumber == 1) { return self.slotValue(1, position: (self.curValue / (self.slotDepth(0)                                                            )) % self.slotDepth(1)) }
        if (slotNumber == 2) { return self.slotValue(2, position: (self.curValue / (self.slotDepth(0) * self.slotDepth(1)                                        )) % self.slotDepth(2)) }
        if (slotNumber == 3) { return self.slotValue(3, position: (self.curValue / (self.slotDepth(0) * self.slotDepth(1) * self.slotDepth(2)                    )) % self.slotDepth(3)) }
        if (slotNumber == 4) { return self.slotValue(4, position: (self.curValue / (self.slotDepth(0) * self.slotDepth(1) * self.slotDepth(2) * self.slotDepth(3))) % self.slotDepth(4)) }
        return 0
    }

    func next() -> [Any]? {
        if (self.curValue < self.maxValue) {
            defer { self.curValue += 1 }
            if (slotsValues.count == 1) { return [self[0]] }
            if (slotsValues.count == 2) { return [self[0], self[1]] }
            if (slotsValues.count == 3) { return [self[0], self[1], self[2]] }
            if (slotsValues.count == 4) { return [self[0], self[1], self[2], self[3]] }
            if (slotsValues.count == 5) { return [self[0], self[1], self[2], self[3], self[4]] }
        }
        return nil
    }

}
