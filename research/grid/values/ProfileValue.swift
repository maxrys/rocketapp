
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@Observable final class ProfileValue {

    public func getBinding<T>(_ propertyName: WritableKeyPath<ProfileValue, T>) -> Binding<T> {
        var instance = self; return Binding(
            get: {             instance[keyPath: propertyName]            },
            set: { newValue in instance[keyPath: propertyName] = newValue }
        )
    }

    public var cellSize: UInt                = ThisApp.CELL_SIZE_DEFAULT
    public var cellSpacing: UInt             = ThisApp.CELL_SPACING_DEFAULT
    public var iconOnHoverZoom: Decimal      = ThisApp.HOVER_ZOOM_DEFAULT
    public var isShowIconTitle: Bool         = ThisApp.IS_SHOW_ICON_TITLE_DEFAULT
    public var background: ColorHSBValue     = ThisApp.WINDOW_BACKGROUND_DEFAULT
    public var backgroundDark: ColorHSBValue = ThisApp.WINDOW_BACKGROUND_DARK_DEFAULT

    init() {
    }

}
