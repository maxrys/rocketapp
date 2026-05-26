
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ProfilePanelForChange: View {

    @Environment(\.colorScheme)   private var colorScheme
    @Environment(\.profilesState) private var profiles

    @Binding private var isShowPanel: Bool
    @State private var isShowDeleteDialog = false

    private let elementSpacing: CGFloat = 20

    private var columnsHead: [GridItem] {[
        GridItem(.flexible(), spacing: self.elementSpacing, alignment: .leading),
        GridItem(.flexible(), spacing: self.elementSpacing, alignment: .trailing)
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
                title: NSLocalizedString("Delete", comment: ""),
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

                /* MARK: Title */

                self.TitleView(
                    NSLocalizedString("Title", comment: "")
                )

                TextFieldCustom(
                    value: self.profiles.current.getBinding(\.title)
                )

            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.DelimiterView()

            LazyVGrid(columns: self.columnsHead, spacing: self.elementSpacing) {

                /* MARK: Zoom configurator */

                HStack(spacing: 10) {

                    self.TitleView(
                        NSLocalizedString("Zoom", comment: "")
                    )

                    StepperCustom(
                        self.profiles.current.getBinding(\.zoom),
                        in: 0.5 ... 2.0, step: 0.1,
                        colorSet: Color.ctrlPanel.stepper
                    )

                }

                /* MARK: Spacing configurator */

                HStack(spacing: 10) {

                    self.TitleView(
                        NSLocalizedString("Spacing", comment: "")
                    )

                    StepperCustom(
                        self.profiles.current.getBinding(\.spacing),
                        in: 0 ... UInt(ThisApp.CELL_SIZE), step: 5,
                        colorSet: Color.ctrlPanel.stepper
                    )

                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.DelimiterView()

            LazyVGrid(columns: self.columnsBody, spacing: self.elementSpacing) {

                /* MARK: "Enlarge Icon on Hover" */

                self.TitleView(
                    NSLocalizedString("Enlarge Icon on Hover", comment: "")
                )

                StepperCustom(
                    self.profiles.current.getBinding(\.iconOnHoverZoom),
                    in: ThisApp.PROFILE_ICON_ON_HOVER_ZOOM_MIN ...
                        ThisApp.PROFILE_ICON_ON_HOVER_ZOOM_MAX, step: 0.1,
                    colorSet: Color.ctrlPanel.stepper
                )
                .scaleEffect(0.7)
                .padding(.horizontal, -18)
                .padding(.vertical  , -10)

                /* MARK: "Show Icon Title" */

                self.TitleView(
                    NSLocalizedString("Show Icon Title", comment: ""),
                    NSLocalizedString("turn off to improve performance", comment: "")
                )

                ToggleCustom(
                    isOn: self.profiles.current.getBinding(\.isShowIconTitle),
                    isFlexible: true
                )

                /* MARK: "Hide on Misclick" */

                self.TitleView(
                    NSLocalizedString("Hide on Misclick", comment: "")
                )

                ToggleCustom(
                    isOn: self.profiles.current.getBinding(\.isHideOnMisclick),
                    isFlexible: true
                )

                /* MARK: "Sticky Grid" */

                self.TitleView(
                    NSLocalizedString("Sticky Grid", comment: "")
                )

                ToggleCustom(
                    isOn: self.profiles.current.getBinding(\.isStickyGrid),
                    isFlexible: true
                )

                /* MARK: "Show Window Title Buttons" */

                self.TitleView(
                    NSLocalizedString("Show Window Title Buttons", comment: "")
                )

                ToggleCustom(
                    isOn: self.profiles.current.getBinding(\.isShowWinTitleButtons),
                    isFlexible: true
                )

            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.DelimiterView()

            LazyVGrid(columns: self.columnsBody, spacing: self.elementSpacing) {

                /* MARK: Background */

                self.TitleView(
                    NSLocalizedString("Background", comment: "")
                )

                ColorPickerHSBO(
                    self.profiles.current.getBinding(\.background),
                    openerSize: .init(width: 40, height: 15),
                    openerRadius: 10,
                    isInstantUpdate: true
                )

                self.TitleView(
                    NSLocalizedString("Background (Dark Scheme)", comment: "")
                )

                ColorPickerHSBO(
                    self.profiles.current.getBinding(\.backgroundDark),
                    openerSize: .init(width: 40, height: 15),
                    openerRadius: 10,
                    isInstantUpdate: true
                )

            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

        }.padding(.vertical, 10)
    }

    @ViewBuilder private func DeleteProfileView() -> some View {
        HStack(spacing: self.elementSpacing) {
            ButtonCustom(
                NSLocalizedString("delete profile", comment: ""),
                colorStyle: .danger,
                font: .system(size: 14, weight: .regular),
                padding: .init(top: 10, leading: 20, bottom: 10, trailing: 20),
                flexibility: .size(200),
                isFlat: false,
                onClick:        { self.isShowDeleteDialog = true })
            .onPressEnterOrSpace{ self.isShowDeleteDialog = true }
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
