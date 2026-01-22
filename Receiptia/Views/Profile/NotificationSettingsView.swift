//
//  NotificationSettingsView.swift
//  Receiptia
//
//  Notification preferences settings
//

import SwiftUI

struct NotificationSettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("compulsiveWarningsEnabled") private var compulsiveWarningsEnabled = true
    @AppStorage("weeklyReportsEnabled") private var weeklyReportsEnabled = true
    @AppStorage("goalRemindersEnabled") private var goalRemindersEnabled = true
    @AppStorage("ethicalSuggestionsEnabled") private var ethicalSuggestionsEnabled = true

    var body: some View {
        List {
            Section {
                Toggle("Abilita Notifiche", isOn: $notificationsEnabled)
                    .tint(.accentGreen)
            } header: {
                Text("Generale")
            }

            Section {
                Toggle("Avvisi Acquisti Compulsivi", isOn: $compulsiveWarningsEnabled)
                    .tint(.accentGreen)
                    .disabled(!notificationsEnabled)

                Toggle("Report Settimanali", isOn: $weeklyReportsEnabled)
                    .tint(.accentGreen)
                    .disabled(!notificationsEnabled)

                Toggle("Promemoria Obiettivi", isOn: $goalRemindersEnabled)
                    .tint(.accentGreen)
                    .disabled(!notificationsEnabled)

                Toggle("Suggerimenti Etici", isOn: $ethicalSuggestionsEnabled)
                    .tint(.accentGreen)
                    .disabled(!notificationsEnabled)
            } header: {
                Text("Tipi di Notifiche")
            } footer: {
                Text("Gli avvisi per acquisti compulsivi ti aiutano a riflettere prima di spese impulsive")
                    .foregroundColor(.textTertiary)
            }

            Section {
                NotificationTimeRow(
                    title: "Report Settimanale",
                    subtitle: "Ogni Lunedì alle 9:00"
                )

                NotificationTimeRow(
                    title: "Promemoria Obiettivi",
                    subtitle: "Ogni giorno alle 10:00"
                )
            } header: {
                Text("Orari")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("Notifiche")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: weeklyReportsEnabled) { _, newValue in
            if newValue {
                NotificationService.shared.scheduleWeeklyReport()
            }
        }
    }
}

struct NotificationTimeRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)

                Text(subtitle)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            Image(systemName: "clock.fill")
                .foregroundColor(.accentGreen)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
    .preferredColorScheme(.dark)
}
