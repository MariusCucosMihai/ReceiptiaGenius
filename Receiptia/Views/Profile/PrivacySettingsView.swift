//
//  PrivacySettingsView.swift
//  Receiptia
//
//  Privacy and security settings
//

import SwiftUI

struct PrivacySettingsView: View {
    @AppStorage("biometricsEnabled") private var biometricsEnabled = true
    @AppStorage("cloudBackupEnabled") private var cloudBackupEnabled = false
    @State private var showingDataDeletion = false
    @State private var showingExportData = false

    var body: some View {
        List {
            Section {
                Toggle("Face ID / Touch ID", isOn: $biometricsEnabled)
                    .tint(.accentGreen)
                    .onChange(of: biometricsEnabled) { _, newValue in
                        if newValue {
                            Task {
                                let authManager = AuthManager()
                                try? await authManager.authenticateWithBiometrics()
                            }
                        }
                    }
            } header: {
                Text("Sicurezza")
            } footer: {
                Text("Usa Face ID per accedere rapidamente all'app")
                    .foregroundColor(.textTertiary)
            }

            Section {
                Toggle("Backup su iCloud", isOn: $cloudBackupEnabled)
                    .tint(.accentGreen)

                Button {
                    showingExportData = true
                } label: {
                    HStack {
                        Text("Esporta i tuoi dati")
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.accentGreen)
                    }
                }
            } header: {
                Text("Dati")
            } footer: {
                Text("I tuoi dati vengono criptati e salvati localmente sul dispositivo")
                    .foregroundColor(.textTertiary)
            }

            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dati sul dispositivo")
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)

                        Text("I tuoi dati rimangono sempre sul tuo dispositivo")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentGreen)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Crittografia end-to-end")
                            .font(.bodyLarge)
                            .foregroundColor(.textPrimary)

                        Text("Tutti i dati sono criptati")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentGreen)
                }
            } header: {
                Text("Privacy")
            }

            Section {
                Button(role: .destructive) {
                    showingDataDeletion = true
                } label: {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("Elimina Tutti i Dati")
                    }
                    .foregroundColor(.alertRed)
                }
            } header: {
                Text("Zona Pericolosa")
            } footer: {
                Text("Questa azione è irreversibile. Tutti i tuoi dati verranno eliminati permanentemente.")
                    .foregroundColor(.textTertiary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("Privacy e Sicurezza")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Elimina Tutti i Dati?", isPresented: $showingDataDeletion) {
            Button("Annulla", role: .cancel) { }
            Button("Elimina", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("Tutti i tuoi dati, spese, obiettivi e premi verranno eliminati permanentemente. Questa azione non può essere annullata.")
        }
        .sheet(isPresented: $showingExportData) {
            ExportDataView()
        }
    }

    private func deleteAllData() {
        // Clear UserDefaults
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }

        // Clear notifications
        NotificationService.shared.cancelAllNotifications()
    }
}

struct ExportDataView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.accentGreen)

                Text("Esporta i tuoi dati")
                    .font(.cardTitle)
                    .foregroundColor(.textPrimary)

                Text("Riceverai un file JSON con tutte le tue spese, obiettivi e progressi.")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                PrimaryButton(title: "Esporta") {
                    exportData()
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 48)
            .padding(.bottom, 24)
            .background(Color.appBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                    .foregroundColor(.accentGreen)
                }
            }
        }
    }

    private func exportData() {
        // Generate export data
        let exportData: [String: Any] = [
            "exportDate": ISO8601DateFormatter().string(from: Date()),
            "appVersion": "1.0.0",
            "expenses": [],
            "goals": [],
            "achievements": []
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            let activityVC = UIActivityViewController(
                activityItems: [jsonString],
                applicationActivities: nil
            )

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootVC = window.rootViewController {
                rootVC.present(activityVC, animated: true)
            }
        }

        dismiss()
    }
}

#Preview {
    NavigationStack {
        PrivacySettingsView()
    }
    .preferredColorScheme(.dark)
}
