# Payra - iOS Personal Finance Tracker

Payra is a comprehensive personal finance tracking application built with SwiftUI and Core Data, designed to help users manage their expenses, income, budgets, and financial goals.

## Features

### 🏠 Dashboard

- **Monthly Summary**: View month-to-date spending vs. income with visual progress indicators
- **Category Breakdown**: See spending distribution across categories with color-coded charts
- **Recent Transactions**: Quick access to latest transactions
- **Budget Alerts**: Visual warnings when approaching budget limits

### 💰 Transaction Management

- **Add Transactions**: Manual entry with amount, date, merchant, category, and notes
- **Recurring Transactions**: Mark bills and subscriptions as recurring with frequency options
- **Search & Filter**: Find transactions by merchant, category, or date range
- **CSV Import**: Bulk import bank statements with automatic category matching

### 🎯 Financial Goals

- **Savings Goals**: Create and track progress toward financial targets
- **Deadline Tracking**: Set deadlines and get reminders
- **Progress Visualization**: Visual progress bars and completion indicators

### 📊 Categories & Budgets

- **Custom Categories**: Create personalized spending categories with icons and colors
- **Budget Limits**: Set monthly spending limits per category
- **Smart Categorization**: Automatic category suggestions based on merchant names

### 🔔 Notifications & Reminders

- **Bill Reminders**: Get notified about upcoming recurring payments
- **Budget Alerts**: Warnings when approaching category spending limits
- **Goal Reminders**: Notifications for goal deadlines

### ⚙️ Settings & Security

- **Biometric Authentication**: Face ID/Touch ID support
- **Data Export**: Export transaction data for backup
- **Category Management**: Add, edit, and delete spending categories

## Technical Architecture

### Core Technologies

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Persistent data storage with encryption
- **UserNotifications**: Local notifications for reminders
- **UniformTypeIdentifiers**: CSV file import support

### Design System

The app follows a Coinbase-inspired design system with:

- Clean, minimalist interface
- Consistent color palette and typography
- Rounded corners and subtle shadows
- Responsive layouts and smooth animations

### Data Model

- **Transaction**: Core financial records with amount, date, merchant, category
- **Category**: Spending categories with budget limits and visual properties
- **Goal**: Savings targets with progress tracking
- **User**: User preferences and settings
- **Reminder**: Notification scheduling for bills and alerts

## Installation

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0 or later
- macOS 14.0 or later (for development)

### Setup

1. Clone the repository
2. Open `payra.xcodeproj` in Xcode
3. Select your development team in project settings
4. Build and run on device or simulator

## Usage

### First Launch

1. **Onboarding**: Set up monthly income and select default categories
2. **Security**: Enable Face ID/Touch ID for app protection
3. **Categories**: Customize spending categories to match your habits

### Adding Transactions

1. Navigate to the Transactions tab
2. Tap the "+" button
3. Enter amount, merchant, and select category
4. Optionally mark as recurring and set frequency
5. Save the transaction

### Importing Bank Statements

1. Export CSV from your bank (Date, Description, Amount columns)
2. Go to Settings → Import CSV
3. Select the CSV file
4. Review and confirm imported transactions
5. Categories will be automatically assigned

### Creating Goals

1. Navigate to the Goals tab
2. Tap "Create Goal"
3. Enter goal name, target amount, and optional deadline
4. Track progress through the dashboard

## File Structure

```
payra/
├── payraApp.swift              # Main app entry point
├── ContentView.swift           # Root view with onboarding logic
├── DesignSystem.swift          # Design tokens and components
├── CoreDataManager.swift       # Data persistence and operations
├── NotificationManager.swift   # Local notifications
├── CSVImportManager.swift      # CSV parsing and import
├── Views/
│   ├── OnboardingView.swift    # User onboarding flow
│   ├── MainTabView.swift       # Main tab navigation
│   ├── DashboardView.swift     # Home dashboard
│   ├── TransactionsView.swift  # Transaction list and management
│   ├── AddTransactionView.swift # Transaction creation
│   ├── GoalsView.swift         # Financial goals
│   ├── AddGoalView.swift       # Goal creation
│   ├── SettingsView.swift      # App settings
│   └── AddCategoryView.swift   # Category management
└── PayraDataModel.xcdatamodeld/ # Core Data model
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes following the existing code style
4. Test thoroughly on device and simulator
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Privacy & Security

- All data is stored locally on device
- Optional biometric authentication
- No data is transmitted to external servers
- CSV import is processed locally

## Support

For issues, feature requests, or questions:

1. Check existing issues in the repository
2. Create a new issue with detailed description
3. Include device/OS version and steps to reproduce

---

Built with ❤️ using SwiftUI and Core Data
