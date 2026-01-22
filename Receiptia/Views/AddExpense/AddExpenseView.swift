//
//  AddExpenseView.swift
//  Receiptia
//
//  Add new expense sheet view
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ExpenseViewModel()
    @FocusState private var isAmountFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Amount Input
                    AmountInputView(amount: $viewModel.amount, isAmountFocused: $isAmountFocused)

                    // Category Selection
                    CategorySelectionView(selectedCategory: $viewModel.selectedCategory)

                    // Details Section
                    DetailsInputView(
                        title: $viewModel.title,
                        notes: $viewModel.notes,
                        date: $viewModel.date
                    )

                    // Night Purchase Warning
                    if viewModel.isNightPurchase {
                        NightPurchaseWarning()
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("Nuova spesa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annulla") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salva") {
                        saveExpense()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(viewModel.isValidExpense ? .accentGreen : .textTertiary)
                    .disabled(!viewModel.isValidExpense)
                }
            }
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            isAmountFocused = true
        }
    }

    private func saveExpense() {
        let expense = viewModel.createExpense()
        modelContext.insert(expense)
        dismiss()
    }
}

struct AmountInputView: View {
    @Binding var amount: String
    var isAmountFocused: FocusState<Bool>.Binding

    var body: some View {
        VStack(spacing: 12) {
            Text("Quanto hai speso?")
                .font(.labelMedium)
                .foregroundColor(.textSecondary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("€")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.textTertiary)

                TextField("0,00", text: $amount)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .focused(isAmountFocused)
                    .frame(maxWidth: 200)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

struct CategorySelectionView: View {
    @Binding var selectedCategory: ExpenseCategory

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Categoria")
                .font(.labelLarge)
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: ExpenseCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color(hex: category.color).opacity(0.2) : Color.cardBackgroundLight)
                        .frame(width: 52, height: 52)

                    Image(systemName: category.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(isSelected ? Color(hex: category.color) : .textSecondary)
                }

                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                    .lineLimit(1)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color(hex: category.color).opacity(0.1) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: category.color).opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
    }
}

struct DetailsInputView: View {
    @Binding var title: String
    @Binding var notes: String
    @Binding var date: Date

    var body: some View {
        VStack(spacing: 16) {
            // Title Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Descrizione")
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)

                TextField("Es. Pranzo al ristorante", text: $title)
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)
                    .padding(16)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Date Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Data e ora")
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)

                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .tint(.accentGreen)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Notes Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Note (opzionale)")
                    .font(.labelMedium)
                    .foregroundColor(.textSecondary)

                TextField("Aggiungi una nota...", text: $notes, axis: .vertical)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(3...5)
                    .padding(16)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

struct NightPurchaseWarning: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "moon.fill")
                .font(.system(size: 20))
                .foregroundColor(.warningYellow)

            VStack(alignment: .leading, spacing: 2) {
                Text("Acquisto notturno")
                    .font(.labelMedium)
                    .foregroundColor(.warningYellow)

                Text("Stai registrando una spesa dopo le 22:00")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.warningYellow.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.warningYellow.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    AddExpenseView()
        .preferredColorScheme(.dark)
}
