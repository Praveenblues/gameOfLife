//
//  GameOfLifeApp.swift
//  GameOfLife
//
//  Created by Praveen V on 10/05/25.
//

import SwiftUI

@main
struct GameOfLifeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
