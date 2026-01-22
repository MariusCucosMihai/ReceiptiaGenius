//
//  Components.swift
//  Receiptia
//
//  Design System - Reusable UI Components
//

import SwiftUI

// MARK: - Card Container
struct CardContainer<Content: View>: View {
    let content: Content
    var padding: CGFloat = 20
    var cornerRadius: CGFloat = 16
    var backgroundColor: Color = .cardBackground

    init(
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 16,
        backgroundColor: Color = .cardBackground,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Gradient Card Container
struct GradientCardContainer<Content: View>: View {
    let content: Content
    var gradient: LinearGradient = .geniusCardGradient
    var padding: CGFloat = 20
    var cornerRadius: CGFloat = 16

    init(
        gradient: LinearGradient = .geniusCardGradient,
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.gradient = gradient
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.accentTeal.opacity(0.2), lineWidth: 1)
            )
    }
}

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isFullWidth: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.buttonLarge)
                .foregroundColor(.appBackground)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(Color.accentGreen)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.buttonMedium)
            .foregroundColor(.accentGreen)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color.accentGreen.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Icon Badge
struct IconBadge: View {
    let icon: String
    var size: CGFloat = 44
    var backgroundColor: Color = .accentGreen.opacity(0.15)
    var iconColor: Color = .accentGreen

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)

            Image(systemName: icon)
                .font(.system(size: size * 0.45, weight: .semibold))
                .foregroundColor(iconColor)
        }
    }
}

// MARK: - Emoji Badge
struct EmojiBadge: View {
    let emoji: String
    var size: CGFloat = 44
    var backgroundColor: Color = .cardBackgroundLight

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)

            Text(emoji)
                .font(.system(size: size * 0.5))
        }
    }
}

// MARK: - Progress Ring
struct ProgressRing: View {
    let progress: Double
    var lineWidth: CGFloat = 6
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.cardBackgroundLight, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.accentGreen,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Chevron Row
struct ChevronRow<Content: View>: View {
    let content: Content
    let action: () -> Void

    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: action) {
            HStack {
                content
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
        }
    }
}

// MARK: - Divider Line
struct DividerLine: View {
    var body: some View {
        Rectangle()
            .fill(Color.cardBackgroundLight)
            .frame(height: 1)
    }
}

// MARK: - Status Indicator
struct StatusIndicator: View {
    enum Status {
        case positive, negative, neutral
    }

    let status: Status
    let value: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: status == .positive ? "arrow.down" : (status == .negative ? "arrow.up" : "minus"))
                .font(.system(size: 12, weight: .bold))

            Text(value)
                .font(.labelSmall)
        }
        .foregroundColor(statusColor)
    }

    private var statusColor: Color {
        switch status {
        case .positive: return .accentGreen
        case .negative: return .alertRed
        case .neutral: return .textSecondary
        }
    }
}
