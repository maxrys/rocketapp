
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct EnvironmentKey_ProfilesState: EnvironmentKey {
    static let defaultValue = ProfilesState.shared
}

struct EnvironmentKey_CellsState: EnvironmentKey {
    static let defaultValue: CellsState = CellsState.initShared(
        profileID: EnvironmentValues().profilesState.current.ID
    )
}

struct EnvironmentKey_ProcessState: EnvironmentKey {
    static let defaultValue = ProcessState.shared
}

struct EnvironmentKey_isEditMode: EnvironmentKey {
    static let defaultValue = ValueState<Bool>(false)
}

struct EnvironmentKey_windowBackground: EnvironmentKey {
    static let defaultValue = ColorHSBValue.black
}

struct EnvironmentKey_windowBackgroundDark: EnvironmentKey {
    static let defaultValue = ColorHSBValue.black
}

extension EnvironmentValues {

    var profilesState: ProfilesState {
        get { self[EnvironmentKey_ProfilesState.self] }
        set { self[EnvironmentKey_ProfilesState.self] = newValue }
    }

    var cellsState: CellsState {
        get { self[EnvironmentKey_CellsState.self] }
        set { self[EnvironmentKey_CellsState.self] = newValue }
    }

    var processState: ProcessState {
        get { self[EnvironmentKey_ProcessState.self] }
        set { self[EnvironmentKey_ProcessState.self] = newValue }
    }

    var isEditMode: ValueState<Bool> {
        get { self[EnvironmentKey_isEditMode.self] }
        set { self[EnvironmentKey_isEditMode.self] = newValue }
    }

    var windowBackground: ColorHSBValue {
        get { self[EnvironmentKey_windowBackground.self] }
        set { self[EnvironmentKey_windowBackground.self] = newValue }
    }

    var windowBackgroundDark: ColorHSBValue {
        get { self[EnvironmentKey_windowBackgroundDark.self] }
        set { self[EnvironmentKey_windowBackgroundDark.self] = newValue }
    }

}
