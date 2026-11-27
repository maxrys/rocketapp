
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

struct ControlPanel: View, BackgroundColorProtocol {

    static let CELL_SIZE_VALUES: [UInt] = [50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]
    static let CELL_SPACING_VALUES: [UInt] = [0, 5, 10, 15, 20, 25, 30]
    static let HOVER_ZOOM_VALUES: [Decimal] = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5]

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark
    @Environment(\.profilesState)        internal var profiles
    @Environment(\.cellsState)           internal var cells
    @Environment(\.isEditMode)           internal var isEditMode

    public var body: some View {
        HStack(spacing: 20) {

            Group {
                self.CellSizeFieldView()
                self.CellSpacingFieldView()
                self.IconOnHoverZoomFieldView()
                self.IsShowTitleFieldView()
                self.BackgroundFieldView()
            }.disabled(
                !self.isEditMode.value
            )

            Spacer()

            Button(self.isEditMode.value ? "View Mode" : "Edit Mode") {
                self.isEditMode.value.toggle()
            }

            Button("+ default") {
                ProcessLoadDefault.run()
            }.disabled(
                !self.isEditMode.value
            )

            Button("+ random") {
                ProcessLoadRandom.run()
            }.disabled(
                !self.isEditMode.value
            )

        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color.NS[.lightGray])
    }

    @ViewBuilder private func CellSizeFieldView() -> some View {
        Picker(selection: self.profiles.current.getBinding(\.cellSize)) {
            ForEach(Self.CELL_SIZE_VALUES, id: \.self) { value in
                Text(value, format: .number)
                    .tag(value)
            }
        } label: {
            Text("Size")
                .fixedSize()
                .font(.headline)
        }.frame(maxWidth: 120)
    }

    @ViewBuilder private func CellSpacingFieldView() -> some View {
        Picker(selection: self.profiles.current.getBinding(\.cellSpacing)) {
            ForEach(Self.CELL_SPACING_VALUES, id: \.self) { value in
                Text(value, format: .number)
                    .tag(value)
            }
        } label: {
            Text("Spacing")
                .fixedSize()
                .font(.headline)
        }.frame(maxWidth: 110)
    }

    @ViewBuilder private func IconOnHoverZoomFieldView() -> some View {
        Picker(selection: self.profiles.current.getBinding(\.iconOnHoverZoom)) {
            ForEach(Self.HOVER_ZOOM_VALUES, id: \.self) { value in
                Text("x\(value, format: .number.precision(.fractionLength(1)))")
                    .tag(value)
            }
        } label: {
            Text("Icon Zoom")
                .fixedSize()
                .font(.headline)
        }.frame(maxWidth: 130)
    }

    @ViewBuilder private func IsShowTitleFieldView() -> some View {
        Toggle(isOn: profiles.current.getBinding(\.isShowIconTitle)) {
            Text("Show Title")
                .fixedSize()
                .font(.headline)
        }.toggleStyle(.switch)
    }

    @ViewBuilder private func BackgroundFieldView() -> some View {
        HStack(spacing: 10) {

            Text("Background")
                .fixedSize()
                .font(.headline)

            ColorPickerHSBO(
                self.profiles.current.getBinding(\.background),
                openerSize: .init(width: 40, height: 20),
                openerRadius: 10,
                isInstantUpdate: true
            )

            ColorPickerHSBO(
                self.profiles.current.getBinding(\.backgroundDark),
                openerSize: .init(width: 40, height: 20),
                openerRadius: 10,
                isInstantUpdate: true
            )

        }
    }

}
