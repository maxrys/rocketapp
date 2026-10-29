
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

final class PL_defaultProfileApps {

    static private let PROPERTY_SOURCE = "defaultProfileApps"
    static private var cachePropertyListData: NSDictionary?

    static private func propertyListDataGet() -> NSDictionary {
        if let cache = cachePropertyListData { return cache }
        let cache = PropertyListSerialization.dataGet(fileName: Self.PROPERTY_SOURCE) as! NSDictionary
        Self.cachePropertyListData = cache
        return cache
    }

    static func selectList() -> [BundleID: GridPlaceIDValue] {
        (Self.propertyListDataGet()).reduce(into: [BundleID: GridPlaceIDValue]()) { result, item in
            let values = item.value as! NSDictionary
            result[item.key as! BundleID] = GridPlaceIDValue(
                rowNum: values["rowNum"] as! GridPlaceIDValue.Index,
                colNum: values["colNum"] as! GridPlaceIDValue.Index,
                sector: values["sector"] as! GridPlaceIDValue.Index
            )
        }
    }

}
