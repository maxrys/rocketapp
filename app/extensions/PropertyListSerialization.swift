
/* ################################################################## */
/* ### Copyright © 2024—2026 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

extension PropertyListSerialization {

    static func dataGet(fileName: String) -> Any {
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        return try! Self.propertyList(
            from: data,
            options: .mutableContainers,
            format: nil
        )
    }

}
