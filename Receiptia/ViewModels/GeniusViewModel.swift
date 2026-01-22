//
//  GeniusViewModel.swift
//  Receiptia
//
//  ViewModel for Genius Tab
//

import Foundation
import SwiftUI

@Observable
final class GeniusViewModel {
    var goals: [GoalMilestone]
    var weeklySpending: WeeklySpending
    var spendingComparison: SpendingComparison
    var completedGoalsCount: Int
    var totalGoalsCount: Int

    init() {
        self.goals = Self.createSampleGoals()
        self.weeklySpending = Self.createSampleWeeklySpending()
        self.spendingComparison = Self.createSampleComparison()
        self.completedGoalsCount = 2
        self.totalGoalsCount = 5
    }

    static func createSampleGoals() -> [GoalMilestone] {
        [
            GoalMilestone(title: "Budget rispettato", isCompleted: true, order: 1, icon: "checkmark.circle.fill"),
            GoalMilestone(title: "Zero spese inutili", isCompleted: true, order: 2, icon: "checkmark.circle.fill"),
            GoalMilestone(title: "Abbonamenti ridotti", isCompleted: false, isLocked: true, order: 3, icon: "lock.fill"),
            GoalMilestone(title: "Risparmio €100", isCompleted: false, isLocked: true, order: 4, icon: "lock.fill"),
            GoalMilestone(title: "Risparmio €200", isCompleted: false, isLocked: true, order: 5, icon: "lock.fill")
        ]
    }

    static func createSampleWeeklySpending() -> WeeklySpending {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        let dailyData: [(String, Double)] = [
            ("L", 10),
            ("M", 8),
            ("M", 82),
            ("G", 12),
            ("V", 35),
            ("S", 9.5),
            ("D", 15)
        ]

        let dailySpending = dailyData.enumerated().map { index, data in
            DailySpending(
                date: calendar.date(byAdding: .day, value: index, to: startOfWeek)!,
                amount: data.1,
                dayAbbreviation: data.0
            )
        }

        return WeeklySpending(
            weekStartDate: startOfWeek,
            weekEndDate: calendar.date(byAdding: .day, value: 6, to: startOfWeek)!,
            dailySpending: dailySpending
        )
    }

    static func createSampleComparison() -> SpendingComparison {
        SpendingComparison(
            userPercentile: 60,
            comparisonMessage: "Sei stato più disciplinato del 60% degli utenti questa settimana",
            isPositive: true
        )
    }

    var weekDateRange: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateFormat = "d"

        let startDay = formatter.string(from: weeklySpending.weekStartDate)

        formatter.dateFormat = "d MMMM"
        let endDay = formatter.string(from: weeklySpending.weekEndDate)

        return "Settimana \(startDay)-\(endDay)"
    }

    func shareWrapped() {
        // Share functionality
    }
}
