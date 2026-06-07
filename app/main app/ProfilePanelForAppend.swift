
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

struct ProfilePanelForAppend: View {

    @Environment(\.profilesState) private var profiles

    @Binding private var isShowPanel: Bool
    @State private var title: String = ""

    init(isShowPanel: Binding<Bool>) {
        self._isShowPanel = isShowPanel
    }

    public var body: some View {
        VStack(spacing: 20) {

            TextFieldCustom(
                NSLocalizedString("Title", comment: ""),
                value: self.$title
            ).onPressEnter { self.onAppendProfile() }

            ButtonCustom(
                NSLocalizedString("append profile", comment: ""),
                colorStyle: .accent,
                font: .system(size: 14, weight: .regular),
                padding: .init(top: 10, leading: 20, bottom: 10, trailing: 20),
                flexibility: .infinity,
                isFlat: false,
                onClick:         { self.onAppendProfile() })                    
            .onPressEnterOrSpace { self.onAppendProfile() }
            .disabled(self.title.isEmpty)

        }
        .padding(20)
        .frame(width: 300)
    }

    private func onAppendProfile() {
        let profile = ProfileValue(
            ID                   : profiles.newID,
            title                : self.title,
            zoom                 : ThisApp.NEW_PROFILE_ZOOM,
            spacing              : ThisApp.NEW_PROFILE_SPACING,
            iconOnHoverZoom      : ThisApp.NEW_PROFILE_ICON_ON_HOVER_ZOOM,
            isShowIconTitle      : ThisApp.NEW_PROFILE_IS_SHOW_ICON_TITLE,
            isHideOnMisclick     : ThisApp.NEW_PROFILE_IS_HIDE_ON_MISCLICK,
            isStickyGrid         : ThisApp.NEW_PROFILE_IS_STICKY_GRID,
            isShowWinTitleButtons: ThisApp.NEW_PROFILE_IS_SHOW_WINDOW_TITLE_BUTTONS,
            background           : ThisApp.NEW_PROFILE_BACKGROUND,
            backgroundDark       : ThisApp.NEW_PROFILE_BACKGROUND_DARK,
            winFrameViewMode     : NSWindow.centerWindowFrame(ThisApp.WINDOW_MAIN_ID, frame: ThisApp.NEW_PROFILE_WIN_FRAME_VIEW_MODE),
            winFrameEditMode     : NSWindow.centerWindowFrame(ThisApp.WINDOW_MAIN_ID, frame: ThisApp.NEW_PROFILE_WIN_FRAME_EDIT_MODE)
        )
        if (self.profiles.insert(profile)) {
            Logger.customLog("The profile (ID: \(profile.ID)) has been created.")
            if (self.profiles.setCurrent(profile.ID)) {
                self.isShowPanel = false
            }
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ProfilePanelForAppend(
        isShowPanel: .constant(true)
    )
}
