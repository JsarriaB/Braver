import SwiftUI

// MARK: - Lesson Wizard Container

struct LessonWizardView: View {
    let lesson: Lesson
    let moduleColor: Color

    @StateObject private var progress = GuiaProgress.shared
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int = 0
    @State private var showExitAlert = false

    private var screens: [LessonScreenData] { lesson.screens ?? [] }
    private var currentScreen: LessonScreenData { screens[currentIndex] }
    private var progressFraction: Double {
        screens.isEmpty ? 0 : Double(currentIndex + 1) / Double(screens.count)
    }

    var body: some View {
        ZStack(alignment: .top) {
            BraverTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                wizardHeader
                    .zIndex(1)

                ZStack {
                    ForEach(0..<screens.count, id: \.self) { i in
                        if i == currentIndex {
                            LessonScreenView(
                                screen: screens[i],
                                moduleColor: moduleColor,
                                lessonNumber: lesson.number,
                                streakDays: StreakService.shared.streakDays,
                                onContinue: advance
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.22), value: currentIndex)
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
        .alert("¿Salir de la lección?", isPresented: $showExitAlert) {
            Button("Salir", role: .destructive) { dismiss() }
            Button("Seguir", role: .cancel) {}
        } message: {
            Text("Perderás el progreso de esta lección.")
        }
    }

    // MARK: Header

    var wizardHeader: some View {
        HStack(spacing: 14) {
            Button {
                if currentIndex >= 3 {
                    showExitAlert = true
                } else {
                    dismiss()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(BraverTheme.textSecondary)
                    .frame(width: 32, height: 32)
                    .background(BraverTheme.surfaceElevated)
                    .clipShape(Circle())
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(BraverTheme.surfaceElevated)
                        .frame(height: 4)
                    Capsule()
                        .fill(moduleColor)
                        .frame(width: geo.size.width * progressFraction, height: 4)
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: progressFraction)
                }
            }
            .frame(height: 4)
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(BraverTheme.background)
    }

    // MARK: Navigation

    func advance() {
        guard currentIndex < screens.count - 1 else {
            dismiss()
            return
        }
        let next = screens[currentIndex + 1]
        if next.type == .celebracion {
            progress.markCompleted(lesson.id)
        }
        withAnimation { currentIndex += 1 }
    }
}

// MARK: - Screen Dispatcher

struct LessonScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let lessonNumber: Int
    let streakDays: Int
    let onContinue: () -> Void

    var body: some View {
        switch screen.type {
        case .intro:
            IntroScreenView(screen: screen, moduleColor: moduleColor, onContinue: onContinue)
        case .diagnostico:
            DiagnosticoScreenView(screen: screen, moduleColor: moduleColor, onContinue: onContinue)
        case .teoria:
            TeoriaScreenView(screen: screen, moduleColor: moduleColor, onContinue: onContinue)
        case .carrusel:
            CarruselScreenView(screen: screen, moduleColor: moduleColor, onContinue: onContinue)
        case .tabs:
            TabsScreenView(screen: screen, moduleColor: moduleColor, onContinue: onContinue)
        case .ejercicioIdentifica:
            EjercicioIdentificaView(screen: screen, moduleColor: moduleColor, onContinue: onContinue)
        case .resumen:
            ResumenScreenView(screen: screen, moduleColor: moduleColor, onContinue: onContinue)
        case .celebracion:
            CelebracionScreenView(screen: screen, moduleColor: moduleColor, lessonNumber: lessonNumber, streakDays: streakDays, onContinue: onContinue)
        case .rating:
            RatingScreenView(screen: screen, moduleColor: moduleColor, onContinue: onContinue)
        }
    }
}

// MARK: - Shared Continue Button

struct WizardContinueButton: View {
    let label: String
    let color: Color
    var enabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(enabled ? .white : BraverTheme.textTertiary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(enabled ? color : BraverTheme.surfaceElevated)
                .cornerRadius(BraverTheme.radiusPill)
        }
        .disabled(!enabled)
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.bottom, 32)
        .padding(.top, 12)
        .background(BraverTheme.background)
    }
}

