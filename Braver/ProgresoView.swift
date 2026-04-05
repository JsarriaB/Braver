import SwiftUI

struct ProgresoView: View {
    @StateObject private var streakService     = StreakService.shared
    @StateObject private var historyService    = ChallengeHistoryService.shared
    @StateObject private var checkInService    = EveningCheckInService.shared
    @StateObject private var achievementsService = AchievementsService.shared

    @State private var selectedTab = 0   // 0 = Resumen, 1 = Retos, 2 = Diario
    @State private var showCheckIn = false

    var totalCompleted: Int { historyService.attempts.filter { $0.status == .completed }.count }
    var momentosValor: Int  { streakService.momentosBraver }

    var achievementGroups: [(AchievementCategory, [Achievement])] {
        achievementsService.grouped(
            streak: streakService.streakDays,
            attempts: historyService.attempts,
            momentos: momentosValor
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerSection
                tabPicker
                Divider().background(BraverTheme.surfaceBorder.opacity(0.4))

                ScrollView(showsIndicators: false) {
                    switch selectedTab {
                    case 0: resumenTab
                    case 1: retosTab
                    default: diarioTab
                    }
                }
            }
            .background(BraverTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showCheckIn) {
            EveningCheckInView(isPresented: $showCheckIn)
        }
    }

