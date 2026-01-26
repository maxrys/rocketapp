
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import SwiftData

@Observable final class CellsState {

    typealias SELF = CellsState

    struct Bounds {
        var minRowNum: GridAxisIndex
        var maxRowNum: GridAxisIndex
        var minColNum: GridAxisIndex
        var maxColNum: GridAxisIndex
    }

    public static var shared: CellsState!
    public private(set) var isAuditInProgress = false
    public private(set) var auditProgress: Double = 0
    public private(set) var auditReport: [String] = []

    private var profileID: ProfileID
    private var cache: [
        CellID.Value: CellValue
    ] = [:]

    @ObservationIgnored var isEmpty: Bool {
        self.cache.isEmpty
    }

    private init(profileID: ProfileID) {
        self.profileID = profileID
        self.reloadCache()
    }

    static func initShared(profileID: ProfileID) -> SELF {
        if let singleton = SELF.shared {
            return singleton
        } else {
            SELF.shared = SELF(profileID: profileID)
            return SELF.shared
        }
    }

    static func initMock(profileID: ProfileID) -> SELF {
        SELF(profileID: profileID)
    }

    var bounds: Bounds? {
        guard let firstCellIDValue = self.cache.first?.key else { return nil }
        let firstCellID = CellID(decodeFrom: firstCellIDValue)
        var result = Self.Bounds(
            minRowNum: firstCellID.rowNum,
            maxRowNum: firstCellID.rowNum,
            minColNum: firstCellID.colNum,
            maxColNum: firstCellID.colNum,
        )
        for (cellIDValue, _) in self.cache {
            let cellID = CellID(decodeFrom: cellIDValue)
            result.minRowNum = min(result.minRowNum, cellID.rowNum)
            result.maxRowNum = max(result.maxRowNum, cellID.rowNum)
            result.minColNum = min(result.minColNum, cellID.colNum)
            result.maxColNum = max(result.maxColNum, cellID.colNum)
        }
        return result
    }

    func reloadCache() {
        self.cache = CellValue.modelSelectAll(
            profileID: self.profileID
        )
    }

    func getProfileID() -> ProfileID {
        self.profileID
    }

    func setProfileID(_ profileID: ProfileID) {
        self.profileID = profileID
        self.reloadCache()
    }

    func select(_ ID: CellID.Value) -> CellValue? {
        self.cache[ID]
    }

    func insert(_ ID: CellID.Value, _ cellValue: CellValue) {
        switch cellValue {
            case .main, .mini:
                self.cache[ID] = cellValue
                Task {
                    _ = cellValue.modelInsert(ID, self.profileID)
                }
        }
    }

    func delete(_ ID: CellID.Value) {
        self.cache[ID] = nil
        Task {
            _ = CellValue.modelDelete(ID, self.profileID)
        }
    }

    func audit() {
        Task {
            await MainActor.run {
                self.isAuditInProgress = true
                self.auditProgress = 0
                self.auditReport.removeAll()
            }
            for await result in AuditSequence(profileID: self.profileID) {
                await MainActor.run {
                    self.auditProgress = result.progress
                    switch result.pair.cellValue {

                        case .main(let appValue):
                            self.auditReport.insert(
                                "#\(result.pair.cellID): \(appValue.name)", at: 0
                            )

                        case .mini(let miniGrid):
                            var appNames: [String] = []
                            if let appValue = miniGrid.cell1 { appNames.append(appValue.name) }
                            if let appValue = miniGrid.cell2 { appNames.append(appValue.name) }
                            if let appValue = miniGrid.cell3 { appNames.append(appValue.name) }
                            if let appValue = miniGrid.cell4 { appNames.append(appValue.name) }
                            if (!appNames.isEmpty) {
                                self.auditReport.insert(
                                    "#\(result.pair.cellID): \(appNames.joined(separator: ","))", at: 0
                                )
                            }

                    }
                    Logger.customLog(
                        "Audit process (\(result.i) from \(result.count) | " +
                        "\(Int(result.progress * 100))%) " +
                        "for cell with ID = \"\(result.pair.cellID)\" was done"
                    )
                }
            }
            try? await Task.sleep(
                nanoseconds: 2_000_000_000
            )
            await MainActor.run {
                self.isAuditInProgress = false
                self.auditReport.removeAll()
                self.reloadCache()
            }
        }
    }

}

struct AuditSequence: AsyncSequence {

    typealias Element = AuditSequenceIterator.StepInfo

    private let profileID: ProfileID
    private var data: [CellID_CellValue_Pair] = []

    init(profileID: ProfileID) {
        self.profileID = profileID
        CellValue.modelSelectAll(profileID: profileID).forEach { (cellID: CellID.Value, cellValue: CellValue) in
            self.data.append(
                CellID_CellValue_Pair(
                    cellID   : cellID,
                    cellValue: cellValue
                )
            )
        }
    }

    func makeAsyncIterator() -> AuditSequenceIterator {
        return AuditSequenceIterator(
            profileID: self.profileID,
            data: self.data
        )
    }

}

struct AuditSequenceIterator: AsyncIteratorProtocol {

    typealias StepInfo = (
        i: UInt,
        count: UInt,
        progress: Double,
        pair: CellID_CellValue_Pair
    )

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

    mutating func next() async -> StepInfo? {
        guard self.i < self.count else { return nil }
        let info = StepInfo(
            i: self.i,
            count: self.count,
            progress: Double(self.i + 1) / Double(self.count),
            pair: self.data[Int(self.i)]
        )
        await self.payloadStep(info: info)
        self.i += 1
        return info
    }

    func payloadStep(info: StepInfo) async {
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
