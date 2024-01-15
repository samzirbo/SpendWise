//
//  SpendWiseAppApp.swift
//  SpendWiseApp
//
//  Created by George Zirbo on 15.01.2024.
//

import SwiftUI
import SwiftData

@main
struct SpendWiseApp: App {
    var container: ModelContainer = {
        let schema = Schema([
            Transaction.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ListView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Transaction.self)
            print(URL.applicationSupportDirectory.path(percentEncoded: false))
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
}
