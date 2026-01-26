
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct AppIcon: View, BackgroundColorResolvingProtocol {

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
            .contentShape(.focusEffect, RoundedRectangle(cornerRadius: self.cellSize / 8))
            .overlay(alignment: .bottom) {
                if (self.profiles.current.isShowTitle) {
                    if (self.isHovering) {
                        self.title.scaleEffect(self.isMiniGrid ? 0.9 : 1.0)
                    }
                }
            }
            .scaleEffect(self.isMiniGrid ? 1.0 : 1.15)
            .hoverBehavior(.scaleEffect(from: 1.0, to: self.profiles.current.iconOnHoverZoom.double))
            .onHover { hovering in
                self.isHovering = hovering
            }
    }

    @ViewBuilder private var title: some View {
        Text(self.name)
            .font(.system(size: self.isMiniGrid ? 10 : 12, weight: .bold))
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
                    .fill(self.colorBackgroundResolve(minOpacity: 0.9).gradient)
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
    VStack(spacing: 10) {
        AppIcon(
            name: "App Title",
            icon: AppValue.APP_NO_ICON,
            cellSize: 100
        ).zIndex(3)
        AppIcon(
            name: "App Title",
            icon: ThisApp.DEMO_ICON,
            cellSize: 100
        ).zIndex(2)
        AppIcon(
            name: "App with Long long long long long long long long title",
            icon: ThisApp.DEMO_ICON,
            cellSize: 100
        ).zIndex(1)
    }
    .padding(10)
    .frame(width: 200)
}
