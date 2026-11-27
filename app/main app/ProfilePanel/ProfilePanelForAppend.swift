
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI

struct ProfilePanelForAppend: View {

    @Environment(\.colorScheme)   private var colorScheme
    @Environment(\.profilesState) private var profiles
    @Environment(\.cellsState)    private var cells

    @Binding private var isShowPanel: Bool
    @State private var title: String = ""
    @State private var withApps: Bool = false

    init(isShowPanel: Binding<Bool>) {
        self._isShowPanel = isShowPanel
    }

    public var body: some View {
        VStack(spacing: 20) {
            self.FieldTitle()
            VStack(spacing: 10) {
                self.ButtonCloneProfile()
                self.ButtonsDelimiter()
                self.ButtonAddNewProfile()
            }
        }
        .padding(20)
        .frame(width: 300)
    }

    @ViewBuilder private func FieldTitle() -> some View {
        TextFieldCustom(
            NSLocalizedString("Title", comment: ""),
            value: self.$title
        ).onPressEnter { self.onAddProfile() }
    }

    @ViewBuilder private func ButtonCloneProfile() -> some View {
        ButtonCustom(
            NSLocalizedString("clone", comment: ""),
            colorStyle: .common,
            font: .system(size: 14, weight: .regular),
            padding: .init(top: 10, leading: 20, bottom: 10, trailing: 20),
            flexibility: .infinity,
            isFlat: false,
            onClick: { self.onCloneProfile() })
        .disabled(self.title.isEmpty)
    }

    @ViewBuilder private func ButtonsDelimiter() -> some View {
        self.colorScheme == .dark ?
        Color.white.frame(maxWidth: .infinity).frame(height: 1).opacity(0.2) :
        Color.black.frame(maxWidth: .infinity).frame(height: 1).opacity(0.2)
    }

    @ViewBuilder private func ButtonAddNewProfile() -> some View {
        VStack(spacing: 10) {

            ButtonCustom(
                NSLocalizedString("add", comment: ""),
                colorStyle: .accent,
                font: .system(size: 14, weight: .regular),
                padding: .init(top: 10, leading: 20, bottom: 10, trailing: 20),
                flexibility: .infinity,
                isFlat: false,
                onClick:         { self.onAddProfile() })
            .onPressEnterOrSpace { self.onAddProfile() }
            .disabled(self.title.isEmpty)

            HStack(spacing: 10) {
                ToggleCustom(
                    isOn: self.$withApps,
                    isFlexible: true
                )
                Text(NSLocalizedString(
                    "with applications"
                , comment: ""))
            }

        }
    }

    private func onCloneProfile() {
        let cells = self.cells.data
        let profile = ProfileValue(
            ID                   : profiles.newID,
            title                : self.title,
            cellSize             : self.profiles.current.cellSize,
            cellSpacing          : self.profiles.current.cellSpacing,
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
            if (self.profiles.setCurrent(profile.ID)) {
                self.isShowPanel = false
                if (!cells.isEmpty) {
                    for (cellID, cellValue) in cells {
                        _ = cellValue.modelInsert(cellID, profile.ID)
                    }
                }
            }
        }
    }

    private func onAddProfile() {
        let profile = ProfileValue(
            ID                   : profiles.newID,
            title                : self.title,
            cellSize             : ThisApp.CELL_SIZE_DEFAULT,
            cellSpacing          : ThisApp.CELL_SPACING_DEFAULT,
            iconOnHoverZoom      : ThisApp.HOVER_ZOOM_DEFAULT,
            isShowIconTitle      : ThisApp.IS_SHOW_ICON_TITLE_DEFAULT,
            isHideOnMisclick     : ThisApp.IS_HIDE_ON_MISCLICK_DEFAULT,
            isStickyGrid         : ThisApp.IS_STICKY_GRID_DEFAULT,
            isShowWinTitleButtons: ThisApp.IS_SHOW_WINDOW_TITLE_BUTTONS_DEFAULT,
            background           : ThisApp.WINDOW_BACKGROUND_DEFAULT,
            backgroundDark       : ThisApp.WINDOW_BACKGROUND_DARK_DEFAULT,
            winFrameViewMode     : NSWindow.centerWindowFrame(ThisApp.WINDOW_MAIN_ID, frame: ThisApp.WINDOW_FRAME_VIEW_MODE_DEFAULT),
            winFrameEditMode     : NSWindow.centerWindowFrame(ThisApp.WINDOW_MAIN_ID, frame: ThisApp.WINDOW_FRAME_EDIT_MODE_DEFAULT)
        )
        if (self.profiles.insert(profile)) {
            Logger.customLog("The profile (ID: \(profile.ID)) has been created.")
            if (self.profiles.setCurrent(profile.ID)) {
                self.isShowPanel = false
                if (self.withApps) {
                    ProcessLoadDefault.run()
                }
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
