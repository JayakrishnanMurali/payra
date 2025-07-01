import SwiftUI
import UIKit

struct MainTabView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            TransactionsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Transactions")
                }
                .tag(1)
            
            GoalsView()
                .tabItem {
                    Image(systemName: "target")
                    Text("Goals")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.payraPrimary)
        .onAppear {
            // Set tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.payraBackground)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
} 