import SwiftUI

struct TransactionsView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var transactions: [Transaction] = []
    @State private var showingAddTransaction = false
    @State private var searchText = ""
    @State private var selectedFilter: TransactionType? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter Bar
                VStack(spacing: .payraSpacingMD) {
                    PayraSearchBar(text: $searchText, placeholder: "Search transactions...")
                    
                    // Filter Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: .payraSpacingSM) {
                            FilterButton(title: "All", isSelected: selectedFilter == nil) {
                                selectedFilter = nil
                            }
                            
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                FilterButton(title: type.displayName, isSelected: selectedFilter == type) {
                                    selectedFilter = type
                                }
                            }
                        }
                        .padding(.horizontal, .payraSpacingMD)
                    }
                }
                .padding(.horizontal, .payraSpacingMD)
                .padding(.top, .payraSpacingMD)
                .background(Color.payraBackground)
                
                // Transactions List
                if filteredTransactions.isEmpty {
                    VStack(spacing: .payraSpacingLG) {
                        Spacer()
                        
                        Image(systemName: "list.bullet")
                            .font(.system(size: 60))
                            .foregroundColor(.payraIconSecondary)
                        
                        Text("No transactions yet")
                            .font(.payraHeadlineMedium)
                            .foregroundColor(.payraTextPrimary)
                        
                        Text("Add your first transaction to start tracking your finances")
                            .font(.payraBodyMedium)
                            .foregroundColor(.payraTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        PayraButton("Add Transaction") {
                            showingAddTransaction = true
                        }
                        .padding(.horizontal, .payraSpacingXL)
                        
                        Spacer()
                    }
                    .background(Color.payraBackground)
                } else {
                    List {
                        ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(formatDate(date))
                                .font(.payraBodySmall)
                                .foregroundColor(.payraTextSecondary)
                                .textCase(nil)
                                .padding(.horizontal, .payraSpacingMD)
                                .padding(.vertical, .payraSpacingSM)) {
                                
                                ForEach(groupedTransactions[date] ?? [], id: \.id) { transaction in
                                    TransactionRowView(transaction: transaction)
                                        .listRowInsets(EdgeInsets(top: .payraSpacingSM, leading: .payraSpacingMD, bottom: .payraSpacingSM, trailing: .payraSpacingMD))
                                        .listRowBackground(Color.clear)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button("Delete", role: .destructive) {
                                                deleteTransaction(transaction)
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.payraBackground)
                }
            }
            .background(Color.payraBackground)
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTransaction = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.payraPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
            .onAppear {
                loadTransactions()
            }
        }
    }
    
    private var filteredTransactions: [Transaction] {
        var filtered = transactions
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                (transaction.merchant?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (transaction.notes?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (transaction.category?.name?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        // Apply type filter
        if let filter = selectedFilter {
            filtered = filtered.filter { $0.type == filter.rawValue }
        }
        
        return filtered
    }
    
    private var groupedTransactions: [Date: [Transaction]] {
        let calendar = Calendar.current
        return Dictionary(grouping: filteredTransactions) { transaction in
            calendar.startOfDay(for: transaction.date ?? Date())
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        
        if Calendar.current.isDate(date, inSameDayAs: today) {
            return "Today"
        } else if Calendar.current.isDate(date, inSameDayAs: yesterday) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
    }
    
    private func loadTransactions() {
        transactions = coreDataManager.fetchTransactions(for: .all)
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        coreDataManager.context.delete(transaction)
        coreDataManager.save()
        loadTransactions()
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.payraBodySmall)
                .foregroundColor(isSelected ? .payraBackground : .payraTextPrimary)
                .padding(.horizontal, .payraSpacingMD)
                .padding(.vertical, .payraSpacingSM)
                .background(
                    RoundedRectangle(cornerRadius: .payraRadiusPill)
                        .fill(isSelected ? Color.payraPrimary : Color.payraSurface)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TransactionsView()
} 