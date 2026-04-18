
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct AppIcon_editMode: View, BackgroundColorProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark

    @Environment(\.profilesState) private var profiles

    @State private var isHovering = false

    private let name: String
    private let icon: NSImage
    private let cellSize: CGFloat
    private let isMiniGrid: Bool
    private let onDelete: () -> Void

    init(
        name: String,
        icon: NSImage,
        cellSize: CGFloat,
        isMiniGrid: Bool = false,
        onDelete: @escaping () -> Void = {}
    ) {
        self.name = name
        self.icon = icon
        self.cellSize = cellSize
        self.isMiniGrid = isMiniGrid
        self.onDelete = onDelete
    }

    public var body: some View {
        Image(nsImage: self.icon)
            .resizable()
            .frame(width: self.cellSize, height: self.cellSize)
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .topTrailing) {
                if (self.isHovering) {
                    self.ButtonDeleteView(
                        self.isMiniGrid ?
                            self.cellSize * 0.35 :
                            self.cellSize * 0.25
                    ) {
                        self.onDelete()
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if (self.profiles.current.isShowIconTitle) {
                    if (self.isHovering) {
                        self.TitleView()
                    }
                }
            }
            .scaleEffect(self.isMiniGrid ? 1.0 : 1.15)
            .onHover { hovering in
                self.isHovering = hovering
            }.hoverBehavior(.zIndex(to: 1))
    }

    @ViewBuilder private func TitleView() -> some View {
        Text(self.name)
            .font(.system(size: self.isMiniGrid ? 9 : 11))
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 9)
            .padding(.vertical  , 5)
            .foregroundStyle(
                self.colorScheme == .dark ?
                    (self.backgroundDark.isTinted == true ? Color.white : Color.black) :
                    (self.background    .isTinted != true ? Color.black : Color.white)
            )
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(self.backgroundHSB(minOpacity: 0.9).color.gradient)
                    .shadow(
                        color:
                            self.colorScheme == .dark ?
                                (self.backgroundDark.isTinted == true ? Color.white.opacity(0.5) : Color.black.opacity(0.5)) :
                                (self.background    .isTinted != true ? Color.black.opacity(0.5) : Color.white.opacity(0.5)),
                        radius: 10.0
                    )
            )
    }

    @ViewBuilder private func ButtonDeleteView(_ size: CGFloat, onClick: @escaping () -> Void) -> some View {
        ButtonRound(
            label: {
                Image(systemName: "minus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(size * 0.25)
            },
            foreground: { Color.ButtonCustomStyle.danger.text },
            background: { Circle().fill(Color.ButtonCustomStyle.danger.background.gradient) },
            size: size,
            onClick: onClick
        ).shadow(
            color: .black,
            radius: size * 0.1,
            y: size * 0.1
        )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
        AppIcon_editMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            cellSize: 100
        ).id(1)
        AppIcon_editMode(
            name: "Application Title",
            icon: ThisApp.DEMO_ICON,
            cellSize: 100
        ).id(2)
        Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                AppIcon_editMode(
                    name: "Application Title",
                    icon: AppValue.APP_NO_ICON,
                    cellSize: 50,
                    isMiniGrid: true
                ).id(3)
                AppIcon_editMode(
                    name: "Application Title",
                    icon: ThisApp.DEMO_ICON,
                    cellSize: 50,
                    isMiniGrid: true
                ).id(4)
            }
        }
    }
    .padding(10)
    .frame(width: 200)
}
