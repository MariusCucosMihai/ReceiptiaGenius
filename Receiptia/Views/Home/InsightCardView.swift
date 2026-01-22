//
//  InsightCardView.swift
//  Receiptia
//
//  Individual Insight Card component
//

import SwiftUI

struct InsightCardView: View {
    let insight: Insight

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Emoji/Icon Badge
            ZStack {
                Circle()
                    .fill(Color(hex: insight.type.accentColorHex).opacity(0.15))
                    .frame(width: 44, height: 44)

                Text(insight.type.emoji)
                    .font(.system(size: 20))
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.labelLarge)
                    .foregroundColor(.textPrimary)

                Text(insight.description)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(14)
        .background(Color.cardBackgroundLight.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InsightsDetailView: View {
    let insights: [Insight]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(insights) { insight in
                        InsightDetailCard(insight: insight)
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("I tuoi Insights")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                    .foregroundColor(.accentGreen)
                }
            }
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct InsightDetailCard: View {
    let insight: Insight

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: insight.type.accentColorHex).opacity(0.2))
                            .frame(width: 56, height: 56)

                        Text(insight.type.emoji)
                            .font(.system(size: 28))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(insight.title)
                            .font(.cardTitleSmall)
                            .foregroundColor(.textPrimary)

                        Text(insight.type.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.caption)
                            .foregroundColor(.textTertiary)
                    }

                    Spacer()
                }

                Text(insight.description)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if let suggestion = insight.actionSuggestion {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.warningYellow)

                        Text(suggestion)
                            .font(.labelMedium)
                            .foregroundColor(.textPrimary)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.warningYellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                if let savings = insight.potentialSavings {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Risparmio potenziale")
                                .font(.caption)
                                .foregroundColor(.textTertiary)

                            Text("€\(Int(savings))/mese")
                                .font(.numberSmall)
                                .foregroundColor(.accentGreen)
                        }

                        Spacer()

                        SecondaryButton(title: "Scopri come", icon: "arrow.right") {
                            // Action
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        InsightCardView(insight: Insight(
            icon: "moon.fill",
            title: "Acquisti notturni",
            description: "Il 60% delle tue spese compulsive avviene dopo le 22:00",
            type: .nightPurchase
        ))
        .padding()
    }
    .preferredColorScheme(.dark)
}
