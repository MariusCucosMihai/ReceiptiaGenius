//
//  UserProfile.swift
//  Receiptia
//
//  Data Model for User Profile
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var email: String?
    var avatarInitials: String
    var monthlyBudget: Double
    var notificationsEnabled: Bool
    var darkModeEnabled: Bool
    var currencyCode: String
    var createdAt: Date
    var lastActiveAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        email: String? = nil,
        avatarInitials: String? = nil,
        monthlyBudget: Double = 1000,
        notificationsEnabled: Bool = true,
        darkModeEnabled: Bool = true,
        currencyCode: String = "EUR",
        createdAt: Date = Date(),
        lastActiveAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarInitials = avatarInitials ?? String(name.prefix(2)).uppercased()
        self.monthlyBudget = monthlyBudget
        self.notificationsEnabled = notificationsEnabled
        self.darkModeEnabled = darkModeEnabled
        self.currencyCode = currencyCode
        self.createdAt = createdAt
        self.lastActiveAt = lastActiveAt
    }
}

struct Achievement: Identifiable {
    let id: UUID
    let title: String
    let achievementDescription: String
    let icon: String
    let isUnlocked: Bool
    let unlockedAt: Date?
    let category: AchievementCategory

    init(
        id: UUID = UUID(),
        title: String,
        achievementDescription: String,
        icon: String,
        isUnlocked: Bool = false,
        unlockedAt: Date? = nil,
        category: AchievementCategory
    ) {
        self.id = id
        self.title = title
        self.achievementDescription = achievementDescription
        self.icon = icon
        self.isUnlocked = isUnlocked
        self.unlockedAt = unlockedAt
        self.category = category
    }
}

enum AchievementCategory: String, CaseIterable {
    case savings = "Risparmi"
    case consistency = "Costanza"
    case goals = "Obiettivi"
    case streaks = "Serie"

    var icon: String {
        switch self {
        case .savings: return "banknote.fill"
        case .consistency: return "chart.line.uptrend.xyaxis"
        case .goals: return "target"
        case .streaks: return "flame.fill"
        }
    }
}
