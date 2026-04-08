
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

struct AuditStepInfo {
    let i: UInt
    let count: UInt
    let progress: Double
    let pair: CellID_CellValue_Pair
}

struct AuditSequence: AsyncSequence {

    typealias Element = AuditStepInfo

    private let profileID: ProfileID
    private var data: [CellID_CellValue_Pair] = []

    init(profileID: ProfileID) {
        self.profileID = profileID
        for (cellIDValue, cellValue) in CellValue.modelSelectMatrix(profileID: profileID).flat {
            self.data.append(
                CellID_CellValue_Pair(
                    cellID   : cellIDValue,
                    cellValue: cellValue
                )
            )
        }
    }

    func makeAsyncIterator() -> AuditSequenceIterator {
        AuditSequenceIterator(
            profileID: self.profileID,
            data: self.data
        )
    }

}

struct AuditSequenceIterator: AsyncIteratorProtocol {

    private let profileID: ProfileID
    private var data: [CellID_CellValue_Pair] = []
    private let count: UInt
    private var i: UInt

    init(profileID: ProfileID, data: [CellID_CellValue_Pair]) {
        self.profileID = profileID
        self.data = data
        self.count = UInt(data.count)
        self.i = 0
    }

    mutating func next() async -> AuditStepInfo? {
        if (self.i < self.count) {
            let info = AuditStepInfo(
                i: self.i,
                count: self.count,
                progress: Double(self.i + 1) / Double(self.count),
                pair: self.data[Int(self.i)]
            )
            await self.payloadStep(info: info)
            defer { self.i += 1 }
            return info
        }
        return nil
    }

    func payloadStep(info: AuditStepInfo) async {
        Task.detached {
            let (cellID, cellValue) = info.pair
            switch cellValue {

                case .main(let appValueOld):
                    if let appValueNew = AppValue(appValueOld.path) { if (appValueNew != appValueOld) {
                              _ = await CellValue.main(appValueNew).modelInsert(cellID, profileID)
                    }} else { _ = await CellValue                  .modelDelete(cellID, profileID) }

                case .mini(let miniGridOld):
                    var miniGridNew = MiniGridValue()
                    if let appValueOld = miniGridOld.cell1 { miniGridNew.cell1 = AppValue(appValueOld.path) }
                    if let appValueOld = miniGridOld.cell2 { miniGridNew.cell2 = AppValue(appValueOld.path) }
                    if let appValueOld = miniGridOld.cell3 { miniGridNew.cell3 = AppValue(appValueOld.path) }
                    if let appValueOld = miniGridOld.cell4 { miniGridNew.cell4 = AppValue(appValueOld.path) }
                    if (!miniGridNew.isEmpty) { if (miniGridNew != miniGridOld) {
                              _ = await CellValue.mini(miniGridNew).modelInsert(cellID, profileID)
                    }} else { _ = await CellValue                  .modelDelete(cellID, profileID) }

            }
        }
    }

}
