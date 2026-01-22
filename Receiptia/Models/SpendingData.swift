//
//  SpendingData.swift
//  Receiptia
//
//  Data Models for Spending Analytics
//

import Foundation

struct DailySpending: Identifiable {
    let id: UUID
    let date: Date
    let amount: Double
    let dayAbbreviation: String

    init(
        id: UUID = UUID(),
        date: Date,
        amount: Double,
        dayAbbreviation: String
    ) {
        self.id = id
        self.date = date
        self.amount = amount
        self.dayAbbreviation = dayAbbreviation
    }
}

struct WeeklySpending: Identifiable {
    let id: UUID
    let weekStartDate: Date
    let weekEndDate: Date
    let dailySpending: [DailySpending]
    let totalAmount: Double
    let averageAmount: Double
    let peakDay: DailySpending?

    init(
        id: UUID = UUID(),
        weekStartDate: Date,
        weekEndDate: Date,
        dailySpending: [DailySpending]
    ) {
        self.id = id
        self.weekStartDate = weekStartDate
        self.weekEndDate = weekEndDate
        self.dailySpending = dailySpending
        self.totalAmount = dailySpending.reduce(0) { $0 + $1.amount }
        self.averageAmount = dailySpending.isEmpty ? 0 : self.totalAmount / Double(dailySpending.count)
        self.peakDay = dailySpending.max(by: { $0.amount < $1.amount })
    }
}

struct SpendingComparison {
    let userPercentile: Int
    let comparisonMessage: String
    let isPositive: Bool

    var displayMessage: String {
        "Sei stato più disciplinato del \(userPercentile)% degli utenti questa settimana"
    }
}

struct SpendingStatus {
    let amountLast24h: Double
    let comparisonYesterday: Double
    let isSpendingLess: Bool
    let statusMessage: String
    let highlightedWord: String

    var comparisonText: String {
        let absComparison = abs(comparisonYesterday)
        let direction = comparisonYesterday < 0 ? "meno" : "più"
        return "€\(String(format: "%.0f", absComparison)) \(direction) di ieri"
    }
}
