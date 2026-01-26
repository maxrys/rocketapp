
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import AppKit
import SwiftData

@Model final class ModelProfile {

    typealias SELF = ModelProfile

    static let modelTitle = "Profile"

    @Attribute(.unique)
    public var id: ProfileID
    public var title: ProfileTitle
    public var zoom: Decimal
    public var spacing: UInt
    public var iconOnHoverZoom: Decimal
    public var isShowIconTitle: Bool
    public var isHideOnMisclick: Bool
    public var isStickyGrid: Bool
    public var isShowWinTitleButtons: Bool
    public var background: String
    public var backgroundDark: String

    init(
        ID: ProfileID,
        title: ProfileTitle,
        zoom: Decimal,
        spacing: UInt,
        iconOnHoverZoom: Decimal,
        isShowIconTitle: Bool,
        isHideOnMisclick: Bool,
        isStickyGrid: Bool,
        isShowWinTitleButtons: Bool,
        background: String,
        backgroundDark: String
    ) {
        self.id = ID
        self.title = title
        self.zoom = zoom
        self.spacing = spacing
        self.iconOnHoverZoom = iconOnHoverZoom
        self.isShowIconTitle = isShowIconTitle
        self.isHideOnMisclick = isHideOnMisclick
        self.isStickyGrid = isStickyGrid
        self.isShowWinTitleButtons = isShowWinTitleButtons
        self.background = background
        self.backgroundDark = backgroundDark
    }

    private static func predicate(ID: ProfileID) -> Predicate<SELF> {
        #Predicate<SELF> { item in
            item.id == ID
        }
    }

    @MainActor static func select(ID: ProfileID) -> SELF? {
        do {
            let modelContext = ModelContainer.shared.mainContext
            let fetchRequest = FetchDescriptor<SELF>(predicate: self.predicate(ID: ID))
            return try modelContext.fetch(fetchRequest).first
        } catch {
            Logger.customLog("Select \(SELF.modelTitle) error: \(error.localizedDescription)")
        }
        return nil
    }

    @MainActor static func selectAll() -> [ProfileID: SELF] {
        var result: [ProfileID: SELF] = [:]
        let modelContext = ModelContainer.shared.mainContext
        let fetchRequest = FetchDescriptor<SELF>()
        if let items = try? modelContext.fetch(fetchRequest) {
            items.forEach { item in
                result[item.id] = item
            }
        }
        return result
    }

    @MainActor static func insert(_ item: SELF) -> Bool {
        do {
            let modelContext = ModelContainer.shared.mainContext
            let fetchRequest = FetchDescriptor<SELF>(predicate: self.predicate(ID: item.id))
            if try modelContext.fetch(fetchRequest).isEmpty {
                modelContext.insert(item)
                try modelContext.save()
                return true
            }
        } catch {
            Logger.customLog("Insert \(SELF.modelTitle) error: \(error.localizedDescription)")
        }
        return false
    }

    @MainActor static func update(_ item: SELF, autoInsert: Bool = false) -> Bool {
        do {
            let modelContext = ModelContainer.shared.mainContext
            let fetchRequest = FetchDescriptor<SELF>(predicate: self.predicate(ID: item.id))
            if let itemToUpdate = try modelContext.fetch(fetchRequest).first {
                itemToUpdate.title                 = item.title
                itemToUpdate.zoom                  = item.zoom
                itemToUpdate.spacing               = item.spacing
                itemToUpdate.iconOnHoverZoom       = item.iconOnHoverZoom
                itemToUpdate.isShowIconTitle       = item.isShowIconTitle
                itemToUpdate.isHideOnMisclick      = item.isHideOnMisclick
                itemToUpdate.isStickyGrid          = item.isStickyGrid
                itemToUpdate.isShowWinTitleButtons = item.isShowWinTitleButtons
                itemToUpdate.background            = item.background
                itemToUpdate.backgroundDark        = item.backgroundDark
                try modelContext.save()
                return true
            } else if (autoInsert) {
                return SELF.insert(item)
            }
        } catch {
            Logger.customLog("Update \(SELF.modelTitle) error: \(error.localizedDescription)")
        }
        return false
    }

    @MainActor static func delete(ID: ProfileID) -> Bool {
        do {
            let modelContext = ModelContainer.shared.mainContext
            try modelContext.delete(
                model: SELF.self,
                where: self.predicate(
                    ID: ID
                )
            )
            /* cascade */
            _ = ModelCell.delete(
                profileID: ID
            )
            return true
        } catch {
            Logger.customLog("Delete \(SELF.modelTitle) error: \(error.localizedDescription)")
        }
        return false
    }

}
