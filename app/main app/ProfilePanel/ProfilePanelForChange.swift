
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ProfilePanelForChange: View {

    @Environment(\.colorScheme)   private var colorScheme
    @Environment(\.profilesState) private var profiles
    @Environment(\.cellsState)    private var cells
    @Environment(\.processState)  private var process

    @Binding private var isShowPanel: Bool
    @State private var isShowDeleteDialog = false

    private let elementSpacing: CGFloat = 20

    private var columnsHead: [GridItem] {[
        GridItem(.flexible(), spacing: 0, alignment: .leading),
        GridItem(.flexible(), spacing: 0, alignment: .trailing)
    ]}

    private var columnsBody: [GridItem] {[
        GridItem(.flexible(), spacing: self.elementSpacing, alignment: .leading),
        GridItem(.fixed(90) , spacing: self.elementSpacing, alignment: .center)
    ]}

    init(isShowPanel: Binding<Bool>) {
        self._isShowPanel = isShowPanel
    }

    public var body: some View {
        TabCustom {
            TabCustom_Item(
                title: NSLocalizedString("Profile Settings", comment: ""),
                icon: Image(systemName: "switch.2"),
                content: { self.ChangeProfileView() })
            TabCustom_Spacer()
            TabCustom_Item(
                title: "",
                icon: Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90"),
                content: { self.AuditProfileView() }
            )
            TabCustom_Item(
                title: "",
                icon: Image(systemName: "trash"),
                content: { self.DeleteProfileView() }
            )
        }.frame(width: 450)
    }

    @ViewBuilder private func TitleView(_ text: String, _ description: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(text)
                .font(.headline)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
            if let description {
                Text(description)
                    .font(.system(size: 10))
                    .opacity(0.3)
            }
        }
    }

    @ViewBuilder private func DescriptionView(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10))
            .opacity(0.5)
    }

    @ViewBuilder private func DelimiterView() -> some View {
        self.colorScheme == .dark ?
            Color.white.opacity(0.1).frame(height: 2).padding(.horizontal, 10) :
            Color.black.opacity(0.1).frame(height: 2).padding(.horizontal, 10)
    }

    @ViewBuilder private func ChangeProfileView() -> some View {
        VStack(spacing: 0) {

            HStack(spacing: self.elementSpacing) {
                self.ChangeProfileView_titleConfigurator()
            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.DelimiterView()

            LazyVGrid(columns: self.columnsHead, spacing: self.elementSpacing) {
                self.ChangeProfileView_sizeConfigurator()
                self.ChangeProfileView_spacingConfigurator()
            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.DelimiterView()

            LazyVGrid(columns: self.columnsBody, spacing: self.elementSpacing) {
                self.ChangeProfileView_enlargeIconOnHoverConfigurator()
                self.ChangeProfileView_showIconTitleConfigurator()
                self.ChangeProfileView_hideOnMisclickConfigurator()
                self.ChangeProfileView_stickyGridConfigurator()
                self.ChangeProfileView_showWindowTitleButtonsConfigurator()
            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.DelimiterView()

            LazyVGrid(columns: self.columnsBody, spacing: self.elementSpacing) {
                self.ChangeProfileView_backgroundConfigurator()
                self.ChangeProfileView_backgroundDarkConfigurator()
            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

        }.padding(.vertical, 10)
    }

    @ViewBuilder private func ChangeProfileView_titleConfigurator() -> some View {
        self.TitleView(NSLocalizedString("Title", comment: ""))
        TextFieldCustom(
            value: self.profiles.current.getBinding(\.title)
        )
    }

    @ViewBuilder private func ChangeProfileView_sizeConfigurator() -> some View {
        HStack(spacing: 10) {
            self.TitleView(NSLocalizedString("Size", comment: ""))
            StepperCustom(
                self.profiles.current.getBinding(\.cellSize),
                in  : ThisApp.CELL_SIZE_MIN ... ThisApp.CELL_SIZE_MAX,
                step: ThisApp.CELL_SIZE_STEP,
                minWidth: 40
            )
        }
    }

    @ViewBuilder private func ChangeProfileView_spacingConfigurator() -> some View {
        HStack(spacing: 10) {
            self.TitleView(NSLocalizedString("Spacing", comment: ""))
            StepperCustom(
                self.profiles.current.getBinding(\.cellSpacing),
                in  : ThisApp.CELL_SPACING_MIN ... ThisApp.CELL_SPACING_MAX,
                step: ThisApp.CELL_SPACING_STEP
            )
        }
    }

    @ViewBuilder private func ChangeProfileView_enlargeIconOnHoverConfigurator() -> some View {
        self.TitleView(NSLocalizedString("Enlarge Icon on Hover", comment: ""))
        StepperCustom(
            self.profiles.current.getBinding(\.iconOnHoverZoom),
            prefix: "x",
            in: ThisApp.HOVER_ZOOM_MIN ...
                ThisApp.HOVER_ZOOM_MAX,
            step: ThisApp.HOVER_ZOOM_STEP,
            minWidth: 40
        )
        .scaleEffect(0.7)
        .padding(.horizontal, -18)
        .padding(.vertical  , -10)
    }

    @ViewBuilder private func ChangeProfileView_showIconTitleConfigurator() -> some View {
        self.TitleView(NSLocalizedString("Show Icon Title", comment: ""))
        ToggleCustom(
            isOn: self.profiles.current.getBinding(\.isShowIconTitle),
            isFlexible: true
        )
    }

    @ViewBuilder private func ChangeProfileView_hideOnMisclickConfigurator() -> some View {
        self.TitleView(NSLocalizedString("Hide on Misclick", comment: ""))
        ToggleCustom(
            isOn: self.profiles.current.getBinding(\.isHideOnMisclick),
            isFlexible: true
        )
    }

    @ViewBuilder private func ChangeProfileView_stickyGridConfigurator() -> some View {
        self.TitleView(NSLocalizedString("Sticky Grid", comment: ""))
        ToggleCustom(
            isOn: self.profiles.current.getBinding(\.isStickyGrid),
            isFlexible: true
        )
    }

    @ViewBuilder private func ChangeProfileView_showWindowTitleButtonsConfigurator() -> some View {
        self.TitleView(NSLocalizedString("Show Window Title Buttons", comment: ""))
        ToggleCustom(
            isOn: self.profiles.current.getBinding(\.isShowWinTitleButtons),
            isFlexible: true
        )
    }

    @ViewBuilder private func ChangeProfileView_backgroundConfigurator() -> some View {
        self.TitleView(NSLocalizedString("Background", comment: ""))
        ColorPickerHSBO(
            self.profiles.current.getBinding(\.background),
            openerSize: .init(width: 40, height: 20),
            openerRadius: 10,
            isInstantUpdate: true
        )
    }

    @ViewBuilder private func ChangeProfileView_backgroundDarkConfigurator() -> some View {
        self.TitleView(NSLocalizedString("Background (Dark Scheme)", comment: ""))
        ColorPickerHSBO(
            self.profiles.current.getBinding(\.backgroundDark),
            openerSize: .init(width: 40, height: 20),
            openerRadius: 10,
            isInstantUpdate: true
        )
    }

    @ViewBuilder private func AuditProfileView() -> some View {
        HStack(spacing: self.elementSpacing) {
            ButtonCustom(
                NSLocalizedString("refresh icons", comment: ""),
                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90"),
                colorStyle: .common,
                font: .system(size: 14, weight: .regular),
                padding: .init(top: 10, leading: 20, bottom: 10, trailing: 20),
                flexibility: .size(200),
                isFlat: false,
                onClick:         { self.isShowPanel = false; ProcessAudit.run() })
            .onPressEnterOrSpace { self.isShowPanel = false; ProcessAudit.run() }
            .disabled(self.process.inProgress || self.cells.isEmpty)
        }
        .padding(.horizontal, 40)
        .padding(.vertical  , 20)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder private func DeleteProfileView() -> some View {
        HStack(spacing: self.elementSpacing) {
            ButtonCustom(
                NSLocalizedString("delete profile", comment: ""),
                Image(systemName: "trash"),
                colorStyle: .danger,
                font: .system(size: 14, weight: .regular),
                padding: .init(top: 10, leading: 20, bottom: 10, trailing: 20),
                flexibility: .size(200),
                isFlat: false,
                onClick:         { self.isShowDeleteDialog = true })
            .onPressEnterOrSpace { self.isShowDeleteDialog = true }
            .disabled(self.profiles.current.ID == ThisApp.EMBEDDED_PROFILE_ID)
            .confirmationDialog("Delete profile\n \"\(self.profiles.current.title)\"", isPresented: self.$isShowDeleteDialog) {
                Button("Delete", role: .destructive, action: self.onDeleteProfile)
                Button("Cancel", role: .cancel) {
                    self.isShowDeleteDialog = false
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical  , 20)
        .frame(maxWidth: .infinity)
    }

    private func onDeleteProfile() {
        if let _ = self.profiles.delete(self.profiles.current.ID) {
            self.isShowDeleteDialog = false
            self.isShowPanel = false
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ProfilePanelForChange(
        isShowPanel: .constant(true)
    )
}
