//
//  ContentView.swift
//  Receiptia
//
//  Main entry point view
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Expense.self, Goal.self, UserProfile.self], inMemory: true)
}