// MARK: - Intro Screen

struct IntroScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 28) {
                // Icon
                ZStack {
                    Circle()
                        .fill(moduleColor.opacity(0.12))
                        .frame(width: 80, height: 80)
                    Image(systemName: screen.icon.isEmpty ? "brain.head.profile" : screen.icon)
                        .font(.system(size: 34, weight: .medium))
                        .foregroundColor(moduleColor)
                }

                VStack(spacing: 14) {
                    Text(screen.title)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    if !screen.subtitle.isEmpty {
                        Text(screen.subtitle)
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal, BraverTheme.screenPadding)

            Spacer()

            WizardContinueButton(label: "Vamos", color: moduleColor, action: onContinue)
        }
    }
}

// MARK: - Diagnostico Screen

struct DiagnosticoScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let onContinue: () -> Void

    @State private var selected: Int? = nil

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Label
                    Text("Pregunta rápida")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(BraverTheme.accent)
                        .cornerRadius(BraverTheme.radiusPill)

                    Text(screen.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(spacing: 10) {
                        ForEach(0..<screen.choices.count, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.25)) { selected = i }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { onContinue() }
                            } label: {
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(selected == i ? moduleColor : BraverTheme.surfaceBorder)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Circle().stroke(selected == i ? moduleColor : BraverTheme.textTertiary, lineWidth: 1.5)
                                        )

                                    Text(screen.choices[i])
                                        .font(.system(size: 15, design: .rounded))
                                        .foregroundColor(selected == i ? BraverTheme.textPrimary : BraverTheme.textSecondary)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Spacer()
                                }
                                .padding(BraverTheme.cardPadding)
                                .background(selected == i ? moduleColor.opacity(0.1) : BraverTheme.surfaceElevated)
                                .cornerRadius(BraverTheme.radiusMedium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                        .stroke(selected == i ? moduleColor.opacity(0.4) : Color.clear, lineWidth: 1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Teoria Screen

struct TeoriaScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text(screen.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    if !screen.body.isEmpty {
                        Text(screen.body)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if !screen.highlight.isEmpty {
                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(moduleColor)
                                .frame(width: 3)
                                .cornerRadius(2)
                            Text(screen.highlight)
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(BraverTheme.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                                .italic()
                        }
                        .padding(BraverTheme.cardPadding)
                        .background(moduleColor.opacity(0.08))
                        .cornerRadius(BraverTheme.radiusMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                .stroke(moduleColor.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }

            WizardContinueButton(label: "Continuar", color: moduleColor, action: onContinue)
        }
    }
}

// MARK: - Carrusel Screen

struct CarruselScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let onContinue: () -> Void

    @State private var currentCard = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(screen.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    if !screen.body.isEmpty {
                        Text(screen.body)
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Cards
                    TabView(selection: $currentCard) {
                        ForEach(0..<screen.cards.count, id: \.self) { i in
                            CarruselCardView(card: screen.cards[i], moduleColor: moduleColor)
                                .tag(i)
                                .padding(.horizontal, 4)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 170)

                    // Dots
                    HStack(spacing: 6) {
                        ForEach(0..<screen.cards.count, id: \.self) { i in
                            Capsule()
                                .fill(i == currentCard ? moduleColor : BraverTheme.textTertiary.opacity(0.4))
                                .frame(width: i == currentCard ? 18 : 6, height: 6)
                                .animation(.spring(response: 0.3), value: currentCard)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }

            WizardContinueButton(label: "Continuar", color: moduleColor, action: onContinue)
        }
    }
}

struct CarruselCardView: View {
    let card: LessonCard
    let moduleColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !card.icon.isEmpty {
                Image(systemName: card.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(moduleColor)
            }
            Text(card.title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(BraverTheme.textPrimary)
            Text(card.body)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(BraverTheme.textSecondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(BraverTheme.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(moduleColor.opacity(0.07))
        .cornerRadius(BraverTheme.radiusMedium)
        .overlay(
            RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                .stroke(moduleColor.opacity(0.18), lineWidth: 1)
        )
    }
}

// MARK: - Tabs Screen

struct TabsScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let onContinue: () -> Void

    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text(screen.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    // Tab picker
                    HStack(spacing: 0) {
                        ForEach(0..<screen.tabs.count, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.25)) { selectedTab = i }
                            } label: {
                                Text(screen.tabs[i].title)
                                    .font(.system(size: 13, weight: selectedTab == i ? .semibold : .regular, design: .rounded))
                                    .foregroundColor(selectedTab == i ? .white : BraverTheme.textTertiary)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedTab == i ? moduleColor : Color.clear)
                                    .cornerRadius(BraverTheme.radiusPill)
                            }
                        }
                    }
                    .padding(4)
                    .background(BraverTheme.surfaceElevated)
                    .cornerRadius(BraverTheme.radiusPill)

                    // Tab content
                    if selectedTab < screen.tabs.count {
                        Text(screen.tabs[selectedTab].body)
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(BraverTheme.cardPadding)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusMedium)
                            .animation(.easeInOut(duration: 0.15), value: selectedTab)
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }

            WizardContinueButton(label: "Continuar", color: moduleColor, action: onContinue)
        }
    }
}

