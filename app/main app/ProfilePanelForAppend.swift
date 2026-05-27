
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

struct ProfilePanelForAppend: View {

    @Environment(\.profilesState) private var profiles
    @Environment(\.cellsState)    private var cells

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

            HStack (spacing: 10) {

                ButtonCustom(
                    NSLocalizedString("clone", comment: ""),
                    colorStyle: .common,
                    font: .system(size: 14, weight: .regular),
                    padding: .init(top: 10, leading: 20, bottom: 10, trailing: 20),
                    flexibility: .infinity,
                    isFlat: false,
                    onClick: { self.onCloneProfile() })
                .disabled(self.title.isEmpty)

                ButtonCustom(
                    NSLocalizedString("append", comment: ""),
                    colorStyle: .accent,
                    font: .system(size: 14, weight: .regular),
                    padding: .init(top: 10, leading: 20, bottom: 10, trailing: 20),
                    flexibility: .infinity,
                    isFlat: false,
                    onClick:         { self.onAppendProfile() })
                .onPressEnterOrSpace { self.onAppendProfile() }
                .disabled(self.title.isEmpty)

            }

        }
        .padding(20)
        .frame(width: 300)
    }

    private func onCloneProfile() {
        let cells = self.cells.data
        let profile = ProfileValue(
            ID                   : profiles.newID,
            title                : self.title,
            zoom                 : self.profiles.current.zoom,
            spacing              : self.profiles.current.spacing,
            iconOnHoverZoom      : self.profiles.current.iconOnHoverZoom,
            isShowIconTitle      : self.profiles.current.isShowIconTitle,
            isHideOnMisclick     : self.profiles.current.isHideOnMisclick,
            isStickyGrid         : self.profiles.current.isStickyGrid,
            isShowWinTitleButtons: self.profiles.current.isShowWinTitleButtons,
            background           : self.profiles.current.background,
            backgroundDark       : self.profiles.current.backgroundDark,
            winFrameViewMode     : self.profiles.current.winFrameViewMode,
            winFrameEditMode     : self.profiles.current.winFrameEditMode
        )
        if (self.profiles.insert(profile)) {
            Logger.customLog("The profile (ID: \(profile.ID)) has been cloned.")
            if (!cells.isEmpty) {
                for (cellID, cellValue) in cells.flat {
                    _ = cellValue.modelInsert(cellID, profile.ID)
                }
            }
            if (self.profiles.setCurrent(profile.ID)) {
                self.isShowPanel = false
            }
        }
    }

    private func onAppendProfile() {
        let profile = ProfileValue(
            ID                   : profiles.newID,
            title                : self.title,
            zoom                 : ThisApp.DEFAULT_ZOOM,
            spacing              : ThisApp.DEFAULT_SPACING,
            iconOnHoverZoom      : ThisApp.DEFAULT_ICON_ON_HOVER_ZOOM,
            isShowIconTitle      : ThisApp.DEFAULT_IS_SHOW_ICON_TITLE,
            isHideOnMisclick     : ThisApp.DEFAULT_IS_HIDE_ON_MISCLICK,
            isStickyGrid         : ThisApp.DEFAULT_IS_STICKY_GRID,
            isShowWinTitleButtons: ThisApp.DEFAULT_IS_SHOW_WINDOW_TITLE_BUTTONS,
            background           : ThisApp.DEFAULT_BACKGROUND,
            backgroundDark       : ThisApp.DEFAULT_BACKGROUND_DARK,
            winFrameViewMode     : NSWindow.centerWindowFrame(ThisApp.WINDOW_MAIN_ID, frame: ThisApp.DEFAULT_WIN_FRAME_VIEW_MODE),
            winFrameEditMode     : NSWindow.centerWindowFrame(ThisApp.WINDOW_MAIN_ID, frame: ThisApp.DEFAULT_WIN_FRAME_EDIT_MODE)
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
