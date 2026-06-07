
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import CoreGraphics

extension CGRect {

    static private let ENCODING_SEPARATOR = "|"

    init(x: Double, y: Double, w: Double, h: Double) {
        self.init(x: x, y: y, width: w, height: h)
    }

    init?(decode from: String) {
        let parts = from.split(separator: Self.ENCODING_SEPARATOR)
        guard parts.count == 4,
              let x = Double(parts[0]),
              let y = Double(parts[1]),
              let w = Double(parts[2]),
              let h = Double(parts[3]) else { return nil }
        self.init(x: x, y: y, w: w, h: h)
    }

    var x: Double { get { self.minX   } set { self = Self(x: newValue, y: self.y  , width: self.w  , height: self.h  ) } }
    var y: Double { get { self.minY   } set { self = Self(x: self.x  , y: newValue, width: self.w  , height: self.h  ) } }
    var w: Double { get { self.width  } set { self = Self(x: self.x  , y: self.y  , width: newValue, height: self.h  ) } }
    var h: Double { get { self.height } set { self = Self(x: self.x  , y: self.y  , width: self.w  , height: newValue) } }

    public func encode() -> String {
        "\(self.x)" + Self.ENCODING_SEPARATOR +
        "\(self.y)" + Self.ENCODING_SEPARATOR +
        "\(self.w)" + Self.ENCODING_SEPARATOR +
        "\(self.h)"
    }

}
