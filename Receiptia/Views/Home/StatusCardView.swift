//
//  StatusCardView.swift
//  Receiptia
//
//  Main Status Card showing spending status
//

import SwiftUI

struct StatusCardView: View {
    let status: SpendingStatus

    var body: some View {
        CardContainer(padding: 24) {
            VStack(alignment: .leading, spacing: 20) {
                // Hero Status Text
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        Text(statusTextPrefix)
                            .font(.heroMedium)
                            .foregroundColor(.textPrimary)

                        Text(" \(status.highlightedWord) ")
                            .font(.heroMedium)
                            .foregroundColor(.accentGreen)

                        Text(statusTextSuffix)
                            .font(.heroMedium)
                            .foregroundColor(.textPrimary)
                    }
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                }

                // Amount Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(formattedAmount)
                            .font(.numberMedium)
                            .foregroundColor(.textPrimary)

                        Text("nelle ultime 24h")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }

                    // Comparison Indicator
                    HStack(spacing: 6) {
                        Image(systemName: status.isSpendingLess ? "arrow.down.right" : "arrow.up.right")
                            .font(.system(size: 14, weight: .bold))

                        Text(status.comparisonText)
                            .font(.labelMedium)
                    }
                    .foregroundColor(status.isSpendingLess ? .accentGreen : .alertRed)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        (status.isSpendingLess ? Color.accentGreen : Color.alertRed).opacity(0.15)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private var statusTextPrefix: String {
        let message = status.statusMessage
        guard let range = message.range(of: status.highlightedWord) else {
            return message
        }
        return String(message[..<range.lowerBound])
    }

    private var statusTextSuffix: String {
        let message = status.statusMessage
        guard let range = message.range(of: status.highlightedWord) else {
            return ""
        }
        return String(message[range.upperBound...])
    }

    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.locale = Locale(identifier: "it_IT")
        return formatter.string(from: NSNumber(value: status.amountLast24h)) ?? "€0,00"
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        StatusCardView(status: SpendingStatus(
            amountLast24h: 300.15,
            comparisonYesterday: -45,
            isSpendingLess: true,
            statusMessage: "Stai spendendo meno del solito",
            highlightedWord: "meno"
        ))
        .padding()
    }
    .preferredColorScheme(.dark)
}
