
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct GridCustom: View {

    typealias DataSource = [
        GridAxisIndex: [GridAxisIndex: any CellProtocol]
    ]

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
    @State private var cellsVisibility: [CellID.Value: Bool] = [:]

    private let source: DataSource
    private let colsCount: GridCellsByAxisCount
    private let rowsCount: GridCellsByAxisCount
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
        self.rowsCount = GridCellsByAxisCount(self.source             .count.fixBounds(max: Int(GridCellsByAxisCount.max))     )
        self.colsCount = GridCellsByAxisCount(self.source.first?.value.count.fixBounds(max: Int(GridCellsByAxisCount.max)) ?? 0)
        self.cellSize = cellSize
        self.cellSpacing = cellSpacing
        self.isSticky = isSticky
        self.gridType = gridType
    }

    private var gridBounds: CGSize {
        let colsCount = CGFloat(self.colsCount)
        let rowsCount = CGFloat(self.rowsCount)
        let gridSizeW = (self.cellSize * colsCount) + (self.cellSpacing * (colsCount + 1))
        let gridSizeH = (self.cellSize * rowsCount) + (self.cellSpacing * (rowsCount + 1))
        return CGSize(width: gridSizeW, height: gridSizeH)
    }

    private var cellsFrame: [CellID.Value: CGRect] {
        var result: [CellID.Value: CGRect] = [:]
        for rowNum in 0 ..< self.rowsCount {
        for colNum in 0 ..< self.colsCount {
            let cellID = CellID(rowNum: rowNum, colNum: colNum).value
            let colNum = CGFloat(colNum)
            let rowNum = CGFloat(rowNum)
            let cellFrameMinX = (self.cellSize * colNum) + (self.cellSpacing * (colNum + 1))
            let cellFrameMinY = (self.cellSize * rowNum) + (self.cellSpacing * (rowNum + 1))
            result[cellID] = CGRect(
                x     : cellFrameMinX,
                y     : cellFrameMinY,
                width : self.cellSize,
                height: self.cellSize
            )
        }}
        return result
    }

    public var body: some View {

        let isScrollDisabled: Bool = {
            let gridBounds = self.gridBounds;
            return gridBounds.width  < self.visibleFrame.size.width &&
                   gridBounds.height < self.visibleFrame.size.height
        }()

        ScrollView([.horizontal, .vertical]) { self.grid }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollDisabled(isScrollDisabled)
            .scrollPosition(self.$scrollPosition)
            .onScrollPhaseChange { oldPhase, newPhase, context in
                if (oldPhase != newPhase) {
                    self.scrollPhase = newPhase
                    self.visibleFrame = CGRect(origin: context.geometry.contentOffset, size: context.geometry.visibleRect.size)
                    self.cellsVisibilityUpdate()
                    if (self.isSticky) {
                        self.makeSticky()
                    }
                }
            }
            .onGeometryChange(for: CGSize.self) { geometry in geometry.size } action: { size in
                self.visibleFrame.size = size
                self.cellsVisibilityUpdate()
            }
    }

    @ViewBuilder private var grid: some View {
        switch self.gridType {

            case .stacks: /* MARK: HStack + VStack */

                VStack(spacing: self.cellSpacing) {
                    ForEach(0 ..< self.rowsCount, id: \.self) { rowNum in HStack(spacing: self.cellSpacing) {
                    ForEach(0 ..< self.colsCount, id: \.self) { colNum in
                        if var cell = self.source[rowNum]?[colNum] {
                            let _ = { cell.isVisible = self.cellsVisibility[cell.ID] ?? false }()
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
                    ForEach(0 ..< self.rowsCount, id: \.self) { rowNum in GridRow {
                    ForEach(0 ..< self.colsCount, id: \.self) { colNum in
                        if var cell = self.source[rowNum]?[colNum] {
                            let _ = { cell.isVisible = self.cellsVisibility[cell.ID] ?? false }()
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

                let columns: [GridItem] = (0 ..< self.colsCount).map { _ in
                    GridItem(.fixed(self.cellSize), spacing: self.cellSpacing)
                }
                LazyVGrid(columns: columns, spacing: self.cellSpacing) {
                    ForEach(0 ..< self.rowsCount, id: \.self) { rowNum in
                    ForEach(0 ..< self.colsCount, id: \.self) { colNum in
                        if var cell = self.source[rowNum]?[colNum] {
                            let _ = { cell.isVisible = self.cellsVisibility[cell.ID] ?? false }()
                            AnyView(cell)
                                .hoverBehavior(.zIndex(to: 1))
                                .id(cell.ID)
                        } else {
                            Color.clear
                                .frame(width: self.cellSize, height: self.cellSize)
                        }
                    }}
                }.padding(self.cellSpacing)

        }
    }

    private func cellsVisibilityUpdate() {
        self.cellsVisibilityDelayTimer?.stopAndReset()
        if (self.scrollPhase == .idle) {
            self.cellsVisibilityDelayTimer = Timer.Custom(
                count: 1,
                interval: 0.1,
                onExpire: {
                    for (cellID, cellFrame) in self.cellsFrame {
                        self.cellsVisibility[cellID] = self.visibleFrame.intersects(cellFrame)
                    }
                }
            )
        }
    }

    private func makeSticky() {
        self.stickyGridDelayTimer?.stopAndReset()
        self.stickyGridTimer?.stopAndReset()
        if (self.scrollPhase == .idle) {
            self.stickyGridDelayTimer = Timer.Custom(
                count: 1,
                interval: 0.4,
                onExpire: {
                    let cellFrameSize = self.cellSize + self.cellSpacing
                    let toX = (self.visibleFrame.minX / cellFrameSize).rounded() * cellFrameSize
                    let toY = (self.visibleFrame.minY / cellFrameSize).rounded() * cellFrameSize
                    if (toX != self.visibleFrame.minX || toY != self.visibleFrame.minY) {
                        let stepsCount: UInt16 = 10
                        let stepX = (toX - self.visibleFrame.minX) / CGFloat(stepsCount)
                        let stepY = (toY - self.visibleFrame.minY) / CGFloat(stepsCount)
                        self.stickyGridTimer = Timer.Custom(
                            count: stepsCount,
                            interval: 0.01,
                            onTick: { i in
                                Task {
                                    self.scrollPosition.scrollTo(
                                        x: self.visibleFrame.minX + (CGFloat(i) * stepX),
                                        y: self.visibleFrame.minY + (CGFloat(i) * stepY)
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
    let colsCount: GridCellsByAxisCount = 30
    let rowsCount: GridCellsByAxisCount = 30
    let cellSize: CGFloat = 100
    let cellSpacing: CGFloat = 20
    let source: GridCustom.DataSource = {
        var result: GridCustom.DataSource = [:]
        for rowNum in 0 ..< rowsCount {
        for colNum in 0 ..< colsCount {
            if (result[rowNum] == nil) { result[rowNum] = [:] }
            let cellID = CellID(rowNum: rowNum, colNum: colNum).value
            result[rowNum]![colNum] = Cell_viewMode(
                ID: cellID,
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
