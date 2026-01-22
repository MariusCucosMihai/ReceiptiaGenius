//
//  ProfileView.swift
//  Receiptia
//
//  Profile and Settings Tab
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var notificationsEnabled: Bool = true
    @State private var nightAlertsEnabled: Bool = true
    @State private var weeklyReportEnabled: Bool = true

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Profile Header
                    ProfileHeaderView(
                        name: viewModel.userName,
                        email: viewModel.userEmail,
                        initials: viewModel.userInitials,
                        memberSince: viewModel.memberSince
                    )

                    // Settings Sections
                    ForEach(viewModel.settingsSections) { section in
                        if !section.title.isEmpty {
                            SettingsSectionView(
                                section: section,
                                notificationsEnabled: $notificationsEnabled,
                                nightAlertsEnabled: $nightAlertsEnabled,
                                weeklyReportEnabled: $weeklyReportEnabled
                            )
                        } else {
                            // Logout section (no title)
                            SettingsSectionView(
                                section: section,
                                notificationsEnabled: $notificationsEnabled,
                                nightAlertsEnabled: $nightAlertsEnabled,
                                weeklyReportEnabled: $weeklyReportEnabled
                            )
                        }
                    }

                    // App Version
                    Text("Receiptia Genius v1.0.0")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color.appBackground)
            .navigationTitle("Profilo")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct ProfileHeaderView: View {
    let name: String
    let email: String
    let initials: String
    let memberSince: String

    var body: some View {
        CardContainer {
            HStack(spacing: 16) {
                // Avatar
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

                    Text(initials)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.appBackground)
                }

                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.cardTitleSmall)
                        .foregroundColor(.textPrimary)

                    Text(email)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)

                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)

                        Text("Membro da \(memberSince)")
                            .font(.caption)
                    }
                    .foregroundColor(.textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
        }
    }
}

struct SettingsSectionView: View {
    let section: ProfileViewModel.SettingsSection
    @Binding var notificationsEnabled: Bool
    @Binding var nightAlertsEnabled: Bool
    @Binding var weeklyReportEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !section.title.isEmpty {
                Text(section.title)
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)
                    .padding(.leading, 4)
            }

            CardContainer(padding: 0) {
                VStack(spacing: 0) {
                    ForEach(Array(section.items.enumerated()), id: \.element.id) { index, item in
                        SettingsItemRow(
                            item: item,
                            notificationsEnabled: $notificationsEnabled,
                            nightAlertsEnabled: $nightAlertsEnabled,
                            weeklyReportEnabled: $weeklyReportEnabled
                        )

                        if index < section.items.count - 1 {
                            Divider()
                                .background(Color.cardBackgroundLight)
                                .padding(.leading, 56)
                        }
                    }
                }
            }
        }
    }
}

struct SettingsItemRow: View {
    let item: ProfileViewModel.SettingsItem
    @Binding var notificationsEnabled: Bool
    @Binding var nightAlertsEnabled: Bool
    @Binding var weeklyReportEnabled: Bool

    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 36, height: 36)

                Image(systemName: item.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
            }

            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.bodyLarge)
                    .foregroundColor(titleColor)

                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
            }

            Spacer()

            // Trailing
            switch item.type {
            case .navigation:
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)

            case .toggle:
                Toggle("", isOn: toggleBinding)
                    .tint(.accentGreen)
                    .labelsHidden()

            case .destructive:
                EmptyView()
            }
        }
        .padding(16)
        .contentShape(Rectangle())
    }

    private var iconBackgroundColor: Color {
        switch item.type {
        case .destructive:
            return .alertRed.opacity(0.15)
        default:
            return .cardBackgroundLight
        }
    }

    private var iconColor: Color {
        switch item.type {
        case .destructive:
            return .alertRed
        default:
            return .textSecondary
        }
    }

    private var titleColor: Color {
        switch item.type {
        case .destructive:
            return .alertRed
        default:
            return .textPrimary
        }
    }

    private var toggleBinding: Binding<Bool> {
        switch item.title {
        case "Notifiche push":
            return $notificationsEnabled
        case "Avvisi acquisti notturni":
            return $nightAlertsEnabled
        case "Report settimanale":
            return $weeklyReportEnabled
        default:
            return .constant(false)
        }
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}
