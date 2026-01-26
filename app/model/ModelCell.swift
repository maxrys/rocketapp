
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import AppKit
import SwiftData

@Model final class ModelCell {

    typealias SELF = ModelCell

    static let modelTitle = "Cell"

    public var id: CellModelID.Value
    public var profileID: ProfileID
    public var bundleID: String
    public var name: String
    public var path: String
    @Attribute(.externalStorage)
    public var icon: Data?

    #Index<ModelCell>([\.id, \.profileID])

    init(
        ID: CellModelID.Value,
        profileID: ProfileID,
        bundleID: String,
        name: String,
        path: String,
        icon: Data?
    ) {
        self.id = ID
        self.profileID = profileID
        self.bundleID = bundleID
        self.name = name
        self.path = path
        self.icon = icon
    }

    private static func predicate(profileID: ProfileID) -> Predicate<SELF> {
        #Predicate<SELF> { item in
            item.profileID == profileID
        }
    }

    private static func predicate(ID: CellModelID.Value, profileID: ProfileID) -> Predicate<SELF> {
        #Predicate<SELF> { item in
            item.id        == ID &&
            item.profileID == profileID
        }
    }

    private static func predicate(IDs: [CellModelID.Value], profileID: ProfileID) -> Predicate<SELF> {
        #Predicate<SELF> { item in
            IDs.contains(item.id) && item.profileID == profileID
        }
    }

    @MainActor static func select(ID: CellModelID.Value, profileID: ProfileID) -> SELF? {
        do {
            let modelContext = ModelContainer.shared.mainContext
            let fetchRequest = FetchDescriptor<SELF>(predicate: self.predicate(ID: ID, profileID: profileID))
            return try modelContext.fetch(fetchRequest).first
        } catch {
            Logger.customLog("Select \(SELF.modelTitle) error: \(error.localizedDescription)")
        }
        return nil
    }

    @MainActor static func selectAll(profileID: ProfileID) -> [CellModelID.Value: SELF] {
        var result: [CellModelID.Value: SELF] = [:]
        let modelContext = ModelContainer.shared.mainContext
        let fetchRequest = FetchDescriptor<SELF>(predicate: self.predicate(profileID: profileID))
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
            let fetchRequest = FetchDescriptor<SELF>(predicate: self.predicate(ID: item.id, profileID: item.profileID))
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
            let fetchRequest = FetchDescriptor<SELF>(predicate: self.predicate(ID: item.id, profileID: item.profileID))
            if let itemToUpdate = try modelContext.fetch(fetchRequest).first {
                itemToUpdate.bundleID = item.bundleID
                itemToUpdate.name     = item.name
                itemToUpdate.path     = item.path
                itemToUpdate.icon     = item.icon
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

    @MainActor static func delete(profileID: ProfileID) -> Bool {
        do {
            let modelContext = ModelContainer.shared.mainContext
            try modelContext.delete(
                model: SELF.self,
                where: self.predicate(
                    profileID: profileID
                )
            )
            return true
        } catch {
            Logger.customLog("Delete \(SELF.modelTitle) error: \(error.localizedDescription)")
        }
        return false
    }

    @MainActor static func delete(ID: CellModelID.Value, profileID: ProfileID) -> Bool {
        do {
            let modelContext = ModelContainer.shared.mainContext
            try modelContext.delete(
                model: SELF.self,
                where: self.predicate(
                    ID: ID,
                    profileID: profileID
                )
            )
            return true
        } catch {
            Logger.customLog("Delete \(SELF.modelTitle) error: \(error.localizedDescription)")
        }
        return false
    }

    @MainActor static func delete(IDs: [CellModelID.Value], profileID: ProfileID) -> Bool {
        do {
            let modelContext = ModelContainer.shared.mainContext
            try modelContext.delete(
                model: SELF.self,
                where: self.predicate(
                    IDs: IDs,
                    profileID: profileID
                )
            )
            return true
        } catch {
            Logger.customLog("Delete \(SELF.modelTitle) error: \(error.localizedDescription)")
        }
        return false
    }

}
