//
//  GeneralSettingsView.swift
//  Receiptia
//
//  General app settings
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("currency") private var currency = "EUR"
    @AppStorage("language") private var language = "it"
    @AppStorage("hapticFeedback") private var hapticFeedback = true
    @AppStorage("soundEffects") private var soundEffects = true

    var body: some View {
        List {
            Section {
                Picker("Valuta", selection: $currency) {
                    Text("€ Euro").tag("EUR")
                    Text("$ Dollaro USA").tag("USD")
                    Text("£ Sterlina").tag("GBP")
                    Text("CHF Franco Svizzero").tag("CHF")
                }

                Picker("Lingua", selection: $language) {
                    Text("Italiano").tag("it")
                    Text("English").tag("en")
                    Text("Français").tag("fr")
                    Text("Deutsch").tag("de")
                    Text("Español").tag("es")
                }
            } header: {
                Text("Regione")
            }

            Section {
                Toggle("Feedback Aptico", isOn: $hapticFeedback)
                    .tint(.accentGreen)

                Toggle("Effetti Sonori", isOn: $soundEffects)
                    .tint(.accentGreen)
            } header: {
                Text("Feedback")
            } footer: {
                Text("Il feedback aptico ti avvisa quando completi un obiettivo o sblocchi un premio")
                    .foregroundColor(.textTertiary)
            }

            Section {
                NavigationLink {
                    BudgetSettingsView()
                } label: {
                    HStack {
                        Text("Budget Mensile")
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(formattedBudget)
                            .foregroundColor(.textSecondary)
                    }
                }

                NavigationLink {
                    CategorySettingsView()
                } label: {
                    Text("Categorie Spese")
                        .foregroundColor(.textPrimary)
                }
            } header: {
                Text("Budget")
            }

            Section {
                Button {
                    resetSettings()
                } label: {
                    Text("Ripristina Impostazioni")
                        .foregroundColor(.warningYellow)
                }
            } footer: {
                Text("Ripristina tutte le impostazioni ai valori predefiniti")
                    .foregroundColor(.textTertiary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("Impostazioni")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var formattedBudget: String {
        let budget = UserDefaults.standard.double(forKey: "monthlyBudget")
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: budget > 0 ? budget : 1500)) ?? "€1.500"
    }

    private func resetSettings() {
        currency = "EUR"
        language = "it"
        hapticFeedback = true
        soundEffects = true
    }
}

struct BudgetSettingsView: View {
    @AppStorage("monthlyBudget") private var monthlyBudget: Double = 1500
    @State private var budgetText: String = ""

    var body: some View {
        List {
            Section {
                HStack {
                    Text("€")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textSecondary)

                    TextField("1500", text: $budgetText)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                .padding(.vertical, 8)
            } header: {
                Text("Budget Mensile")
            } footer: {
                Text("Imposta il tuo limite di spesa mensile per ricevere avvisi quando ti avvicini")
                    .foregroundColor(.textTertiary)
            }

            Section {
                BudgetPresetButton(amount: 500, currentBudget: $monthlyBudget, budgetText: $budgetText)
                BudgetPresetButton(amount: 1000, currentBudget: $monthlyBudget, budgetText: $budgetText)
                BudgetPresetButton(amount: 1500, currentBudget: $monthlyBudget, budgetText: $budgetText)
                BudgetPresetButton(amount: 2000, currentBudget: $monthlyBudget, budgetText: $budgetText)
                BudgetPresetButton(amount: 3000, currentBudget: $monthlyBudget, budgetText: $budgetText)
            } header: {
                Text("Preimpostati")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("Budget Mensile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            budgetText = String(format: "%.0f", monthlyBudget)
        }
        .onChange(of: budgetText) { _, newValue in
            if let value = Double(newValue) {
                monthlyBudget = value
            }
        }
    }
}

struct BudgetPresetButton: View {
    let amount: Double
    @Binding var currentBudget: Double
    @Binding var budgetText: String

    var body: some View {
        Button {
            currentBudget = amount
            budgetText = String(format: "%.0f", amount)
        } label: {
            HStack {
                Text("€\(Int(amount))")
                    .foregroundColor(.textPrimary)

                Spacer()

                if currentBudget == amount {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentGreen)
                }
            }
        }
    }
}

struct CategorySettingsView: View {
    var body: some View {
        List {
            ForEach(ExpenseCategory.allCases, id: \.self) { category in
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: category.color).opacity(0.2))
                            .frame(width: 40, height: 40)

                        Image(systemName: category.icon)
                            .foregroundColor(Color(hex: category.color))
                    }

                    Text(category.rawValue)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.textTertiary)
                }
            }
            .onMove { _, _ in }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("Categorie")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.editMode, .constant(.active))
    }
}

#Preview {
    NavigationStack {
        GeneralSettingsView()
    }
    .preferredColorScheme(.dark)
}
