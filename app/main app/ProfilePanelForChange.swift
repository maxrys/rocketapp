
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

    @ViewBuilder private func title(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
    }

    @ViewBuilder private var delimiter: some View {
        self.colorScheme == .dark ?
            Color.white.opacity(0.1).frame(height: 2).padding(.horizontal, 10) :
            Color.black.opacity(0.1).frame(height: 2).padding(.horizontal, 10)
    }

    public var body: some View {
        TabCustom {
            TabCustom_item(
                title: NSLocalizedString("Profile Settings", comment: ""),
                icon: Image(systemName: "switch.2"),
                view: { self.changeProfile })
            TabCustom_spacer()
            TabCustom_item(
                title: NSLocalizedString("Delete", comment: ""),
                icon: Image(systemName: "trash"),
                view: { self.deleteProfile }
            )
        }.frame(width: 450)
    }

    @ViewBuilder var changeProfile: some View {
        VStack(spacing: 0) {

            HStack(spacing: self.elementSpacing) {

                /* MARK: Title */

                self.title(
                    NSLocalizedString("Title", comment: "")
                )

                TextFieldCustom(value:
                    Binding<String>(
                        get: {             self.profiles.current.title },
                        set: { newValue in self.profiles.current.title = newValue }
                    )
                ).onChange(of: self.profiles.current.title) { oldValue, newValue in
                    if (newValue.isEmpty) {
                        self.profiles.current.title = oldValue
                    }
                }

            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.delimiter

            LazyVGrid(columns: self.columnsHead, spacing: self.elementSpacing) {

                /* MARK: Zoom configurator */

                HStack(spacing: 10) {

                    self.title(
                        NSLocalizedString("Zoom", comment: "")
                    )

                    StepperCustom(
                        Binding<Decimal>(
                            get: {             self.profiles.current.zoom },
                            set: { newValue in self.profiles.current.zoom = newValue }
                        ),
                        in: 0.5 ... 2.0, step: 0.1,
                        colorSet: Color.ctrlPanel.stepper
                    )

                }

                /* MARK: Spacing configurator */

                HStack(spacing: 10) {

                    self.title(
                        NSLocalizedString("Spacing", comment: "")
                    )

                    StepperCustom(
                        Binding<UInt>(
                            get: {             self.profiles.current.spacing },
                            set: { newValue in self.profiles.current.spacing = newValue }
                        ),
                        in: 0 ... UInt(ThisApp.CELL_SIZE), step: 5,
                        colorSet: Color.ctrlPanel.stepper
                    )

                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.delimiter

            LazyVGrid(columns: self.columnsBody, spacing: self.elementSpacing) {

                /* MARK: "Enlarge Icon on Hover" */

                self.title(
                    NSLocalizedString("Enlarge Icon on Hover", comment: "")
                )

                StepperCustom(
                    Binding<Decimal>(
                        get: {             self.profiles.current.iconOnHoverZoom },
                        set: { newValue in self.profiles.current.iconOnHoverZoom = newValue }
                    ),
                    in: ThisApp.PROFILE_ICON_ON_HOVER_ZOOM_MIN ...
                        ThisApp.PROFILE_ICON_ON_HOVER_ZOOM_MAX, step: 0.1,
                    colorSet: Color.ctrlPanel.stepper
                )
                .scaleEffect(0.7)
                .padding(.horizontal, -18)
                .padding(.vertical  , -10)

                /* MARK: "Show Icon Title" */

                self.title(
                    NSLocalizedString("Show Icon Title", comment: "")
                )

                ToggleCustom(
                    isFlexible: true,
                    isOn: Binding<Bool>(
                        get: {             self.profiles.current.isShowIconTitle },
                        set: { newValue in self.profiles.current.isShowIconTitle = newValue }
                    )
                )

                /* MARK: "Hide on Misclick" */

                self.title(
                    NSLocalizedString("Hide on Misclick", comment: "")
                )

                ToggleCustom(
                    isFlexible: true,
                    isOn: Binding<Bool>(
                        get: {             self.profiles.current.isHideOnMisclick },
                        set: { newValue in self.profiles.current.isHideOnMisclick = newValue }
                    )
                )

                /* MARK: "Sticky Grid" */

                self.title(
                    NSLocalizedString("Sticky Grid", comment: "")
                )

                ToggleCustom(
                    isFlexible: true,
                    isOn: Binding<Bool>(
                        get: {             self.profiles.current.isStickyGrid },
                        set: { newValue in self.profiles.current.isStickyGrid = newValue }
                    )
                )

                /* MARK: "Show Window Title Buttons" */

                self.title(
                    NSLocalizedString("Show Window Title Buttons", comment: "")
                )

                ToggleCustom(
                    isFlexible: true,
                    isOn: Binding<Bool>(
                        get: {             self.profiles.current.isShowWinTitleButtons },
                        set: { newValue in self.profiles.current.isShowWinTitleButtons = newValue }
                    )
                )

            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

            self.delimiter

            LazyVGrid(columns: self.columnsBody, spacing: self.elementSpacing) {

                /* MARK: Background */

                self.title(
                    NSLocalizedString("Background", comment: "")
                )

                ColorPickerCustom(
                    Binding<ColorHSBValue>(
                        get: {             self.profiles.current.background },
                        set: { newColor in self.profiles.current.background = newColor }
                    ), openerSize: .init(width: 40, height: 15), openerRadius: 10, isInstantUpdate: true
                )

                self.title(
                    NSLocalizedString("Background (Dark Scheme)", comment: "")
                )

                ColorPickerCustom(
                    Binding<ColorHSBValue>(
                        get: {             self.profiles.current.backgroundDark },
                        set: { newColor in self.profiles.current.backgroundDark = newColor }
                    ), openerSize: .init(width: 40, height: 15), openerRadius: 10, isInstantUpdate: true
                )

            }
            .padding(.horizontal, 40)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)

        }.padding(.vertical, 10)
    }

    @ViewBuilder var deleteProfile: some View {
        HStack(spacing: self.elementSpacing) {
            ButtonCustom(
                NSLocalizedString("delete profile", comment: ""),
                disabled: self.profiles.current.ID == ThisApp.EMBEDDED_PROFILE_ID,
                style: .danger,
                flexibility: .size(200)
            )                   { self.isShowDeleteDialog = true }
            .onPressEnterOrSpace{ self.isShowDeleteDialog = true }
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
        isShowPanel: Binding.constant(true)
    )
}