    // MARK: Header

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Progreso")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Text("La evidencia de que estás mejorando")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(BraverTheme.background)
    }

    // MARK: Tab picker

    var tabPicker: some View {
        HStack(spacing: 0) {
            ForEach(["Resumen", "Retos", "Diario"], id: \.self) { tab in
                let idx = ["Resumen", "Retos", "Diario"].firstIndex(of: tab) ?? 0
                Button {
                    withAnimation(.spring(response: 0.3)) { selectedTab = idx }
                } label: {
                    VStack(spacing: 6) {
                        Text(tab)
                            .font(.system(size: 14, weight: selectedTab == idx ? .semibold : .regular, design: .rounded))
                            .foregroundColor(selectedTab == idx ? BraverTheme.textPrimary : BraverTheme.textTertiary)
                        Rectangle()
                            .fill(selectedTab == idx ? BraverTheme.accent : Color.clear)
                            .frame(height: 2)
                            .cornerRadius(1)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .background(BraverTheme.background)
    }

    // MARK: ── TAB 0: RESUMEN ──

    var resumenTab: some View {
        VStack(spacing: BraverTheme.sectionSpacing) {
            streakRingCard
            statsRow
            miedoVsRealidadCard
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }

    var streakRingCard: some View {
        let goal = 90
        let days = streakService.orbProgressDays
        let fraction = min(Double(days) / Double(goal), 1.0)
        let stageName = BraverOrb.stageName(for: streakService.streakDays).uppercased()
        let nextStage = BraverOrb.nextStageName(for: streakService.streakDays).uppercased()

        return VStack(spacing: 20) {
            ZStack {
                // Track arc (240°, starts bottom-left)
                Circle()
                    .trim(from: 0, to: 2/3)
                    .stroke(BraverTheme.surfaceElevated, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(150))

                // Fill arc
                Circle()
                    .trim(from: 0, to: fraction * 2/3)
                    .stroke(
                        LinearGradient(
                            colors: [BraverTheme.accent, BraverTheme.success],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(150))
                    .animation(.spring(response: 0.8, dampingFraction: 0.75), value: fraction)

                // Center content
                VStack(spacing: 4) {
                    Text("\(days)d")
                        .font(.system(size: 52, weight: .heavy, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                    Text(stageName)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(BraverTheme.accent)
                        .kerning(1)
                }
                .offset(y: -8)

                // Next milestone label at bottom
                VStack {
                    Spacer()
                    Text("→ \(nextStage)")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                        .padding(.bottom, 10)
                }
                .frame(height: 200)
            }
            .frame(height: 200)

            VStack(spacing: 4) {
                Text(days >= goal
                     ? "¡Plan de 90 días completado!"
                     : "Faltan \(goal - days) días para el Braver completo")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(BraverTheme.cardPadding)
        .braverCard(elevated: true)
    }

    var statsRow: some View {
        HStack(spacing: 10) {
            StatChip(value: "\(streakService.streakDays)",  label: "Días\nen racha",     color: BraverTheme.bravura)
            StatChip(value: "\(totalCompleted)",            label: "Retos\ncompletados", color: BraverTheme.accent)
            StatChip(value: "\(momentosValor)",             label: "Momentos\nBraver",   color: BraverTheme.success)
        }
    }

    var miedoVsRealidadCard: some View {
        let miedoVsRealidad = 68
        return VStack(alignment: .leading, spacing: 14) {
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

    // MARK: ── TAB 1: RETOS ──

    var retosTab: some View {
        VStack(spacing: BraverTheme.sectionSpacing) {
            LogrosView(grouped: achievementGroups)
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }

    // MARK: ── TAB 2: DIARIO ──

    var diarioTab: some View {
        VStack(spacing: BraverTheme.sectionSpacing) {
            diarioInfoCard
            if !checkInService.checkIns.isEmpty {
                moodStatsCard
                moodHistoryCard
            } else {
                diarioEmptyCard
            }
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }

    var diarioInfoCard: some View {
        HStack(spacing: 14) {
            Text("🌙")
                .font(.system(size: 28))
            VStack(alignment: .leading, spacing: 3) {
                Text("Diario nocturno")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Text("Recibes una notificación a las 20:00 para registrar tu día.")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(BraverTheme.cardPadding)
        .braverCard(elevated: true)
    }

    var diarioEmptyCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "moon.stars")
                .font(.system(size: 36))
                .foregroundColor(BraverTheme.textTertiary)
            Text("Todavía no hay entradas")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(BraverTheme.textPrimary)
            Text("Cuando recibas la notificación de las 20:00, registra cómo fue tu día. Aquí verás tus estadísticas.")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(BraverTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(BraverTheme.cardPadding)
        .padding(.vertical, 10)
        .braverCard(elevated: true)
    }

    var moodStatsCard: some View {
        let all = checkInService.checkIns
        let bien    = all.filter { $0.mood == "😌" }.count
        let regular = all.filter { $0.mood == "😬" }.count
        let mal     = all.filter { $0.mood == "😤" }.count
        let total   = max(all.count, 1)

        return VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Resumen del diario")

            VStack(spacing: 12) {
                HStack(spacing: 0) {
                    StatChip(value: "\(all.count)", label: "Días\nregistrados", color: BraverTheme.accent)
                    Spacer().frame(width: 10)
                    StatChip(value: "\(Int(Double(bien) / Double(total) * 100))%", label: "Días\nbien", color: BraverTheme.success)
                    Spacer().frame(width: 10)
                    StatChip(value: "\(Int(Double(mal) / Double(total) * 100))%", label: "Días\ndifíciles", color: BraverTheme.danger)
                }

                // Mood bar
                VStack(alignment: .leading, spacing: 6) {
                    Text("Distribución de estado de ánimo")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                    GeometryReader { geo in
                        HStack(spacing: 2) {
                            if bien > 0 {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(BraverTheme.success)
                                    .frame(width: geo.size.width * CGFloat(bien) / CGFloat(total))
                            }
                            if regular > 0 {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(BraverTheme.warning)
                                    .frame(width: geo.size.width * CGFloat(regular) / CGFloat(total))
                            }
                            if mal > 0 {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(BraverTheme.danger)
                                    .frame(width: geo.size.width * CGFloat(mal) / CGFloat(total))
                            }
                        }
                        .frame(height: 10)
                        .cornerRadius(5)
                    }
                    .frame(height: 10)

                    HStack(spacing: 14) {
                        moodLegend(emoji: "😌", label: "Bien", count: bien, color: BraverTheme.success)
                        moodLegend(emoji: "😬", label: "Regular", count: regular, color: BraverTheme.warning)
                        moodLegend(emoji: "😤", label: "Mal", count: mal, color: BraverTheme.danger)
                    }
                }
            }
            .padding(BraverTheme.cardPadding)
            .braverCard(elevated: true)
        }
    }

    func moodLegend(emoji: String, label: String, count: Int, color: Color) -> some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text("\(emoji) \(label) (\(count))")
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(BraverTheme.textTertiary)
        }
    }

    var moodHistoryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Últimas entradas")

            VStack(spacing: 8) {
                ForEach(checkInService.checkIns.prefix(7)) { entry in
                    CheckInRow(entry: entry)
                }
            }
        }
    }

    // MARK: Helpers

    func shortDate(_ date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Hoy" }
        let fmt = DateFormatter()
        fmt.dateFormat = "d/M"
        return fmt.string(from: date)
    }
}

// MARK: - Check-in Row

struct CheckInRow: View {
    let entry: EveningCheckIn

    var formattedDate: String {
        let cal = Calendar.current
        if cal.isDateInToday(entry.date) { return "Hoy" }
        if cal.isDateInYesterday(entry.date) { return "Ayer" }
        let fmt = DateFormatter()
        fmt.dateFormat = "d MMM"
        fmt.locale = Locale(identifier: "es_ES")
        return fmt.string(from: entry.date)
    }

    var body: some View {
        HStack(spacing: 14) {
            Text(entry.mood)
                .font(.system(size: 28))
                .frame(width: 40, height: 40)
                .background(BraverTheme.surfaceElevated)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 3) {
                Text(formattedDate)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                if let note = entry.note, !note.isEmpty {
                    Text(note)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .lineLimit(1)
                } else {
                    Text(entry.moodLabel)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .braverCard(elevated: true)
    }
}
