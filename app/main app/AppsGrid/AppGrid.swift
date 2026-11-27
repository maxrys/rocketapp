
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct AppGrid: View, BackgroundColorProtocol {

    enum FocusedScene: Hashable {
        case vmGrid
        case emGrid
    }

    static var SCENE_FRAME_DEFAULT = CGRect(
        minX: 0,
        minY: 0,
        maxX: CGFloat(ThisApp.CELL_SIZE_DEFAULT),
        maxY: CGFloat(ThisApp.CELL_SIZE_DEFAULT)
    )

    @Environment(\.colorScheme)          internal var colorScheme
    @Environment(\.windowBackground)     internal var background
    @Environment(\.windowBackgroundDark) internal var backgroundDark
    @Environment(\.profilesState)        internal var profiles
    @Environment(\.cellsState)           internal var cells
    @Environment(\.isEditMode)           internal var isEditMode

    @FocusState private var focusedScene: FocusedScene?

    @State private var sceneFrame = ValueState<CGRect>(Self.SCENE_FRAME_DEFAULT)
    @State private var isIdle: Bool = true
    @State private var vmGrid: VMGrid!
    @State private var emGrid: EMGrid!
    @State private var hasAppeared = false

    private var gridInfo: GridInfo

    init(gridInfo: GridInfo) {
        self.gridInfo = gridInfo
        self._vmGrid = State(
            initialValue: .init(
                info: gridInfo,
                sceneFrame: self.sceneFrame
            )
        )
        self._emGrid = State(
            initialValue: .init(
                info: gridInfo,
                sceneFrame: self.sceneFrame
            )
        )
    }

    public var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            ZStack {
                self.vmGrid.zIndex(self.isEditMode.value ? 0 : 1).opacity(self.isEditMode.value ? 0.0 : 1.0).focusable().focused(self.$focusedScene, equals: .vmGrid)
                self.emGrid.zIndex(self.isEditMode.value ? 1 : 0).opacity(self.isEditMode.value ? 1.0 : 0.0).focusable().focused(self.$focusedScene, equals: .emGrid)
            }
        }
        .onScrollPhaseChange { oldPhase, newPhase in
            if (newPhase != oldPhase) {
                if (newPhase == .idle && self.isIdle != true) { self.isIdle.toggle() }
                if (newPhase != .idle && self.isIdle == true) { self.isIdle.toggle() }
            }
        }
        .onChange(of: self.profiles.current.cellSize       ) { _, value in self.onChangeCellSize(value) }
        .onChange(of: self.profiles.current.cellSpacing    ) { _, value in self.onChangeCellSpacing(value) }
        .onChange(of: self.profiles.current.iconOnHoverZoom) { _, value in self.onChangeIconOnHoverZoom(value) }
        .onChange(of: self.profiles.current.isShowIconTitle) { _, value in self.onChangeIsShowIconTitle(value) }
        .onChange(of: self.background                      ) { _, _ in if (self.colorScheme != .dark) { self.onChangeBackground() } }
        .onChange(of: self.backgroundDark                  ) { _, _ in if (self.colorScheme == .dark) { self.onChangeBackground() } }
        .onChange(of: self.colorScheme                     ) { _, _ in                                  self.onChangeBackground()   }
        .onChange(of: self.cells.data) { oldState, newState in
            self.onChangeData(oldState, newState)
        }
        .onChange(of: self.isEditMode.value) { _, isEditMode in
            if (isEditMode)
                 { self.focusedScene = .emGrid }
            else { self.focusedScene = .vmGrid }
            self.updateSceneFrame()
        }
        .task {
            if (self.isEditMode.value)
                 { self.focusedScene = .emGrid }
            else { self.focusedScene = .vmGrid }
            self.updateSceneFrame()
            self.onFirstLaunch()
        }
    }

    private func updateSceneFrame() {
        if (self.isEditMode.value) {
            self.sceneFrame.value = .init(
                origin: .zero,
                size: self.gridInfo.sceneSize
            )
        } else {
            if let bound = self.cells.data.bounds {
                let pointLT = self.gridInfo.addressToPoint(CellAddressValue(rowNum: bound.minRow, colNum: bound.minCol, sector: 0))
                let pointRB = self.gridInfo.addressToPoint(CellAddressValue(rowNum: bound.maxRow, colNum: bound.maxCol, sector: 0))
                let padding = CGFloat(self.gridInfo.cellSize / 2 + self.gridInfo.gridPadding)
                self.sceneFrame.value = CGRect(
                    minX: pointLT.x - padding,
                    minY: pointLT.y + padding,
                    maxX: pointRB.x + padding,
                    maxY: pointRB.y - padding
                )
            } else {
                self.sceneFrame.value = Self.SCENE_FRAME_DEFAULT
            }
        }
    }

    private func onFirstLaunch() {
        guard !self.hasAppeared else { return }
        self.hasAppeared = true
        for (cellID, cellValue) in self.cells.data {
            self.vmGrid?.scene.renderCell(cellID, value: cellValue)
            self.emGrid?.scene.renderCell(cellID, value: cellValue)
        }
        self.onChangeBackground()
    }

    private func onChangeData(_ oldState: CellsDataSource, _ newState: CellsDataSource) {
        for cellID in oldState.differences(with: newState) {
            self.vmGrid?.scene.renderCell(cellID, value: newState[cellID])
            self.emGrid?.scene.renderCell(cellID, value: newState[cellID])
        }
    }

    private func onChangeCellSize(_ value: UInt) {
        self.gridInfo.cellSize = value
        self.updateSceneFrame()
        self.vmGrid?.scene.onChangeCellSize(value)
        self.emGrid?.scene.onChangeCellSize(value)
    }

    private func onChangeCellSpacing(_ value: UInt) {
        self.gridInfo.cellSpacing = value
        self.updateSceneFrame()
        self.vmGrid?.scene.onChangeCellSpacing(value)
        self.emGrid?.scene.onChangeCellSpacing(value)
    }

    private func onChangeIconOnHoverZoom(_ value: Decimal) {
        self.gridInfo.iconOnHoverZoom = value
        self.vmGrid?.scene.onChangeIconOnHoverZoom(value)
        self.emGrid?.scene.onChangeIconOnHoverZoom(value)
    }

    private func onChangeIsShowIconTitle(_ value: Bool) {
        self.gridInfo.isShowIconTitle = value
        self.vmGrid?.scene.onChangeIsShowIconTitle(value)
        self.emGrid?.scene.onChangeIsShowIconTitle(value)
    }

    private func onChangeBackground() {
        self.gridInfo.background = self.backgroundCurrent()
        self.vmGrid?.scene.onChangeBackground(self.backgroundCurrent())
        self.emGrid?.scene.onChangeBackground(self.backgroundCurrent())
    }

}
