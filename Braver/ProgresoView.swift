import SwiftUI
import Combine
import SuperwallKit

struct ProgresoView: View {
    @StateObject private var streakService     = StreakService.shared
    @StateObject private var historyService    = ChallengeHistoryService.shared
    @StateObject private var checkInService    = EveningCheckInService.shared
    @StateObject private var achievementsService = AchievementsService.shared

    @State private var selectedTab = 0   // 0 = Resumen, 1 = Retos, 2 = Diario
    @State private var showCheckIn = false
    @State private var selectedPlan = 1  // 0 = semana, 1 = mes, 2 = año
    @State private var showPaywall = false
    @State private var showSpecialOffer = false

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
        .sheet(isPresented: $showPaywall) {
            BraverProPaywallView(selectedPlan: $selectedPlan, isPresented: $showPaywall)
        }
        .sheet(isPresented: $showSpecialOffer) {
            BraverSpecialOfferView(isPresented: $showSpecialOffer)
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
            if !historyService.attempts.isEmpty {
                categoryStatsCard
            }
            proBanner
            specialOfferBanner
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }

    var proBanner: some View {
        Button { showPaywall = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(BraverTheme.accent.opacity(0.15))
                        .frame(width: 46, height: 46)
                    Image(systemName: "crown.fill")
                        .font(.system(size: 20))
                        .foregroundColor(BraverTheme.accent)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text("Braver Pro")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                    Text("Desbloquea todos los retos, Nova y más")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(BraverTheme.textTertiary)
            }
            .padding(BraverTheme.cardPadding)
            .background(BraverTheme.surfaceElevated)
            .cornerRadius(BraverTheme.radiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                    .stroke(BraverTheme.accent.opacity(0.3), lineWidth: 1)
            )
        }
    }

    var specialOfferBanner: some View {
        Button { showSpecialOffer = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(BraverTheme.bravura.opacity(0.15))
                        .frame(width: 46, height: 46)
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 20))
                        .foregroundColor(BraverTheme.bravura)
                }
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Oferta especial")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Text("−50%")
                            .font(.system(size: 11, weight: .heavy, design: .rounded))
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(BraverTheme.bravura)
                            .cornerRadius(5)
                    }
                    Text("Solo por tiempo limitado. Oferta de lanzamiento.")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(BraverTheme.textTertiary)
            }
            .padding(BraverTheme.cardPadding)
            .background(BraverTheme.surfaceElevated)
            .cornerRadius(BraverTheme.radiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                    .stroke(BraverTheme.bravura.opacity(0.3), lineWidth: 1)
            )
        }
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


    // MARK: ── STATS POR CATEGORÍA ──

    private struct CategoryStat {
        let name: String
        let emoji: String
        let completed: Int
        let total: Int
        let avgSuds: Double?
        var completionRate: Double { total > 0 ? Double(completed) / Double(total) : 0 }
    }

    private var categoryStats: [CategoryStat] {
        let grouped = Dictionary(grouping: historyService.attempts, by: \.category)
        return grouped.compactMap { category, items in
            guard let first = items.first else { return nil }
            let completed = items.filter { $0.status == .completed }.count
            let sudsValues = items.compactMap { $0.suds }
            let avg: Double? = sudsValues.isEmpty ? nil
                : Double(sudsValues.reduce(0, +)) / Double(sudsValues.count)
            return CategoryStat(name: category, emoji: first.categoryEmoji,
                                completed: completed, total: items.count, avgSuds: avg)
        }
        .sorted { $0.total > $1.total }
    }

    var categoryStatsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Por categoría")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(BraverTheme.textPrimary)

            ForEach(categoryStats, id: \.name) { stat in
                VStack(spacing: 6) {
                    HStack(spacing: 6) {
                        Text(stat.emoji)
                            .font(.system(size: 14))
                        Text(stat.name)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Spacer()
                        if let avg = stat.avgSuds {
                            Text("SUDS ~\(Int(avg))")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundColor(BraverTheme.sudsColor(for: Int(avg)))
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(BraverTheme.sudsColor(for: Int(avg)).opacity(0.15))
                                .cornerRadius(6)
                        }
                        Text("\(Int(stat.completionRate * 100))%")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(BraverTheme.accent)
                            .frame(width: 38, alignment: .trailing)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(BraverTheme.surfaceBorder.opacity(0.4))
                                .frame(height: 6)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(BraverTheme.accent)
                                .frame(width: geo.size.width * stat.completionRate, height: 6)
                        }
                    }
                    .frame(height: 6)
                }
            }

            let qualified = categoryStats.filter { $0.total >= 2 }
            if let best = qualified.max(by: { $0.completionRate < $1.completionRate }),
               let worst = qualified.min(by: { $0.completionRate > $1.completionRate }),
               best.name != worst.name {
                Divider().background(BraverTheme.surfaceBorder.opacity(0.4))
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("💪 Más fácil")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.success)
                        Text("\(best.emoji) \(best.name)")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("🎯 Más difícil")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.warning)
                        Text("\(worst.emoji) \(worst.name)")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                    }
                }
            }
        }
        .padding(BraverTheme.cardPadding)
        .braverCard()
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
            if checkInService.hasCheckInToday {
                Text("✓ Registrado")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textTertiary)
            } else {
                Button("Registrar") {
                    showCheckIn = true
                }
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(BraverTheme.accent)
            }
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
            Text("\(label) (\(count))")
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

