
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import CoreGraphics

extension CGRect {

    static private let ENCODING_SEPARATOR = "|"

    init?(decode from: String) {
        let parts = from.split(separator: Self.ENCODING_SEPARATOR)
        guard parts.count == 4,
              let x = Double(parts[0]),
              let y = Double(parts[1]),
              let w = Double(parts[2]),
              let h = Double(parts[3]) else { return nil }
        self.init(x: x, y: y, width: w, height: h)
    }

    public func encode() -> String {
        "\(self.minX  )" + Self.ENCODING_SEPARATOR +
        "\(self.minY  )" + Self.ENCODING_SEPARATOR +
        "\(self.width )" + Self.ENCODING_SEPARATOR +
        "\(self.height)"
    }

}
