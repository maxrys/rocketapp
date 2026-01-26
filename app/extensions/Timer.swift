
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import QuartzCore
import Combine

extension Timer {

    final class Custom {

        private let count: UInt16
        private let interval: Double
        private let onTick: (UInt16) -> Void
        private let onExpire: () -> Void

        private var timer: Cancellable?
        private var i: UInt16 = 0

        init(
            immediately: Bool = true,
            count: UInt16,
            interval: Double,
            onTick: @escaping (UInt16) -> Void = { _ in },
            onExpire: @escaping () -> Void = {}
        ) {
            self.count = count
            self.interval = interval
            self.onTick = onTick
            self.onExpire = onExpire
            if (immediately) {
                self.startOrRenew()
            }
        }

        func startOrRenew() {
            self.i = 0
            self.timer?.cancel()
            self.timer = Timer.publish(
                every: self.interval,
                tolerance: 0.0,
                on: RunLoop.main,
                in: RunLoop.Mode.common,
                options: nil
            ).autoconnect().sink(receiveValue: { _ in
                self.i += 1
                if (self.i > self.count) {
                    self.stopAndReset()
                    self.onExpire()
                } else {
                    self.onTick(
                        self.i
                    )
                }
            })
        }

        func stopAndReset() {
            self.timer?.cancel()
        }

    }

}
