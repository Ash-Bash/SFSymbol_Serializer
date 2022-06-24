//
//  SFSymbols_SerializerApp.swift
//  SFSymbols Serializer
//
//  Created by Ashley Chapman on 20/06/2022.
//

import SwiftUI

@main
struct SFSymbolsSerializerApp: App {
    
    // Variables
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
