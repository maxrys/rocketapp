
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import UniformTypeIdentifiers

final class AppDragValue: NSObject, Codable, NSItemProviderWriting, NSItemProviderReading {

    static var writableTypeIdentifiersForItemProvider: [String] { [UTType.appDragValue.identifier] }
    static var readableTypeIdentifiersForItemProvider: [String] { [UTType.appDragValue.identifier] }

    enum Position: Codable {
        case `main_#0`
        case `mini_#1`
        case `mini_#2`
        case `mini_#3`
        case `mini_#4`
    }

    var ID: CellID.Value
    var position: Position

    var keyPathResolve: CellValuePath? {
        switch self.position {
            case .`mini_#1`: return \.cell1
            case .`mini_#2`: return \.cell2
            case .`mini_#3`: return \.cell3
            case .`mini_#4`: return \.cell4
            default        : return nil
        }
    }

    init(ID: CellID.Value, keyPath: CellValuePath? = nil) {
        self.ID = ID
        switch keyPath {
            case \.cell1: self.position = .`mini_#1`
            case \.cell2: self.position = .`mini_#2`
            case \.cell3: self.position = .`mini_#3`
            case \.cell4: self.position = .`mini_#4`
            default     : self.position = .`main_#0`
        }
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, (any Error)?) -> Void) -> Progress? {
        do {
            let data = try JSONEncoder().encode(self)
            completionHandler(data, nil)
        } catch { completionHandler(nil, error) }
        return nil
    }

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }

}
