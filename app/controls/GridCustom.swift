
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct GridCustom: View {

    typealias DataSource       = Dictionary<CellID.Value, any CellProtocol>.Matrix
    typealias DataSourceBounds = Dictionary<CellID.Value, any CellProtocol>.Matrix.Bounds

    enum GridType {
        case stacks
        case grid
        case lazyVGrid
    }

    @State private var scrollPosition: ScrollPosition = ScrollPosition()
    @State private var scrollPhase: ScrollPhase = .idle
    @State private var visibleFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    @State private var stickyGridDelayTimer: Timer.Custom!
    @State private var stickyGridTimer: Timer.Custom!
    @State private var cellsVisibilityDelayTimer: Timer.Custom!
    @State private var cellsVisibility: Set<CellID.Value> = []

    private let source: DataSource
    private let cellSize: CGFloat
    private let cellSpacing: CGFloat
    private let isSticky: Bool
    private let gridType: GridType

    init(
        data source: DataSource,
        cellSize: CGFloat,
        cellSpacing: CGFloat,
        isSticky: Bool,
        gridType: GridType = .lazyVGrid
    ) {
        self.source = source
        self.cellSize = cellSize
        self.cellSpacing = cellSpacing
        self.isSticky = isSticky
        self.gridType = gridType
        self.cellsVisibilityUpdate()
    }

    private var gridBounds: CGSize {
        guard let bounds = self.source.bounds else { return CGSize(width: 0, height: 0) }
        let colsCount = CGFloat(bounds.maxX - bounds.minX + 1)
        let rowsCount = CGFloat(bounds.maxY - bounds.minY + 1)
        let gridSizeW = (self.cellSize * colsCount) + (self.cellSpacing * (colsCount + 1))
        let gridSizeH = (self.cellSize * rowsCount) + (self.cellSpacing * (rowsCount + 1))
        return CGSize(width: gridSizeW, height: gridSizeH)
    }

    private var cellsFrame: [CellID.Value: CGRect] {
        var result: [CellID.Value: CGRect] = [:]
        if let bounds = self.source.bounds {
            for rowNum in bounds.minY ... bounds.maxY {
            for colNum in bounds.minX ... bounds.maxX {
                let cellFrameMinX = (self.cellSize * CGFloat(colNum)) + (self.cellSpacing * (CGFloat(colNum) + 1))
                let cellFrameMinY = (self.cellSize * CGFloat(rowNum)) + (self.cellSpacing * (CGFloat(rowNum) + 1))
                let rowNum = CellID.Index(rowNum)
                let colNum = CellID.Index(colNum)
                let cellID = CellID(rowNum: rowNum, colNum: colNum)
                result[cellID.value] = CGRect(
                    x     : cellFrameMinX,
                    y     : cellFrameMinY,
                    width : self.cellSize,
                    height: self.cellSize
                )
            }}
        }
        return result
    }

    private var isScrollDisabled: Bool {
        let gridBounds = self.gridBounds;
        return gridBounds.width  < self.visibleFrame.size.width &&
               gridBounds.height < self.visibleFrame.size.height
    }

    public var body: some View {
        ScrollView([.horizontal, .vertical]) { self.GridView() }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollDisabled(self.isScrollDisabled)
            .scrollPosition(self.$scrollPosition)
            .onScrollPhaseChange { oldPhase, newPhase, context in
                if (oldPhase != newPhase) {
                    self.scrollPhase = newPhase
                    self.visibleFrame = CGRect(origin: context.geometry.contentOffset, size: context.geometry.visibleRect.size)
                    if (self.scrollPhase == .idle) {
                        self.cellsVisibilityUpdate()
                    }
                    if (self.isSticky) {
                        self.makeSticky()
                    }
                }
            }
            .onScrollGeometryChange(for: ScrollGeometry.self) { geometry in geometry } action: { _, geometry in
                self.visibleFrame = CGRect(origin: geometry.contentOffset, size: geometry.visibleRect.size)
                self.cellsVisibilityUpdate()
            }
    }

    @ViewBuilder private func GridView() -> some View {
        if let bounds = self.source.bounds {
            switch self.gridType {

                case .stacks: /* MARK: HStack + VStack */

                    VStack(spacing: self.cellSpacing) {
                        ForEach(bounds.minY ... bounds.maxY, id: \.self) { rowNum in HStack(spacing: self.cellSpacing) {
                        ForEach(bounds.minX ... bounds.maxX, id: \.self) { colNum in
                            let rowNum = CellID.Index(rowNum)
                            let colNum = CellID.Index(colNum)
                            if var cell = self.source[rowNum, colNum] {
                                let _ = { cell.isVisible = self.cellsVisibility.contains(cell.ID) }()
                                AnyView(cell)
                                    .hoverBehavior(.zIndex(to: 1))
                                    .id(cell.ID)
                            } else {
                                Color.clear
                                    .frame(width: self.cellSize, height: self.cellSize)
                            }
                        }}}
                    }.padding(self.cellSpacing)

                case .grid: /* MARK: Grid */

                    Grid(alignment: .center, horizontalSpacing: self.cellSpacing, verticalSpacing: self.cellSpacing) {
                        ForEach(bounds.minY ... bounds.maxY, id: \.self) { rowNum in GridRow {
                        ForEach(bounds.minX ... bounds.maxX, id: \.self) { colNum in
                            let rowNum = CellID.Index(rowNum)
                            let colNum = CellID.Index(colNum)
                            if var cell = self.source[rowNum, colNum] {
                                let _ = { cell.isVisible = self.cellsVisibility.contains(cell.ID) }()
                                AnyView(cell)
                                    .hoverBehavior(.zIndex(to: 1))
                                    .id(cell.ID)
                            } else {
                                Color.clear
                                    .frame(width: self.cellSize, height: self.cellSize)
                            }
                        }}}
                    }.padding(self.cellSpacing)

                case .lazyVGrid: /* MARK: LazyVGrid */
                    let columns: [GridItem] = (bounds.minX ... bounds.maxX).map { _ in
                        GridItem(.fixed(self.cellSize), spacing: self.cellSpacing)
                    }
                    LazyVGrid(columns: columns, spacing: self.cellSpacing) {
                        ForEach(bounds.minY ... bounds.maxY, id: \.self) { rowNum in
                        ForEach(bounds.minX ... bounds.maxX, id: \.self) { colNum in
                            let rowNum = CellID.Index(rowNum)
                            let colNum = CellID.Index(colNum)
                            if var cell = self.source[rowNum, colNum] {
                                let _ = { cell.isVisible = self.cellsVisibility.contains(cell.ID) }()
                                AnyView(cell)
                                    .id(cell.ID)
                            } else {
                                Color.clear
                                    .frame(width: self.cellSize, height: self.cellSize)
                            }
                        }}
                    }.padding(self.cellSpacing)
            }

        } else {
            Text("no items")
        }
    }

    private func cellsVisibilityUpdate() {
        self.cellsVisibilityDelayTimer?.stopAndReset()
        self.cellsVisibilityDelayTimer = Timer.Custom(
            repeats: .count(1),
            delay: 0.1,
            onExpire: { _ in
                self.cellsVisibility.removeAll()
                for (cellIDValue, cellFrame) in self.cellsFrame {
                    if (cellFrame.intersects(self.visibleFrame)) {
                        self.cellsVisibility.insert(cellIDValue)
                    }
                }
            }
        )
    }

    private func makeSticky() {
        self.stickyGridDelayTimer?.stopAndReset()
        self.stickyGridTimer?.stopAndReset()
        if (self.scrollPhase == .idle) {
            self.stickyGridDelayTimer = Timer.Custom(
                repeats: .count(1),
                delay: 0.4,
                onExpire: { _ in
                    let cellFrameSize = self.cellSize + self.cellSpacing
                    let fromX = self.visibleFrame.minX
                    let fromY = self.visibleFrame.minY
                    let toX = (fromX / cellFrameSize).rounded() * cellFrameSize
                    let toY = (fromY / cellFrameSize).rounded() * cellFrameSize
                    if (toX != fromX || toY != fromY) {
                        let stepsCount: UInt = 5
                        let stepX = (toX - fromX) / CGFloat(stepsCount)
                        let stepY = (toY - fromY) / CGFloat(stepsCount)
                        self.stickyGridTimer = Timer.Custom(
                            repeats: .count(stepsCount),
                            delay: 0.01,
                            onTick: { timer in
                                Task {
                                    self.scrollPosition.scrollTo(
                                        x: fromX + (CGFloat(timer.i + 1) * stepX),
                                        y: fromY + (CGFloat(timer.i + 1) * stepY),
                                    )
                                }
                            }
                        )
                    }
                }
            )
        }
    }

}

#Preview {
    let colsCount = 30
    let rowsCount = 30
    let cellSize: CGFloat = 100
    let cellSpacing: CGFloat = 20
    let source: GridCustom.DataSource = {
        var result = GridCustom.DataSource()
        for rowNum in 0 ..< rowsCount {
        for colNum in 0 ..< colsCount {
            let rowNum = CellID.Index(rowNum)
            let colNum = CellID.Index(colNum)
            let cellID = CellID(rowNum: rowNum, colNum: colNum)
            result[rowNum, colNum] = Cell_viewMode(
                ID: cellID.value,
                size: cellSize
            )
        }}
        return result
    }()
    GridCustom(
        data: source,
        cellSize: cellSize,
        cellSpacing: cellSpacing,
        isSticky: true
    )
    .frame(
        width : (cellSize * 3) + (cellSpacing * 4),
        height: (cellSize * 3) + (cellSpacing * 4)
    )
}
