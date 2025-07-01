import SwiftUI

struct SettingsView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var user: User?
    @State private var categories: [Category] = []
    @State private var showingAddCategory = false
    
    var body: some View {
        NavigationView {
            List {
                // User Profile Section
                Section("Profile") {
                    if let user = user {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.payraPrimary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.email ?? "Local User")
                                    .font(.payraBodyLarge)
                                    .foregroundColor(.payraTextPrimary)
                                
                                Text("Monthly Income: $\(user.monthlyIncome, specifier: "%.2f")")
                                    .font(.payraBodySmall)
                                    .foregroundColor(.payraTextSecondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, .payraSpacingSM)
                    }
                }
                
                // Security Section
                Section("Security") {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.payraIcon)
                            .frame(width: 24)
                        
                        Text("Use Face ID / Touch ID")
                            .font(.payraBodyMedium)
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { user?.usesBiometry ?? false },
                            set: { newValue in
                                user?.usesBiometry = newValue
                                coreDataManager.save()
                            }
                        ))
                    }
                }
                
                // Categories Section
                Section("Categories") {
                    ForEach(categories, id: \.id) { category in
                        HStack {
                            Image(systemName: category.iconName ?? "circle.fill")
                                .foregroundColor(Color(hex: category.colorHex ?? "#000000"))
                                .frame(width: 24)
                            
                            Text(category.name ?? "")
                                .font(.payraBodyMedium)
                            
                            Spacer()
                            
                            if category.budgetLimit > 0 {
                                Text("$\(category.budgetLimit, specifier: "%.0f")")
                                    .font(.payraBodySmall)
                                    .foregroundColor(.payraTextSecondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteCategories)
                    
                    Button(action: { showingAddCategory = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.payraPrimary)
                            
                            Text("Add Category")
                                .font(.payraBodyMedium)
                                .foregroundColor(.payraPrimary)
                        }
                    }
                }
                
                // Data Management Section
                Section("Data") {
                    Button(action: exportData) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.payraIcon)
                                .frame(width: 24)
                            
                            Text("Export Data")
                                .font(.payraBodyMedium)
                                .foregroundColor(.payraTextPrimary)
                        }
                    }
                    
                    Button(action: importData) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.payraIcon)
                                .frame(width: 24)
                            
                            Text("Import CSV")
                                .font(.payraBodyMedium)
                                .foregroundColor(.payraTextPrimary)
                        }
                    }
                }
                
                // App Info Section
                Section("App Info") {
                    HStack {
                        Text("Version")
                            .font(.payraBodyMedium)
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.payraBodySmall)
                            .foregroundColor(.payraTextSecondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAddCategory) {
                AddCategoryView()
            }
            .onAppear {
                loadData()
            }
        }
    }
    
    private func loadData() {
        user = coreDataManager.fetchUser()
        categories = coreDataManager.fetchCategories()
    }
    
    private func deleteCategories(offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            coreDataManager.context.delete(category)
        }
        coreDataManager.save()
        loadData()
    }
    
    private func exportData() {
        // TODO: Implement data export functionality
    }
    
    private func importData() {
        // TODO: Implement CSV import functionality
    }
}

#Preview {
    SettingsView()
} 