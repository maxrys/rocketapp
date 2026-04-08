
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol TabCustom_Item_Protocol: View {
}

struct TabCustom_Item: TabCustom_Item_Protocol {

    let title: String
    let icon: Image?
    let content: any View

    init(
        title: String,
        icon: Image?,
        @ViewBuilder content: () -> any View
    ) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    public var body: some View {
        AnyView(self.content)
    }

}
