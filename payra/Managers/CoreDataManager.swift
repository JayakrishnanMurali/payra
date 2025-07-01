import CoreData
import Foundation

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PayraDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Save Context
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - Transaction Operations
    func createTransaction(amount: Double, date: Date, merchant: String?, category: Category?, notes: String?, type: TransactionType, isRecurring: Bool = false, recurringFrequency: String? = nil) -> Transaction {
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        transaction.date = date
        transaction.merchant = merchant
        transaction.notes = notes
        transaction.category = category
        transaction.type = type.rawValue
        transaction.isRecurring = isRecurring
        transaction.recurringFrequency = recurringFrequency
        
        save()
        return transaction
    }
    
    func fetchTransactions(for dateRange: DateRange = .thisMonth) -> [Transaction] {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        let calendar = Calendar.current
        let now = Date()
        
        switch dateRange {
        case .thisMonth:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            request.predicate = NSPredicate(format: "date >= %@", startOfMonth as NSDate)
        case .lastMonth:
            let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            let startOfLastMonth = calendar.dateInterval(of: .month, for: lastMonth)?.start ?? lastMonth
            let endOfLastMonth = calendar.dateInterval(of: .month, for: lastMonth)?.end ?? lastMonth
            request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfLastMonth as NSDate, endOfLastMonth as NSDate)
        case .all:
            break
        }
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching transactions: \(error)")
            return []
        }
    }
    
    // MARK: - Category Operations
    func createCategory(name: String, budgetLimit: Double? = nil, colorHex: String? = nil, iconName: String? = nil) -> Category {
        let category = Category(context: context)
        category.id = UUID()
        category.name = name
        category.budgetLimit = budgetLimit ?? 0
        category.colorHex = colorHex
        category.iconName = iconName
        
        save()
        return category
    }
    
    func fetchCategories() -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }
    
    // MARK: - Goal Operations
    func createGoal(name: String, targetAmount: Double, deadline: Date?) -> Goal {
        let goal = Goal(context: context)
        goal.id = UUID()
        goal.name = name
        goal.targetAmount = targetAmount
        goal.currentAmount = 0
        goal.deadline = deadline
        goal.createdAt = Date()
        goal.isCompleted = false
        
        save()
        return goal
    }
    
    func fetchGoals() -> [Goal] {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Goal.createdAt, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching goals: \(error)")
            return []
        }
    }
    
    // MARK: - User Operations
    func createUser(email: String? = nil, usesBiometry: Bool = false, monthlyIncome: Double = 0) -> User {
        let user = User(context: context)
        user.id = UUID()
        user.email = email
        user.usesBiometry = usesBiometry
        user.monthlyIncome = monthlyIncome
        user.isOnboarded = false
        user.createdAt = Date()
        
        save()
        return user
    }
    
    func fetchUser() -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
    
    // MARK: - Reminder Operations
    func createReminder(date: Date, type: ReminderType, title: String, message: String? = nil, transaction: Transaction? = nil) -> Reminder {
        let reminder = Reminder(context: context)
        reminder.id = UUID()
        reminder.date = date
        reminder.type = type.rawValue
        reminder.title = title
        reminder.message = message
        reminder.transaction = transaction
        reminder.isEnabled = true
        
        save()
        return reminder
    }
    
    func fetchReminders() -> [Reminder] {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Reminder.date, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching reminders: \(error)")
            return []
        }
    }
}

// MARK: - Enums
enum DateRange {
    case thisMonth
    case lastMonth
    case all
}

enum ReminderType: String, CaseIterable {
    case bill = "bill"
    case budget = "budget"
    case goal = "goal"
    
    var displayName: String {
        switch self {
        case .bill: return "Bill Reminder"
        case .budget: return "Budget Alert"
        case .goal: return "Goal Reminder"
        }
    }
} 