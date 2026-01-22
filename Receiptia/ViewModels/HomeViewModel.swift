//
//  HomeViewModel.swift
//  Receiptia
//
//  ViewModel for Home Tab
//

import Foundation
import SwiftUI
import SwiftData

enum TimeRange: String, CaseIterable {
    case last24h = "24h"
    case last7d = "7 giorni"
    case last30d = "30 giorni"
    case thisMonth = "Questo mese"

    var displayName: String { rawValue }

    var dateRange: (start: Date, end: Date) {
        let now = Date()
        let calendar = Calendar.current

        switch self {
        case .last24h:
            return (calendar.date(byAdding: .hour, value: -24, to: now)!, now)
        case .last7d:
            return (calendar.date(byAdding: .day, value: -7, to: now)!, now)
        case .last30d:
            return (calendar.date(byAdding: .day, value: -30, to: now)!, now)
        case .thisMonth:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            return (startOfMonth, now)
        }
    }
}

@Observable
final class HomeViewModel {
    var spendingStatus: SpendingStatus
    var insights: [Insight]
    var isLoading: Bool = false
    var selectedTimeRange: TimeRange = .last24h

    init() {
        self.spendingStatus = Self.createSampleSpendingStatus()
        self.insights = Self.createSampleInsights()
    }

    static func createSampleSpendingStatus() -> SpendingStatus {
        SpendingStatus(
            amountLast24h: 300.15,
            comparisonYesterday: -45,
            isSpendingLess: true,
            statusMessage: "Stai spendendo meno del solito",
            highlightedWord: "meno"
        )
    }

    static func createSampleInsights() -> [Insight] {
        [
            Insight(
                icon: "moon.fill",
                title: "Acquisti notturni",
                description: "Il 60% delle tue spese compulsive avviene dopo le 22:00",
                type: .nightPurchase,
                actionSuggestion: "Blocca le notifiche shopping di sera?",
                potentialSavings: 150
            ),
            Insight(
                icon: "brain.head.profile",
                title: "Suggerimento Smart",
                description: "Blocca le notifiche shopping di sera?",
                type: .smartSuggestion,
                actionSuggestion: "Attiva la modalità focus dopo le 22:00"
            ),
            Insight(
                icon: "eurosign.circle.fill",
                title: "Potenziale risparmio",
                description: "Avresti potuto risparmiare €150/mese evitando acquisti notturni",
                type: .savingsOpportunity,
                potentialSavings: 150
            )
        ]
    }

    func loadData(from expenses: [Expense]) {
        isLoading = true

        // Filter expenses by time range
        let range = selectedTimeRange.dateRange
        let filteredExpenses = expenses.filter { $0.date >= range.start && $0.date <= range.end }

        // Generate insights using pattern detection
        insights = PatternDetectionService.shared.generateInsights(from: filteredExpenses)

        // If no insights generated, use sample data
        if insights.isEmpty {
            insights = Self.createSampleInsights()
        }

        // Calculate spending status
        updateSpendingStatus(from: filteredExpenses)

        isLoading = false
    }

    private func updateSpendingStatus(from expenses: [Expense]) {
        let totalAmount = expenses.reduce(0) { $0 + $1.amount }

        // Compare with previous period
        let calendar = Calendar.current
        let now = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        let dayBefore = calendar.date(byAdding: .day, value: -2, to: now)!

        let todayExpenses = expenses.filter {
            calendar.isDate($0.date, inSameDayAs: now)
        }
        let yesterdayExpenses = expenses.filter {
            calendar.isDate($0.date, inSameDayAs: yesterday)
        }

        let todayTotal = todayExpenses.reduce(0) { $0 + $1.amount }
        let yesterdayTotal = yesterdayExpenses.reduce(0) { $0 + $1.amount }

        let comparison = todayTotal - yesterdayTotal
        let isSpendingLess = comparison < 0

        let statusMessage = isSpendingLess ? "Stai spendendo meno del solito" : "Stai spendendo più del solito"
        let highlightedWord = isSpendingLess ? "meno" : "più"

        spendingStatus = SpendingStatus(
            amountLast24h: totalAmount,
            comparisonYesterday: comparison,
            isSpendingLess: isSpendingLess,
            statusMessage: statusMessage,
            highlightedWord: highlightedWord
        )
    }

    func refreshData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isLoading = false
        }
    }
}
