//
//  SpendingChartView.swift
//  Receiptia
//
//  Weekly spending trend chart using Swift Charts
//

import SwiftUI
import Charts

struct SpendingChartView: View {
    let weeklySpending: WeeklySpending
    let weekDateRange: String
    @State private var selectedDay: DailySpending?

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Il tuo andamento")
                            .font(.cardTitleSmall)
                            .foregroundColor(.textPrimary)

                        Text(weekDateRange)
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    // Total Badge
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Totale")
                            .font(.caption)
                            .foregroundColor(.textTertiary)

                        Text(formattedTotal)
                            .font(.labelLarge)
                            .foregroundColor(.textPrimary)
                    }
                }

                // Chart
                Chart {
                    ForEach(weeklySpending.dailySpending) { day in
                        // Area
                        AreaMark(
                            x: .value("Giorno", day.dayAbbreviation),
                            y: .value("Spesa", day.amount)
                        )
                        .foregroundStyle(areaGradient)
                        .interpolationMethod(.catmullRom)

                        // Line
                        LineMark(
                            x: .value("Giorno", day.dayAbbreviation),
                            y: .value("Spesa", day.amount)
                        )
                        .foregroundStyle(lineColor(for: day))
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))

                        // Points
                        PointMark(
                            x: .value("Giorno", day.dayAbbreviation),
                            y: .value("Spesa", day.amount)
                        )
                        .foregroundStyle(pointColor(for: day))
                        .symbolSize(day == weeklySpending.peakDay ? 100 : 60)
                    }

                    // Selection indicator
                    if let selected = selectedDay {
                        RuleMark(x: .value("Giorno", selected.dayAbbreviation))
                            .foregroundStyle(Color.textTertiary.opacity(0.3))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))

                        PointMark(
                            x: .value("Giorno", selected.dayAbbreviation),
                            y: .value("Spesa", selected.amount)
                        )
                        .foregroundStyle(Color.accentGreen)
                        .symbolSize(150)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine()
                            .foregroundStyle(Color.cardBackgroundLight)
                        AxisValueLabel {
                            if let amount = value.as(Double.self) {
                                Text("€\(Int(amount))")
                                    .font(.caption)
                                    .foregroundStyle(Color.textTertiary)
                            }
                        }
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let x = value.location.x
                                        if let day = findDay(at: x, proxy: proxy, geometry: geometry) {
                                            selectedDay = day
                                        }
                                    }
                                    .onEnded { _ in
                                        selectedDay = nil
                                    }
                            )
                    }
                }

                // Peak Day Indicator
                if let peakDay = weeklySpending.peakDay {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.alertRed)
                            .frame(width: 8, height: 8)

                        Text("Picco: \(peakDay.dayAbbreviation) con €\(String(format: "%.0f", peakDay.amount))")
                            .font(.bodySmall)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
    }

    private var formattedTotal: String {
        "€\(String(format: "%.2f", weeklySpending.totalAmount))"
    }

    private var areaGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.accentGreen.opacity(0.4),
                Color.accentGreen.opacity(0.1),
                Color.accentGreen.opacity(0.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func lineColor(for day: DailySpending) -> Color {
        if day == weeklySpending.peakDay {
            return .alertRed
        }
        return .accentGreen
    }

    private func pointColor(for day: DailySpending) -> Color {
        if day == weeklySpending.peakDay {
            return .alertRed
        }
        return .accentGreen
    }

    private func findDay(at x: CGFloat, proxy: ChartProxy, geometry: GeometryProxy) -> DailySpending? {
        let plotFrame = geometry.frame(in: .local)
        let stepWidth = plotFrame.width / CGFloat(weeklySpending.dailySpending.count)
        let index = Int(x / stepWidth)

        guard index >= 0 && index < weeklySpending.dailySpending.count else { return nil }
        return weeklySpending.dailySpending[index]
    }
}

extension DailySpending: Equatable {
    static func == (lhs: DailySpending, rhs: DailySpending) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        SpendingChartView(
            weeklySpending: GeniusViewModel.createSampleWeeklySpending(),
            weekDateRange: "Settimana 13-19 Gennaio"
        )
        .padding()
    }
    .preferredColorScheme(.dark)
}
