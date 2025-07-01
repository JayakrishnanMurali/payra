import SwiftUI

struct GoalsView: View {
    @StateObject private var coreDataManager = CoreDataManager.shared
    @State private var goals: [Goal] = []
    @State private var showingAddGoal = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: .payraSpacingLG) {
                    if goals.isEmpty {
                        VStack(spacing: .payraSpacingLG) {
                            Spacer()
                                .frame(height: 100)
                            
                            Image(systemName: "target")
                                .font(.system(size: 60))
                                .foregroundColor(.payraIconSecondary)
                            
                            Text("No goals yet")
                                .font(.payraHeadlineMedium)
                                .foregroundColor(.payraTextPrimary)
                            
                            Text("Create your first savings goal to start tracking your progress")
                                .font(.payraBodyMedium)
                                .foregroundColor(.payraTextSecondary)
                                .multilineTextAlignment(.center)
                            
                            PayraButton("Create Goal") {
                                showingAddGoal = true
                            }
                            .padding(.horizontal, .payraSpacingXL)
                            
                            Spacer()
                        }
                        .background(Color.payraBackground)
                    } else {
                        LazyVStack(spacing: .payraSpacingMD) {
                            ForEach(goals, id: \.id) { goal in
                                GoalCard(goal: goal) {
                                    // Handle goal tap
                                }
                            }
                        }
                        .padding(.horizontal, .payraSpacingMD)
                    }
                }
                .padding(.top, .payraSpacingMD)
            }
            .background(Color.payraBackground)
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.payraPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
            }
            .onAppear {
                loadGoals()
            }
        }
    }
    
    private func loadGoals() {
        goals = coreDataManager.fetchGoals()
    }
}

struct GoalCard: View {
    let goal: Goal
    let onTap: () -> Void
    
    var body: some View {
        PayraCard {
            VStack(spacing: .payraSpacingMD) {
                HStack {
                    VStack(alignment: .leading, spacing: .payraSpacingSM) {
                        Text(goal.name ?? "Untitled Goal")
                            .font(.payraBodyLarge)
                            .foregroundColor(.payraTextPrimary)
                        
                        if let deadline = goal.deadline {
                            Text("Due: \(formatDate(deadline))")
                                .font(.payraBodySmall)
                                .foregroundColor(.payraTextSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    if goal.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.payraPrimary)
                    }
                }
                
                // Progress Bar
                VStack(spacing: .payraSpacingXS) {
                    HStack {
                        Text("$\(goal.currentAmount, specifier: "%.2f")")
                            .font(.payraBodyMedium)
                            .foregroundColor(.payraTextPrimary)
                        
                        Spacer()
                        
                        Text("$\(goal.targetAmount, specifier: "%.2f")")
                            .font(.payraBodyMedium)
                            .foregroundColor(.payraTextSecondary)
                    }
                    
                    let progress = goal.targetAmount > 0 ? goal.currentAmount / goal.targetAmount : 0
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.payraSurface)
                                .frame(height: 8)
                                .cornerRadius(.payraRadiusPill)
                            
                            Rectangle()
                                .fill(Color.payraPrimary)
                                .frame(width: geometry.size.width * min(progress, 1), height: 8)
                                .cornerRadius(.payraRadiusPill)
                        }
                    }
                    .frame(height: 8)
                    
                    HStack {
                        Text("\(Int(progress * 100))% Complete")
                            .font(.payraBodySmall)
                            .foregroundColor(.payraTextSecondary)
                        
                        Spacer()
                        
                        if let deadline = goal.deadline {
                            let daysRemaining = Calendar.current.dateComponents([.day], from: Date(), to: deadline).day ?? 0
                            Text("\(daysRemaining) days left")
                                .font(.payraBodySmall)
                                .foregroundColor(daysRemaining < 7 ? .payraError : .payraTextSecondary)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            onTap()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    GoalsView()
} 