
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI

struct ProcessLoadDefault {

    static let MINIMUM_OPERATING_TIME: UInt64 = 2_000_000_000

    public static func run() {

        let state = ProcessState.shared
        state.isCencellable = true

        guard !state.inProgress else {
            return
        }

        ProcessState.shared.task = Task.detached {
            let process: () async -> Void = {
                let embeddedApps = await PL_embeddedApps.selectList()
                let defaultProfileApps = await PL_defaultProfileApps.selectList()
                let count = defaultProfileApps.count
                for (index, bundleID_cellAddress_pair) in defaultProfileApps.enumerated() {

                    if (Task.isCancelled) {
                        return
                    }

                    let (bundleID, cellAddress) = bundleID_cellAddress_pair
                    let progress = await index.progress(
                        max: count - 1
                    )

                    guard
                        let embeddedApp = embeddedApps[bundleID],
                        let appValue = AppValue(embeddedApp)
                    else {
                        continue
                    }

                    let sector = cellAddress.sector
                    let cellID = await CellIDValue(
                        rowNum: CellIDValue.Index(cellAddress.rowNum),
                        colNum: CellIDValue.Index(cellAddress.colNum)
                    )

                    await MainActor.run {
                        CellsState.shared.insertAppValue(
                            cellID, appValue,
                            to: CellAddressValue.sectorToKeyPath(
                                sector: sector
                            )
                        )
                    }

                    await MainActor.run {
                        state.report.insert(
                            "#\(cellID.rowNum):\(cellID.colNum):\(sector): \(appValue.name)", at: 0
                        )
                    }

                    await Logger.customLog(
                        "ProcessLoadDefault (\(index + 1) from \(count) | " +
                        "\(Int(progress * 100))%%) " +
                        "for cell \"\(cellID.rowNum):\(cellID.colNum):\(sector)\" was done"
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
