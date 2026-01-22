//
//  ReceiptiaApp.swift
//  Receiptia
//
//  Receiptia Genius - AI-Powered Financial Coaching App
//  "Spotify Wrapped for your expenses"
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct ReceiptiaApp: App {
    @State private var authManager = AuthManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Expense.self,
            Goal.self,
            UserProfile.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        configureAppearance()
        requestNotificationPermissions()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
        }
        .modelContainer(sharedModelContainer)
    }

    private func configureAppearance() {
        // Hide default tab bar
        UITabBar.appearance().isHidden = true

        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.appBackground)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance

        // Configure table view appearance for Lists
        UITableView.appearance().backgroundColor = .clear
    }

    private func requestNotificationPermissions() {
        Task {
            let granted = await NotificationService.shared.requestAuthorization()
            if granted {
                NotificationService.shared.scheduleWeeklyReport()
            }
        }
    }
}
