//
//  CustomTabBar.swift
//  Receiptia
//
//  Custom Tab Bar with centered Add button
//

import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0
    case genius = 1
    case add = 2
    case rewards = 3
    case profile = 4

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .genius: return "sparkles"
        case .add: return "plus"
        case .rewards: return "trophy.fill"
        case .profile: return "person.fill"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home"
        case .genius: return "Genius"
        case .add: return ""
        case .rewards: return "Premi"
        case .profile: return "Profilo"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    var onAddTapped: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                if tab == .add {
                    AddTabButton(action: onAddTapped)
                } else {
                    TabBarButton(tab: tab, isSelected: selectedTab == tab) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            Color.tabBarBackground
                .shadow(color: .black.opacity(0.3), radius: 10, y: -5)
        )
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isSelected ? .accentGreen : .tabBarInactive)

                Text(tab.title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .accentGreen : .tabBarInactive)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct AddTabButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.accentGreen)
                    .frame(width: 56, height: 56)
                    .shadow(color: .accentGreen.opacity(0.4), radius: 8, y: 4)

                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.appBackground)
            }
            .offset(y: -20)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    @State private var showAddExpense: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabContentView(selectedTab: selectedTab)
                .padding(.bottom, 80)

            CustomTabBar(selectedTab: $selectedTab) {
                showAddExpense = true
            }
        }
        .ignoresSafeArea(.keyboard)
        .background(Color.appBackground)
        .sheet(isPresented: $showAddExpense) {
            AddExpenseView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct TabContentView: View {
    let selectedTab: TabItem

    var body: some View {
        switch selectedTab {
        case .home:
            HomeView()
        case .genius:
            GeniusView()
        case .add:
            EmptyView()
        case .rewards:
            RewardsView()
        case .profile:
            ProfileView()
        }
    }
}

#Preview {
    MainTabView()
}
