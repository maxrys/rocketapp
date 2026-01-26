
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

protocol TabItemProtocol: View {
}

struct TabsCustom: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var selected: Int = 0

    private let contents: [any TabItemProtocol]

    init(@ViewBuilderArray<TabItemProtocol> content: () -> [any TabItemProtocol]) {
        self.contents = content()
    }

    public var body: some View {
        VStack(spacing: 0) {

            HStack(spacing: 10) {
                ForEach(0 ..< self.contents.count, id: \.self) { index in
                    if let tabItemSpacer = self.contents[safe: index] as? TabItemSpacer { tabItemSpacer }
                    if let tabItemCustom = self.contents[safe: index] as? TabItemCustom {
                        TabsCustom_header(
                            title: tabItemCustom.title,
                            icon: tabItemCustom.systemIcon,
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

            VStack {
                if let tabItem = self.contents[safe: self.selected] as? TabItemCustom {
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

fileprivate struct TabsCustom_header: View {

    @Environment(\.colorScheme) fileprivate var colorScheme

    @State fileprivate var isHovering = false

    fileprivate var title: String
    fileprivate var icon: String?
    fileprivate var index: Int
    fileprivate var isSelected: Bool
    fileprivate var onClick: (Int) -> Void

    public var body: some View {
        Button {
            self.onClick(self.index)
        } label: {
            HStack(spacing: 7) {
                if let icon {
                    Image(systemName: icon)
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                if (!title.isEmpty) {
                    Text(title)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding(.horizontal, 7)
            .padding(.vertical  , 5)
            .contentShape(.focusEffect, RoundedRectangle(cornerRadius: 5))
            .padding(5)
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
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
    TabsCustom {
        TabItemCustom(title: "Update", systemIcon: "pencil.tip.crop.circle") { Text("Tab Update content").padding(20) }
        TabItemCustom(title: "Insert", systemIcon: "plus.circle"           ) { Text("Tab Insert content").padding(20) }; TabItemSpacer()
        TabItemCustom(title: "Delete", systemIcon: "trash"                 ) { Text("Tab Delete content").padding(20) }
    }.frame(maxWidth: 350)
}
