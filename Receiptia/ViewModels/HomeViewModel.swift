//
//  HomeViewModel.swift
//  Receiptia
//
//  ViewModel for Home Tab
//

import Foundation
import SwiftUI

@Observable
final class HomeViewModel {
    var spendingStatus: SpendingStatus
    var insights: [Insight]
    var isLoading: Bool = false

    init() {
        self.spendingStatus = Self.createSampleSpendingStatus()
        self.insights = Self.createSampleInsights()
    }

    static func createSampleSpendingStatus() -> SpendingStatus {
        SpendingStatus(
            amountLast24h: 300.15,
            comparisonYesterday: -45,
            isSpendingLess: true,
            statusMessage: "Stai spendendo meno del solito",
            highlightedWord: "meno"
        )
    }

    static func createSampleInsights() -> [Insight] {
        [
            Insight(
                icon: "moon.fill",
                title: "Acquisti notturni",
                description: "Il 60% delle tue spese compulsive avviene dopo le 22:00",
                type: .nightPurchase,
                actionSuggestion: "Blocca le notifiche shopping di sera?",
                potentialSavings: 150
            ),
            Insight(
                icon: "brain.head.profile",
                title: "Suggerimento Smart",
                description: "Blocca le notifiche shopping di sera?",
                type: .smartSuggestion,
                actionSuggestion: "Attiva la modalità focus dopo le 22:00"
            ),
            Insight(
                icon: "eurosign.circle.fill",
                title: "Potenziale risparmio",
                description: "Avresti potuto risparmiare €150/mese evitando acquisti notturni",
                type: .savingsOpportunity,
                potentialSavings: 150
            )
        ]
    }

    func refreshData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isLoading = false
        }
    }
}
