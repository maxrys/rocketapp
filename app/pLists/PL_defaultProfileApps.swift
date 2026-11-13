
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

    static func selectList() -> [BundleID: CellAddressValue] {
        (Self.propertyListDataGet()).reduce(into: [BundleID: CellAddressValue]()) { result, item in
            let values = item.value as! NSDictionary
            result[item.key as! BundleID] = CellAddressValue(
                rowNum: values["rowNum"] as! CellAddressValue.Index,
                colNum: values["colNum"] as! CellAddressValue.Index,
                sector: values["sector"] as! CellAddressValue.Index
            )
        }
    }

}
