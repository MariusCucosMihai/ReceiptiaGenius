//
//  Goal.swift
//  Receiptia
//
//  Data Model for User Goals and Achievements
//

import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID
    var title: String
    var goalDescription: String
    var isCompleted: Bool
    var isLocked: Bool
    var order: Int
    var icon: String
    var rewardDescription: String?
    var completedAt: Date?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        goalDescription: String,
        isCompleted: Bool = false,
        isLocked: Bool = false,
        order: Int,
        icon: String,
        rewardDescription: String? = nil,
        completedAt: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.goalDescription = goalDescription
        self.isCompleted = isCompleted
        self.isLocked = isLocked
        self.order = order
        self.icon = icon
        self.rewardDescription = rewardDescription
        self.completedAt = completedAt
        self.createdAt = createdAt
    }
}

struct GoalMilestone: Identifiable {
    let id: UUID
    let title: String
    let isCompleted: Bool
    let isLocked: Bool
    let order: Int
    let icon: String

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        isLocked: Bool = false,
        order: Int,
        icon: String
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.isLocked = isLocked
        self.order = order
        self.icon = icon
    }
}
