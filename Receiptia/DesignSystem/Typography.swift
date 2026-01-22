//
//  Typography.swift
//  Receiptia
//
//  Design System - Typography for Receiptia Genius
//

import SwiftUI

extension Font {
    // MARK: - Hero Text
    static let heroLarge = Font.system(size: 40, weight: .bold, design: .default)
    static let heroMedium = Font.system(size: 32, weight: .bold, design: .default)

    // MARK: - Card Titles
    static let cardTitle = Font.system(size: 24, weight: .semibold, design: .default)
    static let cardTitleSmall = Font.system(size: 20, weight: .semibold, design: .default)

    // MARK: - Body Text
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

    // MARK: - Labels
    static let labelLarge = Font.system(size: 17, weight: .medium, design: .default)
    static let labelMedium = Font.system(size: 15, weight: .medium, design: .default)
    static let labelSmall = Font.system(size: 13, weight: .medium, design: .default)

    // MARK: - Numbers
    static let numberLarge = Font.system(size: 48, weight: .bold, design: .rounded)
    static let numberMedium = Font.system(size: 32, weight: .bold, design: .rounded)
    static let numberSmall = Font.system(size: 24, weight: .semibold, design: .rounded)

    // MARK: - Button Text
    static let buttonLarge = Font.system(size: 17, weight: .semibold, design: .default)
    static let buttonMedium = Font.system(size: 15, weight: .semibold, design: .default)

    // MARK: - Caption
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    static let captionMedium = Font.system(size: 12, weight: .medium, design: .default)
}

// MARK: - Text Style Modifiers
struct HeroTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.heroLarge)
            .foregroundColor(.textPrimary)
    }
}

struct CardTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.cardTitle)
            .foregroundColor(.textPrimary)
    }
}

struct BodyTextStyle: ViewModifier {
    var isSecondary: Bool = false

    func body(content: Content) -> some View {
        content
            .font(.bodyMedium)
            .foregroundColor(isSecondary ? .textSecondary : .textPrimary)
    }
}

extension View {
    func heroTextStyle() -> some View {
        modifier(HeroTextStyle())
    }

    func cardTitleStyle() -> some View {
        modifier(CardTitleStyle())
    }

    func bodyTextStyle(secondary: Bool = false) -> some View {
        modifier(BodyTextStyle(isSecondary: secondary))
    }
}
