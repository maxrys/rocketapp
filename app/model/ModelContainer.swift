
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import os
import AppKit
import SwiftData

extension ModelContainer {

    static var shared: ModelContainer! = {
        let schema = Schema([
            ModelCell.self,
            ModelProfile.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            let alert = NSAlert()
            alert.messageText = "The application will be force closed."
            alert.informativeText = "The database schema is outdated.\n\nTo solve the problem please delete the directory manually:\n" + ThisApp.CONTAINER_PATH
            alert.alertStyle = .critical
            alert.addButton(withTitle: "ОК")
            alert.runModal()
            Logger.customLog("Error: \(error)")
            NSApp.terminate(nil)
            return nil
        }
    }()

}
