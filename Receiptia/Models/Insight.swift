//
//  Insight.swift
//  Receiptia
//
//  Data Model for AI-Generated Insights
//

import Foundation

struct Insight: Identifiable {
    let id: UUID
    let icon: String
    let title: String
    let description: String
    let type: InsightType
    let actionSuggestion: String?
    let potentialSavings: Double?
    let createdAt: Date

    init(
        id: UUID = UUID(),
        icon: String,
        title: String,
        description: String,
        type: InsightType,
        actionSuggestion: String? = nil,
        potentialSavings: Double? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.description = description
        self.type = type
        self.actionSuggestion = actionSuggestion
        self.potentialSavings = potentialSavings
        self.createdAt = createdAt
    }
}

enum InsightType: String, CaseIterable {
    case nightPurchase = "night_purchase"
    case forgottenSubscription = "forgotten_subscription"
    case savingsOpportunity = "savings_opportunity"
    case spendingPattern = "spending_pattern"
    case smartSuggestion = "smart_suggestion"
    case achievement = "achievement"
    case warning = "warning"

    var emoji: String {
        switch self {
        case .nightPurchase: return "🌙"
        case .forgottenSubscription: return "👻"
        case .savingsOpportunity: return "💰"
        case .spendingPattern: return "📊"
        case .smartSuggestion: return "🧠"
        case .achievement: return "🏆"
        case .warning: return "⚠️"
        }
    }

    var accentColorHex: String {
        switch self {
        case .nightPurchase: return "6B5B95"
        case .forgottenSubscription: return "FF6B6B"
        case .savingsOpportunity: return "00FF88"
        case .spendingPattern: return "4ECDC4"
        case .smartSuggestion: return "00D9C0"
        case .achievement: return "FFD700"
        case .warning: return "FF4444"
        }
    }
}
