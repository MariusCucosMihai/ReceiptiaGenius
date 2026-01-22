//
//  ExpenseViewModel.swift
//  Receiptia
//
//  ViewModel for Adding and Managing Expenses
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class ExpenseViewModel {
    var amount: String = ""
    var selectedCategory: ExpenseCategory = .other
    var title: String = ""
    var notes: String = ""
    var date: Date = Date()
    var isShowingCategoryPicker: Bool = false

    var parsedAmount: Double {
        let cleanedString = amount.replacingOccurrences(of: ",", with: ".")
        return Double(cleanedString) ?? 0
    }

    var isValidExpense: Bool {
        parsedAmount > 0 && !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var isNightPurchase: Bool {
        let hour = Calendar.current.component(.hour, from: date)
        return hour >= 22 || hour < 6
    }

    func createExpense() -> Expense {
        Expense(
            amount: parsedAmount,
            category: selectedCategory,
            title: title.trimmingCharacters(in: .whitespaces),
            date: date,
            isImpulsive: false,
            isNightPurchase: isNightPurchase,
            notes: notes.isEmpty ? nil : notes
        )
    }

    func reset() {
        amount = ""
        selectedCategory = .other
        title = ""
        notes = ""
        date = Date()
    }

    var formattedAmount: String {
        guard parsedAmount > 0 else { return "€0,00" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "it_IT")
        return formatter.string(from: NSNumber(value: parsedAmount)) ?? "€0,00"
    }
}
