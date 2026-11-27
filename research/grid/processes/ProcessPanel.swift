
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ProcessPanel: View {

    @Environment(\.colorScheme) internal var colorScheme
    @Environment(\.processState) internal var process

    @FocusState private var isFocusedButton: Bool

    public var body: some View {
        Color(self.colorScheme == .dark ? .white : .black).opacity(0.3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                VStack(spacing: 10) {

                    ProgressCustom(value: process.progress)
                        .shadow(
                            color: .black.opacity(0.5),
                            radius: 5.0
                        )

                    ButtonCustom(
                        NSLocalizedString("cancel", comment: ""),
                        flexibility: .size(200),
                        isFlat: false,
                        onClick: {
                            process.task?.cancel()
                        }
                    ).focused(self.$isFocusedButton)

                    if !process.report.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(process.report, id: \.self) { line in
                                    Text(line)
                                        .font(.system(size: 12, design: .monospaced))
                                }
                            }
                            .padding(10)
                            .background(
                                self.colorScheme == .dark ?
                                    .black.opacity(0.5) :
                                    .white.opacity(0.5)
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )
                    }

                }
                .padding(50)
                .padding(.top, 50)
            }
            .onAppear {
                self.isFocusedButton = true
            }

    }
}
