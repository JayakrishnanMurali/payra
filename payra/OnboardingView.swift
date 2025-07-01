import SwiftUI

struct OnboardingView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var currentStep = 0
    @State private var monthlyIncome: String = ""
    @State private var selectedCategories: Set<String> = []
    @State private var showMainApp = false
    
    private let defaultCategories = [
        ("Food & Dining", "fork.knife", "#FF6B6B"),
        ("Transportation", "car.fill", "#4ECDC4"),
        ("Shopping", "bag.fill", "#45B7D1"),
        ("Entertainment", "gamecontroller.fill", "#96CEB4"),
        ("Healthcare", "heart.fill", "#FFEAA7"),
        ("Utilities", "bolt.fill", "#DDA0DD"),
        ("Housing", "house.fill", "#98D8C8"),
        ("Education", "book.fill", "#F7DC6F"),
        ("Travel", "airplane", "#BB8FCE"),
        ("Personal Care", "person.fill", "#85C1E9")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: .payraSpacingXL) {
                // Header
                VStack(spacing: .payraSpacingMD) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.payraPrimary)
                    
                    Text("Welcome to Payra")
                        .font(.payraHeadlineLarge)
                        .foregroundColor(.payraTextPrimary)
                    
                    Text("Let's set up your personal finance tracker")
                        .font(.payraBodyLarge)
                        .foregroundColor(.payraTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, .payraSpacingXL)
                
                // Step Content
                VStack(spacing: .payraSpacingLG) {
                    if currentStep == 0 {
                        incomeSetupView
                    } else {
                        categorySetupView
                    }
                }
                
                Spacer()
                
                // Navigation
                VStack(spacing: .payraSpacingMD) {
                    PayraButton(currentStep == 0 ? "Continue" : "Get Started") {
                        if currentStep == 0 {
                            currentStep = 1
                        } else {
                            completeOnboarding()
                        }
                    }
                    .disabled(currentStep == 0 ? monthlyIncome.isEmpty : selectedCategories.isEmpty)
                    
                    if currentStep == 1 {
                        Button("Skip for now") {
                            completeOnboarding()
                        }
                        .font(.payraBodyMedium)
                        .foregroundColor(.payraTextSecondary)
                    }
                }
                .padding(.bottom, .payraSpacingXL)
            }
            .padding(.horizontal, .payraSpacingLG)
            .background(Color.payraBackground)
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainTabView()
        }
    }
    
    private var incomeSetupView: some View {
        VStack(spacing: .payraSpacingLG) {
            Text("What's your monthly income?")
                .font(.payraHeadlineMedium)
                .foregroundColor(.payraTextPrimary)
                .multilineTextAlignment(.center)
            
            Text("This helps us track your spending against your income")
                .font(.payraBodyMedium)
                .foregroundColor(.payraTextSecondary)
                .multilineTextAlignment(.center)
            
            PayraCard {
                VStack(spacing: .payraSpacingMD) {
                    HStack {
                        Text("$")
                            .font(.payraHeadlineMedium)
                            .foregroundColor(.payraTextSecondary)
                        
                        TextField("0.00", text: $monthlyIncome)
                            .font(.payraHeadlineMedium)
                            .foregroundColor(.payraTextPrimary)
                            .keyboardType(.decimalPad)
                    }
                    .padding(.payraSpacingMD)
                    .background(Color.payraSurface)
                    .cornerRadius(.payraRadiusDefault)
                }
            }
        }
    }
    
    private var categorySetupView: some View {
        VStack(spacing: .payraSpacingLG) {
            Text("Select your spending categories")
                .font(.payraHeadlineMedium)
                .foregroundColor(.payraTextPrimary)
                .multilineTextAlignment(.center)
            
            Text("Choose the categories that match your spending habits")
                .font(.payraBodyMedium)
                .foregroundColor(.payraTextSecondary)
                .multilineTextAlignment(.center)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: .payraSpacingMD) {
                    ForEach(defaultCategories, id: \.0) { category in
                        CategorySelectionCard(
                            name: category.0,
                            iconName: category.1,
                            colorHex: category.2,
                            isSelected: selectedCategories.contains(category.0)
                        ) {
                            if selectedCategories.contains(category.0) {
                                selectedCategories.remove(category.0)
                            } else {
                                selectedCategories.insert(category.0)
                            }
                        }
                    }
                }
                .padding(.horizontal, .payraSpacingMD)
            }
        }
    }
    
    private func completeOnboarding() {
        // Create user
        let income = Double(monthlyIncome) ?? 0
        let user = coreDataManager.createUser(monthlyIncome: income)
        
        // Create selected categories
        for categoryName in selectedCategories {
            if let category = defaultCategories.first(where: { $0.0 == categoryName }) {
                coreDataManager.createCategory(
                    name: category.0,
                    colorHex: category.2,
                    iconName: category.1
                )
            }
        }
        
        // Mark user as onboarded
        user.isOnboarded = true
        coreDataManager.save()
        
        showMainApp = true
    }
}

struct CategorySelectionCard: View {
    let name: String
    let iconName: String
    let colorHex: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: .payraSpacingSM) {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: colorHex))
                
                Text(name)
                    .font(.payraBodySmall)
                    .foregroundColor(.payraTextPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: .payraRadiusDefault)
                    .fill(isSelected ? Color(hex: colorHex).opacity(0.1) : Color.payraSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: .payraRadiusDefault)
                            .stroke(isSelected ? Color(hex: colorHex) : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    OnboardingView()
} 