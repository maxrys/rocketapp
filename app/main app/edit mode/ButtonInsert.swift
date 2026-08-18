
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import UniformTypeIdentifiers

struct Cell_editMode_ButtonInsert: View, BackgroundColorProtocol {

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark
    @Environment(\.isEnabled) private var isEnabled

    @State private var isHovering = false

    public let size: CGFloat
    public let onClick: () -> Void
    public let onDrop: (_ providers: [NSItemProvider]) -> Bool

    public var body: some View {
        Button { self.onClick() } label: {
            Circle()
                .fill(self.backgroundHSB(minOpacity: 1.0).color)
                .stroke(self.backgroundAccentHSB(minOpacity: 1.0).color, lineWidth: self.size * 0.1)
                .frame(width: self.size, height: self.size)
                .clipShape   (              Circle())
                .contentShape(              Circle())
                .contentShape(.focusEffect, Circle())
                .overlay {
                    Image(systemName: "plus")
                        .resizable()
                        .fontWeight(.medium)
                        .frame(width: self.size * 0.6, height: self.size * 0.6)
                        .foregroundStyle(
                            self.isHovering ? Color.accentColor :
                            self.backgroundAccentHSB(minOpacity: 1.0).color
                        )
                }
        }
        .buttonStyle(.plain)
        .pointerStyle(self.isEnabled ? .link : .default)
        .onHover { isHovering in self.isHovering = isHovering }
        .onDrop(of: [.application, UTType.appDragValue], isTargeted: self.$isHovering, perform: self.onDrop)
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    Previewer(axis: .horizontal) {
        VStack(spacing: 10) {

            Cell_editMode_ButtonInsert(
                size: 40,
                onClick: { },
                onDrop: { providers in true }
            )

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], spacing: 10) {
                Cell_editMode_ButtonInsert(size: 20, onClick: { }, onDrop: { providers in true } ).id(1)
                Cell_editMode_ButtonInsert(size: 20, onClick: { }, onDrop: { providers in true } ).id(2)
                Cell_editMode_ButtonInsert(size: 20, onClick: { }, onDrop: { providers in true } ).id(3)
                Cell_editMode_ButtonInsert(size: 20, onClick: { }, onDrop: { providers in true } ).id(4)
            }

        }.padding(20)
    }
}