// MARK: - Ejercicio Identifica Screen

struct EjercicioIdentificaView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let onContinue: () -> Void

    @State private var tappedIndices: Set<Int> = []
    @State private var lastTapped: Int? = nil

    var canContinue: Bool { !tappedIndices.isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Label
                    Text("Ejercicio")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(BraverTheme.accent)
                        .cornerRadius(BraverTheme.radiusPill)

                    Text(screen.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    if !screen.body.isEmpty {
                        Text(screen.body)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Options grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(0..<screen.identifyOptions.count, id: \.self) { i in
                            let opt = screen.identifyOptions[i]
                            let tapped = tappedIndices.contains(i)
                            let isCorrect = opt.isCorrect

                            Button {
                                withAnimation(.spring(response: 0.2)) {
                                    tappedIndices.insert(i)
                                    lastTapped = i
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    if tapped {
                                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(isCorrect ? BraverTheme.success : BraverTheme.danger)
                                    }
                                    Text(opt.text)
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(tapped ? .white : BraverTheme.textPrimary)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
                                .background(
                                    tapped
                                        ? (isCorrect ? BraverTheme.success.opacity(0.8) : BraverTheme.danger.opacity(0.75))
                                        : BraverTheme.surfaceElevated
                                )
                                .cornerRadius(BraverTheme.radiusMedium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                        .stroke(
                                            tapped ? (isCorrect ? BraverTheme.success : BraverTheme.danger) : BraverTheme.surfaceBorder,
                                            lineWidth: 1.5
                                        )
                                )
                            }
                            .disabled(tapped)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    // Explanation for last tapped
                    if let idx = lastTapped {
                        let opt = screen.identifyOptions[idx]
                        if !opt.explanation.isEmpty {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: opt.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(opt.isCorrect ? BraverTheme.success : BraverTheme.danger)
                                    .font(.system(size: 16))
                                Text(opt.explanation)
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(BraverTheme.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(BraverTheme.cardPadding)
                            .background(BraverTheme.surface)
                            .cornerRadius(BraverTheme.radiusMedium)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.spring(response: 0.3), value: lastTapped)
                        }
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }

            WizardContinueButton(label: "Continuar", color: moduleColor, enabled: canContinue, action: onContinue)
        }
    }
}

// MARK: - Resumen Screen

struct ResumenScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Lo que aprendiste")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(moduleColor)
                        Text(screen.title)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(spacing: 12) {
                        ForEach(0..<screen.keyPoints.count, id: \.self) { i in
                            HStack(alignment: .top, spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(moduleColor.opacity(0.15))
                                        .frame(width: 32, height: 32)
                                    Text("\(i + 1)")
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                        .foregroundColor(moduleColor)
                                }
                                Text(screen.keyPoints[i])
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(BraverTheme.textPrimary)
                                    .lineSpacing(4)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 6)
                                Spacer()
                            }
                            .padding(BraverTheme.cardPadding)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusMedium)
                        }
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }

            WizardContinueButton(label: "Terminar lección", color: moduleColor, action: onContinue)
        }
    }
}

