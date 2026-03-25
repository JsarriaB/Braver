import SwiftUI

struct HoyView: View {
    @StateObject private var streakService = StreakService.shared
    @StateObject private var historyService = ChallengeHistoryService.shared
    @State private var userName = "Jorge"
    @State private var challengeAccepted = false
    @State private var showReflectionModal = false
    @State private var featuredOrbIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var todaysOptions: [DailyChallenge] = []
    @State private var challengeSwapped = false

    var todayChallenge: DailyChallenge? {
        guard !todaysOptions.isEmpty else { return nil }
        if challengeSwapped && todaysOptions.count > 1 { return todaysOptions[1] }
        return todaysOptions[0]
    }
    var datoDelDia: DatoDelDia { DatosHoy.random() }

    var streak: Int { streakService.streakDays }
    var orbDays: Int { streakService.orbProgressDays }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:  return "Buenos días,"
        case 12..<18: return "Buenas tardes,"
        default:       return "Buenas noches,"
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Fixed header — no scrollea
                headerSection
                    .padding(.horizontal, BraverTheme.screenPadding)
                    .padding(.bottom, 12)
                    .background(BraverTheme.background)

                Divider()
                    .background(BraverTheme.surfaceBorder.opacity(0.4))

                // Scrollable content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: BraverTheme.sectionSpacing) {
                        weeklyDotsSection
                        orbSection
                        dailyChallengeSection
                        datoDelDiaSection
                    }
                    .padding(.horizontal, BraverTheme.screenPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 100) // margen tab bar
                }
            }
            .background(BraverTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showReflectionModal) {
            ReflexionModal(isPresented: $showReflectionModal)
        }
        .onAppear {
            streakService.registerAppOpen()
            featuredOrbIndex = currentStageIndex
            if todaysOptions.isEmpty {
                todaysOptions = ChallengeLibrary.todaysChallenges(orbDays: orbDays, seen: [])
            }
        }
    }

    // MARK: Header

    var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text(greeting)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.textTertiary)
                Text(userName)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
            }
            Spacer()
            streakBadge
        }
        .padding(.top, 8)
    }

    var streakBadge: some View {
        HStack(spacing: 5) {
            Text("🔥")
                .font(.system(size: 16))
            Text("\(streak)")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(BraverTheme.bravura)
            Text("días")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(BraverTheme.bravura.opacity(0.7))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(BraverTheme.bravura.opacity(0.12))
        .cornerRadius(BraverTheme.radiusPill)
        .overlay(
            RoundedRectangle(cornerRadius: BraverTheme.radiusPill)
                .stroke(BraverTheme.bravura.opacity(0.25), lineWidth: 1)
        )
    }

    // MARK: Weekly dots

    var weeklyDotsSection: some View {
        let calendar = Calendar.current
        let today = Date()
        let weekdayToday = calendar.component(.weekday, from: today)
        // Gregorian: 1=Dom, 2=Lun... 7=Sáb → convertimos a 0=Lun...6=Dom
        let todayIndex = (weekdayToday + 5) % 7
        let dayLabels = ["L", "M", "X", "J", "V", "S", "D"]
        // Mock: días pasados de esta semana como completados
        let completedDays = (0..<7).map { $0 < todayIndex }

        return HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { i in
                let isToday = i == todayIndex
                let isCompleted = completedDays[i]

                VStack(spacing: 5) {
                    ZStack {
                        if isCompleted {
                            Circle()
                                .fill(BraverTheme.accent)
                                .frame(width: 30, height: 30)
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        } else if isToday {
                            Circle()
                                .fill(BraverTheme.surfaceElevated)
                                .frame(width: 30, height: 30)
                            Circle()
                                .stroke(BraverTheme.accent, lineWidth: 2)
                                .frame(width: 30, height: 30)
                        } else {
                            Circle()
                                .fill(BraverTheme.surfaceElevated)
                                .frame(width: 30, height: 30)
                        }
                    }

                    Text(dayLabels[i])
                        .font(.system(size: 10, weight: isToday ? .semibold : .regular, design: .rounded))
                        .foregroundColor(isToday ? BraverTheme.accent : BraverTheme.textTertiary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .braverCard()
    }

    // MARK: Orb section

    struct OrbStage {
        let name: String
        let streakValue: Int
        let minDays: Int
    }

    let orbStages: [OrbStage] = [
        OrbStage(name: "Cerrado",         streakValue: 0,  minDays: 0),
        OrbStage(name: "Despertando",     streakValue: 3,  minDays: 3),
        OrbStage(name: "Abriéndote",      streakValue: 7,  minDays: 7),
        OrbStage(name: "En Marcha",       streakValue: 14, minDays: 14),
        OrbStage(name: "Más Fuerte",      streakValue: 21, minDays: 21),
        OrbStage(name: "Sin Esconderte",  streakValue: 30, minDays: 30),
        OrbStage(name: "Presente",        streakValue: 45, minDays: 45),
        OrbStage(name: "Sin Frenos",      streakValue: 60, minDays: 60),
        OrbStage(name: "Braver",          streakValue: 90, minDays: 90),
    ]

    var currentStageIndex: Int {
        var idx = 0
        for (i, stage) in orbStages.enumerated() {
            if orbDays >= stage.minDays { idx = i }
        }
        return idx
    }

    var orbSection: some View {
        let orbSize: CGFloat = 108
        let sideScale: CGFloat = 0.46   // más pequeñas para no cortarse
        let containerW: CGFloat = 140
        let gap: CGFloat = 16
        let step = containerW + gap

        return GeometryReader { geo in
            let baseX = geo.size.width / 2 - containerW / 2
            let totalOffset = baseX - CGFloat(featuredOrbIndex) * step + dragOffset

            HStack(spacing: gap) {
                ForEach(Array(orbStages.enumerated()), id: \.offset) { i, stage in
                    let isFeatured = i == featuredOrbIndex
                    let isUnlocked = orbDays >= stage.minDays
                    let daysLeft = max(0, stage.minDays - streak)

                    VStack(spacing: 8) {
                        ZStack {
                            Color.clear.frame(width: orbSize, height: orbSize)
                            BraverOrb(
                                streak: stage.streakValue,
                                size: isFeatured ? orbSize : orbSize * sideScale,
                                dimmed: !isUnlocked
                            )
                            if !isUnlocked {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.35))
                            }
                        }

                        VStack(spacing: 3) {
                            Text(stage.name)
                                .font(.system(size: isFeatured ? 15 : 12, weight: .semibold, design: .rounded))
                                .foregroundColor(isFeatured ? BraverTheme.textPrimary : BraverTheme.textTertiary)

                            if isFeatured && i == currentStageIndex {
                                Text("\(orbDays) días")
                                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                                    .foregroundColor(BraverTheme.textPrimary)
                            } else if isFeatured && isUnlocked {
                                Text("Conseguida")
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(BraverTheme.success)
                            } else if isFeatured {
                                Text("Faltan \(daysLeft)d")
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(BraverTheme.textTertiary)
                            } else {
                                Text(isUnlocked ? "✓" : "\(daysLeft)d")
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(isUnlocked ? BraverTheme.success : BraverTheme.textTertiary.opacity(0.45))
                            }
                        }
                        .frame(height: 38)
                    }
                    .frame(width: containerW)
                    .opacity(isFeatured ? 1.0 : 0.55)
                    .animation(.spring(response: 0.3, dampingFraction: 0.75), value: featuredOrbIndex)
                }
            }
            .offset(x: totalOffset)
            .animation(.spring(response: 0.3, dampingFraction: 0.75), value: featuredOrbIndex)
            .gesture(
                DragGesture(minimumDistance: 8)
                    .onChanged { v in
                        dragOffset = v.translation.width * 0.75
                    }
                    .onEnded { v in
                        let thresh = step * 0.28
                        let vel = v.predictedEndTranslation.width - v.translation.width
                        if (v.translation.width < -thresh || vel < -60), featuredOrbIndex < orbStages.count - 1 {
                            featuredOrbIndex += 1
                        } else if (v.translation.width > thresh || vel > 60), featuredOrbIndex > 0 {
                            featuredOrbIndex -= 1
                        }
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            dragOffset = 0
                        }
                    }
            )
        }
        .frame(height: 200)
        .clipped()
        .onAppear { featuredOrbIndex = currentStageIndex }
    }

    // MARK: Daily Challenge

    var dailyChallengeSection: some View {
        VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
            SectionHeader(title: "Misión de hoy")

            if let challenge = todayChallenge {
                VStack(alignment: .leading, spacing: 16) {
                    // Category + difficulty
                    HStack(spacing: 8) {
                        Text(challenge.categoryEmoji)
                            .font(.system(size: 14))
                        Text(challenge.category)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                        Spacer()
                        Text(challenge.difficulty.rawValue)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(challenge.difficulty.color)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(challenge.difficulty.color.opacity(0.15))
                            .cornerRadius(BraverTheme.radiusPill)
                    }

                    Text(challenge.title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(challenge.subtitle)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()
                        .background(BraverTheme.surfaceBorder)

                    if challengeAccepted {
                        HStack(spacing: 12) {
                            Button {
                                streakService.registerChallengeCompleted()
                                if let c = todayChallenge {
                                    historyService.record(challenge: c, status: .completed)
                                }
                                showReflectionModal = true
                            } label: {
                                Label("Ya lo hice", systemImage: "checkmark")
                            }
                            .buttonStyle(BraverPrimaryButton(color: BraverTheme.success))

                            Button("Lo intenté") {
                                if let c = todayChallenge {
                                    historyService.record(challenge: c, status: .attempted)
                                }
                                showReflectionModal = true
                            }
                            .buttonStyle(BraverGhostButton())
                        }
                    } else {
                        VStack(spacing: 10) {
                            Button("Lo intento hoy  →") {
                                withAnimation(.spring(response: 0.3)) {
                                    challengeAccepted = true
                                }
                            }
                            .buttonStyle(BraverPrimaryButton())

                            if !challengeSwapped && todaysOptions.count > 1 {
                                Button("Ver otro reto") {
                                    withAnimation(.spring(response: 0.3)) {
                                        challengeSwapped = true
                                    }
                                }
                                .buttonStyle(BraverGhostButton())
                            }
                        }
                    }

                    if !challengeAccepted {
                        Text("Completar esto suma 1 día a tu racha.")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(BraverTheme.cardPadding)
                .braverCard(elevated: true)
            } else {
                Text("Cargando misión...")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(BraverTheme.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(BraverTheme.cardPadding)
                    .braverCard()
            }
        }
    }

    // MARK: Dato del día

    var datoDelDiaSection: some View {
        VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
            SectionHeader(title: "Dato de hoy")

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(BraverTheme.warning)
                        .font(.system(size: 14))
                    Text(datoDelDia.tag)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(BraverTheme.warning)
                }

                Text(datoDelDia.text)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(3)

                Text("Toca para leer más →")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.accent)
            }
            .padding(BraverTheme.cardPadding)
            .braverCard(elevated: true)
        }
    }
}

