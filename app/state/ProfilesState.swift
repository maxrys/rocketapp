
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import SwiftUI
import SwiftData

@Observable final class ProfilesState {

    public var current: ProfileValue {
        self.cache[self.currentID]!
    }

    private var currentID: ProfileID!
    private var cache: [
        ProfileID: ProfileValue
    ] = [:]

    @ObservationIgnored var maxID: ProfileID {
        self.cache.reduce(into: ProfileID()) { (result, item) in
            result = max(result, item.value.ID)
        }
    }

    @ObservationIgnored var newID: ProfileID {
        self.maxID + 1
    }

    @ObservationIgnored var isEmpty: Bool {
        self.cache.isEmpty
    }

    @ObservationIgnored var list: [ProfileID: ProfileTitle] {
        self.cache.reduce(into: [ProfileID: ProfileTitle]()) { (result, item) in
            if (item.value.ID == ThisApp.EMBEDDED_PROFILE_ID && item.value.title.isEmpty != true) { result[item.value.ID] = "\(item.value.title)°" }
            if (item.value.ID != ThisApp.EMBEDDED_PROFILE_ID && item.value.title.isEmpty != true) { result[item.value.ID] = "\(item.value.title)" }
            if (item.value.ID == ThisApp.EMBEDDED_PROFILE_ID && item.value.title.isEmpty == true) { result[item.value.ID] = "ID: \(item.value.ID)°" }
            if (item.value.ID != ThisApp.EMBEDDED_PROFILE_ID && item.value.title.isEmpty == true) { result[item.value.ID] = "ID: \(item.value.ID)" }
        }
    }

    static let shared = ProfilesState()

    private init() {
        self.cache = ProfileValue.modelSelectAll()
        self.findAntActivateAvailableProfile()
    }

    private func findAntActivateAvailableProfile() {

        /* load the last used profileID */

        if let profileID = UserDefaults.standard.object(forKey: "profileID") as? ProfileID {
            if let profile = self.cache[profileID] {
                _ = self.setCurrent(profile.ID, withDefaults: false)
                Logger.customLog("The profile (ID: \(profile.ID)) from UserDefaults was loaded.")
                return
            }
        }

        /* load embedded profile */

        if (!self.isEmpty) {
            if let profile = self.cache[ThisApp.EMBEDDED_PROFILE_ID] {
                _ = self.setCurrent(profile.ID)
                Logger.customLog("The embedded profile (ID: \(profile.ID)) was loaded.")
                return
            }
        }

        /* load first profile */

        if (!self.isEmpty) {
            if let profile = self.cache.sortedBy(order: .valueAsc).first?.value {
                _ = self.setCurrent(profile.ID)
                Logger.customLog("The first profile (ID: \(profile.ID)) was loaded.")
                return
            }
        }

        /* seed and load embedded profile */

        if (self.insert(ProfileValue.embeddedProfile)) {
            Logger.customLog("The profile (ID: \(ProfileValue.embeddedProfile.ID)) has been created.")
            if (self.setCurrent(ProfileValue.embeddedProfile.ID)) {
                Logger.customLog("The profile (ID: \(ProfileValue.embeddedProfile.ID)) was loaded.")
            } else { fatalError("Unable to activate profile!") }
        }     else { fatalError("Unable to seed profile!") }
    }

    func setCurrent(_ ID: ProfileID, withDefaults: Bool = true) -> Bool {
        if let _ = self.cache[ID] {
            if (withDefaults) {
                UserDefaults.standard.set(ID, forKey: "profileID")
                Logger.customLog("The profile (ID: \(ID)) has been added to UserDefaults.")
            }
            self.currentID = ID
            return true
        }
        return false
    }

    func select(_ ID: ProfileID) -> ProfileValue? {
        self.cache[ID]
    }

    func insert(_ profile: ProfileValue) -> Bool {
        let result = profile.modelInsert()
        if (result) {
            self.cache[profile.ID] = profile
            return true
        }
        return false
    }

    func delete(_ ID: ProfileID) -> ProfileID? {
        let result = ProfileValue.modelDelete(ID)
        if (result) {
            self.cache[ID] = nil
            Logger.customLog("The profile (ID: \(ID)) has been deleted.")
            self.findAntActivateAvailableProfile()
            return self.currentID
        }
        return nil
    }

}
