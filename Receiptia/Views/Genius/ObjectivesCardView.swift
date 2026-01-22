//
//  ObjectivesCardView.swift
//  Receiptia
//
//  Objectives progress card with milestones
//

import SwiftUI

struct ObjectivesCardView: View {
    let goals: [GoalMilestone]
    let completedCount: Int
    let totalCount: Int

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("I tuoi obiettivi")
                            .font(.cardTitleSmall)
                            .foregroundColor(.textPrimary)

                        Text("Completa un obiettivo per ricevere un premio")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    // Progress Badge
                    HStack(spacing: 6) {
                        ProgressRing(progress: Double(completedCount) / Double(totalCount), lineWidth: 4, size: 36)

                        Text("\(completedCount)/\(totalCount)")
                            .font(.labelLarge)
                            .foregroundColor(.accentGreen)
                    }
                }

                // Milestone Progress Track
                MilestoneTrackView(goals: goals)
            }
        }
    }
}

struct MilestoneTrackView: View {
    let goals: [GoalMilestone]

    var body: some View {
        VStack(spacing: 12) {
            // Progress Line with Milestones
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let stepWidth = totalWidth / CGFloat(goals.count)

                ZStack(alignment: .leading) {
                    // Background Line
                    Rectangle()
                        .fill(Color.cardBackgroundLight)
                        .frame(height: 4)
                        .offset(y: 18)

                    // Progress Line
                    Rectangle()
                        .fill(Color.accentGreen)
                        .frame(width: progressWidth(totalWidth: totalWidth, stepWidth: stepWidth), height: 4)
                        .offset(y: 18)

                    // Milestones
                    HStack(spacing: 0) {
                        ForEach(goals) { goal in
                            MilestoneIcon(goal: goal)
                                .frame(width: stepWidth)
                        }
                    }
                }
            }
            .frame(height: 44)

            // Labels
            HStack(spacing: 0) {
                ForEach(goals) { goal in
                    Text(goal.title)
                        .font(.caption)
                        .foregroundColor(goal.isCompleted ? .accentGreen : (goal.isLocked ? .textTertiary : .textSecondary))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private func progressWidth(totalWidth: CGFloat, stepWidth: CGFloat) -> CGFloat {
        let completedCount = goals.filter { $0.isCompleted }.count
        guard completedCount > 0 else { return 0 }

        let halfStep = stepWidth / 2
        return halfStep + (CGFloat(completedCount - 1) * stepWidth) + halfStep
    }
}

struct MilestoneIcon: View {
    let goal: GoalMilestone

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 36, height: 36)

            if goal.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.appBackground)
            } else if goal.isLocked {
                Image(systemName: "lock.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
            } else {
                Circle()
                    .fill(Color.textSecondary)
                    .frame(width: 12, height: 12)
            }
        }
    }

    private var backgroundColor: Color {
        if goal.isCompleted {
            return .accentGreen
        } else if goal.isLocked {
            return .cardBackgroundLight
        } else {
            return .cardBackgroundElevated
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        ObjectivesCardView(
            goals: GeniusViewModel.createSampleGoals(),
            completedCount: 2,
            totalCount: 5
        )
        .padding()
    }
    .preferredColorScheme(.dark)
}
