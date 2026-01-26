
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ToggleCustom: View {

    @Binding private var isOn: Bool

    private var text: String
    private var isFlexible: Bool
    private var onChange: (Bool) -> Void

    init(text: String = "", isFlexible: Bool = false, isOn: Binding<Bool>, onChange: @escaping (Bool) -> Void = { isOn in }) {
        self.text = text
        self._isOn = isOn
        self.isFlexible = isFlexible
        self.onChange = onChange
    }

    var body: some View {
        if (self.text.count > 0) {
            if (self.isFlexible) {
                HStack {
                    Text(self.text)
                        .font(.headline)
                    Spacer()
                    ToggleCustom_switcher(
                        isOn: self.$isOn,
                        onChange: self.onChange
                    )
                }.frame(maxWidth: .infinity)
            } else {
                HStack {
                    Text(self.text)
                        .font(.headline)
                    ToggleCustom_switcher(
                        isOn: self.$isOn,
                        onChange: self.onChange
                    )
                }
            }
        } else {
            ToggleCustom_switcher(
                isOn: self.$isOn,
                onChange: self.onChange
            )
        }
    }

}

fileprivate struct ToggleCustom_switcher: View {

    @Binding fileprivate var isOn: Bool

    fileprivate let size = CGSize(width: 40, height: 16)
    fileprivate let innerPadding: CGFloat = 3
    fileprivate let onChange: (Bool) -> Void

    init(isOn: Binding<Bool>, onChange: @escaping (Bool) -> Void = { isOn in }) {
        self._isOn = isOn
        self.onChange = onChange
    }

    var body: some View {
        Button {
            self.onChange(!self.isOn)
            withAnimation(.easeInOut(duration: 0.1)) {
                self.isOn.toggle()
            }
        } label: {
            ZStack(alignment: self.isOn ? .trailing : .leading) {
                Capsule()
                    .fill(self.isOn ? .green : .gray)
                    .frame(width: self.size.width, height: self.size.height)
                Capsule()
                    .fill(.white)
                    .frame(width: (self.size.height * 1.5) - (self.innerPadding * 2), height: self.size.height - (self.innerPadding * 2))
                    .padding(self.innerPadding)
                    .shadow(
                        color: .black.opacity(0.5),
                        radius: 2.0
                    )
            }
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
        .hoverBehavior(.scaleEffect(from: 1.0, to: 1.1))
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    @Previewable @State var isOn = false
    HStack {
        ToggleCustom(
            text: "Test",
            isOn: $isOn
        ).frame(width: 100, height: 50)
    }
    .padding(20)
}
