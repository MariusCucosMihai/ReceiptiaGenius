//
//  GeniusView.swift
//  Receiptia
//
//  Genius Tab - Analytics and Insights
//

import SwiftUI

struct GeniusView: View {
    @State private var viewModel = GeniusViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // AI Coach Input Bar
                    CoachInputBar()

                    // Objectives Card
                    ObjectivesCardView(
                        goals: viewModel.goals,
                        completedCount: viewModel.completedGoalsCount,
                        totalCount: viewModel.totalGoalsCount
                    )

                    // Spending Trend Chart
                    SpendingChartView(
                        weeklySpending: viewModel.weeklySpending,
                        weekDateRange: viewModel.weekDateRange
                    )

                    // Comparison Card
                    ComparisonCardView(comparison: viewModel.spendingComparison)

                    // Share Card
                    ShareWrappedCard(onShare: viewModel.shareWrapped)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color.appBackground)
            .navigationTitle("Genius")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct CoachInputBar: View {
    @State private var inputText = ""
    @FocusState private var isFocused: Bool
    @State private var showingCoachResponse = false

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 20))
                    .foregroundColor(.accentGreen)

                TextField("Chiedi al tuo coach AI...", text: $inputText)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .focused($isFocused)

                if !inputText.isEmpty {
                    Button {
                        sendToCoach()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.accentGreen)
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isFocused ? Color.accentGreen.opacity(0.5) : Color.clear, lineWidth: 1)
            )

            // Suggestion Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CoachSuggestionChip(text: "Dove posso comprare eticamente?") {
                        inputText = "Dove posso comprare eticamente?"
                    }
                    CoachSuggestionChip(text: "Come ridurre le spese?") {
                        inputText = "Come ridurre le spese?"
                    }
                    CoachSuggestionChip(text: "Analizza i miei acquisti") {
                        inputText = "Analizza i miei acquisti"
                    }
                }
            }
        }
        .sheet(isPresented: $showingCoachResponse) {
            CoachResponseView(query: inputText)
        }
    }

    private func sendToCoach() {
        guard !inputText.isEmpty else { return }
        showingCoachResponse = true
        isFocused = false
    }
}

struct CoachSuggestionChip: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.cardBackgroundLight)
                .clipShape(Capsule())
        }
    }
}

struct CoachResponseView: View {
    let query: String
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var response: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 24) {
                    // Query
                    HStack {
                        Text(query)
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)
                            .padding(16)
                            .background(Color.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                        Spacer()
                    }
                    .padding(.horizontal)

                    // Response
                    if isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .tint(.accentGreen)

                            Text("Il tuo coach sta pensando...")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            HStack {
                                Spacer()

                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "sparkles")
                                            .foregroundColor(.accentGreen)
                                        Text("Genius Coach")
                                            .font(.labelMedium)
                                            .foregroundColor(.accentGreen)
                                    }

                                    Text(response)
                                        .font(.bodyMedium)
                                        .foregroundColor(.textPrimary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(16)
                                .background(
                                    LinearGradient(
                                        colors: [Color.accentGreen.opacity(0.1), Color.cardBackground],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal)
                        }
                    }

                    Spacer()
                }
                .padding(.top, 24)
            }
            .navigationTitle("Coach AI")
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
        .onAppear {
            generateResponse()
        }
    }

    private func generateResponse() {
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            response = generateCoachResponse(for: query)
            isLoading = false
        }
    }

    private func generateCoachResponse(for query: String) -> String {
        let lowercasedQuery = query.lowercased()

        if lowercasedQuery.contains("etico") || lowercasedQuery.contains("eticamente") {
            return """
            Ottima domanda! Ecco alcuni suggerimenti per acquisti più etici:

            🌿 **Negozi locali**: Supporta i piccoli commercianti nella tua zona. Oltre ad essere più sostenibile, spesso offrono prodotti di qualità superiore.

            🔄 **Second-hand**: App come Vinted o Wallapop sono ottime per trovare capi di abbigliamento usati in ottimo stato.

            🏷️ **Certificazioni**: Cerca prodotti con certificazioni come Fair Trade, B Corp, o biologico.

            📍 **Km Zero**: Per il cibo, i mercati contadini sono un'ottima scelta.

            Vuoi che ti aiuti a trovare alternative etiche per una categoria specifica?
            """
        } else if lowercasedQuery.contains("ridurre") || lowercasedQuery.contains("spese") || lowercasedQuery.contains("risparmi") {
            return """
            Ho analizzato le tue spese e ho alcuni consigli personalizzati:

            💡 **Acquisti notturni**: Il 60% delle tue spese impulsive avviene dopo le 22:00. Prova ad attivare la modalità "Non disturbare" per le notifiche di shopping.

            📱 **Abbonamenti**: Hai 3 abbonamenti attivi per €45/mese. Verifica se li usi davvero tutti.

            🛒 **Lista della spesa**: Prima di ogni acquisto, aspetta 24 ore. Se lo desideri ancora, probabilmente ne hai davvero bisogno.

            🎯 **Budget settimanale**: Imposta un limite di €150/settimana e monitora i progressi qui in app.

            Risparmio potenziale stimato: **€150-200/mese**
            """
        } else if lowercasedQuery.contains("analizza") || lowercasedQuery.contains("acquisti") {
            return """
            Ecco l'analisi dei tuoi acquisti questa settimana:

            📊 **Totale speso**: €171,50
            📈 **Media giornaliera**: €24,50
            🏆 **Giorno migliore**: Lunedì (€10)
            ⚠️ **Giorno critico**: Mercoledì (€82)

            **Categorie principali:**
            • Shopping: 45%
            • Cibo: 30%
            • Intrattenimento: 25%

            **Pattern rilevati:**
            • Picco di spesa a metà settimana
            • Acquisti impulsivi dopo cena

            Stai facendo progressi! Sei più disciplinato del 60% degli utenti.
            """
        } else {
            return """
            Sono qui per aiutarti a gestire meglio le tue finanze! 💚

            Posso aiutarti con:
            • Analisi delle tue spese
            • Consigli per risparmiare
            • Suggerimenti per acquisti etici
            • Impostazione di obiettivi finanziari

            Cosa vorresti approfondire?
            """
        }
    }
}

#Preview {
    GeniusView()
        .preferredColorScheme(.dark)
}
