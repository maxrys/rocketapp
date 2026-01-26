
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import Foundation

struct ColorHSBValue: Equatable, Codable {

    public var hue: Double
    public var saturation: Double
    public var brightness: Double
    public var opacity: Double

    public var isTinted: Bool {
        self.brightness < 0.5
    }

    init(_ hue: Double, _ saturation: Double, _ brightness: Double, _ opacity: Double = 1.0) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.opacity = opacity
    }

    init?(decode json: String) {
        do {
            guard let data = json.data(using: .utf8) else {
                return nil
            }
            self = try JSONDecoder().decode(
                Self.self,
                from: data
            )
        } catch {
            return nil
        }
    }

    func encode() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(
            data: data,
            encoding: .utf8
        )
    }

}
