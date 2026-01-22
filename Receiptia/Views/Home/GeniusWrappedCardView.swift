//
//  GeniusWrappedCardView.swift
//  Receiptia
//
//  Genius Wrapped insights card
//

import SwiftUI

struct GeniusWrappedCardView: View {
    let insights: [Insight]
    @State private var showAllInsights: Bool = false

    var body: some View {
        GradientCardContainer {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.accentTeal.opacity(0.2))
                            .frame(width: 44, height: 44)

                        Image(systemName: "sparkles")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.accentTeal)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Genius Wrapped")
                            .font(.cardTitleSmall)
                            .foregroundColor(.textPrimary)

                        Text("Il tuo comportamento questa settimana")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()
                }

                // Insights List
                VStack(spacing: 12) {
                    ForEach(insights) { insight in
                        InsightCardView(insight: insight)
                    }
                }

                // CTA Button
                Button(action: { showAllInsights = true }) {
                    Text("Esplora tutti i tuoi insights")
                        .font(.buttonLarge)
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.accentGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .sheet(isPresented: $showAllInsights) {
            InsightsDetailView(insights: insights)
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        GeniusWrappedCardView(insights: HomeViewModel.createSampleInsights())
            .padding()
    }
    .preferredColorScheme(.dark)
}
