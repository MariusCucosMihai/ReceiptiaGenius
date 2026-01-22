//
//  ComparisonCardView.swift
//  Receiptia
//
//  User comparison card showing percentile ranking
//

import SwiftUI

struct ComparisonCardView: View {
    let comparison: SpendingComparison

    var body: some View {
        CardContainer(backgroundColor: .accentGreen.opacity(0.15)) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentGreen.opacity(0.2))
                        .frame(width: 56, height: 56)

                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.accentGreen)
                }

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text("Il tuo confronto")
                        .font(.labelMedium)
                        .foregroundColor(.accentGreen)

                    Text(comparison.displayMessage)
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentGreen.opacity(0.3), lineWidth: 1)
        )
    }
}

struct ShareWrappedCard: View {
    let onShare: () -> Void

    var body: some View {
        Button(action: onShare) {
            CardContainer {
                HStack(spacing: 16) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color.accentTeal.opacity(0.15))
                            .frame(width: 48, height: 48)

                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.accentTeal)
                    }

                    // Content
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Condividi il tuo Genius Wrapped")
                            .font(.labelLarge)
                            .foregroundColor(.textPrimary)

                        Text("Mostra i tuoi progressi agli amici")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textTertiary)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        VStack(spacing: 16) {
            ComparisonCardView(comparison: SpendingComparison(
                userPercentile: 60,
                comparisonMessage: "Sei stato più disciplinato del 60% degli utenti questa settimana",
                isPositive: true
            ))

            ShareWrappedCard(onShare: {})
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
