import SwiftUI

struct AddGoalView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var targetAmount: String = ""
    @State private var hasDeadline = false
    @State private var deadline = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Goal Details") {
                    TextField("Goal name", text: $name)
                    
                    HStack {
                        Text("$")
                            .font(.payraBodyLarge)
                            .foregroundColor(.payraTextSecondary)
                        
                        TextField("0.00", text: $targetAmount)
                            .font(.payraBodyLarge)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("Deadline") {
                    Toggle("Set deadline", isOn: $hasDeadline)
                    
                    if hasDeadline {
                        DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGoal()
                    }
                    .disabled(name.isEmpty || targetAmount.isEmpty)
                }
            }
        }
    }
    
    private func saveGoal() {
        guard let amount = Double(targetAmount), !name.isEmpty else { return }
        
        _ = coreDataManager.createGoal(
            name: name,
            targetAmount: amount,
            deadline: hasDeadline ? deadline : nil
        )
        
        dismiss()
    }
}

#Preview {
    AddGoalView()
} 