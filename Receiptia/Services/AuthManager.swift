//
//  AuthManager.swift
//  Receiptia
//
//  Authentication Manager with Biometrics support
//

import Foundation
import SwiftUI
import LocalAuthentication

@Observable
final class AuthManager {
    var isAuthenticated: Bool = false
    var currentUser: User?
    var authError: String?

    init() {
        checkAuthenticationStatus()
    }

    func checkAuthenticationStatus() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }

    func signIn(email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        let user = User(
            id: UUID(),
            name: "Marco Rossi",
            email: email
        )

        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
            saveUser(user)
        }
    }

    func signUp(name: String, email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 1_500_000_000)

        let user = User(
            id: UUID(),
            name: name,
            email: email
        )

        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
            saveUser(user)
        }
    }

    func authenticateWithBiometrics() async throws {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw AuthError.biometricsNotAvailable
        }

        let reason = "Accedi con Face ID per entrare rapidamente"

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )

            if success {
                await MainActor.run {
                    self.isAuthenticated = true
                }
            }
        } catch {
            throw AuthError.biometricsFailed
        }
    }

    func signOut() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }

    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
}

enum AuthError: LocalizedError {
    case biometricsNotAvailable
    case biometricsFailed
    case invalidCredentials
    case networkError

    var errorDescription: String? {
        switch self {
        case .biometricsNotAvailable:
            return "Face ID / Touch ID non disponibile"
        case .biometricsFailed:
            return "Autenticazione biometrica fallita"
        case .invalidCredentials:
            return "Credenziali non valide"
        case .networkError:
            return "Errore di rete"
        }
    }
}

struct User: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String

    var initials: String {
        let components = name.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials.joined().uppercased()
    }
}
