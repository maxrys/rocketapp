
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct ColorPickerCustom: View {

    enum ColorComponent {
        case H
        case S
        case B
        case O
    }

    @Binding private var colorExternal: ColorHSBValue

    @State private var colorInternal: ColorHSBValue
    @State private var isShowPopover: Bool = false

    let width: CGFloat = 200
    let openerSize: CGSize
    let openerRadius: CGFloat
    let isInstantUpdate: Bool

    init(
        _ value: Binding<ColorHSBValue>,
        openerSize: CGSize = CGSize(width: 20, height: 20),
        openerRadius: CGFloat = 0,
        isInstantUpdate: Bool = true
    ) {
        self._colorExternal = value
        self.colorInternal = value.wrappedValue
        self.openerSize = openerSize
        self.openerRadius = openerRadius
        self.isInstantUpdate = isInstantUpdate
    }

    public var body: some View {
        Button {
            self.isShowPopover = true
        } label: {
            self.ColorView()
                .frame(width: openerSize.width, height: openerSize.height)
                .overlay { self.ZebraStrokeView() }
                .clipShape(                 RoundedRectangle(cornerRadius: self.openerRadius))
                .contentShape(              RoundedRectangle(cornerRadius: self.openerRadius))
                .contentShape(.focusEffect, RoundedRectangle(cornerRadius: self.openerRadius))
                .hoverBehavior(.scaleEffect(from: 1.0, to: 1.1))
        }
        .buttonStyle(.plain)
        .pointerStyle(.link)
        .popover(isPresented: self.$isShowPopover) {
            self.PopoverView()
        }
    }

    @ViewBuilder private func ColorView() -> some View {
        Color(
            hue       : self.colorInternal.hue,
            saturation: self.colorInternal.saturation,
            brightness: self.colorInternal.brightness,
            opacity   : self.colorInternal.opacity
        )
    }

    @ViewBuilder private func ZebraStrokeView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: self.openerRadius)
                .stroke(.black, lineWidth: 1)
            RoundedRectangle(cornerRadius: self.openerRadius)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [1], dashPhase: 0.5))
                .foregroundStyle(.white)
        }
    }

    @ViewBuilder private func PopoverView() -> some View {
        VStack(spacing: 20) {

            ZStack(alignment: .leading) {
                self.PaletteView  (component: .H)
                self.IndicatorView(component: .H)
                self.TouchpadView (component: .H)
            }.frame(height: 30)

            ZStack(alignment: .leading) {
                self.PaletteView  (component: .S)
                self.IndicatorView(component: .S)
                self.TouchpadView (component: .S)
            }.frame(height: 30)

            ZStack(alignment: .leading) {
                self.PaletteView  (component: .B)
                self.IndicatorView(component: .B)
                self.TouchpadView (component: .B)
            }.frame(height: 30)

            ZStack(alignment: .leading) {
                self.ChessboardView()
                self.ColorView()
                self.IndicatorView(component: .O)
                self.TouchpadView (component: .O)
            }.frame(height: 30)

        }
        .frame(width: self.width)
        .padding(20)
    }

    @ViewBuilder private func ChessboardView() -> some View {
        let cellSize: CGFloat = 10
        Canvas { context, size in
            context.drawRectangle(x: 0, y: 0, w: size.width, h: size.height, colorFill: .white)
            for j in 0 ... Int(size.height / cellSize) {
            for i in 0 ... Int(size.width  / cellSize) {
                if (i % 2 == 0 && j % 2 != 0) ||
                   (i % 2 != 0 && j % 2 == 0) {
                    context.drawRectangle(
                        x: cellSize * CGFloat(i),
                        y: cellSize * CGFloat(j),
                        w: cellSize,
                        h: cellSize,
                        colorFill: .black.opacity(0.3)
                    )
                }
            }}
        }
    }

    @ViewBuilder private func PaletteView(component: ColorComponent) -> some View {
        Canvas { context, size in
            for i in 0 ... Int(size.width) {
                context.drawRectangle(
                    x: CGFloat(i),
                    y: 0,
                    w: 1,
                    h: size.height,
                    colorFill: Color(
                        hue       : component == .H ? 1.0 / size.width * CGFloat(i) : self.colorInternal.hue,
                        saturation: component == .S ? 1.0 / size.width * CGFloat(i) : 1.0,
                        brightness: component == .B ? 1.0 / size.width * CGFloat(i) : 1.0
                    )
                )
            }
        }
    }

    @ViewBuilder private func IndicatorView(component: ColorComponent) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .stroke(.white, lineWidth: 3)
                .frame(width: 12)
                .shadow(
                    color: .black.opacity(0.7),
                    radius: 2.0
                )
            let title = { switch component {
                case .H: "H"
                case .S: "S"
                case .B: "B"
                case .O: "O"
            }}()
            Text(title)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
                .shadow(
                    color: .black,
                    radius: 1.0
                )
        }
        .padding(.horizontal, -6)
        .padding(.vertical  , -1)
        .offset(x: {
            switch component {
                case .H: self.width * self.colorInternal.hue
                case .S: self.width * self.colorInternal.saturation
                case .B: self.width * self.colorInternal.brightness
                case .O: self.width * self.colorInternal.opacity
            }
        }())
    }

    @ViewBuilder private func TouchpadView(component: ColorComponent) -> some View {
        let setComponentValue: (ColorComponent, Double) -> Void = { component, x in
            switch component {
                case .H: self.colorInternal.hue        = x / self.width
                case .S: self.colorInternal.saturation = x / self.width
                case .B: self.colorInternal.brightness = x / self.width
                case .O: self.colorInternal.opacity    = x / self.width
            }
        }
        Rectangle()
            .foregroundColor(.clear)
            .contentShape(Rectangle())
            .pointerStyle(.link)
            .onTapGesture { location in
                setComponentValue(component, location.x.fixBounds(max: self.width))
                self.colorExternal = self.colorInternal
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        setComponentValue(component, gesture.location.x.fixBounds(max: self.width))
                        if (self.isInstantUpdate) {
                            self.colorExternal = self.colorInternal
                        }
                    }
                    .onEnded { gesture in
                        self.colorExternal = self.colorInternal
                    }
            )
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

#Preview {
    @Previewable @State var pickerColorR = ColorHSBValue(0.00, 1.0, 1.0)
    @Previewable @State var pickerColorG = ColorHSBValue(0.33, 1.0, 1.0)
    @Previewable @State var pickerColorB = ColorHSBValue(0.66, 1.0, 1.0)
    VStack(spacing: 10) {
        ColorPickerCustom($pickerColorR)
        ColorPickerCustom($pickerColorG)
        ColorPickerCustom($pickerColorB)
    }
    .padding(20)
    .onChange(of: pickerColorR) { _, value in print(value.encode() ?? "") }
    .onChange(of: pickerColorG) { _, value in print(value.encode() ?? "") }
    .onChange(of: pickerColorB) { _, value in print(value.encode() ?? "") }
}
