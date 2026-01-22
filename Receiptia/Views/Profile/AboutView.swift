//
//  AboutView.swift
//  Receiptia
//
//  About the app view
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // App Icon and Name
                VStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [.accentGreen, .accentTeal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        Image(systemName: "sparkles")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.appBackground)
                    }

                    VStack(spacing: 4) {
                        Text("Receiptia Genius")
                            .font(.cardTitle)
                            .foregroundColor(.textPrimary)

                        Text("Versione 1.0.0")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(.top, 32)

                // Description
                CardContainer {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Spotify Wrapped per le tue spese")
                            .font(.labelLarge)
                            .foregroundColor(.accentGreen)

                        Text("Receiptia Genius trasforma il tracking delle spese da un'esperienza punitiva in un viaggio coinvolgente e motivazionale. L'app ti fa sentire compreso e potenziato, non giudicato.")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal)

                // Features
                VStack(spacing: 12) {
                    FeatureRow(icon: "brain.head.profile", title: "AI Coaching", description: "Consigli personalizzati non giudicanti")
                    FeatureRow(icon: "moon.fill", title: "Pattern Detection", description: "Rileva acquisti notturni e compulsivi")
                    FeatureRow(icon: "trophy.fill", title: "Gamification", description: "Obiettivi e premi per motivarti")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Analytics", description: "Visualizza i tuoi trend di spesa")
                    FeatureRow(icon: "lock.shield.fill", title: "Privacy First", description: "I tuoi dati restano sul dispositivo")
                }
                .padding(.horizontal)

                // Links
                CardContainer {
                    VStack(spacing: 0) {
                        AboutLinkRow(icon: "star.fill", title: "Valuta l'app", action: openAppStore)
                        Divider().background(Color.cardBackgroundLight)
                        AboutLinkRow(icon: "envelope.fill", title: "Contattaci", action: openEmail)
                        Divider().background(Color.cardBackgroundLight)
                        AboutLinkRow(icon: "doc.text.fill", title: "Termini di servizio", action: openTerms)
                        Divider().background(Color.cardBackgroundLight)
                        AboutLinkRow(icon: "hand.raised.fill", title: "Privacy Policy", action: openPrivacy)
                    }
                }
                .padding(.horizontal)

                // Copyright
                Text("© 2026 Receiptia Genius. Tutti i diritti riservati.")
                    .font(.caption)
                    .foregroundColor(.textTertiary)
                    .padding(.bottom, 32)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func openAppStore() {
        // Open App Store review page
    }

    private func openEmail() {
        if let url = URL(string: "mailto:support@receiptia.app") {
            UIApplication.shared.open(url)
        }
    }

    private func openTerms() {
        if let url = URL(string: "https://receiptia.app/terms") {
            UIApplication.shared.open(url)
        }
    }

    private func openPrivacy() {
        if let url = URL(string: "https://receiptia.app/privacy") {
            UIApplication.shared.open(url)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        CardContainer(padding: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.accentGreen.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.accentGreen)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.labelLarge)
                        .foregroundColor(.textPrimary)

                    Text(description)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }

                Spacer()
            }
        }
    }
}

struct AboutLinkRow: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.accentGreen)
                    .frame(width: 24)

                Text(title)
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(16)
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
    .preferredColorScheme(.dark)
}
