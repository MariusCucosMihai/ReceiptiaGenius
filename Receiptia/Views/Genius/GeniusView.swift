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

#Preview {
    GeniusView()
        .preferredColorScheme(.dark)
}
