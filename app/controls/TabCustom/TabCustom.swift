
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TabCustom: View {

    @Environment(\.colorScheme) private var colorScheme

    @State private var selected: Int = 0

    private let contents: [any TabCustom_Item_Protocol]

    init(@ViewBuilderArray<TabCustom_Item_Protocol> content: () -> [any TabCustom_Item_Protocol]) {
        self.contents = content()
    }

    private var colorHeadBackground: Color {
        self.colorScheme == .dark ?
            Color.tab.headBackgroundDark :
            Color.tab.headBackground
    }

    public var body: some View {
        VStack(spacing: 0) {

            /* MARK: Tab Header */

            HStack(spacing: 10) {
                ForEach(self.contents.indices, id: \.self) { index in
                    if let tatSpacer = self.contents[safe: index] as? TabCustom_Spacer { tatSpacer }
                    if let tabItem   = self.contents[safe: index] as? TabCustom_Item {
                        TabCustom_HeadTitle(
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
            .background(self.colorHeadBackground)
            .overlay(alignment: .bottom) {
                self.ShadowView()
            }

            /* MARK: Tab Body */

            VStack {
                if let tabItem = self.contents[safe: self.selected] as? TabCustom_Item {
                    tabItem.frame(maxWidth: .infinity)
                }
            }.frame(maxWidth: .infinity)

        }.frame(maxWidth: .infinity)
    }

    @ViewBuilder private func ShadowView() -> some View {
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

fileprivate struct TabCustom_HeadTitle: View {

    @Environment(\.colorScheme) private var colorScheme

    @State fileprivate var isHovering = false

    fileprivate let title: String
    fileprivate let icon: Image?
    fileprivate let index: Int
    fileprivate let isSelected: Bool
    fileprivate let onClick: (Int) -> Void

    private var colorBorder: Color {
        if (self.isHovering != true && self.colorScheme != .dark) { return .tab.headTitleBorder             }
        if (self.isHovering != true && self.colorScheme == .dark) { return .tab.headTitleBorderDark         }
        if (self.isHovering == true && self.colorScheme != .dark) { return .tab.headTitleBorderHovering     }
        if (self.isHovering == true && self.colorScheme == .dark) { return .tab.headTitleBorderHoveringDark }
        return .clear
    }

    private var colorForeground: Color {
        if (self.isSelected != true && self.colorScheme != .dark) { return .tab.headTitle             }
        if (self.isSelected != true && self.colorScheme == .dark) { return .tab.headTitleDark         }
        if (self.isSelected == true && self.colorScheme != .dark) { return .tab.headTitleSelected     }
        if (self.isSelected == true && self.colorScheme == .dark) { return .tab.headTitleSelectedDark }
        return .clear
    }

    private var colorBackground: Color {
        self.isSelected ?
            .tab.headTitleSelectedBackground :
            .tab.headTitleBackground
    }

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
                        .font(.system(size: 13))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical  , 10)
            .foregroundStyle(self.colorForeground)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(self.colorBackground)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(self.colorBorder)
                    }.contentShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
        .onHover { isHovering in
            self.isHovering = isHovering
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    TabCustom {
        TabCustom_Item(title: NSLocalizedString("Title 1", comment: ""), icon: Image(systemName: "1.square")) { Text("Tab 1 Content").padding(20) }
        TabCustom_Item(title: NSLocalizedString("Title 2", comment: ""), icon: Image(systemName: "2.square")) { Text("Tab 2 Content").padding(20) }; TabCustom_Spacer()
        TabCustom_Item(title: NSLocalizedString("Title 3", comment: ""), icon: Image(systemName: "3.square")) { Text("Tab 3 Content").padding(20) }
    }.frame(maxWidth: 350)
}
