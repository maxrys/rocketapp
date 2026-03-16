
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TextFieldCustom: View {

    typealias ColorSet = Color.TextFieldCustomColorSet

    @Binding private var value: String

    private let title: String?
    private let isDisabled: Bool
    private let colorSet: ColorSet

    init(
        _ title: String? = nil,
        value: Binding<String>,
        isDisabled: Bool = false,
        colorSet: ColorSet = Color.textField
    ) {
        self.title = title
        self._value = value
        self.isDisabled = isDisabled
        self.colorSet = colorSet
    }

    public var body: some View {
        VStack(spacing: 5) {

            if let title = self.title, !title.isEmpty {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(self.colorSet.titleText)
                    .disabled(self.isDisabled)
            }

            TextField("", text: self.$value)
                .padding(.horizontal, 10)
                .padding(.vertical  ,  5)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .foregroundStyle(self.colorSet.text)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(self.colorSet.border, lineWidth: 3)
                        .fill(self.colorSet.background)
                }
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    @Previewable @State var value: String = "some text"
    VStack {
        TextFieldCustom("Title", value: $value)
        TextFieldCustom(""     , value: $value)
        TextFieldCustom(         value: $value)
    }
    .frame(width: 200)
    .padding(10)
}
