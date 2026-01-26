
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PickerCustom<Key>: View where Key: Hashable & Comparable {

    typealias ColorSet = Color.ProfilePanelColorSet.PickerColorSet

    @Binding fileprivate var selectedKey: Key
    @State fileprivate var isOpened = false

    fileprivate let items: [Key: String]
    fileprivate let sortedBy: Dictionary<Key, String>.SortedBy
    fileprivate let isPlainListStyle: Bool
    fileprivate let flexibility: Flexibility
    fileprivate let colorSet: ColorSet
    fileprivate let cornerRadius: CGFloat = 15

    fileprivate var itemsSorted: [(key: Key, value: String)] {
        self.items.sortedBy(
            order: self.sortedBy
        )
    }

    fileprivate var KeyToIndex: [Key: Int] {
        self.itemsSorted.enumerated().reduce(into: [Key: Int]()) { result, info in
            let (index, item) = info
            result[item.key] = index
        }
    }

    init(
        selected: Binding<Key>,
        items: [Key: String],
        sortedBy: Dictionary<Key, String>.SortedBy = .keyAsc,
        isPlainListStyle: Bool = false,
        flexibility: Flexibility = .none,
        colorSet: ColorSet = Color.profilePanel.picker
    ) {
        self._selectedKey = selected
        self.items = items
        self.sortedBy = sortedBy
        self.isPlainListStyle = isPlainListStyle
        self.flexibility = flexibility
        self.colorSet = colorSet
    }

    public var body: some View {
        if (self.items.isEmpty) {
            self.opener
                .disabled(true)
        } else {
            self.opener
                .onKeyPress(phases: .down) { press in
                    switch press.key {
                        case .upArrow, .downArrow, .return:
                            self.isOpened = true
                        default: break
                    }
                    return .handled
                }
                .popover(isPresented: self.$isOpened) {
                    PickerCustomPopover<Key>(
                        rootView: self
                    )
                }
        }
    }

    @ViewBuilder private var opener: some View {
        Button {
            self.isOpened = true
        } label: {
            Text(self.items[self.selectedKey] ?? ThisApp.NOT_APPLICABLE)
                .lineLimit(1)
                .padding(.horizontal, 9)
                .padding(.vertical  , 5)
                .flexibility(self.flexibility)
                .foregroundStyle(self.colorSet.text)
                .background {
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .stroke(self.colorSet.border, lineWidth: 4)
                        .fill(self.colorSet.background)
                }.contentShape(.focusEffect,
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                )
        }
        .hoverBehavior(.scaleEffect(from: 1.0, to: 1.02))
        .buttonStyle(.plain)
        .pointerStyle(.link)
    }

}

