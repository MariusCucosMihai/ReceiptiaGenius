//
//  Expense.swift
//  Receiptia
//
//  Data Model for Expenses
//

import Foundation
import SwiftData

@Model
final class Expense {
    var id: UUID
    var amount: Double
    var category: ExpenseCategory
    var title: String
    var date: Date
    var isImpulsive: Bool
    var isNightPurchase: Bool
    var merchant: String?
    var notes: String?

    init(
        id: UUID = UUID(),
        amount: Double,
        category: ExpenseCategory,
        title: String,
        date: Date = Date(),
        isImpulsive: Bool = false,
        isNightPurchase: Bool = false,
        merchant: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.category = category
        self.title = title
        self.date = date
        self.isImpulsive = isImpulsive
        self.isNightPurchase = isNightPurchase
        self.merchant = merchant
        self.notes = notes
    }
}

enum ExpenseCategory: String, Codable, CaseIterable {
    case food = "Cibo"
    case transport = "Trasporti"
    case shopping = "Shopping"
    case entertainment = "Intrattenimento"
    case bills = "Bollette"
    case subscriptions = "Abbonamenti"
    case health = "Salute"
    case education = "Istruzione"
    case travel = "Viaggi"
    case other = "Altro"

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "bag.fill"
        case .entertainment: return "tv.fill"
        case .bills: return "doc.text.fill"
        case .subscriptions: return "repeat"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .travel: return "airplane"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: String {
        switch self {
        case .food: return "FF6B6B"
        case .transport: return "4ECDC4"
        case .shopping: return "FFE66D"
        case .entertainment: return "95E1D3"
        case .bills: return "F38181"
        case .subscriptions: return "AA96DA"
        case .health: return "FCBAD3"
        case .education: return "A8D8EA"
        case .travel: return "FFB347"
        case .other: return "999999"
        }
    }
}
