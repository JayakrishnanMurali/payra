//
//  GoalStatus.swift
//  payra
//
//  Created by Payra Team
//

import Foundation
import SwiftUI

enum GoalStatus: String, CaseIterable, Codable {
    case active = "active"
    case completed = "completed"
    case paused = "paused"
    case cancelled = "cancelled"
    
    var displayName: String {
        switch self {
        case .active:
            return "Active"
        case .completed:
            return "Completed"
        case .paused:
            return "Paused"
        case .cancelled:
            return "Cancelled"
        }
    }
    
    var icon: String {
        switch self {
        case .active:
            return "play.circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        case .paused:
            return "pause.circle.fill"
        case .cancelled:
            return "xmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .active:
            return .successColor
        case .completed:
            return .primaryColor
        case .paused:
            return .warningColor
        case .cancelled:
            return .errorColor
        }
    }
    
    var isEditable: Bool {
        switch self {
        case .active, .paused:
            return true
        case .completed, .cancelled:
            return false
        }
    }
    
    var canBeActivated: Bool {
        switch self {
        case .paused, .cancelled:
            return true
        case .active, .completed:
            return false
        }
    }
} 