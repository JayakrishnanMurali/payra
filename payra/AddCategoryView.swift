import SwiftUI

struct AddCategoryView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedIcon = "circle.fill"
    @State private var selectedColor = "#FF6B6B"
    @State private var budgetLimit: String = ""
    
    private let icons = [
        "fork.knife", "car.fill", "bag.fill", "gamecontroller.fill", "heart.fill",
        "bolt.fill", "house.fill", "book.fill", "airplane", "person.fill",
        "cart.fill", "gift.fill", "medical.fill", "pills.fill", "cross.fill",
        "leaf.fill", "pawprint.fill", "star.fill", "crown.fill", "diamond.fill"
    ]
    
    private let colors = [
        "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7",
        "#DDA0DD", "#98D8C8", "#F7DC6F", "#BB8FCE", "#85C1E9",
        "#F39C12", "#E74C3C", "#9B59B6", "#3498DB", "#1ABC9C"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Category Details") {
                    TextField("Category name", text: $name)
                    
                    HStack {
                        Text("Budget limit (optional)")
                            .font(.payraBodyMedium)
                        
                        Spacer()
                        
                        TextField("0", text: $budgetLimit)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Icon") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: .payraSpacingMD) {
                        ForEach(icons, id: \.self) { icon in
                            Button(action: { selectedIcon = icon }) {
                                Image(systemName: icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(selectedIcon == icon ? .payraBackground : .payraIcon)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(selectedIcon == icon ? Color.payraPrimary : Color.payraSurface)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, .payraSpacingSM)
                }
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: .payraSpacingMD) {
                        ForEach(colors, id: \.self) { color in
                            Button(action: { selectedColor = color }) {
                                Circle()
                                    .fill(Color(hex: color))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.payraPrimary : Color.clear, lineWidth: 3)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, .payraSpacingSM)
                }
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCategory()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveCategory() {
        let budget = Double(budgetLimit) ?? 0
        
        _ = coreDataManager.createCategory(
            name: name,
            budgetLimit: budget > 0 ? budget : nil,
            colorHex: selectedColor,
            iconName: selectedIcon
        )
        
        dismiss()
    }
}

#Preview {
    AddCategoryView()
} 