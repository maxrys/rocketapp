
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import AppKit

extension NSImage {

    var pixelData: Data? {
        if let tiffData = self.tiffRepresentation {
            if let bitmap = NSBitmapImageRep(data: tiffData) {
                if let bitmapData = bitmap.bitmapData {
                    return Data(
                        bytes: bitmapData,
                        count: bitmap.bytesPerRow * bitmap.pixelsHigh
                    )
                }
            }
        }
        return nil
    }

    static func == (lhs: NSImage, rhs: NSImage) -> Bool {
        if let lhsData = lhs.pixelData,
           let rhsData = rhs.pixelData { return lhsData == rhsData }
        return false
    }

}
