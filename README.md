# Payra - Personal Finance App

A modern iOS app for personal finance management built with SwiftUI and Core Data.

## Project Structure

The project follows a clean architecture pattern with the following folder structure:

```
payra/
├── App/                    # Core app files
│   ├── payraApp.swift     # App entry point
│   └── ContentView.swift  # Root content view
├── Views/                  # All UI views organized by feature
│   ├── Dashboard/         # Dashboard-related views
│   │   ├── DashboardView.swift
│   │   └── MainTabView.swift
│   ├── Transactions/      # Transaction management views
│   │   ├── TransactionsView.swift
│   │   └── AddTransactionView.swift
│   ├── Goals/            # Financial goals views
│   │   ├── GoalsView.swift
│   │   └── AddGoalView.swift
│   ├── Settings/         # App settings and configuration
│   │   ├── SettingsView.swift
│   │   └── AddCategoryView.swift
│   └── Onboarding/       # User onboarding flow
│       └── OnboardingView.swift
├── Models/               # Data models and Core Data
│   └── PayraDataModel.xcdatamodeld/
├── Managers/             # Business logic and services
│   ├── CoreDataManager.swift
│   ├── CSVImportManager.swift
│   └── NotificationManager.swift
├── Design/              # Design system and assets
│   ├── DesignSystem.swift
│   ├── Assets.xcassets/
│   └── Preview Content/
└── Utils/               # Utilities and helpers
```

## Architecture Guidelines

### Views

- **Feature-based organization**: Views are grouped by feature (Dashboard, Transactions, Goals, etc.)
- **Single responsibility**: Each view should have a clear, single purpose
- **SwiftUI best practices**: Use proper state management and view composition

### Managers

- **Business logic separation**: All business logic is contained in manager classes
- **Dependency injection**: Managers can be injected into views as needed
- **Error handling**: Proper error handling and user feedback

### Models

- **Core Data integration**: All data models are defined in the Core Data model
- **Type safety**: Use proper Swift types and Core Data relationships

### Design

- **Consistent styling**: Use the DesignSystem for consistent UI components
- **Asset management**: All images and colors are managed through asset catalogs

## Development Guidelines

1. **File naming**: Use descriptive names that clearly indicate the file's purpose
2. **Code organization**: Keep related functionality together
3. **Documentation**: Add comments for complex business logic
4. **Testing**: Write unit tests for managers and integration tests for views

## Getting Started

1. Open `payra.xcodeproj` in Xcode
2. Build and run the project
3. The app will start with the onboarding flow for new users

## Features

- **Dashboard**: Overview of financial status and recent activity
- **Transactions**: Add, edit, and categorize financial transactions
- **Goals**: Set and track financial goals
- **Settings**: Configure categories, notifications, and app preferences
- **CSV Import**: Import transaction data from CSV files
- **Notifications**: Smart reminders for bills and goals

## Requirements

- iOS 18.1+
- Xcode 16.1+
- Swift 6.0+

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
