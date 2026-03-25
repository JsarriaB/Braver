import SwiftUI

struct ProgresoView: View {
    @StateObject private var streakService = StreakService.shared
    @StateObject private var historyService = ChallengeHistoryService.shared

    var totalCompleted: Int { historyService.attempts.filter { $0.status == .completed }.count }
    var momentosValor: Int  { streakService.momentosBraver }
    let miedoVsRealidad = 68

    let sudsHistory: [(String, Int, Int)] = [
        ("Lun", 70, 45),
        ("Mar", 65, 38),
        ("Mié", 60, 42),
        ("Jue", 58, 35),
        ("Vie", 55, 30),
        ("Sáb", 50, 28),
        ("Hoy", 45, 22)
    ]

    let achievements: [(String, String, String, Bool)] = [
        ("bolt.fill",      "Primer Braver",     "Tu primera sesión de respiración", true),
        ("flame.fill",     "Primera semana",     "7 días en racha",                  true),
        ("checkmark.seal", "Primer reto",        "Completaste tu primer reto",       true),
        ("chart.line.uptrend.xyaxis", "En progreso", "Reduciste ansiedad un 50%",   false),
        ("trophy.fill",    "30 días",            "Mantén la racha 30 días",          false)
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: BraverTheme.sectionSpacing) {
                    headerSection
                    statsRow
                    miedoVsRealidadCard
                    sudsChartSection
                    achievementsSection
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .background(BraverTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    // MARK: Header

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Tu progreso")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Text("La evidencia de que estás mejorando")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
            }
            Spacer()
        }
        .padding(.top, 12)
    }

    // MARK: Stats row

    var statsRow: some View {
        HStack(spacing: 10) {
            StatChip(value: "\(streakService.streakDays)", label: "Días\nen racha", color: BraverTheme.bravura)
            StatChip(value: "\(totalCompleted)", label: "Retos\ncompletados", color: BraverTheme.accent)
            StatChip(value: "\(momentosValor)", label: "Momentos\nBraver", color: BraverTheme.success)
        }
    }

    // MARK: Miedo vs Realidad

    var miedoVsRealidadCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Miedo vs Realidad")

            VStack(spacing: 14) {
                HStack(alignment: .bottom, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(miedoVsRealidad)%")
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                            .foregroundColor(BraverTheme.bravura)
                        Text("Tu cerebro exagera el peligro")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                    }
                    Spacer()
                    // Mini bar chart
                    HStack(alignment: .bottom, spacing: 6) {
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(BraverTheme.danger.opacity(0.7))
                                .frame(width: 28, height: 80)
                            Text("Miedo")
                                .font(.system(size: 10, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                        }
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(BraverTheme.success.opacity(0.7))
                                .frame(width: 28, height: 80 * (1 - Double(miedoVsRealidad) / 100))
                            Text("Real")
                                .font(.system(size: 10, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                        }
                    }
                }

                Divider().background(BraverTheme.surfaceBorder)

                Text("En promedio, tu ansiedad real es un **\(miedoVsRealidad)% menor** que la que anticipas. Este número bajará con el tiempo.")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(BraverTheme.cardPadding)
            .braverCard(elevated: true)
        }
    }

    // MARK: SUDS Chart

    var sudsChartSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Tu ansiedad en el tiempo")

            VStack(spacing: 16) {
                // Simple bar chart
                HStack(alignment: .bottom, spacing: 6) {
                    ForEach(sudsHistory, id: \.0) { day, predicted, actual in
                        VStack(spacing: 4) {
                            ZStack(alignment: .bottom) {
                                // Predicted bar (background)
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(BraverTheme.surfaceElevated)
                                    .frame(width: 34, height: CGFloat(predicted) * 0.9)

                                // Actual bar (foreground)
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(
                                        LinearGradient(
                                            colors: [BraverTheme.accent.opacity(0.9), BraverTheme.success.opacity(0.8)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 34, height: CGFloat(actual) * 0.9)
                            }
                            .frame(height: 90, alignment: .bottom)

                            Text(day)
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(BraverTheme.surfaceElevated)
                            .frame(width: 12, height: 8)
                        Text("Ansiedad anticipada")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                    }
                    HStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(BraverTheme.accent)
                            .frame(width: 12, height: 8)
                        Text("Ansiedad real")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(BraverTheme.cardPadding)
            .braverCard(elevated: true)
        }
    }

    // MARK: Achievements

    var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Logros")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(achievements, id: \.0) { icon, title, desc, unlocked in
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(unlocked ? BraverTheme.bravura.opacity(0.15) : BraverTheme.surfaceElevated)
                                    .frame(width: 52, height: 52)
                                Image(systemName: icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(unlocked ? BraverTheme.bravura : BraverTheme.textTertiary)
                            }
                            Text(title)
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(unlocked ? BraverTheme.textPrimary : BraverTheme.textTertiary)
                                .multilineTextAlignment(.center)
                            Text(desc)
                                .font(.system(size: 10, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(width: 100)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 10)
                        .background(unlocked ? BraverTheme.surfaceElevated : BraverTheme.surfaceElevated.opacity(0.5))
                        .cornerRadius(BraverTheme.radiusMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                .stroke(unlocked ? BraverTheme.bravura.opacity(0.2) : BraverTheme.surfaceBorder, lineWidth: 1)
                        )
                        .opacity(unlocked ? 1 : 0.5)
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
            }
            .padding(.horizontal, -BraverTheme.screenPadding)
        }
    }

}
