
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol TabCustom_Item_Protocol: View {
}

struct TabCustom_Item: TabCustom_Item_Protocol {

    let title: String
    let icon: Image?
    let iconSize: CGSize?
    let axis: Axis
    let spacing: CGFloat
    let content: any View

    init(
        title: String,
        icon: Image? = nil,
        iconSize: CGSize? = CGSize(width: 15, height: 15),
        axis: Axis = .horizontal,
        spacing: CGFloat = 7,
        @ViewBuilder content: () -> any View
    ) {
        self.title = title
        self.icon = icon
        self.iconSize = iconSize
        self.axis = axis
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        AnyView(self.content)
    }

}
