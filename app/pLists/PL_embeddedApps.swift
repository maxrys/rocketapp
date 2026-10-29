
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

final class PL_embeddedApps {

    static private let PROPERTY_SOURCE = "embeddedApps"
    static private var cachePropertyListData: NSDictionary?

    static private func propertyListDataGet() -> NSDictionary {
        if let cache = cachePropertyListData { return cache }
        let cache = PropertyListSerialization.dataGet(fileName: Self.PROPERTY_SOURCE) as! NSDictionary
        Self.cachePropertyListData = cache
        return cache
    }

    static func selectList() -> [String: String] {
        Self.propertyListDataGet().reduce(into: [String: String]()) { result, item in
            result[item.key as! String] = (item.value as! String)
        }
    }

}
