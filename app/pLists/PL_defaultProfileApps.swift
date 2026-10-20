
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

final class PL_defaultProfileApps {

    struct ListItem {
        var rowNum: Int
        var colNum: Int
        var sector: Int
    }

    static private let PROPERTY_SOURCE = "defaultProfileApps"
    static private var cachePropertyListData: NSDictionary?

    static private func propertyListDataGet() -> NSDictionary {
        if let cache = cachePropertyListData { return cache }
        let cache = PropertyListSerialization.dataGet(fileName: Self.PROPERTY_SOURCE) as! NSDictionary
        Self.cachePropertyListData = cache
        return cache
    }

    static func selectList() -> [String: ListItem] {
        (Self.propertyListDataGet()).reduce(into: [String: ListItem]()) { result, item in
            let values = item.value as! NSDictionary
            result[item.key as! String] = ListItem(
                rowNum: values["rowNum"] as! Int,
                colNum: values["colNum"] as! Int,
                sector: values["sector"] as! Int
            )
        }
    }

}