fileprivate struct PickerCustomPopover<Key>: View where Key: Hashable & Comparable {

    enum Focuser: Hashable {
        case item(index: Int)
    }

    @FocusState private var focuser: Focuser?
    @State private var hoveringKey: Key?

    private var rootView: PickerCustom<Key>

    init(rootView: PickerCustom<Key>) {
        self.rootView = rootView
    }

    public var body: some View {
        if (self.rootView.items.count > 8)
             { self.listWithScroll }
        else { self.list }
    }

    private var list: some View {
        VStack(spacing: 10) {
            ForEach(Array(self.rootView.itemsSorted.enumerated()), id: \.element.key) { index, item in
                Button {
                    self.rootView.selectedKey = item.key
                    self.rootView.isOpened = false
                } label: {
                    var backgroundColor: Color {
                        if (self.rootView.selectedKey      == item.key) { return self.rootView.colorSet.itemSelectedBackground }
                        if (self.hoveringKey               == item.key) { return self.rootView.colorSet.itemHoveringBackground }
                        if (self.rootView.isPlainListStyle == false   ) { return self.rootView.colorSet.itemBackground }
                        return Color.clear
                    }
                    Text(item.value)
                        .lineLimit(1)
                        .padding(.horizontal, 9)
                        .padding(.vertical  , 5)
                        .frame(maxWidth: .infinity, alignment: self.rootView.isPlainListStyle ? .leading : .center)
                        .foregroundStyle(self.rootView.colorSet.itemText)
                        .background(
                            RoundedRectangle(cornerRadius: self.rootView.cornerRadius)
                                .fill(backgroundColor)
                        ).contentShape(.focusEffect,
                            RoundedRectangle(cornerRadius: self.rootView.cornerRadius)
                        )
                        .onHover { isHovering in
                            self.hoveringKey = isHovering ? item.key : nil
                        }
                }
                .pointerStyle(.link)
                .buttonStyle(.plain)
                .focused(self.$focuser, equals: .item(index: index))
                .id(index)
            }
        }
        .padding(10)
        .onAppear {
            let index = self.rootView.KeyToIndex[self.rootView.selectedKey] ?? 0
            self.focuser = .item(index: index)
        }
        .onKeyPress(phases: .down) { press in
            switch press.key {
                case .upArrow:
                    if case .item(let index) = self.focuser {
                        if (index > 0) {
                            self.focuser = .item(index: index - 1)
                        }
                    }
                case .downArrow:
                    if case .item(let index) = self.focuser {
                        if (index < self.rootView.items.count - 1) {
                            self.focuser = .item(index: index + 1)
                        }
                    }
                case .return:
                    if case .item(let index) = self.focuser {
                        if (index >= 0 && index <= self.rootView.items.count - 1) {
                            self.rootView.selectedKey = self.rootView.itemsSorted[index].key
                        }
                    }
                    self.rootView.isOpened = false
                default:
                    break
            }
            return .handled
        }
    }

    private var listWithScroll: some View {
        ScrollViewReader { scrollProxy in
            List {
                ForEach(Array(self.rootView.itemsSorted.enumerated()), id: \.element.key) { index, item in
                    Button {
                        self.rootView.selectedKey = item.key
                        self.rootView.isOpened = false
                    } label: {
                        var backgroundColor: Color {
                            if (self.rootView.selectedKey      == item.key) { return self.rootView.colorSet.itemSelectedBackground }
                            if (self.hoveringKey               == item.key) { return self.rootView.colorSet.itemHoveringBackground }
                            if (self.rootView.isPlainListStyle == false   ) { return self.rootView.colorSet.itemBackground }
                            return Color.clear
                        }
                        Text(item.value)
                            .lineLimit(1)
                            .padding(.horizontal, 9)
                            .padding(.vertical  , 5)
                            .frame(maxWidth: .infinity, alignment: self.rootView.isPlainListStyle ? .leading : .center)
                            .foregroundStyle(self.rootView.colorSet.itemText)
                            .background(
                                RoundedRectangle(cornerRadius: self.rootView.cornerRadius)
                                    .fill(backgroundColor)
                            ).contentShape(.focusEffect,
                                RoundedRectangle(cornerRadius: self.rootView.cornerRadius)
                            )
                            .onHover { isHovering in
                                self.hoveringKey = isHovering ? item.key : nil
                            }
                    }
                    .pointerStyle(.link)
                    .buttonStyle(.plain)
                    .focused(self.$focuser, equals: .item(index: index))
                    .id(index)
                }
            }
            .listStyle(.sidebar)
            .onAppear {
                let index = self.rootView.KeyToIndex[self.rootView.selectedKey] ?? 0
                self.focuser = .item(index: index)
            }
            .onKeyPress(phases: .down) { press in
                switch press.key {
                    case .upArrow:
                        if case .item(let index) = self.focuser {
                            if (index > 0) {
                                self.focuser = .item(index: index - 1)
                                scrollProxy.scrollTo(index - 1)
                            }
                        }
                    case .downArrow:
                        if case .item(let index) = self.focuser {
                            if (index < self.rootView.items.count - 1) {
                                self.focuser = .item(index: index + 1)
                                scrollProxy.scrollTo(index + 1)
                            }
                        }
                    case .return:
                        if case .item(let index) = self.focuser {
                            if (index >= 0 && index <= self.rootView.items.count - 1) {
                                self.rootView.selectedKey = self.rootView.itemsSorted[index].key
                            }
                        }
                        self.rootView.isOpened = false
                    default:
                        break
                }
                return .handled
            }
        }
    }

}



