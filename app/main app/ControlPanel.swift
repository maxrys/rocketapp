
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ControlPanel: View {

    @Environment(\.colorScheme)   private var colorScheme
    @Environment(\.profilesState) private var profiles
    @Environment(\.cellsState)    private var cells

    @Binding private var isEditMode: Bool

    private let elementSpacing: CGFloat = 30

    init(isEditMode: Binding<Bool>) {
        self._isEditMode = isEditMode
    }

    public var body: some View {
        LazyVGrid(columns: [
            GridItem(.fixed(30) , spacing: self.elementSpacing),
            GridItem(.flexible(), spacing: self.elementSpacing),
            GridItem(.fixed(30) , spacing: self.elementSpacing)
        ], spacing: self.elementSpacing) {
            self.buttonAudit
            ProfilePanel()
            self.buttonCloseSettings
        }
        .padding(.horizontal, 15)
        .padding(.vertical  , 12)
        .background(Color.ctrlPanel.background)
        .overlay(alignment: .bottom) {
            self.shadow.offset(y: 5)
        }
    }

    @ViewBuilder private var shadow: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.black.opacity(0.3), Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            ).frame(height: 5)
    }

    @ViewBuilder private var buttonAudit: some View {
        ButtonRound(
            label: {
                if (self.cells.isAuditInProgress) {
                    TimelineView(.periodic(from: .now, by: 1.0 / 24)) { _ in
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.circle")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(
                                Date.spin(max: 360, speed: 500)
                            )
                        )
                    }
                } else {
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.circle")
                        .resizable()
                        .scaledToFit()
                }
            },
            foreground: { Color.ctrlPanel.buttonText },
            background: { Color.ctrlPanel.buttonBackground },
            disabled  :   self.cells.isAuditInProgress || self.cells.isEmpty,
            onClick   : { self.cells.audit() }
        )
    }

    @ViewBuilder private var buttonCloseSettings: some View {
        ButtonRound(
            label     : { Image(systemName: "arrow.forward.circle") },
            foreground: { Color.ctrlPanel.buttonText },
            background: { Color.ctrlPanel.buttonBackground }
        ) { self.isEditMode = false }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    ControlPanel(
        isEditMode: .constant(true)
    ).frame(width: 600)
}
