
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI

struct ProcessAudit {

    static let MINIMUM_OPERATING_TIME: UInt64 = 2_000_000_000

    public static func run() {

        let state = ProcessState.shared
        state.isCencellable = true

        guard !state.inProgress else {
            return
        }

        ProcessState.shared.task = Task.detached {
            let process: () async -> Void = {
                let data = await CellsState.shared.data
                let count = data.count
                for (index, cellID_cellValue_pair) in data.enumerated() {

                    if (Task.isCancelled) {
                        return
                    }

                    let (cellID, cellValue) = cellID_cellValue_pair
                    let progress = await index.progress(
                        max: count - 1
                    )

                    let cellUpdater: (CellIDValue, AppValue, AppValue?, CellValuePath?) async -> Void = { cellID, appValueOld, appValueNew, keyPath in
                        let sector = await CellAddressValue.keyPathToSector(keyPath: keyPath)
                        if let appValueNew {
                            if (appValueNew != appValueOld) {
                                await MainActor.run {
                                    CellsState.shared.deleteAppValue(cellID, from: keyPath)
                                    state.report.insert("#\(cellID.rowNum):\(cellID.colNum):\(sector): \(appValueOld.name) was deleted", at: 0)
                                    CellsState.shared.insertAppValue(cellID, appValueNew, to: keyPath)
                                    state.report.insert("#\(cellID.rowNum):\(cellID.colNum):\(sector): \(appValueNew.name) was inserted", at: 0)
                                }
                            }
                        } else {
                            await MainActor.run {
                                CellsState.shared.deleteAppValue(cellID, from: keyPath)
                                state.report.insert("#\(cellID.rowNum):\(cellID.colNum):\(sector): \(appValueOld.name) was deleted", at: 0)
                            }
                        }
                    }

                    switch cellValue {
                        case .main(let appValueOld):
                            await cellUpdater(cellID, appValueOld, AppValue(appValueOld.path), nil)
                        case .mini(let miniGrid):
                            if let appValueOld = miniGrid.cell1 { await cellUpdater(cellID, appValueOld, AppValue(appValueOld.path), \.cell1) }
                            if let appValueOld = miniGrid.cell2 { await cellUpdater(cellID, appValueOld, AppValue(appValueOld.path), \.cell2) }
                            if let appValueOld = miniGrid.cell3 { await cellUpdater(cellID, appValueOld, AppValue(appValueOld.path), \.cell3) }
                            if let appValueOld = miniGrid.cell4 { await cellUpdater(cellID, appValueOld, AppValue(appValueOld.path), \.cell4) }
                    }

                    await Logger.customLog(
                        "ProcessAudit (\(index + 1) from \(count) | " +
                        "\(Int(progress * 100))%%) " +
                        "for cell with ID = \"\(cellID)\" was done"
                    )

                    await MainActor.run {
                        state.progress = progress
                    }
                }
            }

            await MainActor.run {
                state.inProgress = true
                state.progress = 0
                state.report.removeAll()
            }

            async let processResult: Void = process()
            async let reliableDelay: Void = await Task.sleep(
                nanoseconds: Self.MINIMUM_OPERATING_TIME
            )

            let _ = try? await (
                processResult,
                reliableDelay
            )

            await MainActor.run {
                state.inProgress = false
                state.report.removeAll()
            }

        }
    }

}
