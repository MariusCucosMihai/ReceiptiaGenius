//
//  HomeView.swift
//  Receiptia
//
//  Main Home Tab View
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Query private var expenses: [Expense]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Time Range Picker
                    TimeRangePicker(selectedRange: $viewModel.selectedTimeRange)

                    // Status Card
                    StatusCardView(status: viewModel.spendingStatus)

                    // Genius Wrapped Card
                    GeniusWrappedCardView(insights: viewModel.insights)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.accentGreen)

                        Text("Receiptia")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.textPrimary)

                        Text("Genius")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.accentGreen)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .refreshable {
                viewModel.loadData(from: expenses)
            }
        }
        .onAppear {
            viewModel.loadData(from: expenses)
        }
        .onChange(of: viewModel.selectedTimeRange) { _, _ in
            viewModel.loadData(from: expenses)
        }
    }
}

struct TimeRangePicker: View {
    @Binding var selectedRange: TimeRange

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    TimeRangeChip(
                        title: range.displayName,
                        isSelected: selectedRange == range
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedRange = range
                        }
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct TimeRangeChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.labelMedium)
                .foregroundColor(isSelected ? .appBackground : .textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.accentGreen : Color.cardBackground)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.cardBackgroundLight, lineWidth: 1)
                )
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Expense.self, inMemory: true)
        .preferredColorScheme(.dark)
}
