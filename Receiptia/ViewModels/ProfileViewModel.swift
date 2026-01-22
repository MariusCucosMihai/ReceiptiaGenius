//
//  ProfileViewModel.swift
//  Receiptia
//
//  ViewModel for Profile Tab
//

import Foundation
import SwiftUI

@Observable
final class ProfileViewModel {
    var userName: String = "Marco"
    var userEmail: String = "marco@example.com"
    var userInitials: String = "MA"
    var monthlyBudget: Double = 1500
    var notificationsEnabled: Bool = true
    var nightPurchaseAlerts: Bool = true
    var weeklyReportEnabled: Bool = true

    var memberSince: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date().addingTimeInterval(-86400 * 90))
    }

    var formattedBudget: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "it_IT")
        return formatter.string(from: NSNumber(value: monthlyBudget)) ?? "€0"
    }

    struct SettingsSection: Identifiable {
        let id = UUID()
        let title: String
        let items: [SettingsItem]
    }

    struct SettingsItem: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let subtitle: String?
        let type: SettingsItemType

        init(icon: String, title: String, subtitle: String? = nil, type: SettingsItemType = .navigation) {
            self.icon = icon
            self.title = title
            self.subtitle = subtitle
            self.type = type
        }
    }

    enum SettingsItemType {
        case navigation
        case toggle
        case destructive
    }

    var settingsSections: [SettingsSection] {
        [
            SettingsSection(title: "Account", items: [
                SettingsItem(icon: "person.fill", title: "Profilo", subtitle: userName),
                SettingsItem(icon: "eurosign.circle.fill", title: "Budget mensile", subtitle: formattedBudget),
                SettingsItem(icon: "creditcard.fill", title: "Metodi di pagamento")
            ]),
            SettingsSection(title: "Notifiche", items: [
                SettingsItem(icon: "bell.fill", title: "Notifiche push", type: .toggle),
                SettingsItem(icon: "moon.fill", title: "Avvisi acquisti notturni", type: .toggle),
                SettingsItem(icon: "chart.bar.fill", title: "Report settimanale", type: .toggle)
            ]),
            SettingsSection(title: "Privacy e Sicurezza", items: [
                SettingsItem(icon: "lock.fill", title: "Privacy"),
                SettingsItem(icon: "shield.fill", title: "Sicurezza"),
                SettingsItem(icon: "doc.text.fill", title: "Termini di servizio"),
                SettingsItem(icon: "hand.raised.fill", title: "Informativa privacy")
            ]),
            SettingsSection(title: "Supporto", items: [
                SettingsItem(icon: "questionmark.circle.fill", title: "Centro assistenza"),
                SettingsItem(icon: "envelope.fill", title: "Contattaci"),
                SettingsItem(icon: "star.fill", title: "Valuta l'app")
            ]),
            SettingsSection(title: "", items: [
                SettingsItem(icon: "rectangle.portrait.and.arrow.right", title: "Esci", type: .destructive)
            ])
        ]
    }
}
