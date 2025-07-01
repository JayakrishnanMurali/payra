//
//  payraApp.swift
//  payra
//
//  Created by Jayakrishnan M on 01/07/25.
//

import SwiftUI

@main
struct payraApp: App {
    @StateObject private var coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.context)
        }
    }
}
