import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func scheduleBillReminder(for transaction: Transaction) {
        guard transaction.isRecurring,
              let frequency = transaction.recurringFrequency else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Bill Reminder"
        content.body = "\(transaction.merchant ?? "Recurring bill") - $\(String(format: "%.2f", transaction.amount))"
        content.sound = .default
        
        // Calculate next due date based on frequency
        let nextDueDate = calculateNextDueDate(for: transaction.date ?? Date(), frequency: frequency)
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day], from: nextDueDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "bill-\(transaction.id?.uuidString ?? UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling bill reminder: \(error)")
            }
        }
    }
    
    func scheduleBudgetAlert(for category: Category, currentSpent: Double) {
        guard category.budgetLimit > 0 else { return }
        
        let percentage = currentSpent / category.budgetLimit
        
        if percentage >= 0.8 {
            let content = UNMutableNotificationContent()
            content.title = "Budget Alert"
            content.body = "You've spent \(Int(percentage * 100))% of your \(category.name ?? "category") budget"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "budget-\(category.id?.uuidString ?? UUID().uuidString)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling budget alert: \(error)")
                }
            }
        }
    }
    
    func scheduleGoalReminder(for goal: Goal) {
        guard let deadline = goal.deadline else { return }
        
        let daysUntilDeadline = Calendar.current.dateComponents([.day], from: Date(), to: deadline).day ?? 0
        
        // Remind 7 days before deadline
        if daysUntilDeadline <= 7 && daysUntilDeadline > 0 {
            let content = UNMutableNotificationContent()
            content.title = "Goal Reminder"
            content.body = "\(goal.name ?? "Your goal") is due in \(daysUntilDeadline) days"
            content.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "goal-\(goal.id?.uuidString ?? UUID().uuidString)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling goal reminder: \(error)")
                }
            }
        }
    }
    
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func calculateNextDueDate(for currentDate: Date, frequency: String) -> Date {
        let calendar = Calendar.current
        
        switch frequency {
        case "weekly":
            return calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
        case "monthly":
            return calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        case "yearly":
            return calendar.date(byAdding: .year, value: 1, to: currentDate) ?? currentDate
        default:
            return currentDate
        }
    }
} 