// MARK: - Reflexion Modal

struct ReflexionModal: View {
    @Binding var isPresented: Bool
    @State private var sudsValue: Double = 40
    @State private var outcomeText = ""
    @State private var selectedEmoji: String? = nil

    let emojis = ["😌", "😬", "😤"]
    let emojiLabels = ["Bien", "Regular", "Mal"]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 6) {
                        Text("¿Cómo fue?")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Text("Registra tu experiencia. Solo tarda 30 segundos.")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 8)

                    // SUDS slider
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("¿Cuánta ansiedad sentiste?")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(BraverTheme.textPrimary)
                            Spacer()
                            Text("\(Int(sudsValue))")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(BraverTheme.sudsColor(for: Int(sudsValue)))
                        }
                        Slider(value: $sudsValue, in: 0...100, step: 1)
                            .tint(BraverTheme.sudsColor(for: Int(sudsValue)))
                        HStack {
                            Text("Nada")
                            Spacer()
                            Text("Mucha")
                        }
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                    }
                    .padding(BraverTheme.cardPadding)
                    .braverCard()

                    // Outcome text
                    VStack(alignment: .leading, spacing: 10) {
                        Text("¿Qué pasó realmente?")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        TextField("Opcional — cuéntame cómo fue", text: $outcomeText, axis: .vertical)
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .lineLimit(3...5)
                            .padding(14)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusSmall)
                    }
                    .padding(BraverTheme.cardPadding)
                    .braverCard()

                    // Emoji how do you feel
                    VStack(spacing: 12) {
                        Text("¿Cómo te sientes ahora?")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        HStack(spacing: 20) {
                            ForEach(0..<3) { i in
                                Button {
                                    withAnimation(.spring(response: 0.2)) {
                                        selectedEmoji = emojis[i]
                                    }
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(emojis[i])
                                            .font(.system(size: 36))
                                            .scaleEffect(selectedEmoji == emojis[i] ? 1.2 : 1)
                                        Text(emojiLabels[i])
                                            .font(.system(size: 11, weight: .medium, design: .rounded))
                                            .foregroundColor(selectedEmoji == emojis[i] ? BraverTheme.accent : BraverTheme.textTertiary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(selectedEmoji == emojis[i] ? BraverTheme.accent.opacity(0.12) : BraverTheme.surface)
                                    .cornerRadius(BraverTheme.radiusMedium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                            .stroke(selectedEmoji == emojis[i] ? BraverTheme.accent.opacity(0.4) : BraverTheme.surfaceBorder, lineWidth: 1)
                                    )
                                }
                                .animation(.spring(response: 0.2), value: selectedEmoji)
                            }
                        }
                    }
                    .padding(BraverTheme.cardPadding)
                    .braverCard()

                    // Save button
                    Button("Guardar reflexión") {
                        isPresented = false
                    }
                    .buttonStyle(BraverPrimaryButton())
                    .padding(.top, 4)
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.bottom, 40)
            }
            .background(BraverTheme.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(BraverTheme.textTertiary)
                            .font(.system(size: 20))
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Supporting Types

struct DatoDelDia {
    let tag: String
    let text: String
}
