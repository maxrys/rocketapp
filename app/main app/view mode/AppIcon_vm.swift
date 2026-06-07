
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct AppIcon_viewMode: View, BackgroundColorProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark
    @Environment(\.profilesState) private var profiles

    @State private var isHovering = false

    private let name: String
    private let icon: NSImage
    private let size: CGFloat

    private var scaleFactor: Double {
        self.size / ThisApp.CELL_SIZE
    }

    init(
        name: String,
        icon: NSImage,
        size: CGFloat,
    ) {
        self.name = name
        self.icon = icon
        self.size = size
    }

    public var body: some View {
        Image(nsImage: self.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: self.size, height: self.size)
            .contentShape(.focusEffect, RoundedRectangle(cornerRadius: self.size / 8))
            .overlay(alignment: .bottom) {
                if (self.profiles.current.isShowIconTitle) {
                    if (self.isHovering) {
                        self.TitleView()
                    }
                }
            }
            .hoverBehavior(.scaleEffect(from: 1.0, to: self.profiles.current.iconOnHoverZoom.double))
            .onHover { hovering in
                self.isHovering = hovering
            }.hoverBehavior(.zIndex(to: 1))
    }

    @ViewBuilder private func TitleView() -> some View {
        СhameleonView {
            Text(self.name)
                .font(.system(size: 14))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 9)
                .padding(.vertical  , 5)
        }.scaleEffect(
            self.scaleFactor.fixBounds(
                min: 0.8,
                max: 1.5
            )
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Previewer(isHorizontal: true) {
        Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {

            AppIcon_viewMode(
                name: "Application Title",
                icon: AppValue.APP_NO_ICON,
                size: ThisApp.CELL_SIZE
            ).id(1)

            AppIcon_viewMode(
                name: "Application Title",
                icon: ThisApp.DEMO_ICON,
                size: ThisApp.CELL_SIZE
            ).id(2)

            Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                GridRow {

                    AppIcon_viewMode(
                        name: "Application Title",
                        icon: AppValue.APP_NO_ICON,
                        size: ThisApp.CELL_SIZE / 2
                    ).id(3)

                    AppIcon_viewMode(
                        name: "Application Title",
                        icon: ThisApp.DEMO_ICON,
                        size: ThisApp.CELL_SIZE / 2
                    ).id(4)

                }
            }

        }.padding(10)
    }
}

#Preview {
    Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {

        AppIcon_viewMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            size: ThisApp.CELL_SIZE * 0.5
        ).id(1)

        AppIcon_viewMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            size: ThisApp.CELL_SIZE
        ).id(2)

        AppIcon_viewMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            size: ThisApp.CELL_SIZE * 1.5
        ).id(3)

        AppIcon_viewMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            size: ThisApp.CELL_SIZE * 2.0
        ).id(4)

    }.padding(20)
}
