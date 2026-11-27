
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import os
import SwiftUI

struct ProcessLoadRandom {

    static let MINIMUM_OPERATING_TIME: UInt64 = 2_000_000_000

    public static func run() {

        let state = ProcessState.shared

        guard !state.inProgress else {
            return
        }

        ProcessState.shared.task = Task.detached {
            let process: () async -> Void = {
                let embeddedApps = PL_embeddedApps.selectList()
                let defaultProfileApps = PL_defaultProfileApps.selectList()
                let count = defaultProfileApps.count
                for (index, bundleID_CellAddress_pair) in defaultProfileApps.enumerated() {

                    if (Task.isCancelled) {
                        return
                    }

                    let (bundleID, _) = bundleID_CellAddress_pair
                    let progress = index.progress(
                        max: count
                    )

                    guard
                        let embeddedApp = embeddedApps[bundleID],
                        let appValue = AppValue(embeddedApp)
                    else {
                        continue
                    }

                    let sector = (0 ... 4).randomElement() ?? 0
                    let cellID = await CellIDValue(
                        rowNum: (0 ... ThisApp.GRID_ROWS - 1).randomElement() ?? 0,
                        colNum: (0 ... ThisApp.GRID_COLS - 1).randomElement() ?? 0
                    )

                    await MainActor.run {
                        if (sector == 0) { CellsState.shared.insertAppValue(cellID, appValue) }
                        if (sector == 1) { CellsState.shared.insertAppValue(cellID, appValue, to: \.cell1) }
                        if (sector == 2) { CellsState.shared.insertAppValue(cellID, appValue, to: \.cell2) }
                        if (sector == 3) { CellsState.shared.insertAppValue(cellID, appValue, to: \.cell3) }
                        if (sector == 4) { CellsState.shared.insertAppValue(cellID, appValue, to: \.cell4) }
                    }

                    await MainActor.run {
                        state.report.insert(
                            "#\(cellID.rowNum):\(cellID.colNum):\(sector): \(appValue.name)", at: 0
                        )
                    }

                    Logger.customLog(
                        "ProcessLoadRandom (\(index + 1) from \(count) | " +
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
