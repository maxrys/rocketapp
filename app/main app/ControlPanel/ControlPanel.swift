
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ControlPanel: View {

    @Environment(\.colorScheme)   private var colorScheme
    @Environment(\.profilesState) private var profiles
    @Environment(\.cellsState)    private var cells
    @Environment(\.isEditMode)    private var isEditMode

    public var body: some View {
        ProfilePanel()
            .padding(.horizontal, 15)
            .padding(.vertical  , 12)
            .frame(maxWidth: .infinity)
            .background(Color.ctrlPanel.background)
            .overlay(alignment: .trailing) {
                self.ButtonCloseSettingsView()
                    .offset(x: -12)
            }
            .overlay(alignment: .bottom) {
                ShadowLine()
                    .offset(y: 5)
            }
    }

    @ViewBuilder private func ButtonCloseSettingsView() -> some View {
        ButtonRound(
            label     : { Image(systemName: "checkmark.circle") },
            foreground: { Color.ctrlPanel.buttonText },
            background: { Color.ctrlPanel.buttonBackground }
        ) { self.isEditMode.value = false }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Previewer {
        ControlPanel()
            .frame(width: 600, height: 100, alignment: .top)
            .environment(\.isEditMode, ValueState<Bool>(true))
    }
}
