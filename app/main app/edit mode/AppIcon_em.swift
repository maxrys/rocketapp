
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct AppIcon_editMode: View, BackgroundColorProtocol {

    static private let BUTTON_DELETE_MIN_SIZE: Double = 15
    static private let BUTTON_DELETE_MAX_SIZE: Double = 40

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark
    @Environment(\.profilesState) private var profiles

    @State private var isHovering = false

    private let name: String
    private let icon: NSImage
    private let size: CGFloat
    private let onDelete: () -> Void

    private var scaleFactor: Double {
        self.size / ThisApp.CELL_SIZE
    }

    init(
        name: String,
        icon: NSImage,
        size: CGFloat,
        onDelete: @escaping () -> Void = {}
    ) {
        self.name = name
        self.icon = icon
        self.size = size
        self.onDelete = onDelete
    }

    public var body: some View {
        Image(nsImage: self.icon)
            .resizable()
            .frame(width: self.size, height: self.size)
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .topTrailing) {
                if (self.isHovering) {
                    Cell_editMode_ButtonDelete(
                        size: (self.size * 0.25 * self.scaleFactor).fixBounds(
                            min: Self.BUTTON_DELETE_MIN_SIZE,
                            max: Self.BUTTON_DELETE_MAX_SIZE),
                        onClick: self.onDelete
                    )
                }
            }
            .overlay(alignment: .bottom) {
                if (self.profiles.current.isShowIconTitle) {
                    if (self.isHovering) {
                        self.TitleView()
                    }
                }
            }
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

            AppIcon_editMode(
                name: "Application Title",
                icon: AppValue.APP_NO_ICON,
                size: ThisApp.CELL_SIZE
            ).id(1)

            AppIcon_editMode(
                name: "Application Title",
                icon: ThisApp.DEMO_ICON,
                size: ThisApp.CELL_SIZE
            ).id(2)

            Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                GridRow {

                    AppIcon_editMode(
                        name: "Application Title",
                        icon: AppValue.APP_NO_ICON,
                        size: ThisApp.CELL_SIZE / 2
                    ).id(3)

                    AppIcon_editMode(
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

        AppIcon_editMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            size: 50
        ).id(1)

        AppIcon_editMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            size: 100
        ).id(2)

        AppIcon_editMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            size: 150
        ).id(3)

        AppIcon_editMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            size: 200
        ).id(4)

    }.padding(20)
}
