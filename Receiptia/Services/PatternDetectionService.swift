//
//  PatternDetectionService.swift
//  Receiptia
//
//  AI-powered pattern detection for spending analysis
//

import Foundation

final class PatternDetectionService {
    static let shared = PatternDetectionService()

    private init() {}

    func generateInsights(from expenses: [Expense]) -> [Insight] {
        var insights: [Insight] = []

        guard !expenses.isEmpty else { return insights }

        // Night purchases analysis
        let nightInsight = analyzeNightPurchases(expenses)
        if let insight = nightInsight {
            insights.append(insight)
        }

        // Smart suggestion based on patterns
        let suggestionInsight = generateSmartSuggestion(expenses)
        if let insight = suggestionInsight {
            insights.append(insight)
        }

        // Savings potential
        let savingsInsight = calculateSavingsPotential(expenses)
        if let insight = savingsInsight {
            insights.append(insight)
        }

        // Subscription detection
        let subscriptionInsight = detectForgottenSubscriptions(expenses)
        if let insight = subscriptionInsight {
            insights.append(insight)
        }

        return insights
    }

    private func analyzeNightPurchases(_ expenses: [Expense]) -> Insight? {
        let nightPurchases = expenses.filter { expense in
            let hour = Calendar.current.component(.hour, from: expense.date)
            return hour >= 22 || hour < 6
        }

        guard !nightPurchases.isEmpty else { return nil }

        let percentage = Int((Double(nightPurchases.count) / Double(expenses.count)) * 100)

        guard percentage >= 20 else { return nil }

        return Insight(
            icon: "moon.fill",
            title: "Acquisti notturni",
            description: "Il \(percentage)% delle tue spese compulsive avviene dopo le 22:00",
            type: .nightPurchase,
            actionSuggestion: "Blocca le notifiche shopping di sera?",
            potentialSavings: nightPurchases.reduce(0) { $0 + $1.amount } * 0.5
        )
    }

    private func generateSmartSuggestion(_ expenses: [Expense]) -> Insight? {
        let nightPurchases = expenses.filter { expense in
            let hour = Calendar.current.component(.hour, from: expense.date)
            return hour >= 22 || hour < 6
        }

        guard !nightPurchases.isEmpty else { return nil }

        return Insight(
            icon: "brain.head.profile",
            title: "Suggerimento Smart",
            description: "Blocca le notifiche shopping di sera?",
            type: .smartSuggestion,
            actionSuggestion: "Attiva la modalità focus dopo le 22:00"
        )
    }

    private func calculateSavingsPotential(_ expenses: [Expense]) -> Insight? {
        let impulsiveExpenses = expenses.filter { $0.isImpulsive || $0.isNightPurchase }

        guard !impulsiveExpenses.isEmpty else { return nil }

        let potentialSavings = impulsiveExpenses.reduce(0) { $0 + $1.amount }

        return Insight(
            icon: "eurosign.circle.fill",
            title: "Potenziale risparmio",
            description: "Avresti potuto risparmiare €\(Int(potentialSavings))/mese evitando acquisti notturni",
            type: .savingsOpportunity,
            potentialSavings: potentialSavings
        )
    }

    private func detectForgottenSubscriptions(_ expenses: [Expense]) -> Insight? {
        let subscriptionExpenses = expenses.filter { $0.category == .subscriptions }

        let groupedByMerchant = Dictionary(grouping: subscriptionExpenses) { $0.merchant ?? "Unknown" }

        let recurringSubscriptions = groupedByMerchant.filter { $0.value.count >= 2 }

        guard !recurringSubscriptions.isEmpty else { return nil }

        let totalMonthly = recurringSubscriptions.values.compactMap { $0.first?.amount }.reduce(0, +)

        return Insight(
            icon: "repeat.circle.fill",
            title: "Abbonamenti attivi",
            description: "Hai \(recurringSubscriptions.count) abbonamenti per €\(Int(totalMonthly))/mese. Tutti necessari?",
            type: .forgottenSubscription,
            actionSuggestion: "Rivedi i tuoi abbonamenti"
        )
    }

    func detectCompulsivePurchase(amount: Double, category: ExpenseCategory, time: Date) -> Bool {
        let hour = Calendar.current.component(.hour, from: time)
        let isNightTime = hour >= 22 || hour < 6

        let impulsiveCategories: [ExpenseCategory] = [.shopping, .entertainment, .food]

        let isImpulsiveCategory = impulsiveCategories.contains(category)

        let isHighAmount = amount > 50

        return (isNightTime && isImpulsiveCategory) || (isHighAmount && isImpulsiveCategory && isNightTime)
    }

    func calculateUserPercentile(weeklySpending: Double) -> Int {
        let averageUserSpending = 250.0
        let standardDeviation = 100.0

        let zScore = (weeklySpending - averageUserSpending) / standardDeviation

        let percentile: Int
        if zScore <= -2 {
            percentile = 95
        } else if zScore <= -1 {
            percentile = 84
        } else if zScore <= 0 {
            percentile = 60
        } else if zScore <= 1 {
            percentile = 30
        } else {
            percentile = 10
        }

        return percentile
    }
}
