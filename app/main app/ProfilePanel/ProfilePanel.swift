
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ProfilePanel: View {

    @State private var isShowPanelForAppend = false
    @State private var isShowPanelForChange = false

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.profilesState) private var profiles

    public var body: some View {
        HStack {

            /* MARK: Title */

            Text("Profile")
                .font(.headline)
                .fixedSize(horizontal: true, vertical: false)
                .foregroundStyle(Color.profilePanel.titleText)
                .lineLimit(1)

            HStack(spacing: 10) {

                /* MARK: Button: Show Panel for append new Profile */

                self.ButtonShowPanelForAppendView()
                    .popover(isPresented: self.$isShowPanelForAppend, arrowEdge: .bottom) {
                        ProfilePanelForAppend(
                            isShowPanel: self.$isShowPanelForAppend
                        )
                    }

                /* MARK: List */

                PickerCustom<ProfileID>(
                    selected: Binding<ProfileID>(
                        get: { self.profiles.current.ID },
                        set: { value in self.onChangeProfile(profileID: value) }
                    ),
                    items: self.profiles.list,
                    sortedBy: .valueAsc,
                    isPlainListStyle: true,
                    flexibility: .size(250),
                    colorSet: Color.profilePanel.picker
                ).overlay(alignment: .trailing) {
                    if (self.profiles.current.ID == ThisApp.EMBEDDED_PROFILE_ID) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10))
                            .background(
                                Circle()
                                    .fill  (self.colorScheme == .dark ? .black : .white)
                                    .stroke(self.colorScheme == .dark ? .white : .black)
                                    .frame(width: 18, height: 18)
                            )
                            .offset(x: -7)
                    }
                }

                /* MARK: Button: Show Panel for change Profile */

                self.ButtonShowPanelForChangeView()
                    .popover(isPresented: self.$isShowPanelForChange, arrowEdge: .bottom) {
                        ProfilePanelForChange(
                            isShowPanel: self.$isShowPanelForChange
                        )
                    }

            }
            .padding(5)
            .background(Color.profilePanel.groupBackground)
            .clipShape(Capsule())
            .padding(.trailing, 50)

        }
    }

    @ViewBuilder private func ButtonShowPanelForAppendView() -> some View {
        ButtonRound(
            label     : { Image(systemName: "plus.circle") },
            foreground: { Color.profilePanel.buttonText },
            background: { Color.profilePanel.buttonBackground },
            size: 25.0
        ) { self.isShowPanelForAppend = true }
    }

    @ViewBuilder private func ButtonShowPanelForChangeView() -> some View {
        ButtonRound(
            label     : { Image(systemName: "gearshape.circle") },
            foreground: { Color.profilePanel.buttonText },
            background: { Color.profilePanel.buttonBackground },
            size: 25.0
        ) { self.isShowPanelForChange = true }
    }

    func onChangeProfile(profileID: ProfileID) {
        _ = self.profiles.setCurrent(profileID)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ProfilePanel().padding(20)
}
