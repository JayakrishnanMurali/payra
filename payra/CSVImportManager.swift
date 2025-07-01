import Foundation
import UniformTypeIdentifiers

struct CSVTransaction {
    let date: Date
    let description: String
    let amount: Double
    let type: TransactionType
}

class CSVImportManager: ObservableObject {
    @Published var isImporting = false
    @Published var importProgress: Double = 0
    @Published var importedTransactions: [CSVTransaction] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    func importCSV(from url: URL) async throws {
        await MainActor.run {
            isImporting = true
            importProgress = 0
        }
        
        let data = try Data(contentsOf: url)
        guard let csvString = String(data: data, encoding: .utf8) else {
            throw CSVImportError.invalidEncoding
        }
        
        let lines = csvString.components(separatedBy: .newlines)
        guard lines.count > 1 else {
            throw CSVImportError.emptyFile
        }
        
        // Parse header to determine column positions
        let header = lines[0].components(separatedBy: ",")
        let dateIndex = findColumnIndex(in: header, possibleNames: ["date", "Date", "DATE", "Transaction Date"])
        let descriptionIndex = findColumnIndex(in: header, possibleNames: ["description", "Description", "DESCRIPTION", "Merchant", "merchant", "MERCHANT", "Details", "details"])
        let amountIndex = findColumnIndex(in: header, possibleNames: ["amount", "Amount", "AMOUNT", "Transaction Amount"])
        
        guard let dateIdx = dateIndex,
              let descIdx = descriptionIndex,
              let amountIdx = amountIndex else {
            throw CSVImportError.invalidFormat
        }
        
        var transactions: [CSVTransaction] = []
        let dataLines = Array(lines.dropFirst())
        
        for (index, line) in dataLines.enumerated() {
            await MainActor.run {
                importProgress = Double(index) / Double(dataLines.count)
            }
            
            let columns = parseCSVLine(line)
            guard columns.count > max(dateIdx, descIdx, amountIdx) else { continue }
            
            // Parse date
            let dateString = columns[dateIdx].trimmingCharacters(in: .whitespacesAndNewlines)
            guard let date = parseDate(dateString) else { continue }
            
            // Parse amount
            let amountString = columns[amountIdx].trimmingCharacters(in: .whitespacesAndNewlines)
            guard let amount = parseAmount(amountString) else { continue }
            
            // Parse description
            let description = columns[descIdx].trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Determine transaction type based on amount
            let type: TransactionType = amount >= 0 ? .income : .expense
            let absoluteAmount = abs(amount)
            
            let transaction = CSVTransaction(
                date: date,
                description: description,
                amount: absoluteAmount,
                type: type
            )
            
            transactions.append(transaction)
        }
        
        await MainActor.run {
            importedTransactions = transactions
            importProgress = 1.0
            isImporting = false
        }
    }
    
    func saveImportedTransactions(with categoryMapping: [String: Category]) {
        for csvTransaction in importedTransactions {
            let category = categoryMapping[csvTransaction.description] ?? findBestMatchingCategory(for: csvTransaction.description)
            
            _ = coreDataManager.createTransaction(
                amount: csvTransaction.amount,
                date: csvTransaction.date,
                merchant: csvTransaction.description,
                category: category,
                notes: "Imported from CSV",
                type: csvTransaction.type
            )
        }
        
        importedTransactions.removeAll()
    }
    
    private func findColumnIndex(in header: [String], possibleNames: [String]) -> Int? {
        for (index, column) in header.enumerated() {
            let cleanColumn = column.trimmingCharacters(in: .whitespacesAndNewlines)
            if possibleNames.contains(cleanColumn) {
                return index
            }
        }
        return nil
    }
    
    private func parseCSVLine(_ line: String) -> [String] {
        var columns: [String] = []
        var currentColumn = ""
        var insideQuotes = false
        
        for character in line {
            switch character {
            case "\"":
                insideQuotes.toggle()
            case ",":
                if !insideQuotes {
                    columns.append(currentColumn)
                    currentColumn = ""
                } else {
                    currentColumn.append(character)
                }
            default:
                currentColumn.append(character)
            }
        }
        
        columns.append(currentColumn)
        return columns
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let formatters = [
            "yyyy-MM-dd",
            "MM/dd/yyyy",
            "dd/MM/yyyy",
            "yyyy/MM/dd",
            "MM-dd-yyyy",
            "dd-MM-yyyy"
        ]
        
        for format in formatters {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
    
    private func parseAmount(_ amountString: String) -> Double? {
        let cleanString = amountString
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return Double(cleanString)
    }
    
    private func findBestMatchingCategory(for description: String) -> Category? {
        let categories = coreDataManager.fetchCategories()
        
        // Simple keyword matching
        let lowerDescription = description.lowercased()
        
        for category in categories {
            if let name = category.name?.lowercased() {
                if lowerDescription.contains(name) {
                    return category
                }
            }
        }
        
        // Default category mapping
        let defaultMappings: [String: String] = [
            "restaurant": "Food & Dining",
            "cafe": "Food & Dining",
            "coffee": "Food & Dining",
            "uber": "Transportation",
            "lyft": "Transportation",
            "gas": "Transportation",
            "amazon": "Shopping",
            "walmart": "Shopping",
            "target": "Shopping",
            "netflix": "Entertainment",
            "spotify": "Entertainment",
            "doctor": "Healthcare",
            "pharmacy": "Healthcare",
            "electric": "Utilities",
            "water": "Utilities",
            "rent": "Housing",
            "mortgage": "Housing"
        ]
        
        for (keyword, categoryName) in defaultMappings {
            if lowerDescription.contains(keyword) {
                return categories.first { $0.name == categoryName }
            }
        }
        
        return nil
    }
}

enum CSVImportError: Error, LocalizedError {
    case invalidEncoding
    case emptyFile
    case invalidFormat
    
    var errorDescription: String? {
        switch self {
        case .invalidEncoding:
            return "The CSV file could not be read. Please ensure it's encoded in UTF-8."
        case .emptyFile:
            return "The CSV file is empty."
        case .invalidFormat:
            return "The CSV file format is not recognized. Please ensure it has Date, Description, and Amount columns."
        }
    }
} 