//
//  Colors.swift
//  Receiptia
//
//  Design System - Color Palette for Receiptia Genius
//

import SwiftUI

extension Color {
    // MARK: - Background Colors
    static let appBackground = Color(hex: "0A0A0A")
    static let cardBackground = Color(hex: "1A1A1A")
    static let cardBackgroundLight = Color(hex: "252525")
    static let cardBackgroundElevated = Color(hex: "2A2A2A")

    // MARK: - Accent Colors
    static let accentGreen = Color(hex: "00FF88")
    static let accentTeal = Color(hex: "00D9C0")
    static let accentGreenDark = Color(hex: "00CC6A")

    // MARK: - Text Colors
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "999999")
    static let textTertiary = Color(hex: "666666")

    // MARK: - Status Colors
    static let warningYellow = Color(hex: "FFD700")
    static let alertRed = Color(hex: "FF4444")
    static let successGreen = Color(hex: "00FF88")

    // MARK: - Gradient Colors
    static let gradientTealStart = Color(hex: "00D9C0")
    static let gradientTealEnd = Color(hex: "1A1A1A")

    // MARK: - Chart Colors
    static let chartGreen = Color(hex: "00FF88")
    static let chartYellow = Color(hex: "FFD700")
    static let chartRed = Color(hex: "FF4444")

    // MARK: - Tab Bar
    static let tabBarBackground = Color(hex: "0F0F0F")
    static let tabBarInactive = Color(hex: "666666")
}

// MARK: - Hex Color Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradient Presets
extension LinearGradient {
    static let geniusCardGradient = LinearGradient(
        colors: [Color.accentTeal.opacity(0.3), Color.cardBackground],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let chartAreaGradient = LinearGradient(
        colors: [Color.accentGreen.opacity(0.4), Color.accentGreen.opacity(0.0)],
        startPoint: .top,
        endPoint: .bottom
    )

    static let ctaButtonGradient = LinearGradient(
        colors: [Color.accentGreen, Color.accentTeal],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let warningGradient = LinearGradient(
        colors: [Color.chartYellow.opacity(0.3), Color.cardBackground],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
