
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import SwiftData

@Observable final class ProfilesState {

    static public private(set) var shared = ProfilesState()

    public var current = ProfileValue()

    private init() {
    }

}
