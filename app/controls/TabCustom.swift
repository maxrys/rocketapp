
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol TabCustom_item_Protocol: View {
}

struct TabCustom: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var selected: Int = 0

    private let contents: [any TabCustom_item_Protocol]

    init(@ViewBuilderArray<TabCustom_item_Protocol> content: () -> [any TabCustom_item_Protocol]) {
        self.contents = content()
    }

    public var body: some View {
        VStack(spacing: 0) {

            /* MARK: Tab Header */

            HStack(spacing: 10) {
                ForEach(0 ..< self.contents.count, id: \.self) { index in
                    if let tatSpacer = self.contents[safe: index] as? TabCustom_spacer { tatSpacer }
                    if let tabItem   = self.contents[safe: index] as? TabCustom_item {
                        TabCustom_header(
                            title: tabItem.title,
                            icon: tabItem.icon,
                            index: index,
                            isSelected: self.selected == index) { index in
                                self.selected = index
                            }
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical  , 20)
            .frame(maxWidth: .infinity)
            .background(
                self.colorScheme == .dark ?
                    .black.opacity(0.2) :
                    .white.opacity(0.5)
            )
            .overlay(alignment: .bottom) {
                self.shadow
            }

            /* MARK: Tab Body */

            VStack {
                if let tabItem = self.contents[safe: self.selected] as? TabCustom_item {
                    tabItem.frame(maxWidth: .infinity)
                }
            }.frame(maxWidth: .infinity)

        }.frame(maxWidth: .infinity)
    }

    @ViewBuilder private var shadow: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.clear,
                        self.colorScheme == .dark ?
                            .black.opacity(0.5) :
                            .black.opacity(0.2) ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            ).frame(height: 8)
    }

}

fileprivate struct TabCustom_header: View {

    @Environment(\.colorScheme) fileprivate var colorScheme

    @State fileprivate var isHovering = false

    fileprivate let title: String
    fileprivate let icon: Image?
    fileprivate let index: Int
    fileprivate let isSelected: Bool
    fileprivate let onClick: (Int) -> Void

    public var body: some View {
        Button {
            self.onClick(self.index)
        } label: {
            HStack(spacing: 7) {
                if let icon {
                    icon.resizable()
                        .frame(width: 15, height: 15)
                }
                if (!title.isEmpty) {
                    Text(title)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical  , 10)
            .foregroundStyle(
                self.isSelected ? Color.white :
                    (self.colorScheme == .dark ?
                        Color.white :
                        Color.black
                    )
            )
            .background {
                if (self.isSelected) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle({
                            if (self.isHovering) {
                                return Color.accentColor } else {
                                return self.colorScheme == .dark ?
                                    Color.white.opacity(0.1) :
                                    Color.black.opacity(0.1)
                            }
                        }())
                }
            }
            .contentShape(.focusEffect, RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
        .onHover { isHovering in
            withAnimation(.easeInOut(duration: 0.3)) {
                self.isHovering = isHovering
            }
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    TabCustom {
        TabCustom_item(title: NSLocalizedString("Title 1", comment: ""), icon: Image(systemName: "1.square")) { Text("Tab 1 Content").padding(20) }
        TabCustom_item(title: NSLocalizedString("Title 2", comment: ""), icon: Image(systemName: "2.square")) { Text("Tab 2 Content").padding(20) }; TabCustom_spacer()
        TabCustom_item(title: NSLocalizedString("Title 3", comment: ""), icon: Image(systemName: "3.square")) { Text("Tab 3 Content").padding(20) }
    }.frame(maxWidth: 350)
}
