//
//  RewardsViewModel.swift
//  Receiptia
//
//  ViewModel for Rewards Tab
//

import Foundation
import SwiftUI

@Observable
final class RewardsViewModel {
    var achievements: [Achievement]
    var currentStreak: Int
    var totalPoints: Int
    var level: Int
    var levelProgress: Double

    init() {
        self.achievements = Self.createSampleAchievements()
        self.currentStreak = 7
        self.totalPoints = 2450
        self.level = 5
        self.levelProgress = 0.65
    }

    static func createSampleAchievements() -> [Achievement] {
        [
            Achievement(
                title: "Prima Settimana",
                achievementDescription: "Hai completato la tua prima settimana di tracking",
                icon: "star.fill",
                isUnlocked: true,
                unlockedAt: Date().addingTimeInterval(-86400 * 7),
                category: .streaks
            ),
            Achievement(
                title: "Risparmiatore",
                achievementDescription: "Hai risparmiato €100 questo mese",
                icon: "banknote.fill",
                isUnlocked: true,
                unlockedAt: Date().addingTimeInterval(-86400 * 3),
                category: .savings
            ),
            Achievement(
                title: "Obiettivo Raggiunto",
                achievementDescription: "Hai completato il tuo primo obiettivo",
                icon: "target",
                isUnlocked: true,
                unlockedAt: Date().addingTimeInterval(-86400 * 2),
                category: .goals
            ),
            Achievement(
                title: "Costante",
                achievementDescription: "7 giorni consecutivi di tracking",
                icon: "flame.fill",
                isUnlocked: true,
                unlockedAt: Date(),
                category: .streaks
            ),
            Achievement(
                title: "Super Risparmiatore",
                achievementDescription: "Risparmia €500 in un mese",
                icon: "crown.fill",
                isUnlocked: false,
                category: .savings
            ),
            Achievement(
                title: "Maestro del Budget",
                achievementDescription: "Rispetta il budget per 30 giorni",
                icon: "medal.fill",
                isUnlocked: false,
                category: .consistency
            )
        ]
    }

    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }

    var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }

    var pointsToNextLevel: Int {
        let nextLevelPoints = (level + 1) * 500
        let currentLevelPoints = level * 500
        return nextLevelPoints - currentLevelPoints
    }

    var currentLevelPoints: Int {
        Int(Double(pointsToNextLevel) * levelProgress)
    }
}
