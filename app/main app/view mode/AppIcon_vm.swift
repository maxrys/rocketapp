
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
    private let cellSize: CGFloat
    private let isMiniGrid: Bool

    init(
        name: String,
        icon: NSImage,
        cellSize: CGFloat,
        isMiniGrid: Bool = false
    ) {
        self.name = name
        self.icon = icon
        self.cellSize = cellSize
        self.isMiniGrid = isMiniGrid
    }

    public var body: some View {
        Image(nsImage: self.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: self.cellSize, height: self.cellSize)
            .contentShape(.focusEffect, RoundedRectangle(cornerRadius: self.cellSize / 8))
            .overlay(alignment: .bottom) {
                if (self.profiles.current.isShowIconTitle) {
                    if (self.isHovering) {
                        self.TitleView()
                    }
                }
            }
            .scaleEffect(self.isMiniGrid ? 1.0 : 1.15)
            .hoverBehavior(.scaleEffect(from: 1.0, to: self.profiles.current.iconOnHoverZoom.double))
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

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
        AppIcon_viewMode(
            name: "Application Title",
            icon: AppValue.APP_NO_ICON,
            cellSize: 100
        ).id(1)
        AppIcon_viewMode(
            name: "Application Title",
            icon: ThisApp.DEMO_ICON,
            cellSize: 100
        ).id(2)
        Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                AppIcon_viewMode(
                    name: "Application Title",
                    icon: AppValue.APP_NO_ICON,
                    cellSize: 50,
                    isMiniGrid: true
                ).id(3)
                AppIcon_viewMode(
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
