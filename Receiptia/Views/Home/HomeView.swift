//
//  HomeView.swift
//  Receiptia
//
//  Main Home Tab View
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
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
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
