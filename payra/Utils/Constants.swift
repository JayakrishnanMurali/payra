//
//  Constants.swift
//  payra
//
//  Created by Payra Team
//

import Foundation
import SwiftUI

// MARK: - App Constants
struct AppConstants {
    static let appName = "Payra"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let selectedCurrency = "selectedCurrency"
        static let notificationsEnabled = "notificationsEnabled"
        static let biometricAuthEnabled = "biometricAuthEnabled"
    }
    
    // MARK: - Notification Names
    struct NotificationNames {
        static let transactionAdded = "transactionAdded"
        static let goalUpdated = "goalUpdated"
        static let categoryAdded = "categoryAdded"
    }
    
    // MARK: - Animation Durations
    struct AnimationDurations {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
    }
    
    // MARK: - Layout Constants
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        static let buttonHeight: CGFloat = 50
        static let iconSize: CGFloat = 24
    }
    
    // MARK: - Validation Rules
    struct Validation {
        static let maxTransactionAmount: Double = 999999.99
        static let maxGoalAmount: Double = 9999999.99
        static let maxCategoryNameLength = 50
        static let maxGoalNameLength = 100
        static let maxTransactionNoteLength = 200
    }
    
    // MARK: - Date Formats
    struct DateFormats {
        static let display = "MMM dd, yyyy"
        static let shortDisplay = "MMM dd"
        static let monthYear = "MMMM yyyy"
        static let year = "yyyy"
        static let time = "HH:mm"
    }
    
    // MARK: - Currency
    struct Currency {
        static let defaultCurrency = "USD"
        static let supportedCurrencies = ["USD", "EUR", "GBP", "CAD", "AUD", "JPY"]
    }
    
    // MARK: - File Extensions
    struct FileExtensions {
        static let csv = "csv"
        static let json = "json"
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let genericError = "Something went wrong. Please try again."
        static let networkError = "Network connection error. Please check your internet connection."
        static let invalidAmount = "Please enter a valid amount."
        static let invalidDate = "Please select a valid date."
        static let requiredField = "This field is required."
        static let invalidCSVFormat = "Invalid CSV format. Please check your file."
    }
    
    // MARK: - Success Messages
    struct SuccessMessages {
        static let transactionAdded = "Transaction added successfully!"
        static let goalCreated = "Goal created successfully!"
        static let categoryAdded = "Category added successfully!"
        static let dataImported = "Data imported successfully!"
    }
} 