// MARK: - Celebracion Screen

struct CelebracionScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let lessonNumber: Int
    let streakDays: Int
    let onContinue: () -> Void

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                // Icon
                ZStack {
                    Circle()
                        .fill(moduleColor.opacity(0.12))
                        .frame(width: 100, height: 100)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 52))
                        .foregroundColor(moduleColor)
                }
                .scaleEffect(appeared ? 1 : 0.5)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.65).delay(0.1), value: appeared)

                VStack(spacing: 8) {
                    Text(screen.title.isEmpty ? "¡Lección completada!" : screen.title)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                    if !screen.body.isEmpty {
                        Text(screen.body)
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                    }
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.25), value: appeared)

                // Metrics
                HStack(spacing: 16) {
                    MetricChip(value: "Lección \(lessonNumber)", label: "completada", color: moduleColor)
                    MetricChip(value: "\(streakDays)d", label: "racha 🔥", color: BraverTheme.bravura)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.4), value: appeared)
            }
            .padding(.horizontal, BraverTheme.screenPadding)

            Spacer()

            WizardContinueButton(label: "Continuar", color: moduleColor, action: onContinue)
        }
        .onAppear { appeared = true }
    }
}

struct MetricChip: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(BraverTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.08))
        .cornerRadius(BraverTheme.radiusMedium)
    }
}

// MARK: - Rating Screen

struct RatingScreenView: View {
    let screen: LessonScreenData
    let moduleColor: Color
    let onContinue: () -> Void

    @State private var selectedRating: Int? = nil
    @State private var feedback: String = ""
    @FocusState private var feedbackFocused: Bool

    private let emojis = ["😶", "😕", "😐", "😊", "🤩"]
    private let labels = ["Nada", "Poco", "Algo", "Bastante", "Mucho"]

    var showFeedbackField: Bool {
        guard let r = selectedRating else { return false }
        return r <= 1
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 32) {
                VStack(spacing: 10) {
                    Text("💬")
                        .font(.system(size: 44))
                    Text(screen.title.isEmpty ? "¿Cuánto resuena esto contigo hoy?" : screen.title)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .multilineTextAlignment(.center)
                }

                // Emoji rating
                HStack(spacing: 12) {
                    ForEach(0..<emojis.count, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.25)) { selectedRating = i }
                        } label: {
                            VStack(spacing: 5) {
                                Text(emojis[i])
                                    .font(.system(size: selectedRating == i ? 34 : 26))
                                    .scaleEffect(selectedRating == i ? 1.15 : 1)
                                    .animation(.spring(response: 0.25), value: selectedRating)
                                Text(labels[i])
                                    .font(.system(size: 10, design: .rounded))
                                    .foregroundColor(selectedRating == i ? moduleColor : BraverTheme.textTertiary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)

                // Low rating follow-up
                if showFeedbackField {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("¿Hay algo que te está bloqueando?")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)

                        TextField("Cuéntanos (opcional)", text: $feedback, axis: .vertical)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .padding(14)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusMedium)
                            .focused($feedbackFocused)
                            .lineLimit(3...5)
                    }
                    .padding(.horizontal, BraverTheme.screenPadding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.3), value: showFeedbackField)
                }
            }

            Spacer()

            WizardContinueButton(
                label: selectedRating == nil ? "Omitir" : "Enviar",
                color: selectedRating == nil ? BraverTheme.textTertiary : moduleColor,
                action: onContinue
            )
        }
    }
}
