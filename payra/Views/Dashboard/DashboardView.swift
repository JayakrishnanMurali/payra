import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var transactions: [Transaction] = []
    @State private var categories: [Category] = []
    @State private var user: User?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: .payraSpacingLG) {
                    // Monthly Summary Card
                    monthlySummaryCard
                    
                    // Category Breakdown
                    categoryBreakdownCard
                    
                    // Recent Transactions
                    recentTransactionsCard
                }
                .padding(.horizontal, .payraSpacingMD)
                .padding(.top, .payraSpacingMD)
            }
            .background(Color.payraBackground)
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                loadData()
            }
        }
    }
    
    private var monthlySummaryCard: some View {
        PayraCard {
            VStack(spacing: .payraSpacingMD) {
                HStack {
                    Text("This Month")
                        .font(.payraBodyLarge)
                        .foregroundColor(.payraTextPrimary)
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: .payraSpacingSM) {
                        Text("Spent")
                            .font(.payraBodySmall)
                            .foregroundColor(.payraTextSecondary)
                        Text("$\(totalSpent, specifier: "%.2f")")
                            .font(.payraHeadlineLarge)
                            .foregroundColor(.payraTextPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: .payraSpacingSM) {
                        Text("Income")
                            .font(.payraBodySmall)
                            .foregroundColor(.payraTextSecondary)
                        Text("$\(user?.monthlyIncome ?? 0, specifier: "%.2f")")
                            .font(.payraHeadlineLarge)
                            .foregroundColor(.payraTextPrimary)
                    }
                }
                
                // Progress Bar
                let progress = user?.monthlyIncome ?? 0 > 0 ? totalSpent / (user?.monthlyIncome ?? 1) : 0
                VStack(spacing: .payraSpacingXS) {
                    HStack {
                        Text("Budget Usage")
                            .font(.payraBodySmall)
                            .foregroundColor(.payraTextSecondary)
                        Spacer()
                        Text("\(Int(progress * 100))%")
                            .font(.payraBodySmall)
                            .foregroundColor(progress > 0.8 ? .payraError : .payraTextSecondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.payraSurface)
                                .frame(height: 8)
                                .cornerRadius(.payraRadiusPill)
                            
                            Rectangle()
                                .fill(progress > 0.8 ? Color.payraError : Color.payraPrimary)
                                .frame(width: geometry.size.width * min(progress, 1), height: 8)
                                .cornerRadius(.payraRadiusPill)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
    }
    
    private var categoryBreakdownCard: some View {
        PayraCard {
            VStack(spacing: .payraSpacingMD) {
                HStack {
                    Text("Spending by Category")
                        .font(.payraBodyLarge)
                        .foregroundColor(.payraTextPrimary)
                    Spacer()
                }
                
                if categorySpending.isEmpty {
                    Text("No transactions this month")
                        .font(.payraBodyMedium)
                        .foregroundColor(.payraTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.payraSpacingLG)
                } else {
                    VStack(spacing: .payraSpacingSM) {
                        ForEach(Array(categorySpending.prefix(5)), id: \.key) { category, amount in
                            HStack {
                                Circle()
                                    .fill(Color(hex: category.colorHex ?? "#000000"))
                                    .frame(width: 12, height: 12)
                                
                                Text(category.name ?? "Unknown")
                                    .font(.payraBodyMedium)
                                    .foregroundColor(.payraTextPrimary)
                                
                                Spacer()
                                
                                Text("$\(amount, specifier: "%.2f")")
                                    .font(.payraBodyMedium)
                                    .foregroundColor(.payraTextPrimary)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var recentTransactionsCard: some View {
        PayraCard {
            VStack(spacing: .payraSpacingMD) {
                HStack {
                    Text("Recent Transactions")
                        .font(.payraBodyLarge)
                        .foregroundColor(.payraTextPrimary)
                    Spacer()
                    
                    NavigationLink("See All") {
                        TransactionsView()
                    }
                    .font(.payraBodyMedium)
                    .foregroundColor(.payraPrimary)
                }
                
                if transactions.isEmpty {
                    Text("No transactions yet")
                        .font(.payraBodyMedium)
                        .foregroundColor(.payraTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.payraSpacingLG)
                } else {
                    VStack(spacing: .payraSpacingSM) {
                        ForEach(Array(transactions.prefix(3)), id: \.id) { transaction in
                            TransactionRowView(transaction: transaction)
                        }
                    }
                }
            }
        }
    }
    
    private var totalSpent: Double {
        transactions
            .filter { $0.type == TransactionType.expense.rawValue }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var categorySpending: [(key: Category, value: Double)] {
        let spending = transactions
            .filter { $0.type == TransactionType.expense.rawValue }
            .reduce(into: [Category: Double]()) { result, transaction in
                if let category = transaction.category {
                    result[category, default: 0] += transaction.amount
                }
            }
        
        return spending.sorted { $0.value > $1.value }
    }
    
    private func loadData() {
        transactions = coreDataManager.fetchTransactions()
        categories = coreDataManager.fetchCategories()
        user = coreDataManager.fetchUser()
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: .payraSpacingMD) {
            // Category Icon
            if let category = transaction.category {
                Image(systemName: category.iconName ?? "circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: category.colorHex ?? "#000000"))
                    .frame(width: 32, height: 32)
                    .background(Color(hex: category.colorHex ?? "#000000").opacity(0.1))
                    .cornerRadius(.payraRadiusDefault)
            } else {
                Image(systemName: "circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.payraIconSecondary)
                    .frame(width: 32, height: 32)
                    .background(Color.payraSurface)
                    .cornerRadius(.payraRadiusDefault)
            }
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.merchant ?? "Unknown")
                    .font(.payraBodyMedium)
                    .foregroundColor(.payraTextPrimary)
                
                if let category = transaction.category {
                    Text(category.name ?? "")
                        .font(.payraBodySmall)
                        .foregroundColor(.payraTextSecondary)
                }
            }
            
            Spacer()
            
            // Amount
            Text("$\(transaction.amount, specifier: "%.2f")")
                .font(.payraBodyMedium)
                .foregroundColor(transaction.type == TransactionType.expense.rawValue ? .payraTextPrimary : .payraPrimary)
        }
        .padding(.vertical, .payraSpacingSM)
    }
}

#Preview {
    DashboardView()
} 