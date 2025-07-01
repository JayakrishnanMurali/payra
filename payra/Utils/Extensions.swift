//
//  Extensions.swift
//  payra
//
//  Created by Payra Team
//

import Foundation
import SwiftUI

// MARK: - Date Extensions
extension Date {
    func formattedString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func isThisMonth() -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    func isThisYear() -> Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.dateInterval(of: .month, for: self)?.start ?? self
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.dateInterval(of: .month, for: self)?.end ?? self
    }
    
    func startOfYear() -> Date {
        return Calendar.current.dateInterval(of: .year, for: self)?.start ?? self
    }
    
    func endOfYear() -> Date {
        return Calendar.current.dateInterval(of: .year, for: self)?.end ?? self
    }
}

// MARK: - Double Extensions
extension Double {
    func formattedCurrency(currency: String = AppConstants.Currency.defaultCurrency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func formattedPercentage() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self / 100)) ?? "\(self)%"
    }
    
    func rounded(to places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}

// MARK: - String Extensions
extension String {
    var isEmptyOrWhitespace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func truncate(to length: Int, trailing: String = "...") -> String {
        if self.count <= length {
            return self
        }
        return String(self.prefix(length)) + trailing
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidAmount() -> Bool {
        let amountRegex = "^\\d+(\\.\\d{1,2})?$"
        let amountPredicate = NSPredicate(format: "SELF MATCHES %@", amountRegex)
        return amountPredicate.evaluate(with: self)
    }
}

// MARK: - Color Extensions
extension Color {
    static let primaryColor = Color("AccentColor")
    static let secondaryColor = Color.blue
    static let backgroundColor = Color(.systemBackground)
    static let secondaryBackgroundColor = Color(.secondarySystemBackground)
    static let textColor = Color(.label)
    static let secondaryTextColor = Color(.secondaryLabel)
    static let successColor = Color.green
    static let errorColor = Color.red
    static let warningColor = Color.orange
    
    // MARK: - Transaction Type Colors
    static let incomeColor = Color.green
    static let expenseColor = Color.red
    static let transferColor = Color.blue
}

// MARK: - View Extensions
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    func cardStyle() -> some View {
        self
            .background(Color.secondaryBackgroundColor)
            .cornerRadius(AppConstants.Layout.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .frame(height: AppConstants.Layout.buttonHeight)
            .background(Color.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(AppConstants.Layout.cornerRadius)
            .font(.headline)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .frame(height: AppConstants.Layout.buttonHeight)
            .background(Color.secondaryBackgroundColor)
            .foregroundColor(Color.primaryColor)
            .cornerRadius(AppConstants.Layout.cornerRadius)
            .font(.headline)
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius)
                    .stroke(Color.primaryColor, lineWidth: 1)
            )
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - RoundedCorner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - UserDefaults Extensions
extension UserDefaults {
    func getBool(forKey key: String, defaultValue: Bool = false) -> Bool {
        return bool(forKey: key)
    }
    
    func getString(forKey key: String, defaultValue: String = "") -> String {
        return string(forKey: key) ?? defaultValue
    }
    
    func getInt(forKey key: String, defaultValue: Int = 0) -> Int {
        return integer(forKey: key)
    }
    
    func getDouble(forKey key: String, defaultValue: Double = 0.0) -> Double {
        return double(forKey: key)
    }
}

// MARK: - Bundle Extensions
extension Bundle {
    var appName: String {
        return object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Payra"
    }
    
    var appVersion: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    
    var buildNumber: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
} 