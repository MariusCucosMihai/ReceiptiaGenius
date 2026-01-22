//
//  RewardsView.swift
//  Receiptia
//
//  Rewards and Achievements Tab
//

import SwiftUI

struct RewardsView: View {
    @State private var viewModel = RewardsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Level Progress Card
                    LevelProgressCard(
                        level: viewModel.level,
                        progress: viewModel.levelProgress,
                        currentPoints: viewModel.currentLevelPoints,
                        totalPoints: viewModel.pointsToNextLevel
                    )

                    // Stats Row
                    StatsRowView(
                        streak: viewModel.currentStreak,
                        totalPoints: viewModel.totalPoints,
                        achievements: viewModel.unlockedAchievements.count
                    )

                    // Unlocked Achievements
                    if !viewModel.unlockedAchievements.isEmpty {
                        AchievementsSectionView(
                            title: "Traguardi sbloccati",
                            achievements: viewModel.unlockedAchievements,
                            isLocked: false
                        )
                    }

                    // Locked Achievements
                    if !viewModel.lockedAchievements.isEmpty {
                        AchievementsSectionView(
                            title: "Prossimi traguardi",
                            achievements: viewModel.lockedAchievements,
                            isLocked: true
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color.appBackground)
            .navigationTitle("Premi")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct LevelProgressCard: View {
    let level: Int
    let progress: Double
    let currentPoints: Int
    let totalPoints: Int

    var body: some View {
        CardContainer {
            VStack(spacing: 20) {
                // Level Badge
                HStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.accentGreen, .accentTeal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 72, height: 72)

                        VStack(spacing: 0) {
                            Text("LV")
                                .font(.caption)
                                .foregroundColor(.appBackground.opacity(0.7))

                            Text("\(level)")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.appBackground)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Livello \(level)")
                            .font(.cardTitleSmall)
                            .foregroundColor(.textPrimary)

                        Text("\(currentPoints)/\(totalPoints) punti per il prossimo livello")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                }

                // Progress Bar
                VStack(spacing: 8) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.cardBackgroundLight)
                                .frame(height: 12)

                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [.accentGreen, .accentTeal],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * progress, height: 12)
                                .animation(.easeInOut(duration: 0.5), value: progress)
                        }
                    }
                    .frame(height: 12)

                    HStack {
                        Text("Livello \(level)")
                            .font(.caption)
                            .foregroundColor(.textTertiary)

                        Spacer()

                        Text("Livello \(level + 1)")
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                }
            }
        }
    }
}

struct StatsRowView: View {
    let streak: Int
    let totalPoints: Int
    let achievements: Int

    var body: some View {
        HStack(spacing: 12) {
            StatCard(icon: "flame.fill", value: "\(streak)", label: "Giorni", color: .alertRed)
            StatCard(icon: "star.fill", value: "\(totalPoints)", label: "Punti", color: .warningYellow)
            StatCard(icon: "trophy.fill", value: "\(achievements)", label: "Traguardi", color: .accentGreen)
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        CardContainer(padding: 16) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)

                Text(value)
                    .font(.numberSmall)
                    .foregroundColor(.textPrimary)

                Text(label)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct AchievementsSectionView: View {
    let title: String
    let achievements: [Achievement]
    let isLocked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.cardTitleSmall)
                .foregroundColor(.textPrimary)

            VStack(spacing: 12) {
                ForEach(achievements) { achievement in
                    AchievementCard(achievement: achievement, isLocked: isLocked)
                }
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isLocked: Bool

    var body: some View {
        CardContainer {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isLocked ? Color.cardBackgroundLight : Color.warningYellow.opacity(0.2))
                        .frame(width: 56, height: 56)

                    Image(systemName: achievement.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isLocked ? .textTertiary : .warningYellow)
                }

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.title)
                        .font(.labelLarge)
                        .foregroundColor(isLocked ? .textSecondary : .textPrimary)

                    Text(achievement.achievementDescription)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)

                    if let date = achievement.unlockedAt {
                        Text(formattedDate(date))
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }
                }

                Spacer()

                if !isLocked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentGreen)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .opacity(isLocked ? 0.7 : 1)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    RewardsView()
        .preferredColorScheme(.dark)
}
