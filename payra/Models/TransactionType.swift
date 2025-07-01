//
//  TransactionType.swift
//  payra
//
//  Created by Payra Team
//

import Foundation
import SwiftUI

enum TransactionType: String, CaseIterable, Codable {
    case income = "income"
    case expense = "expense"
    case transfer = "transfer"
    
    var displayName: String {
        switch self {
        case .income:
            return "Income"
        case .expense:
            return "Expense"
        case .transfer:
            return "Transfer"
        }
    }
    
    var icon: String {
        switch self {
        case .income:
            return "arrow.down.circle.fill"
        case .expense:
            return "arrow.up.circle.fill"
        case .transfer:
            return "arrow.left.arrow.right.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .income:
            return .incomeColor
        case .expense:
            return .expenseColor
        case .transfer:
            return .transferColor
        }
    }
    
    var isPositive: Bool {
        switch self {
        case .income:
            return true
        case .expense:
            return false
        case .transfer:
            return true // Transfers can be positive or negative depending on context
        }
    }
} 