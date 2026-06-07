
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainScene: View, BackgroundColorProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark
    @Environment(\.profilesState) private var profiles
    @Environment(\.cellsState)    private var cells

    @Binding private var isEditMode: Bool
    @State private var isHovering = false

    private var cellSizeFinal: Double {
        ThisApp.CELL_SIZE * self.profiles.current.zoom.double
    }

    private var cellSpacingFinal: Double {
        Double(self.profiles.current.spacing) * self.profiles.current.zoom.double
    }

    private var frameMinSizeViewMode: Double {
        self.cellSizeFinal + (self.cellSpacingFinal * 2)
    }

    init(isEditMode: Binding<Bool>) {
        self._isEditMode = isEditMode
    }

    public var body: some View {
        VStack (spacing: 0) {

            if (self.isEditMode == false) {
                if (self.cells.isEmpty) {
                    self.NoOneAppView()
                } else {
                    MainGrid_viewMode(
                        cellSize: self.cellSizeFinal,
                        cellSpacing: self.cellSpacingFinal
                    ).onTapGesture {
                        if (self.profiles.current.isHideOnMisclick) {
                            NSWindow.hideWithAnimation(ThisApp.WINDOW_MAIN_ID)
                        }
                    }
                }
            }

            if (self.isEditMode) {
                ControlPanel(
                    isEditMode: self.$isEditMode
                ).zIndex(1)
                MainGrid_editMode(
                    cellSize: self.cellSizeFinal,
                    cellSpacing: self.cellSpacingFinal
                )
            }

        }
        .frame(
            minWidth : self.isEditMode ? ThisApp.NEW_PROFILE_WIN_FRAME_EDIT_MODE.w : self.frameMinSizeViewMode, maxWidth : .infinity,
            minHeight: self.isEditMode ? ThisApp.NEW_PROFILE_WIN_FRAME_EDIT_MODE.h : self.frameMinSizeViewMode, maxHeight: .infinity
        )
        .background(self.backgroundHSB().color)
        .overlay(alignment: .topTrailing) {
            if (self.isEditMode == false) {
                self.ButtonOpenSettingsView()
                    .padding(15)
                    .opacity(self.isHovering ? 1 : 0)
            }
        }
        .overlay {
            if (self.cells.isAuditInProgress) {
                self.AuditPanelView()
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
                Button { self.isEditMode = true } label: {
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

    @ViewBuilder private func AuditPanelView() -> some View {
        Color(self.colorScheme == .dark ? .white : .black).opacity(0.3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                VStack(spacing: 10) {
                    ProgressCustom(value: self.cells.auditProgress)
                        .shadow(
                            color: .black.opacity(0.5),
                            radius: 5.0
                        )
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(self.cells.auditReport, id: \.self) { reportLine in
                                Text(reportLine)
                                    .font(.system(size: 12, design: .monospaced))
                            }
                        }
                        .padding(10)
                        .background(
                            self.colorScheme == .dark ?
                                .black.opacity(0.5) :
                                .white.opacity(0.5)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                    }
                }
                .padding(50)
                .padding(.top, 50)
            }
    }

    @ViewBuilder fileprivate func ButtonOpenSettingsView() -> some View {
        ButtonRound(
            label     : { Image(systemName: "gearshape.circle") },
            foreground: { self.backgroundAccentHSB(minOpacity: 0.5).color },
            background: { Color.clear },
        ) { self.isEditMode = true }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Previewer {
        MainScene(
            isEditMode: .constant(false)
        ).ButtonOpenSettingsView().padding(10)

        MainScene(
            isEditMode: .constant(false)
        ).NoOneAppView()
    }
}
