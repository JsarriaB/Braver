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
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }

    var streakRingCard: some View {
        let goal  = 90
        let days  = streakService.orbProgressDays
        let frac  = min(CGFloat(days) / CGFloat(goal), 1.0)
        // 240° arc = 2/3 of circle, but as CGFloat to avoid integer division
        let arcSpan: CGFloat = 0.667
        let stageName = BraverOrb.stageName(for: streakService.orbProgressDays).uppercased()
        let nextStage = BraverOrb.nextStageName(for: streakService.orbProgressDays).uppercased()

        // Teal colors matching home screen ambient
        let tealDark  = Color(hex: "0B7A8A")
        let tealMid   = Color(hex: "0E9090")
        let tealLight = Color(hex: "14B8A6")

        return ZStack {
            // Outer aura glow
            Circle()
                .fill(tealMid.opacity(0.18))
                .frame(width: 240, height: 240)
                .blur(radius: 28)

            VStack(spacing: 20) {
                ZStack {
                    // Track (empty arc)
                    Circle()
                        .trim(from: 0, to: arcSpan)
                        .stroke(
                            Color(hex: "1A2535"),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .frame(width: 190, height: 190)
                        .rotationEffect(.degrees(150))

                    // Fill arc — teal gradient
                    Circle()
                        .trim(from: 0, to: max(frac * arcSpan, frac > 0 ? 0.015 : 0))
                        .stroke(
                            LinearGradient(
                                colors: [tealDark, tealMid, tealLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .frame(width: 190, height: 190)
                        .rotationEffect(.degrees(150))
                        .shadow(color: tealMid.opacity(0.55), radius: 10, x: 0, y: 0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.75), value: frac)

                    // Center text
                    VStack(spacing: 3) {
                        Text("\(days)d")
                            .font(.system(size: 50, weight: .heavy, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Text(stageName)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(tealLight)
                            .kerning(1.5)
                    }
                    .offset(y: -6)

                    // Next stage hint at arc bottom
                    VStack {
                        Spacer()
                        Text("→ \(nextStage)")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                            .padding(.bottom, 6)
                    }
                    .frame(height: 190)
                }
                .frame(width: 190, height: 190)

                Text(days >= goal
                     ? "¡Plan de 90 días completado!"
                     : "Faltan \(goal - days) días para el Braver completo")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, BraverTheme.cardPadding)
        .background(Color(hex: "080C14"))
        .cornerRadius(BraverTheme.radiusLarge)
        .overlay(
            RoundedRectangle(cornerRadius: BraverTheme.radiusLarge)
                .stroke(tealMid.opacity(0.2), lineWidth: 1)
        )
    }

    var statsRow: some View {
        HStack(spacing: 0) {
            statItem(value: "\(streakService.streakDays)", label: "Días racha", color: BraverTheme.bravura)
            Divider()
                .frame(width: 1, height: 36)
                .background(Color.white.opacity(0.07))
            statItem(value: "\(totalCompleted)", label: "Completados", color: BraverTheme.accent)
            Divider()
                .frame(width: 1, height: 36)
                .background(Color.white.opacity(0.07))
            statItem(value: "\(momentosValor)", label: "Momentos", color: BraverTheme.success)
        }
        .padding(.vertical, 20)
        .background(BraverTheme.surfaceElevated)
        .cornerRadius(BraverTheme.radiusMedium)
    }

    func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(BraverTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
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
            Button("Registrar") {
                showCheckIn = true
            }
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .foregroundColor(BraverTheme.accent)
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
