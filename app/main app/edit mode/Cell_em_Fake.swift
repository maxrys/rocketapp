
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct Cell_editMode_Fake: View, BackgroundColorProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark

    public let size: CGFloat
    public var color1: Color?
    public var color2: Color?

    init(
        size: CGFloat,
        color1: Color? = nil,
        color2: Color? = nil
    ) {
        self.size   = size
        self.color1 = color1
        self.color2 = color2
    }

    public var body: some View {
        ZStack {
            Image("FakeCell")
                .resizable()
                .frame(width: self.size * 0.73, height: self.size * 0.73)
                .padding(.leading, self.size * 0.024)
                .padding(.top    , self.size * 0.022)
                .symbolRenderingMode(.palette)
                .foregroundStyle(
                    self.color1 ?? self.backgroundAccentHSB(minOpacity: 1.0).color,
                    self.color2 ?? self.backgroundHSB      (minOpacity: 1.0).color
                )
        }.frame(
            width : self.size,
            height: self.size
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    @Previewable @State var mockForNone = CellsState.initMock(profileID: ThisApp.PREVIEW_PROFILE_ID)
    let size: CGFloat = 300
    /* overlap */
    ZStack {
        Cell_editMode_Fake(
            size: size,
            color1: .red,
            color2: .blue
        )
        Cell_editMode(
            ID: 0,
            size: size,
            isVisible: true
        ).environment(\.cellsState, mockForNone).opacity(0.5)
    }
    ZStack {
        Cell_editMode(
            ID: 0,
            size: size,
            isVisible: true
        ).environment(\.cellsState, mockForNone)
        Cell_editMode_Fake(
            size: size,
            color1: .red,
            color2: .blue
        ).opacity(0.5)
    }
}
