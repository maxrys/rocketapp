
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainScene: View, BackgroundColorProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark
    @Environment(\.profilesState)        internal var profiles
    @Environment(\.cellsState)           internal var cells
    @Environment(\.processState)         internal var process
    @Environment(\.isEditMode)           internal var isEditMode

    @State private var isHovering = false

    private var frameMinSizeViewMode: CGFloat {
        CGFloat(self.profiles.current.cellSize) + CGFloat(self.profiles.current.cellSpacing) * 2
    }

    public var body: some View {
        VStack(spacing: 0) {

            if (self.isEditMode.value == false) {
                if (self.cells.isEmpty) {
                    self.NoOneAppView()
                } else {
                    MainGrid_viewMode(
                        cellSize   : CGFloat(self.profiles.current.cellSize),
                        cellSpacing: CGFloat(self.profiles.current.cellSpacing)
                    ).onTapGesture {
                        if (self.profiles.current.isHideOnMisclick) {
                            NSWindow.hideWithAnimation(ThisApp.WINDOW_MAIN_ID)
                        }
                    }
                }
            }

            if (self.isEditMode.value) {
                ControlPanel()
                    .zIndex(1)
                MainGrid_editMode(
                    cellSize   : CGFloat(self.profiles.current.cellSize),
                    cellSpacing: CGFloat(self.profiles.current.cellSpacing)
                )
            }

        }
        .frame(
            minWidth : self.isEditMode.value ? ThisApp.WINDOW_FRAME_EDIT_MODE_DEFAULT.width  : self.frameMinSizeViewMode, maxWidth : .infinity,
            minHeight: self.isEditMode.value ? ThisApp.WINDOW_FRAME_EDIT_MODE_DEFAULT.height : self.frameMinSizeViewMode, maxHeight: .infinity
        )
        .background(self.backgroundCurrent().color)
        .overlay(alignment: .topTrailing) {
            if (self.isEditMode.value == false) {
                self.ButtonOpenSettingsView()
                    .padding(15)
                    .opacity(self.isHovering ? 1 : 0)
            }
        }
        .overlay {
            if (self.process.inProgress) {
                ProcessPanel()
            }
        }
        .onHover { isHovering in
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isHovering = isHovering
            }
        }
    }

    @ViewBuilder fileprivate func NoOneAppView() -> some View {
        СhameleonView(radius: 30, minOpacity: 0.7, shadowRadius: 0, isFlat: true) {
            VStack(spacing: 15) {
                Text(ThisApp.MESSAGE_NO_APPLICATIONS)
                    .font(.system(size: 15, weight: .bold))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                Button { self.isEditMode.value = true } label: {
                    СhameleonView(shadowRadius: 3) {
                        Text(ThisApp.MESSAGE_OPEN_SETTINGS)
                            .font(.system(size: 14))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 30)
                            .padding(.vertical  , 10)
                    }
                }
                .buttonStyle(.plain)
                .pointerStyle(.link)
            }.padding(20)
        }.padding(20)
    }

    @ViewBuilder fileprivate func ButtonOpenSettingsView() -> some View {
        ButtonRound(
            label     : { Image(systemName: "gearshape.circle") },
            foreground: { self.backgroundCurrentAccent(minOpacity: 0.5).color },
            background: { Color.clear },
        ) { self.isEditMode.value = true }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Previewer {
        MainScene()
            .ButtonOpenSettingsView().padding(10)
            .environment(\.isEditMode, ValueState<Bool>(true))

        MainScene()
            .NoOneAppView()
            .environment(\.isEditMode, ValueState<Bool>(false))
    }
}
