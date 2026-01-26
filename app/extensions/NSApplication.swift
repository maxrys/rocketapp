
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import AppKit

extension NSApplication {

    static func open(_ appURL: URL) {
        NSWorkspace.shared.openApplication(at: appURL, configuration: NSWorkspace.OpenConfiguration()) { (app, error) in
            if let error = error {
                Logger.customLog("Error: \(error.localizedDescription)")
            }
        }
    }

}