/* ############################################################# */
/* ########################## PREVIEW ########################## */
/* ############################################################# */

func generatePreviewItems_intKey(count: Int) -> [UInt: String] {
    (1000 ..< 1000 + count).reduce(into: [UInt: String]()) { result, i in
        if (i == 1005) { result[UInt(i)] = "Value \(i) long long long long long long" }
        else           { result[UInt(i)] = "Value \(i)" }
    }
}

func generatePreviewItems_strKey(count: Int) -> [String: String] {
    (1000 ..< 1100).reduce(into: [String: String]()) { result, i in
        if (i == 1005) { result["ID:\(i)"] = "Value \(i) long long long long long long" }
        else           { result["ID:\(i)"] = "Value \(i)" }
    }
}

func generatePreviewItems_forSort() -> [String: String] {[
    "key1": "Значение Б",
    "key3": "Значение Я",
    "key5": "Значение Ё",
    "key6": "Value A",
    "key4": "Value Z",
    "key2": "Value I",
]}

#Preview {
    @Previewable @State var selectedKeyInt: UInt = 0
    @Previewable @State var selectedKeyString: String = ""

    VStack(spacing: 20) {

        VStack {
            Text("Items: 0-30, key: int").font(.headline)
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count:  0))
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count:  5))
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 10))
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 15))
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 20))
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 25))
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 30))
        }

        VStack {
            Text("Items: 0-30, key: string").font(.headline)
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count:  0))
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count:  5))
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 10))
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 15))
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 20))
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 25))
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 30))
        }

    }.frame(minWidth: 250, minHeight: 600)
}

#Preview {
    @Previewable @State var selectedKeyInt: UInt = 0
    @Previewable @State var selectedKeyString: String = ""

    VStack(spacing: 20) {

        VStack {
            Text("Items: 0-30, key: int, style: plain").font(.headline)
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count:  0), isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count:  5), isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 10), isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 15), isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 20), isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 25), isPlainListStyle: true)
            PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 30), isPlainListStyle: true)
        }

        VStack {
            Text("Items: 0-30, key: string, style: plain").font(.headline)
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count:  0), isPlainListStyle: true)
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count:  5), isPlainListStyle: true)
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 10), isPlainListStyle: true)
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 15), isPlainListStyle: true)
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 20), isPlainListStyle: true)
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 25), isPlainListStyle: true)
            PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_strKey(count: 30), isPlainListStyle: true)
        }

    }.frame(minWidth: 250, minHeight: 600)
}


#Preview {
    @Previewable @State var selectedKeyInt: UInt = 0
    VStack {
        Text("Flexibility:").font(.headline)
        PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 30))
        PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 30), flexibility: .none)
        PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 30), flexibility: .size(100))
        PickerCustom<UInt>(selected: $selectedKeyInt, items: generatePreviewItems_intKey(count: 30), flexibility: .infinity)
    }
    .padding(20)
    .frame(width: 200)
}


#Preview {
    @Previewable @State var selectedKeyString: String = ""
    VStack {
        Text("Sort:").font(.headline)
        PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_forSort(), sortedBy: .keyAsc)
        PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_forSort(), sortedBy: .keyDsc)
        PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_forSort(), sortedBy: .valueAsc)
        PickerCustom<String>(selected: $selectedKeyString, items: generatePreviewItems_forSort(), sortedBy: .valueDsc)
    }
    .padding(20)
    .frame(width: 200)
}