// MARK: - Paywall Pro (full screen sheet)

struct BraverProPaywallView: View {
    @Binding var selectedPlan: Int
    @Binding var isPresented: Bool

    private let plans: [(label: String, price: String, period: String, note: String, badge: String?)] = [
        ("Semanal",  "€10", "/semana",  "Ideal para probar",      nil),
        ("Mensual",  "€25", "/mes",     "Lo más flexible",        nil),
        ("Anual",    "€80", "/año",     "Menos de €0,90/día",     "MEJOR PRECIO"),
    ]

    private let features: [(String, String)] = [
        ("🎯", "150+ retos de exposición gradual"),
        ("🤖", "Coach IA Nova sin límites"),
        ("😰", "Modo Pánico con guía paso a paso"),
        ("📊", "Estadísticas detalladas por categoría"),
        ("🏆", "Sistema de logros y los 9 estadios"),
        ("📓", "Diario nocturno de progreso"),
    ]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            BraverTheme.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Hero ──
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(BraverTheme.accent.opacity(0.12))
                                .frame(width: 80, height: 80)
                            Image(systemName: "crown.fill")
                                .font(.system(size: 34))
                                .foregroundColor(BraverTheme.accent)
                        }
                        Text("BRAVER PRO")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .kerning(1)
                        Text("Accede a todo lo que Braver tiene.")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 56)
                    .padding(.bottom, 32)

                    // ── Features ──
                    VStack(spacing: 0) {
                        ForEach(features, id: \.0) { emoji, text in
                            HStack(spacing: 14) {
                                Text(emoji).font(.system(size: 18))
                                Text(text)
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(BraverTheme.textPrimary)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(BraverTheme.accent)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 13)
                            Divider()
                                .background(BraverTheme.surfaceBorder.opacity(0.25))
                                .padding(.leading, 58)
                        }
                    }
                    .background(BraverTheme.surfaceElevated)
                    .cornerRadius(BraverTheme.radiusMedium)
                    .padding(.horizontal, 20)

                    // ── Plan selector ──
                    VStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.25)) { selectedPlan = i }
                            } label: {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .stroke(selectedPlan == i ? BraverTheme.accent : BraverTheme.surfaceBorder.opacity(0.5), lineWidth: 2)
                                            .frame(width: 22, height: 22)
                                        if selectedPlan == i {
                                            Circle()
                                                .fill(BraverTheme.accent)
                                                .frame(width: 11, height: 11)
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 8) {
                                            Text(plans[i].label)
                                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                                .foregroundColor(BraverTheme.textPrimary)
                                            if let badge = plans[i].badge {
                                                Text(badge)
                                                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                                                    .foregroundColor(.black)
                                                    .padding(.horizontal, 7)
                                                    .padding(.vertical, 3)
                                                    .background(BraverTheme.accent)
                                                    .cornerRadius(5)
                                            }
                                        }
                                        Text(plans[i].note)
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundColor(BraverTheme.textTertiary)
                                    }
                                    Spacer()
                                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                                        Text(plans[i].price)
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundColor(selectedPlan == i ? BraverTheme.accent : BraverTheme.textPrimary)
                                        Text(plans[i].period)
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundColor(BraverTheme.textTertiary)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(selectedPlan == i ? BraverTheme.accent.opacity(0.08) : BraverTheme.surfaceElevated)
                                .cornerRadius(BraverTheme.radiusMedium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                        .stroke(selectedPlan == i ? BraverTheme.accent.opacity(0.6) : Color.clear, lineWidth: 1.5)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // ── CTA ──
                    VStack(spacing: 12) {
                        Button {
                            Superwall.shared.register(placement: "campaign_trigger")
                        } label: {
                            Text("Empezar ahora")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(BraverTheme.accent)
                                .cornerRadius(BraverTheme.radiusMedium)
                        }
                        Text("Cancela cuando quieras · Sin compromisos")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }

            // ── Close button ──
            Button { isPresented = false } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(BraverTheme.textSecondary)
                    .padding(10)
                    .background(BraverTheme.surfaceElevated)
                    .clipShape(Circle())
            }
            .padding(.top, 16)
            .padding(.trailing, 20)
        }
    }
}

