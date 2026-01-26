
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TabCustom_item: TabCustom_item_Protocol {

    let title: String
    let icon: Image?
    let view: any View

    init(
        title: String,
        icon: Image?,
        @ViewBuilder view: () -> any View
    ) {
        self.title = title
        self.icon = icon
        self.view = view()
    }

    public var body: some View {
        AnyView(self.view)
    }

}
