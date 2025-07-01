import SwiftUI

struct AddTransactionView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var amount: String = ""
    @State private var merchant: String = ""
    @State private var notes: String = ""
    @State private var selectedDate = Date()
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: Category?
    @State private var isRecurring = false
    @State private var recurringFrequency = "monthly"
    
    private let categories: [Category]
    
    init() {
        self.categories = CoreDataManager.shared.fetchCategories()
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Amount Section
                Section("Amount") {
                    HStack {
                        Text("$")
                            .font(.payraBodyLarge)
                            .foregroundColor(.payraTextSecondary)
                        
                        TextField("0.00", text: $amount)
                            .font(.payraBodyLarge)
                            .keyboardType(.decimalPad)
                    }
                }
                
                // Transaction Type
                Section("Type") {
                    Picker("Transaction Type", selection: $selectedType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Details Section
                Section("Details") {
                    TextField("Merchant", text: $merchant)
                    
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    
                    if !categories.isEmpty {
                        Picker("Category", selection: $selectedCategory) {
                            Text("No Category").tag(nil as Category?)
                            ForEach(categories, id: \.id) { category in
                                HStack {
                                    Image(systemName: category.iconName ?? "circle.fill")
                                        .foregroundColor(Color(hex: category.colorHex ?? "#000000"))
                                    Text(category.name ?? "")
                                }
                                .tag(category as Category?)
                            }
                        }
                    }
                    
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                // Recurring Section
                Section("Recurring") {
                    Toggle("Mark as recurring", isOn: $isRecurring)
                    
                    if isRecurring {
                        Picker("Frequency", selection: $recurringFrequency) {
                            Text("Weekly").tag("weekly")
                            Text("Monthly").tag("monthly")
                            Text("Yearly").tag("yearly")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTransaction()
                    }
                    .disabled(amount.isEmpty || merchant.isEmpty)
                }
            }
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount), !merchant.isEmpty else { return }
        
        _ = coreDataManager.createTransaction(
            amount: amountValue,
            date: selectedDate,
            merchant: merchant,
            category: selectedCategory,
            notes: notes.isEmpty ? nil : notes,
            type: selectedType,
            isRecurring: isRecurring,
            recurringFrequency: isRecurring ? recurringFrequency : nil
        )
        
        dismiss()
    }
}

#Preview {
    AddTransactionView()
} 