// MARK: - Special Offer (full screen sheet)

struct BraverSpecialOfferView: View {
    @Binding var isPresented: Bool
    @State private var timeRemaining: Int = 300
    private let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var timeFormatted: String {
        String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
    }
    private var expired: Bool { timeRemaining == 0 }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            BraverTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Orange top bar ──
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill").font(.system(size: 12)).foregroundColor(.black)
                    Text("OFERTA DE LANZAMIENTO")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundColor(.black)
                        .kerning(0.8)
                    Spacer()
                    Image(systemName: "bolt.fill").font(.system(size: 12)).foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(BraverTheme.bravura)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {

                        // ── Hero ──
                        VStack(spacing: 14) {
                            Text("50%")
                                .font(.system(size: 80, weight: .heavy, design: .rounded))
                                .foregroundColor(BraverTheme.textPrimary)
                                + Text(" OFF")
                                .font(.system(size: 36, weight: .heavy, design: .rounded))
                                .foregroundColor(BraverTheme.bravura)

                            Text("Solo para nuevos usuarios")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(BraverTheme.textSecondary)
                        }
                        .padding(.top, 40)

                        // ── Countdown ──
                        VStack(spacing: 8) {
                            Text(expired ? "Oferta expirada" : "La oferta expira en")
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(BraverTheme.textSecondary)

                            Text(expired ? "00:00" : timeFormatted)
                                .font(.system(size: 52, weight: .heavy, design: .monospaced))
                                .foregroundColor(expired ? BraverTheme.danger : BraverTheme.bravura)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 14)
                                .background((expired ? BraverTheme.danger : BraverTheme.bravura).opacity(0.1))
                                .cornerRadius(BraverTheme.radiusMedium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                        .stroke((expired ? BraverTheme.danger : BraverTheme.bravura).opacity(0.3), lineWidth: 1)
                                )
                        }

                        // ── Price comparison ──
                        HStack(spacing: 0) {
                            VStack(spacing: 6) {
                                Text("Precio normal")
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(BraverTheme.textTertiary)
                                Text("€80")
                                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                                    .foregroundColor(BraverTheme.textTertiary)
                                    .strikethrough(true, color: BraverTheme.textTertiary)
                                Text("por año")
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(BraverTheme.textTertiary)
                            }
                            .frame(maxWidth: .infinity)

                            Rectangle()
                                .fill(BraverTheme.surfaceBorder.opacity(0.4))
                                .frame(width: 1, height: 80)

                            VStack(spacing: 6) {
                                Text("Tu precio hoy")
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundColor(BraverTheme.bravura)
                                Text("€40")
                                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                                    .foregroundColor(BraverTheme.textPrimary)
                                Text("por año")
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(BraverTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.vertical, 20)
                        .background(BraverTheme.surfaceElevated)
                        .cornerRadius(BraverTheme.radiusMedium)
                        .padding(.horizontal, 20)

                        // ── CTA ──
                        VStack(spacing: 12) {
                            Button {
                                Superwall.shared.register(placement: "campaign_trigger")
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "bolt.fill").font(.system(size: 14))
                                    Text(expired ? "Oferta no disponible" : "Conseguir oferta · €40/año")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    expired
                                        ? AnyView(BraverTheme.surfaceBorder)
                                        : AnyView(LinearGradient(
                                            colors: [BraverTheme.bravura, Color(hex: "C85A08")],
                                            startPoint: .leading, endPoint: .trailing
                                        ))
                                )
                                .cornerRadius(BraverTheme.radiusMedium)
                                .shadow(color: expired ? .clear : BraverTheme.bravura.opacity(0.35), radius: 10, x: 0, y: 4)
                            }
                            .disabled(expired)
                            .padding(.horizontal, 20)

                            Text("Equivale a menos de €0,11 al día")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }

            // ── Close button ──
            Button { isPresented = false } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(BraverTheme.textSecondary)
                    .padding(10)
                    .background(BraverTheme.surfaceElevated)
                    .clipShape(Circle())
            }
            .padding(.top, 56)
            .padding(.trailing, 20)
        }
        .onReceive(countdown) { _ in
            if timeRemaining > 0 { timeRemaining -= 1 }
        }
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
