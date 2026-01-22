//
//  LoginView.swift
//  Receiptia
//
//  Login and onboarding view
//

import SwiftUI

struct LoginView: View {
    @State private var authManager = AuthManager()
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 60)

                    // Logo
                    VStack(spacing: 16) {
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

                            Image(systemName: "sparkles")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.appBackground)
                        }

                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Text("Receiptia")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.textPrimary)

                                Text("Genius")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.accentGreen)
                            }

                            Text("Il tuo coach finanziario AI")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                        }
                    }

                    // Form
                    VStack(spacing: 16) {
                        if isSignUp {
                            AuthTextField(
                                placeholder: "Nome",
                                text: $name,
                                icon: "person.fill"
                            )
                        }

                        AuthTextField(
                            placeholder: "Email",
                            text: $email,
                            icon: "envelope.fill",
                            keyboardType: .emailAddress
                        )

                        AuthTextField(
                            placeholder: "Password",
                            text: $password,
                            icon: "lock.fill",
                            isSecure: true
                        )
                    }
                    .padding(.horizontal, 24)

                    // Actions
                    VStack(spacing: 16) {
                        PrimaryButton(title: isSignUp ? "Crea Account" : "Accedi") {
                            performAuth()
                        }
                        .disabled(isLoading)
                        .opacity(isLoading ? 0.6 : 1)

                        // Biometrics Button
                        if !isSignUp {
                            Button {
                                performBiometricAuth()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "faceid")
                                        .font(.system(size: 20))

                                    Text("Accedi con Face ID")
                                        .font(.buttonMedium)
                                }
                                .foregroundColor(.accentGreen)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.accentGreen.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    // Toggle
                    Button {
                        withAnimation {
                            isSignUp.toggle()
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(isSignUp ? "Hai già un account?" : "Non hai un account?")
                                .foregroundColor(.textSecondary)

                            Text(isSignUp ? "Accedi" : "Registrati")
                                .foregroundColor(.accentGreen)
                        }
                        .font(.bodyMedium)
                    }

                    Spacer(minLength: 40)
                }
            }

            // Loading Overlay
            if isLoading {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                ProgressView()
                    .tint(.accentGreen)
                    .scaleEffect(1.5)
            }
        }
        .alert("Errore", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    private func performAuth() {
        guard validateInput() else { return }

        isLoading = true

        Task {
            do {
                if isSignUp {
                    try await authManager.signUp(name: name, email: email, password: password)
                } else {
                    try await authManager.signIn(email: email, password: password)
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }

            await MainActor.run {
                isLoading = false
            }
        }
    }

    private func performBiometricAuth() {
        Task {
            do {
                try await authManager.authenticateWithBiometrics()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    private func validateInput() -> Bool {
        if isSignUp && name.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Inserisci il tuo nome"
            showError = true
            return false
        }

        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Inserisci la tua email"
            showError = true
            return false
        }

        if password.count < 6 {
            errorMessage = "La password deve avere almeno 6 caratteri"
            showError = true
            return false
        }

        return true
    }
}

struct AuthTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.textTertiary)
                .frame(width: 24)

            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .font(.bodyLarge)
        .foregroundColor(.textPrimary)
        .padding(16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    LoginView()
}
