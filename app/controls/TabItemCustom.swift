
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TabItemCustom: TabItemProtocol {

    var title: String
    var systemIcon: String?
    var view: any View

    init(
        title: String,
        systemIcon: String?,
        @ViewBuilder view: () -> any View
    ) {
        self.title = title
        self.systemIcon = systemIcon
        self.view = view()
    }

    public var body: some View {
        AnyView(self.view)
    }

}
