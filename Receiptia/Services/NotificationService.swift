//
//  NotificationService.swift
//  Receiptia
//
//  Notification handling and scheduling
//

import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            if granted {
                await setupNotificationCategories()
            }
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    @MainActor
    func setupNotificationCategories() {
        // Compulsive warning category
        let pauseAction = UNNotificationAction(
            identifier: "PAUSE_SHOPPING",
            title: "Pausa di 5 minuti",
            options: []
        )

        let continueAction = UNNotificationAction(
            identifier: "CONTINUE_SHOPPING",
            title: "Continua comunque",
            options: []
        )

        let compulsiveCategory = UNNotificationCategory(
            identifier: "COMPULSIVE_WARNING",
            actions: [pauseAction, continueAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )

        // Weekly report category
        let viewAction = UNNotificationAction(
            identifier: "VIEW_REPORT",
            title: "Vedi Report",
            options: [.foreground]
        )

        let reportCategory = UNNotificationCategory(
            identifier: "WEEKLY_REPORT",
            actions: [viewAction],
            intentIdentifiers: [],
            options: []
        )

        // Goal reminder category
        let checkGoalAction = UNNotificationAction(
            identifier: "CHECK_GOAL",
            title: "Controlla Obiettivo",
            options: [.foreground]
        )

        let goalCategory = UNNotificationCategory(
            identifier: "GOAL_REMINDER",
            actions: [checkGoalAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([
            compulsiveCategory,
            reportCategory,
            goalCategory
        ])
    }

    func scheduleWeeklyReport() {
        let content = UNMutableNotificationContent()
        content.title = "📊 Il tuo Genius Wrapped è pronto!"
        content.body = "Scopri come hai speso questa settimana e ricevi consigli personalizzati"
        content.sound = .default
        content.categoryIdentifier = "WEEKLY_REPORT"

        // Every Monday at 9:00 AM
        var dateComponents = DateComponents()
        dateComponents.weekday = 2 // Monday
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "WEEKLY_REPORT",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleCompulsiveWarning(forAmount amount: Double) {
        let content = UNMutableNotificationContent()
        content.title = "⏸️ Fermati un attimo"
        content.body = "Stai per spendere €\(String(format: "%.2f", amount)). Vuoi prenderti un momento per riflettere?"
        content.sound = .default
        content.categoryIdentifier = "COMPULSIVE_WARNING"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "COMPULSIVE_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleGoalReminder(goalTitle: String, daysLeft: Int) {
        let content = UNMutableNotificationContent()
        content.title = "🎯 Promemoria Obiettivo"
        content.body = "Mancano \(daysLeft) giorni per completare: \(goalTitle)"
        content.sound = .default
        content.categoryIdentifier = "GOAL_REMINDER"

        // Tomorrow at 10:00 AM
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "GOAL_REMINDER_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
