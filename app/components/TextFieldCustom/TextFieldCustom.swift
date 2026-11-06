
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TextFieldCustom: View {

    static let EMPTY_STRING = ""

    @Binding private var value: String

    private let title: String?

    init(
        _ title: String? = nil,
        value: Binding<String>
    ) {
        self.title = title
        self._value = value
    }

    public var body: some View {
        VStack(spacing: 5) {

            if let title = self.title, !title.isEmpty {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.textField.titleText)
            }

            TextField(Self.EMPTY_STRING, text: self.$value)
                .padding(.horizontal, 10)
                .padding(.vertical  ,  5)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .foregroundStyle(Color.textField.text)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.textField.border, lineWidth: 3)
                        .fill(Color.textField.background)
                }
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    @Previewable @State var value: String = "some text"
    Previewer(padding: 20) {
        TextFieldCustom("Title", value: $value)
        TextFieldCustom(""     , value: $value)
        TextFieldCustom(         value: $value)
    }.frame(width: 200)
}
