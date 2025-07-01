//
//  ContentView.swift
//  payra
//
//  Created by Jayakrishnan M on 01/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var user: User?
    
    var body: some View {
        Group {
            if let user = user, user.isOnboarded {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            user = coreDataManager.fetchUser()
        }
    }
}

#Preview {
    ContentView()
}
