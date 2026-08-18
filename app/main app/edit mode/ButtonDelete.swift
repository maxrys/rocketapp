
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct Cell_editMode_ButtonDelete: View {

    public let size: CGFloat
    public let onClick: () -> Void

    public var body: some View {
        ButtonRound(
            label: {
                Image(systemName: "minus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(self.size * 0.25)
            },
            foreground: { Color.ButtonCustomStyle.danger.text },
            background: { Circle().fill(Color.ButtonCustomStyle.danger.background.gradient) },
            size: self.size,
            onClick: self.onClick
        ).shadow(
            color: .black,
            radius: self.size * 0.1,
            y: self.size * 0.1
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Previewer(axis: .horizontal) {
        Cell_editMode_ButtonDelete(
            size: 60,
            onClick: { }
        ).padding(20)
    }
}
