//
//  ProfileView.swift
//  Receiptia
//
//  Profile and Settings Tab
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var showingSignOutAlert = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Profile Header
                    NavigationLink {
                        EditProfileView()
                    } label: {
                        ProfileHeaderView(
                            name: viewModel.userName,
                            email: viewModel.userEmail,
                            initials: viewModel.userInitials,
                            memberSince: viewModel.memberSince
                        )
                    }

                    // Account Section
                    SettingsSectionCard(title: "Account") {
                        NavigationLink {
                            NotificationSettingsView()
                        } label: {
                            SettingsRow(
                                icon: "bell.fill",
                                title: "Notifiche",
                                subtitle: "Gestisci avvisi e promemoria"
                            )
                        }

                        Divider().background(Color.cardBackgroundLight).padding(.leading, 56)

                        NavigationLink {
                            PrivacySettingsView()
                        } label: {
                            SettingsRow(
                                icon: "lock.fill",
                                title: "Privacy e Sicurezza",
                                subtitle: "Face ID, backup, dati"
                            )
                        }

                        Divider().background(Color.cardBackgroundLight).padding(.leading, 56)

                        NavigationLink {
                            GeneralSettingsView()
                        } label: {
                            SettingsRow(
                                icon: "gearshape.fill",
                                title: "Impostazioni",
                                subtitle: "Valuta, lingua, budget"
                            )
                        }
                    }

                    // Support Section
                    SettingsSectionCard(title: "Supporto") {
                        Button {
                            openHelpCenter()
                        } label: {
                            SettingsRow(
                                icon: "questionmark.circle.fill",
                                title: "Centro Assistenza",
                                subtitle: "FAQ e guide"
                            )
                        }

                        Divider().background(Color.cardBackgroundLight).padding(.leading, 56)

                        Button {
                            openEmail()
                        } label: {
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contattaci",
                                subtitle: "Invia feedback o segnalazioni"
                            )
                        }

                        Divider().background(Color.cardBackgroundLight).padding(.leading, 56)

                        Button {
                            rateApp()
                        } label: {
                            SettingsRow(
                                icon: "star.fill",
                                title: "Valuta l'app",
                                subtitle: "Lascia una recensione"
                            )
                        }
                    }

                    // About Section
                    SettingsSectionCard(title: "Info") {
                        NavigationLink {
                            AboutView()
                        } label: {
                            SettingsRow(
                                icon: "info.circle.fill",
                                title: "Info su Receiptia Genius",
                                subtitle: "Versione 1.0.0"
                            )
                        }
                    }

                    // Sign Out Button
                    Button {
                        showingSignOutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 18))

                            Text("Esci")
                                .font(.buttonLarge)
                        }
                        .foregroundColor(.alertRed)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.alertRed.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // App Version
                    Text("Receiptia Genius v1.0.0 (Build 1)")
                        .font(.caption)
                        .foregroundColor(.textTertiary)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color.appBackground)
            .navigationTitle("Profilo")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert("Vuoi uscire?", isPresented: $showingSignOutAlert) {
                Button("Annulla", role: .cancel) { }
                Button("Esci", role: .destructive) {
                    signOut()
                }
            } message: {
                Text("Dovrai effettuare nuovamente l'accesso per usare l'app.")
            }
        }
    }

    private func openHelpCenter() {
        if let url = URL(string: "https://receiptia.app/help") {
            UIApplication.shared.open(url)
        }
    }

    private func openEmail() {
        if let url = URL(string: "mailto:support@receiptia.app") {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        // Open App Store review
    }

    private func signOut() {
        let authManager = AuthManager()
        authManager.signOut()
    }
}

struct ProfileHeaderView: View {
    let name: String
    let email: String
    let initials: String
    let memberSince: String

    var body: some View {
        CardContainer {
            HStack(spacing: 16) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.accentGreen, .accentTeal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)

                    Text(initials)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.appBackground)
                }

                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.cardTitleSmall)
                        .foregroundColor(.textPrimary)

                    Text(email)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)

                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)

                        Text("Membro da \(memberSince)")
                            .font(.caption)
                    }
                    .foregroundColor(.textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
        }
    }
}

struct SettingsSectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.labelMedium)
                .foregroundColor(.textSecondary)
                .padding(.leading, 4)

            CardContainer(padding: 0) {
                VStack(spacing: 0) {
                    content
                }
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.accentGreen.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.accentGreen)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.bodyLarge)
                    .foregroundColor(.textPrimary)

                Text(subtitle)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textTertiary)
        }
        .padding(16)
        .contentShape(Rectangle())
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = "Marco"
    @State private var email: String = "marco@example.com"

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.accentGreen, .accentTeal],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)

                        Text(String(name.prefix(2)).uppercased())
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.appBackground)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            Section {
                TextField("Nome", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
            } header: {
                Text("Informazioni")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("Modifica Profilo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Salva") {
                    saveProfile()
                    dismiss()
                }
                .foregroundColor(.accentGreen)
            }
        }
    }

    private func saveProfile() {
        // Save profile changes
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}
