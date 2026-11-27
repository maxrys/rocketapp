
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@Observable final class ProcessState {

    static public private(set) var shared = ProcessState()

    internal var task: Task<Void, Never>? = nil
    internal var inProgress = false
    internal var isCencellable = false
    internal var progress: Double = 0
    internal var report: [String] = []

    private init() {
    }

}
