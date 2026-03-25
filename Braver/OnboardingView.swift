import SwiftUI
import StoreKit
import UserNotifications

// MARK: - OnboardingView

struct OnboardingView: View {
    let onCompleted: () -> Void

    @State private var step: Int = 0
    @State private var userName: String = ""
    @State private var userAge: String = ""
    @State private var q3selected: Set<Int> = []   // índices seleccionados para categorías de miedo

    // Respuestas
    @State private var q1answer: Int? = nil   // género
    @State private var q2answer: Int? = nil   // frecuencia evitación
    @State private var q3answer: Int? = nil   // cómo nos conociste
    @State private var q4answer: Int? = nil   // ha empeorado la evitación
    @State private var q5answer: Int? = nil   // edad inicio ansiedad social
    @State private var q6answer: Int? = nil   // dificultad actuar bajo ansiedad
    @State private var q7answer: Int? = nil   // evitación como mecanismo de afrontamiento
    @State private var q8answer: Int? = nil   // evitación cuando estás estresado
    @State private var q9answer: Int? = nil   // evitación por aburrimiento o rutina
    @State private var q10answer: Int? = nil  // oportunidades perdidas por vergüenza

    let totalQuestions = 10

    /// Score 0–100 calculado de las respuestas de diagnóstico
    private var anxietyScore: Int {
        var pts = 0
        // Q2: frecuencia de evitación (Varias/día=4, Una/día=3, Algunas/semana=2, Raramente=1)
        if let a = q2answer { pts += [4, 3, 2, 1][safe: a] ?? 0 }
        // Q4: ha empeorado (Sí=2, No=0)
        if q4answer == 0 { pts += 2 }
        // Q6: dificultad bajo ansiedad (Con frecuencia=3, A veces=2, Raramente=1)
        if let a = q6answer { pts += [3, 2, 1][safe: a] ?? 0 }
        // Q7: evitación como mecanismo
        if let a = q7answer { pts += [3, 2, 1][safe: a] ?? 0 }
        // Q8: evitación bajo estrés
        if let a = q8answer { pts += [3, 2, 1][safe: a] ?? 0 }
        // Q9: evitación por aburrimiento
        if let a = q9answer { pts += [3, 2, 1][safe: a] ?? 0 }
        // Q10: oportunidades perdidas (Sí=2, No=0)
        if q10answer == 0 { pts += 2 }
        let maxPts = 4 + 2 + 3 + 3 + 3 + 3 + 2  // 20
        return max(45, min(95, Int(Double(pts) / Double(maxPts) * 100)))
    }

    var body: some View {
        ZStack {
            Color(hex: "050507").ignoresSafeArea()

            switch step {
            case 0:
                WelcomeScreen(onStart: {
                    withAnimation(.easeInOut(duration: 0.45)) { step = 1 }
                })
                .transition(.opacity)

            case 1:
                OnboardingQuestionScreen(
                    number: 1,
                    total: totalQuestions,
                    question: "¿Cómo te identificas?",
                    options: ["Hombre", "Mujer", "Prefiero no decirlo"],
                    skippable: true,
                    selectedIndex: q1answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 0 } },
                    onAnswer: { idx in
                        q1answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 2 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 2 } }
                )
                .transition(.opacity)

            case 2:
                OnboardingQuestionScreen(
                    number: 2,
                    total: totalQuestions,
                    question: "¿Con qué frecuencia evitas situaciones sociales por vergüenza o ansiedad?",
                    options: [
                        "Varias veces al día",
                        "Una vez al día",
                        "Algunas veces a la semana",
                        "Raramente o nunca"
                    ],
                    skippable: true,
                    selectedIndex: q2answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 1 } },
                    onAnswer: { idx in
                        q2answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 3 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 3 } }
                )
                .transition(.opacity)

            case 3:
                OnboardingQuestionScreen(
                    number: 3,
                    total: totalQuestions,
                    question: "¿Cómo nos conociste?",
                    options: ["Instagram", "X (Twitter)", "TikTok", "Google", "Un amigo", "Otro"],
                    icons: ["📸", "🐦", "🎵", "🔍", "🤝", "💬"],
                    skippable: true,
                    selectedIndex: q3answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 2 } },
                    onAnswer: { idx in
                        q3answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 4 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 4 } }
                )
                .transition(.opacity)

            case 4:
                OnboardingQuestionScreen(
                    number: 4,
                    total: totalQuestions,
                    question: "¿Has notado que cada vez evitas más situaciones sociales con el tiempo?",
                    options: ["Sí", "No"],
                    skippable: true,
                    selectedIndex: q4answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 3 } },
                    onAnswer: { idx in
                        q4answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 5 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 5 } }
                )
                .transition(.opacity)

            case 5:
                OnboardingQuestionScreen(
                    number: 5,
                    total: totalQuestions,
                    question: "¿A qué edad empezaste a notar que la vergüenza social te limitaba?",
                    options: ["12 años o antes", "13 a 16 años", "17 a 24 años", "25 años o más"],
                    skippable: true,
                    selectedIndex: q5answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 4 } },
                    onAnswer: { idx in
                        q5answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 6 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 6 } }
                )
                .transition(.opacity)

            case 6:
                OnboardingQuestionScreen(
                    number: 6,
                    total: totalQuestions,
                    question: "¿Te resulta difícil actuar con normalidad cuando sientes ansiedad social?",
                    options: ["Con frecuencia", "A veces", "Raramente o nunca"],
                    skippable: true,
                    selectedIndex: q6answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 5 } },
                    onAnswer: { idx in
                        q6answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 7 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 7 } }
                )
                .transition(.opacity)

            case 7:
                OnboardingQuestionScreen(
                    number: 7,
                    total: totalQuestions,
                    question: "¿Usas la evitación como forma de lidiar con el malestar emocional?",
                    options: ["Con frecuencia", "A veces", "Raramente o nunca"],
                    skippable: true,
                    selectedIndex: q7answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 6 } },
                    onAnswer: { idx in
                        q7answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 8 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 8 } }
                )
                .transition(.opacity)

            case 8:
                OnboardingQuestionScreen(
                    number: 8,
                    total: totalQuestions,
                    question: "¿Recurres a la evitación social cuando te sientes estresado?",
                    options: ["Con frecuencia", "A veces", "Raramente o nunca"],
                    skippable: true,
                    selectedIndex: q8answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 7 } },
                    onAnswer: { idx in
                        q8answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 9 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 9 } }
                )
                .transition(.opacity)

            case 9:
                OnboardingQuestionScreen(
                    number: 9,
                    total: totalQuestions,
                    question: "¿Evitas situaciones sociales por aburrimiento o falta de motivación?",
                    options: ["Con frecuencia", "A veces", "Raramente o nunca"],
                    skippable: true,
                    selectedIndex: q9answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 8 } },
                    onAnswer: { idx in
                        q9answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 10 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 10 } }
                )
                .transition(.opacity)

            case 10:
                OnboardingQuestionScreen(
                    number: 10,
                    total: totalQuestions,
                    question: "¿Has perdido oportunidades importantes por evitar situaciones sociales?",
                    options: ["Sí", "No"],
                    skippable: true,
                    selectedIndex: q10answer,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 9 } },
                    onAnswer: { idx in
                        q10answer = idx
                        withAnimation(.easeInOut(duration: 0.3)) { step = 11 }
                    },
                    onSkip: { withAnimation(.easeInOut(duration: 0.3)) { step = 11 } }
                )
                .transition(.opacity)

            case 11:
                NameAgeScreen(
                    userName: $userName,
                    userAge: $userAge,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 10 } },
                    onContinue: {
                        let trimmed = userName.trimmingCharacters(in: .whitespaces)
                        if !trimmed.isEmpty {
                            UserDefaults.standard.set(trimmed, forKey: "braver_user_name")
                        }
                        withAnimation(.easeInOut(duration: 0.45)) { step = 12 }
                    }
                )
                .transition(.opacity)

            case 12:
                AnalyzingScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 11 } },
                    onComplete: { withAnimation(.easeInOut(duration: 0.45)) { step = 13 } }
                )
                .transition(.opacity)

            case 13:
                AnalysisResultScreen(
                    userScore: anxietyScore,
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 12 } },
                    onContinue: { withAnimation(.easeInOut(duration: 0.45)) { step = 14 } }
                )
                .transition(.opacity)

            case 14:
                SymptomsScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 13 } },
                    onContinue: { withAnimation(.easeInOut(duration: 0.45)) { step = 15 } }
                )
                .transition(.opacity)

            case 15:
                EducationSlidesScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 14 } },
                    onComplete: { withAnimation(.easeInOut(duration: 0.45)) { step = 16 } }
                )
                .transition(.opacity)

            case 16:
                FeatureSlidesScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 15 } },
                    onComplete: { withAnimation(.easeInOut(duration: 0.45)) { step = 17 } }
                )
                .transition(.opacity)

            case 17:
                SocialProofScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 16 } },
                    onContinue: { withAnimation(.easeInOut(duration: 0.45)) { step = 18 } }
                )
                .transition(.opacity)

            case 18:
                ProgressChartScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 17 } },
                    onContinue: { withAnimation(.easeInOut(duration: 0.45)) { step = 19 } }
                )
                .transition(.opacity)

            case 19:
                GoalsScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 18 } },
                    onContinue: { withAnimation(.easeInOut(duration: 0.45)) { step = 20 } }
                )
                .transition(.opacity)

            case 20:
                RatingScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 19 } },
                    onContinue: { withAnimation(.easeInOut(duration: 0.45)) { step = 21 } }
                )
                .transition(.opacity)

            case 21:
                NotificationsScreen(
                    onBack: { withAnimation(.easeInOut(duration: 0.3)) { step = 20 } },
                    onContinue: { withAnimation(.easeInOut(duration: 0.45)) { step = 22 } }
                )
                .transition(.opacity)

            case 22:
                BraverCardRevealScreen(
                    onContinue: { withAnimation(.easeInOut(duration: 0.45)) { step = 23 } }
                )
                .transition(.opacity)

            case 23:
                PaywallScreen(onStart: {
                    saveAndComplete()
                })
                .transition(.opacity)

            default:
                Color(hex: "050507").ignoresSafeArea()
                    .onAppear { saveAndComplete() }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func saveFearCategories() {
        let categories = OnboardingFearCategory.all
        let selected = q3selected.compactMap { idx -> String? in
            guard idx < categories.count else { return nil }
            return categories[idx].key
        }
        if let data = try? JSONEncoder().encode(selected) {
            UserDefaults.standard.set(data, forKey: "braver_fear_categories")
        }
    }

    private func saveAndComplete() {
        let trimmed = userName.trimmingCharacters(in: CharacterSet.whitespaces)
        if !trimmed.isEmpty {
            UserDefaults.standard.set(trimmed, forKey: "braver_user_name")
        }
        let ageTrimmed = userAge.trimmingCharacters(in: CharacterSet.whitespaces)
        if !ageTrimmed.isEmpty {
            UserDefaults.standard.set(ageTrimmed, forKey: "braver_user_age")
        }
        UserDefaults.standard.set(true, forKey: "braver_onboarding_completed")
        onCompleted()
    }
}

// MARK: - Name & Age Screen (Step 11)

private struct NameAgeScreen: View {
    @Binding var userName: String
    @Binding var userAge: String
    let onBack: () -> Void
    let onContinue: () -> Void

    @FocusState private var focusedField: Field?
    private enum Field { case name, age }

    var body: some View {
        ZStack {
            Color(hex: "050507").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)

                Text("Última cosa")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)

                Text("Para personalizar tu experiencia.")
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)

                // Nombre
                VStack(alignment: .leading, spacing: 8) {
                    Text("¿Cómo te llamas?")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "94A3B8"))
                        .padding(.horizontal, 24)

                    TextField("Tu nombre", text: $userName)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(14)
                        .padding(.horizontal, 24)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .age }
                }
                .padding(.bottom, 24)

                // Edad
                VStack(alignment: .leading, spacing: 8) {
                    Text("¿Cuántos años tienes?")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "94A3B8"))
                        .padding(.horizontal, 24)

                    TextField("Tu edad", text: $userAge)
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(14)
                        .padding(.horizontal, 24)
                        .focused($focusedField, equals: .age)
                        .keyboardType(.numberPad)
                        .submitLabel(.done)
                        .onSubmit { focusedField = nil }
                }

                Spacer()

                Button(action: onContinue) {
                    Text("Continuar →")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(BraverTheme.accent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onTapGesture { focusedField = nil }
    }
}

// MARK: - Fear Category Model

struct OnboardingFearCategory {
    let emoji: String
    let label: String
    let key: String

    static let all: [OnboardingFearCategory] = [
        .init(emoji: "📞", label: "Llamadas",        key: "calls"),
        .init(emoji: "🛍️", label: "Tiendas",         key: "stores"),
        .init(emoji: "🎤", label: "Hablar en público", key: "public_speaking"),
        .init(emoji: "💘", label: "Ligar",            key: "dating"),
        .init(emoji: "👥", label: "Grupos",           key: "groups"),
        .init(emoji: "💼", label: "Trabajo",          key: "work"),
        .init(emoji: "😤", label: "Conflictos",       key: "conflict"),
        .init(emoji: "🤝", label: "Conocer gente",    key: "meeting_people")
    ]
}

// MARK: - Braver Card Reveal Screen (Step 21)

private struct BraverCardRevealScreen: View {
    let onContinue: () -> Void

    @State private var visibleText: String = ""
    @State private var textOpacity: Double = 1
    @State private var showButton: Bool = false

    private var userName: String {
        UserDefaults.standard.string(forKey: "braver_user_name") ?? "Tú"
    }
    private var startDate: String {
        let f = DateFormatter(); f.dateFormat = "MM/yy"
        return f.string(from: Date())
    }

    private let phrases: [String] = [
        "Hemos analizado\ntu perfil.",
        "Es hora de invertir\nen ti mismo.",
        "Diseñado para ayudarte\na superar la ansiedad.",
        "Con tus respuestas,\nhemos construido tu plan."
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(hex: "050507").ignoresSafeArea()

                // Mismo fondo que WelcomeScreen
                Circle()
                    .fill(Color(hex: "0E9090").opacity(0.20))
                    .frame(width: geo.size.width * 1.1)
                    .blur(radius: 80)
                    .offset(x: -geo.size.width * 0.3, y: -geo.size.height * 0.28)
                Circle()
                    .fill(Color(hex: "4C9EEB").opacity(0.12))
                    .frame(width: geo.size.width * 0.9)
                    .blur(radius: 70)
                    .offset(x: geo.size.width * 0.4, y: -geo.size.height * 0.05)
                Circle()
                    .fill(Color(hex: "0E9090").opacity(0.08))
                    .frame(width: geo.size.width * 0.7)
                    .blur(radius: 60)
                    .offset(x: geo.size.width * 0.1, y: geo.size.height * 0.2)

                VStack(spacing: 0) {
                    // Texto con typewriter
                    Text(visibleText)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 28)
                        .opacity(textOpacity)
                        .frame(height: geo.size.height * 0.27, alignment: .center)

                    Spacer()

                    // Tarjeta identidad Braver
                    BraverIdentityCard(userName: userName, startDate: startDate)
                        .padding(.horizontal, 36)

                    Spacer()

                    // Botón continuar (fade-in al terminar)
                    Button(action: onContinue) {
                        Text("Comenzar →")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(BraverTheme.accent)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .opacity(showButton ? 1 : 0)
                    .animation(.easeIn(duration: 0.5), value: showButton)

                    Spacer().frame(height: 44)
                }
                .padding(.top, 72)
            }
        }
        .ignoresSafeArea()
        .onAppear { typePhrase(at: 0) }
    }

    private func typePhrase(at index: Int) {
        guard index < phrases.count else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { showButton = true }
            return
        }

        let phrase = phrases[index]
        let charDelay = 0.038

        for (i, char) in phrase.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * charDelay) {
                visibleText += String(char)
            }
        }

        let typingDone = Double(phrase.count) * charDelay + 1.4

        DispatchQueue.main.asyncAfter(deadline: .now() + typingDone) {
            if index < phrases.count - 1 {
                withAnimation(.easeOut(duration: 0.25)) { textOpacity = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.32) {
                    visibleText = ""
                    withAnimation(.easeIn(duration: 0.2)) { textOpacity = 1 }
                    typePhrase(at: index + 1)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { showButton = true }
            }
        }
    }
}

private struct BraverIdentityCard: View {
    let userName: String
    let startDate: String

    var body: some View {
        VStack(spacing: 0) {
            // ── Zona gradiente ──
            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color(hex: "0A6060"), location: 0.0),
                        .init(color: Color(hex: "3A7CC4"), location: 0.3),
                        .init(color: Color(hex: "D05010"), location: 0.65),
                        .init(color: Color(hex: "F59E0B"), location: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack {
                    HStack {
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.85), lineWidth: 2)
                                .frame(width: 44, height: 44)
                            Text("BRV")
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image(systemName: "shield.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Racha activa")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.85))
                            Text("0 días")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                }
                .padding(18)
            }
            .frame(height: 230)

            // ── Footer oscuro ──
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Nombre")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.45))
                    Text(userName)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("Braver desde")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.45))
                    Text(startDate)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .padding(18)
            .background(Color(hex: "0E0F14"))
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.5), radius: 25, x: 0, y: 12)
    }
}

// MARK: - Notifications Screen (Step 20)

private struct NotificationsScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "050507").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // Back button
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)

                // Título grande alineado a la izquierda
                Text("No pierdas\nel ritmo")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)

                Text("Recibe recordatorios y motivación para mantener tu racha de retos diarios.")
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
                    .lineSpacing(4)
                    .padding(.horizontal, 24)

                Spacer()
            }

            // Botones inferiores
            VStack(spacing: 14) {
                Button(action: onContinue) {
                    Text("Activar notificaciones")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(BraverTheme.accent)
                        .cornerRadius(16)
                }

                Button(action: onContinue) {
                    Text("Ahora no")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color(hex: "64748B"))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }

}

// MARK: - Rating Screen (Step 19)

private struct AppReview: Identifiable {
    let id = UUID()
    let initials: String
    let initialsColor: Color
    let name: String
    let handle: String
    let stars: Int
    let quote: String
}

private struct RatingScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    private func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
            DispatchQueue.main.async { onContinue() }
        }
    }

    private let reviews: [AppReview] = [
        .init(initials: "CM", initialsColor: Color(hex: "4C9EEB"),
              name: "Carlos M.", handle: "@carlosm",
              stars: 5,
              quote: "\"Braver me cambió la vida. Llevaba años evitando situaciones sociales. En 3 semanas ya noto la diferencia en mi trabajo y en mis relaciones.\""),
        .init(initials: "LG", initialsColor: Color(hex: "10B981"),
              name: "Laura G.", handle: "@laurag92",
              stars: 5,
              quote: "\"Nunca creí que podría hablar con desconocidos sin que se me disparara la ansiedad. Los retos diarios me fueron empujando poco a poco. Ahora salgo sin miedo.\""),
        .init(initials: "AP", initialsColor: Color(hex: "F97316"),
              name: "Andrés P.", handle: "@andresp",
              stars: 5,
              quote: "\"La función de análisis de patrones es increíble. Mi confianza social ha mejorado muchísimo desde que uso Braver cada día.\""),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "050507").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 72)

                    // Título
                    Text("Puntúanos")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    // Decoración estrellas
                    HStack(spacing: 4) {
                        Text("🥈")
                            .font(.system(size: 40))
                            .rotationEffect(.degrees(-15))
                        Text("★★★★★")
                            .font(.system(size: 32))
                            .foregroundColor(Color(hex: "F59E0B"))
                        Text("🥈")
                            .font(.system(size: 40))
                            .rotationEffect(.degrees(15))
                    }
                    .padding(.bottom, 28)

                    // Social proof
                    VStack(spacing: 8) {
                        Text("Esta app fue diseñada para personas como tú.")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        HStack(spacing: -8) {
                            ForEach(["4C9EEB", "F97316", "10B981"], id: \.self) { hex in
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 30, height: 30)
                                    .overlay(Circle().stroke(Color(hex: "050507"), lineWidth: 2))
                            }
                            Text("+10.000 personas")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Color(hex: "94A3B8"))
                                .padding(.leading, 14)
                        }
                    }
                    .padding(.bottom, 28)

                    // Reseñas
                    VStack(spacing: 14) {
                        ForEach(reviews) { review in
                            ReviewCard(review: review)
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 120)
                }
            }

            // Header fijo
            VStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .background(Color(hex: "050507"))
                Spacer()
            }

            // CTA
            VStack(spacing: 0) {
                Button(action: requestNotifications) {
                    Text("Puntuar Braver →")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(BraverTheme.accent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color(hex: "050507"))
        }
    }
}

private struct ReviewCard: View {
    let review: AppReview

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(review.initialsColor.opacity(0.25)).frame(width: 46, height: 46)
                    Text(review.initials)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(review.initialsColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.name)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text(review.handle)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(Color(hex: "64748B"))
                }
                Spacer()
                Text(String(repeating: "★", count: review.stars))
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "F59E0B"))
            }
            Text(review.quote)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(Color(hex: "CBD5E1"))
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

// MARK: - Goals Screen (Step 18)

private struct GoalItem: Identifiable {
    let id = UUID()
    let emoji: String
    let label: String
    let rowColor: Color
    let iconColor: Color
}

private struct GoalsScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    @Environment(\.requestReview) private var requestReview
    @State private var selected: Set<UUID> = []

    private let goals: [GoalItem] = [
        .init(emoji: "🗣️", label: "Hablar con más confianza",       rowColor: Color(hex: "1A3A5C"), iconColor: Color(hex: "2A5A8C")),
        .init(emoji: "💪", label: "Superar el miedo al rechazo",    rowColor: Color(hex: "5C1A1A"), iconColor: Color(hex: "8C2A2A")),
        .init(emoji: "🤝", label: "Conocer gente nueva",            rowColor: Color(hex: "1A3D2B"), iconColor: Color(hex: "2A6040")),
        .init(emoji: "📞", label: "Hacer llamadas sin ansiedad",    rowColor: Color(hex: "0D3030"), iconColor: Color(hex: "1A5252")),
        .init(emoji: "👥", label: "Participar en grupos",           rowColor: Color(hex: "2D1A5C"), iconColor: Color(hex: "4A2A8C")),
        .init(emoji: "💼", label: "Destacar en el trabajo",         rowColor: Color(hex: "3D3010"), iconColor: Color(hex: "6A5520")),
        .init(emoji: "💘", label: "Mejorar mi vida romántica",      rowColor: Color(hex: "4D1A2E"), iconColor: Color(hex: "7A2A48")),
        .init(emoji: "😌", label: "Reducir mi ansiedad social",     rowColor: Color(hex: "0D2A2A"), iconColor: Color(hex: "1A4A4A")),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "050507").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 80)

                    Text("Selecciona los objetivos que quieres alcanzar con Braver.")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color(hex: "94A3B8"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)

                    VStack(spacing: 12) {
                        ForEach(goals) { goal in
                            GoalRow(goal: goal, isSelected: selected.contains(goal.id)) {
                                if selected.contains(goal.id) { selected.remove(goal.id) }
                                else { selected.insert(goal.id) }
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 120)
                }
            }

            // Header fijo
            VStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Elige tus objetivos")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Spacer().frame(width: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 10)
                .background(Color(hex: "050507"))
                Spacer()
            }

            // CTA
            VStack(spacing: 0) {
                Button(action: {
                    let labels = goals.filter { selected.contains($0.id) }.map { $0.label }
                    if let data = try? JSONEncoder().encode(labels) {
                        UserDefaults.standard.set(data, forKey: "braver_goals")
                    }
                    requestReview()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { onContinue() }
                }) {
                    Text("Seguir estos objetivos →")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(BraverTheme.accent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color(hex: "050507"))
        }
    }
}

private struct GoalRow: View {
    let goal: GoalItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(goal.iconColor)
                        .frame(width: 42, height: 42)
                    Text(goal.emoji)
                        .font(.system(size: 20))
                }

                Text(goal.label)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)

                Spacer()

                Circle()
                    .fill(isSelected ? BraverTheme.accent : Color.black.opacity(0.5))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle().stroke(Color.white.opacity(isSelected ? 0 : 0.15), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(goal.rowColor)
            .cornerRadius(100)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Progress Chart Screen (Step 17)

private struct SmoothCurveShape: Shape {
    let points: [(CGFloat, CGFloat)]  // normalizados 0-1

    func path(in rect: CGRect) -> Path {
        var p = Path()
        guard points.count > 1 else { return p }
        let mapped = points.map {
            CGPoint(x: rect.minX + $0.0 * rect.width,
                    y: rect.minY + $0.1 * rect.height)
        }
        p.move(to: mapped[0])
        for i in 1..<mapped.count {
            let prev = mapped[i-1], curr = mapped[i]
            p.addCurve(to: curr,
                       control1: CGPoint(x: (prev.x + curr.x) / 2, y: prev.y),
                       control2: CGPoint(x: (prev.x + curr.x) / 2, y: curr.y))
        }
        return p
    }
}

private struct SmoothFillShape: Shape {
    let points: [(CGFloat, CGFloat)]

    func path(in rect: CGRect) -> Path {
        var p = SmoothCurveShape(points: points).path(in: rect)
        let mapped = points.map {
            CGPoint(x: rect.minX + $0.0 * rect.width,
                    y: rect.minY + $0.1 * rect.height)
        }
        p.addLine(to: CGPoint(x: mapped.last!.x, y: rect.maxY))
        p.addLine(to: CGPoint(x: mapped.first!.x, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

private struct ProgressChartScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    @State private var lineProgress: Double = 0
    @State private var labelsOpacity: Double = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "050507").ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Tu progreso con Braver")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Spacer().frame(width: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()

                BraverProgressChartView(lineProgress: lineProgress, labelsOpacity: labelsOpacity)
                    .padding(.horizontal, 20)

                Spacer()

                Text("Beneficios de la exposición gradual")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
                    .padding(.bottom, 110)
            }
        }
        .overlay(alignment: .bottom) {
            Button(action: onContinue) {
                Text("Continuar →")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(BraverTheme.accent)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.2).delay(0.3)) { lineProgress = 1.0 }
            withAnimation(.easeIn(duration: 0.5).delay(2.3)) { labelsOpacity = 1.0 }
        }
    }
}

private struct BraverProgressChartView: View {
    let lineProgress: Double
    let labelsOpacity: Double

    // Con Braver: confianza sube (y: 0=top, 1=bottom — línea va de abajo-izq a arriba-der)
    private let braverPts: [(CGFloat, CGFloat)] = [
        (0.0, 0.82), (0.2, 0.72), (0.4, 0.55),
        (0.6, 0.36), (0.8, 0.20), (1.0, 0.08)
    ]
    // Sin tratamiento: se queda estancado con ciclos de evitación
    private let noTxPts: [(CGFloat, CGFloat)] = [
        (0.0, 0.78), (0.15, 0.58), (0.27, 0.72),
        (0.40, 0.55), (0.52, 0.68), (0.63, 0.53),
        (0.75, 0.66), (0.88, 0.57), (1.0, 0.74)
    ]
    private let avoidXs: [CGFloat] = [0.27, 0.52, 0.75, 0.88]

    private func absPoint(_ pt: (CGFloat, CGFloat), in rect: CGRect) -> CGPoint {
        CGPoint(x: rect.minX + pt.0 * rect.width,
                y: rect.minY + pt.1 * rect.height)
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let chartRect = CGRect(x: 16, y: 44, width: w - 32, height: h - 76)

            ZStack(alignment: .topLeading) {
                // Fondo tarjeta
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.04))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.08), lineWidth: 1))

                // Rellenos
                SmoothFillShape(points: noTxPts)
                    .fill(LinearGradient(colors: [Color(hex: "EF4444").opacity(0.14), .clear], startPoint: .top, endPoint: .bottom))
                    .frame(width: chartRect.width, height: chartRect.height)
                    .position(x: chartRect.midX, y: chartRect.midY)
                    .opacity(lineProgress)

                SmoothFillShape(points: braverPts)
                    .fill(LinearGradient(colors: [BraverTheme.accent.opacity(0.17), .clear], startPoint: .top, endPoint: .bottom))
                    .frame(width: chartRect.width, height: chartRect.height)
                    .position(x: chartRect.midX, y: chartRect.midY)
                    .opacity(lineProgress)

                // Líneas animadas
                SmoothCurveShape(points: noTxPts)
                    .trim(from: 0, to: lineProgress)
                    .stroke(Color(hex: "EF4444"), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .frame(width: chartRect.width, height: chartRect.height)
                    .position(x: chartRect.midX, y: chartRect.midY)

                SmoothCurveShape(points: braverPts)
                    .trim(from: 0, to: lineProgress)
                    .stroke(BraverTheme.accent, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .frame(width: chartRect.width, height: chartRect.height)
                    .position(x: chartRect.midX, y: chartRect.midY)

                // Puntos de inicio
                Circle().fill(Color.white).frame(width: 10, height: 10).position(absPoint(braverPts[0], in: chartRect))
                Circle().fill(Color.white).frame(width: 10, height: 10).position(absPoint(noTxPts[0], in: chartRect))

                // Puntos finales + etiquetas (aparecen al final)
                Circle().fill(BraverTheme.accent).frame(width: 12, height: 12)
                    .position(absPoint(braverPts.last!, in: chartRect))
                    .opacity(labelsOpacity)

                Circle().fill(Color(hex: "EF4444")).frame(width: 12, height: 12)
                    .position(absPoint(noTxPts.last!, in: chartRect))
                    .opacity(labelsOpacity)

                Text("Con Braver")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.accent)
                    .position(x: absPoint(braverPts.last!, in: chartRect).x - 38,
                              y: absPoint(braverPts.last!, in: chartRect).y - 16)
                    .opacity(labelsOpacity)

                Text("Sin tratamiento")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "EF4444"))
                    .position(x: absPoint(noTxPts.last!, in: chartRect).x - 46,
                              y: absPoint(noTxPts.last!, in: chartRect).y + 16)
                    .opacity(labelsOpacity)

                // Marcadores × de evitación
                ForEach(avoidXs.indices, id: \.self) { i in
                    let xN = avoidXs[i]
                    if lineProgress > Double(xN) {
                        let yN: CGFloat = {
                            for j in 0..<noTxPts.count - 1 {
                                if noTxPts[j].0 <= xN && noTxPts[j+1].0 >= xN {
                                    let t = (xN - noTxPts[j].0) / (noTxPts[j+1].0 - noTxPts[j].0)
                                    return noTxPts[j].1 + t * (noTxPts[j+1].1 - noTxPts[j].1)
                                }
                            }
                            return 0.6
                        }()
                        Text("×")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(hex: "EF4444"))
                            .position(x: chartRect.minX + xN * chartRect.width,
                                      y: chartRect.minY + yN * chartRect.height - 14)
                    }
                }

                // Etiquetas eje X
                ForEach(0..<3, id: \.self) { i in
                    Text(["Semana 1", "Semana 2", "Semana 3"][i])
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(Color(hex: "64748B"))
                        .position(x: chartRect.minX + CGFloat(i) * chartRect.width / 2,
                                  y: chartRect.maxY + 16)
                }

                // Leyenda
                HStack(spacing: 5) {
                    Text("×")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "EF4444"))
                    Text("episodios de evitación")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(Color(hex: "64748B"))
                }
                .position(x: chartRect.minX + 82, y: chartRect.minY - 18)
            }
        }
        .frame(height: 300)
    }
}

// MARK: - Social Proof Screen (Step 16)

private struct SocialProofCard: Identifiable {
    let id = UUID()
    let avatarEmoji: String
    let name: String
    let isExpert: Bool
    let quoteTitle: String
    let quoteBody: String
}

private struct SocialProofScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    private let cards: [SocialProofCard] = [
        .init(
            avatarEmoji: "🧠",
            name: "Dr. Stefan Hofmann, Ph.D.",
            isExpert: true,
            quoteTitle: "La exposición cambia el cerebro",
            quoteBody: "La exposición gradual es el tratamiento más eficaz para la ansiedad social. Cada reto pequeño enseña al cerebro que el peligro no existe."
        ),
        .init(
            avatarEmoji: "📚",
            name: "Dr. Ricardo Muñoz",
            isExpert: true,
            quoteTitle: "La evitación lo empeora todo",
            quoteBody: "Cuanto más evitamos, más poderoso se vuelve el miedo. La única salida real es atravesarlo paso a paso, de forma gradual y controlada."
        ),
        .init(
            avatarEmoji: "😊",
            name: "Alejandro, 24",
            isExpert: false,
            quoteTitle: "Por fin hablo sin entrar en pánico.",
            quoteBody: "Siempre evitaba hablar en clase o en reuniones. Con Braver empecé por retos pequeños. Ahora hablo con desconocidos sin que se me dispare la ansiedad."
        ),
        .init(
            avatarEmoji: "🌸",
            name: "Sofía, 31",
            isExpert: false,
            quoteTitle: "Mi vida social cambió en 3 semanas.",
            quoteBody: "Cancelaba planes constantemente por miedo al qué dirán. Los retos diarios me fueron empujando poco a poco. Ya no vivo con ese miedo constante."
        )
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "050507").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Spacer().frame(height: 72)
                    ForEach(cards) { card in
                        SocialProofCardView(card: card)
                    }
                    Spacer().frame(height: 100)
                }
                .padding(.horizontal, 20)
            }

            // Header fijo
            VStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Resultados reales")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Spacer().frame(width: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 10)
                .background(Color(hex: "050507"))
                Spacer()
            }

            // CTA
            VStack(spacing: 0) {
                Button(action: onContinue) {
                    Text("Continuar →")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(BraverTheme.accent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color(hex: "050507"))
        }
    }
}

private struct SocialProofCardView: View {
    let card: SocialProofCard

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Avatar + nombre
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 44, height: 44)
                    Text(card.avatarEmoji)
                        .font(.system(size: 22))
                }
                HStack(spacing: 6) {
                    Text(card.name)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "22C55E"))
                }
            }

            // Tarjeta de cita
            VStack(alignment: .leading, spacing: 8) {
                Text(card.quoteTitle)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(card.quoteBody)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color(hex: "CBD5E1"))
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.06))
            .cornerRadius(14)
        }
    }
}

// MARK: - Feature Slides Screen (Step 15)

private struct FeatureSlide {
    let emoji: String
    let title: String
    let description: [TextChunk]
    let badge: String?   // línea de credibilidad opcional debajo del texto

    struct TextChunk {
        let text: String
        let bold: Bool
    }
}

private struct FeatureSlidesScreen: View {
    let onBack: () -> Void
    let onComplete: () -> Void

    @State private var current: Int = 0

    private let slides: [FeatureSlide] = [
        .init(
            emoji: "⚡",
            title: "Bienvenido/a a Braver",
            description: [
                .init(text: "Braver es una app ", bold: false),
                .init(text: "líder en exposición gradual", bold: true),
                .init(text: " basada en ", bold: false),
                .init(text: "técnicas de psicología cognitiva", bold: true),
                .init(text: " y años de investigación sobre ansiedad social.", bold: false)
            ],
            badge: "TCC · Exposición Gradual · Psicología Cognitiva"
        )
        ,
        .init(
            emoji: "🔬",
            title: "Recablea tu cerebro",
            description: [
                .init(text: "Los retos de Braver te ayudan a ", bold: false),
                .init(text: "recablear tu respuesta al miedo", bold: true),
                .init(text: ", ", bold: false),
                .init(text: "reconstruir tu confianza", bold: true),
                .init(text: " y ", bold: false),
                .init(text: "evitar recaídas", bold: true),
                .init(text: ".", bold: false)
            ],
            badge: "Basado en TCC · Respaldado por la ciencia"
        )
        ,
        .init(
            emoji: "🧘",
            title: "Mantén la motivación",
            description: [
                .init(text: "Superar la vergüenza social es un proceso. Tu ", bold: false),
                .init(text: "reto diario", bold: true),
                .init(text: " te mantiene ", bold: false),
                .init(text: "motivado", bold: true),
                .init(text: " mientras te conviertes en tu ", bold: false),
                .init(text: "mejor versión", bold: true),
                .init(text: ".", bold: false)
            ],
            badge: nil
        )
        ,
        .init(
            emoji: "🛡️",
            title: "Evita los retrocesos",
            description: [
                .init(text: "Braver ", bold: false),
                .init(text: "aprende tus patrones", bold: true),
                .init(text: " y situaciones que te generan más ansiedad, dándote apoyo inmediato ", bold: false),
                .init(text: "cuando más lo necesitas", bold: true),
                .init(text: ".", bold: false)
            ],
            badge: nil
        )
        ,
        .init(
            emoji: "🏆",
            title: "Supérate a ti mismo",
            description: [
                .init(text: "Conoce tus ", bold: false),
                .init(text: "patrones de ansiedad", bold: true),
                .init(text: " para superarlos. Entiende tus ", bold: false),
                .init(text: "puntos fuertes y débiles", bold: true),
                .init(text: ", gana logros y ", bold: false),
                .init(text: "sigue tu progreso", bold: true),
                .init(text: " cada día.", bold: false)
            ],
            badge: "Logros · Seguimiento · Progreso"
        )
        ,
        .init(
            emoji: "🌟",
            title: "Eleva tu vida",
            description: [
                .init(text: "Superar la vergüenza social tiene enormes beneficios ", bold: false),
                .init(text: "psicológicos", bold: true),
                .init(text: " y ", bold: false),
                .init(text: "sociales", bold: true),
                .init(text: ". Crece más ", bold: false),
                .init(text: "seguro de ti mismo", bold: true),
                .init(text: ", más ", bold: false),
                .init(text: "conectado", bold: true),
                .init(text: " y más ", bold: false),
                .init(text: "feliz", bold: true),
                .init(text: ".", bold: false)
            ],
            badge: "★ 4.9 · +10.000 personas más valientes"
        )
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "050507").ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        if current == 0 { onBack() }
                        else { withAnimation(.easeInOut(duration: 0.3)) { current -= 1 } }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("BRAVER")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(4)
                    Spacer()
                    Spacer().frame(width: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()

                // Illustration
                ZStack {
                    Circle()
                        .fill(BraverTheme.accent.opacity(0.15))
                        .frame(width: 220, height: 220)
                        .blur(radius: 40)
                    FloatingEmoji(emoji: slides[current].emoji)
                }
                .id(current)
                .padding(.bottom, 40)

                // Text
                VStack(spacing: 16) {
                    Text(slides[current].title)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    slides[current].description.reduce(Text("")) { acc, chunk in
                        acc + Text(chunk.text)
                            .font(.system(size: 17, weight: chunk.bold ? .bold : .regular, design: .rounded))
                    }
                    .foregroundColor(Color(hex: "CBD5E1"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                    if let badge = slides[current].badge {
                        Text(badge)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.accent)
                            .padding(.top, 4)
                    }
                }

                Spacer()

                // Page dots
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { i in
                        Circle()
                            .fill(i == current ? Color.white : Color.white.opacity(0.3))
                            .frame(width: i == current ? 9 : 7, height: i == current ? 9 : 7)
                            .animation(.easeInOut(duration: 0.2), value: current)
                    }
                }
                .padding(.bottom, 28)

                // CTA
                Button(action: {
                    if current < slides.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) { current += 1 }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(current < slides.count - 1 ? "Siguiente →" : "Continuar →")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(BraverTheme.accent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .id(current)
    }
}

// MARK: - Education Slides Screen (Step 14)

private struct EduSlide {
    let emoji: String
    let title: String
    let body: [TextChunk]   // alternating normal/bold segments

    struct TextChunk {
        let text: String
        let bold: Bool
    }
}

private struct EducationSlidesScreen: View {
    let onBack: () -> Void
    let onComplete: () -> Void

    @State private var current: Int = 0

    private let slides: [EduSlide] = [
        .init(
            emoji: "🧠",
            title: "La ansiedad social es tu cerebro",
            body: [
                .init(text: "Cuando enfrentas una situación social, tu amígdala activa una ", bold: false),
                .init(text: "respuesta de alarma", bold: true),
                .init(text: ". Tu cerebro cree que hay peligro — pero no lo hay. Solo ", bold: false),
                .init(text: "incomodidad", bold: true),
                .init(text: ".", bold: false)
            ]
        )
        ,
        .init(
            emoji: "🚪",
            title: "La evitación te aleja de los demás",
            body: [
                .init(text: "Cada vez que evitas, ", bold: false),
                .init(text: "pierdes una conexión real", bold: true),
                .init(text: " y refuerzas la idea de que no eres capaz. La ansiedad social ", bold: false),
                .init(text: "no tratada", bold: true),
                .init(text: " no desaparece sola.", bold: false)
            ]
        )
        ,
        .init(
            emoji: "📉",
            title: "La ansiedad destruye la confianza",
            body: [
                .init(text: "Más del ", bold: false),
                .init(text: "60% de las personas", bold: true),
                .init(text: " con ansiedad social reportan una ", bold: false),
                .init(text: "pérdida de confianza", bold: true),
                .init(text: " progresiva y una menor ", bold: false),
                .init(text: "capacidad para actuar", bold: true),
                .init(text: " en su vida diaria.", bold: false)
            ]
        )
        ,
        .init(
            emoji: "😔",
            title: "¿Te sientes atrapado?",
            body: [
                .init(text: "La ansiedad social ", bold: false),
                .init(text: "activa el cortisol", bold: true),
                .init(text: " constantemente. Por eso tantas personas con vergüenza social se sienten ", bold: false),
                .init(text: "agotadas", bold: true),
                .init(text: ", ", bold: false),
                .init(text: "desmotivadas", bold: true),
                .init(text: " y ", bold: false),
                .init(text: "aisladas", bold: true),
                .init(text: ".", bold: false)
            ]
        )
        ,
        .init(
            emoji: "🌱",
            title: "El camino al cambio",
            body: [
                .init(text: "El cambio es posible. Al ", bold: false),
                .init(text: "enfrentarte poco a poco", bold: true),
                .init(text: " a tus miedos, tu cerebro ", bold: false),
                .init(text: "recalibra su respuesta de alarma", bold: true),
                .init(text: ", ganando confianza real y ", bold: false),
                .init(text: "mayor bienestar", bold: true),
                .init(text: ".", bold: false)
            ]
        )
    ]

    private var slideBackground: Color {
        current < slides.count - 1 ? Color(hex: "1A0608") : Color(hex: "060D1A")
    }

    private var glowColor: Color {
        current < slides.count - 1 ? Color(hex: "7F1D1D") : BraverTheme.accent
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            slideBackground.ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: current)

            // Glow blob de fondo
            Circle()
                .fill(glowColor.opacity(0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 80)
                .offset(y: -80)
                .animation(.easeInOut(duration: 0.4), value: current)

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        if current == 0 { onBack() }
                        else { withAnimation(.easeInOut(duration: 0.3)) { current -= 1 } }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("BRAVER")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(4)
                    Spacer()
                    Spacer().frame(width: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()

                // Emoji flotando
                FloatingEmoji(emoji: slides[current].emoji)
                    .padding(.bottom, 40)

                // Text
                VStack(spacing: 16) {
                    Text(slides[current].title)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    slides[current].body.reduce(Text("")) { acc, chunk in
                        acc + Text(chunk.text)
                            .font(.system(size: 17, weight: chunk.bold ? .bold : .regular, design: .rounded))
                    }
                    .foregroundColor(Color(hex: "CBD5E1"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                }

                Spacer()

                // Page dots
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { i in
                        Circle()
                            .fill(i == current ? Color.white : Color.white.opacity(0.3))
                            .frame(width: i == current ? 9 : 7, height: i == current ? 9 : 7)
                            .animation(.easeInOut(duration: 0.2), value: current)
                    }
                }
                .padding(.bottom, 28)

                // CTA
                Button(action: {
                    if current < slides.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) { current += 1 }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(current < slides.count - 1 ? "Siguiente →" : "Empezar →")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(current < slides.count - 1 ? Color(hex: "7F1D1D") : BraverTheme.accent)
                        .cornerRadius(16)
                        .animation(.easeInOut(duration: 0.4), value: current)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .id(current)
    }
}

private struct FloatingEmoji: View {
    let emoji: String
    @State private var floating = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 170, height: 170)
                .scaleEffect(floating ? 1.08 : 0.94)
                .animation(
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: floating
                )
            Text(emoji)
                .font(.system(size: 90))
                .scaleEffect(floating ? 1.08 : 0.94)
                .offset(y: floating ? -10 : 10)
                .animation(
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: floating
                )
        }
        .onAppear { floating = true }
    }
}

// MARK: - Symptoms Screen (Step 13)

private struct SymptomItem: Identifiable {
    let id = UUID()
    let bold: String
    let rest: String
}

private struct SymptomCategory {
    let title: String
    let items: [SymptomItem]
}

private struct SymptomsScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    @State private var selected: Set<UUID> = []

    private let categories: [SymptomCategory] = [
        .init(title: "Mental", items: [
            .init(bold: "Pensamientos negativos", rest: " antes de situaciones sociales"),
            .init(bold: "Miedo al juicio", rest: " de los demás"),
            .init(bold: "Ansiedad anticipatoria", rest: " constante"),
            .init(bold: "Dificultad para concentrarte", rest: " en conversaciones"),
            .init(bold: "Baja autoestima", rest: " en contextos sociales")
        ]),
        .init(title: "Físico", items: [
            .init(bold: "Sudoración o temblores", rest: " en situaciones sociales"),
            .init(bold: "Corazón acelerado", rest: " al interactuar con desconocidos"),
            .init(bold: "Tensión muscular", rest: " o sensación de bloqueo"),
            .init(bold: "Voz cortada", rest: " o dificultad para hablar")
        ]),
        .init(title: "Social", items: [
            .init(bold: "Evitar llamadas", rest: " telefónicas"),
            .init(bold: "Cancelar planes", rest: " por ansiedad en el último momento"),
            .init(bold: "Sentirte invisible", rest: " o excluido en grupos"),
            .init(bold: "Dificultad para conocer", rest: " gente nueva"),
            .init(bold: "Aislamiento voluntario", rest: " para evitar el malestar")
        ]),
        .init(title: "Personal", items: [
            .init(bold: "Oportunidades perdidas", rest: " por no atreverte"),
            .init(bold: "Sensación de que todos te juzgan", rest: ""),
            .init(bold: "Menor deseo", rest: " de relacionarte socialmente")
        ])
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "050507").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Fixed-style header space
                    Spacer().frame(height: 80)

                    // Banner
                    Text("La ansiedad social puede afectar negativamente muchas áreas de tu vida.")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "E8895A"))
                        .cornerRadius(14)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)

                    Text("Selecciona los síntomas que reconoces:")
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color(hex: "CBD5E1"))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // Categories
                    ForEach(categories, id: \.title) { category in
                        Text(category.title)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 12)

                        ForEach(category.items) { item in
                            SymptomRow(item: item, isSelected: selected.contains(item.id)) {
                                if selected.contains(item.id) {
                                    selected.remove(item.id)
                                } else {
                                    selected.insert(item.id)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        }
                        .padding(.bottom, 8)
                    }

                    Spacer().frame(height: 100)
                }
            }

            // Back button overlay
            VStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Síntomas")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Spacer().frame(width: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .background(Color(hex: "050507").ignoresSafeArea())
                Spacer()
            }

            // CTA button
            VStack(spacing: 0) {
                Button(action: onContinue) {
                    Text("Empezar mi plan →")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(BraverTheme.accent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color(hex: "050507"))
        }
    }
}

private struct SymptomRow: View {
    let item: SymptomItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(isSelected ? 0 : 0.3), lineWidth: 1.5)
                        .frame(width: 26, height: 26)
                    if isSelected {
                        Circle()
                            .fill(BraverTheme.accent)
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Group {
                    Text(item.bold).bold() + Text(item.rest)
                }
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(16)
            .background(Color.white.opacity(0.06))
            .cornerRadius(14)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Safe subscript helper
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Analysis Result Screen (Step 12)

private struct AnalysisResultScreen: View {
    let userScore: Int
    let onBack: () -> Void
    let onContinue: () -> Void

    private let averageScore = 38
    @State private var barProgress: Double = 0
    @State private var labelOpacity: Double = 0

    private var userColor: Color { Color(hex: "E8895A") }   // naranja cálido = score alto
    private var avgColor:  Color { Color(hex: "14B8A6") }   // teal = media

    var body: some View {
        ZStack {
            Color(hex: "050507").ignoresSafeArea()

            // Back button
            VStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                Spacer()
            }

            ScrollView {
                VStack(spacing: 28) {
                    Spacer().frame(height: 60)

                    // Header
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Text("Análisis completado")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color(hex: "22C55E"))
                        }
                        Text("Tenemos algo que contarte...")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(Color(hex: "94A3B8"))
                    }
                    .multilineTextAlignment(.center)

                    // Result sentence
                    Text("Tus respuestas indican un nivel **elevado** de ansiedad social*")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    // Bar chart
                    HStack(alignment: .bottom, spacing: 32) {
                        BarView(
                            percent: userScore,
                            color: userColor,
                            label: "Tu puntuación",
                            maxHeight: 220,
                            progress: barProgress
                        )
                        BarView(
                            percent: averageScore,
                            color: avgColor,
                            label: "Media",
                            maxHeight: 220,
                            progress: barProgress
                        )
                    }
                    .padding(.horizontal, 48)

                    // Summary line
                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            Text("\(userScore)%")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(userColor)
                            Text("más ansiedad social que la media")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .foregroundColor(.white)
                        }
                        Text("* Este resultado es orientativo, no un diagnóstico médico.")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(Color(hex: "64748B"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .opacity(labelOpacity)

                    // CTA
                    Button(action: onContinue) {
                        Text("Ver mi plan →")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(BraverTheme.accent)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2).delay(0.3)) { barProgress = 1.0 }
            withAnimation(.easeIn(duration: 0.5).delay(1.4)) { labelOpacity = 1.0 }
        }
    }
}

private struct BarView: View {
    let percent: Int
    let color: Color
    let label: String
    let maxHeight: CGFloat
    let progress: Double

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .top) {
                // Bar
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: 90, height: maxHeight * CGFloat(percent) / 100 * CGFloat(progress))

                Text("\(percent)%")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
            .frame(height: maxHeight, alignment: .bottom)

            Text(label)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Color(hex: "94A3B8"))
        }
    }
}

// MARK: - Analyzing Screen (Step 11)

private struct AnalyzingScreen: View {
    let onBack: () -> Void
    let onComplete: () -> Void

    @State private var progress: Double = 0
    @State private var percentage: Int = 0
    @State private var phraseIndex: Int = 0
    @State private var phraseOpacity: Double = 1

    private let phrases = [
        "Analizando tus respuestas",
        "Identificando tus patrones",
        "Calculando tu nivel de ansiedad",
        "Preparando tu plan personalizado",
        "Casi listo..."
    ]
    private let totalDuration: Double = 7.0

    var body: some View {
        ZStack {
            Color(hex: "050507").ignoresSafeArea()

            // Back button
            VStack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                Spacer()
            }

            // Center content
            VStack(spacing: 40) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.08), lineWidth: 8)
                        .frame(width: 180, height: 180)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            BraverTheme.accent,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 180, height: 180)
                        .rotationEffect(.degrees(-90))

                    Text("\(percentage)%")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }

                // Labels
                VStack(spacing: 10) {
                    Text("Analizando")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text(phrases[phraseIndex])
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundColor(Color(hex: "94A3B8"))
                        .opacity(phraseOpacity)
                }
            }
        }
        .onAppear { startAnimation() }
    }

    private func startAnimation() {
        withAnimation(.linear(duration: totalDuration)) {
            progress = 1.0
        }

        // Percentage counter
        let step = totalDuration / 100.0
        for i in 0...100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * step) {
                percentage = i
                if i == 100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        onComplete()
                    }
                }
            }
        }

        // Phrase rotation
        let phraseInterval = totalDuration / Double(phrases.count)
        for i in 1..<phrases.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * phraseInterval) {
                withAnimation(.easeInOut(duration: 0.35)) { phraseOpacity = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    phraseIndex = i
                    withAnimation(.easeInOut(duration: 0.35)) { phraseOpacity = 1 }
                }
            }
        }
    }
}

// MARK: - Welcome Screen (Step 0)

private struct WelcomeScreen: View {
    let onStart: () -> Void

    @State private var orbPulse: Bool = false

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {

                // ── Background blobs ──────────────────────────────────
                Color(hex: "050507").ignoresSafeArea()

                Circle()
                    .fill(Color(hex: "0E9090").opacity(0.18))
                    .frame(width: geo.size.width * 1.1)
                    .blur(radius: 80)
                    .offset(x: -geo.size.width * 0.3, y: -geo.size.height * 0.25)

                Circle()
                    .fill(Color(hex: "4C9EEB").opacity(0.12))
                    .frame(width: geo.size.width * 0.9)
                    .blur(radius: 70)
                    .offset(x: geo.size.width * 0.4, y: -geo.size.height * 0.05)

                Circle()
                    .fill(Color(hex: "0E9090").opacity(0.10))
                    .frame(width: geo.size.width * 0.7)
                    .blur(radius: 60)
                    .offset(x: geo.size.width * 0.1, y: geo.size.height * 0.2)

                // ── Landscape silhouette ──────────────────────────────
                LandscapeSilhouette()
                    .frame(width: geo.size.width, height: geo.size.height * 0.38)

                // ── Main content ──────────────────────────────────────
                VStack(spacing: 0) {

                    // Logo
                    Text("BRAVER")
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .tracking(10)
                        .foregroundColor(Color(hex: "F1F5F9"))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 64)

                    Spacer(minLength: 0)

                    // Welcome copy
                    VStack(spacing: 12) {
                        Text("¡Hola!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "F1F5F9"))
                            .multilineTextAlignment(.center)

                        Text("Vamos a descubrir qué situaciones\nte frenan.")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .foregroundColor(Color(hex: "94A3B8"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)

                    // Social proof
                    VStack(spacing: 6) {
                        Text("★★★★★")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "F59E0B"))

                        Text("Más de 10.000 personas superando sus miedos")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(Color(hex: "94A3B8"))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 40)

                    // Orb as moon / centerpiece
                    BraverOrb(streak: 30, size: 90)
                        .scaleEffect(orbPulse ? 1.04 : 1.0)
                        .animation(
                            .easeInOut(duration: 2.8).repeatForever(autoreverses: true),
                            value: orbPulse
                        )
                        .onAppear { orbPulse = true }
                        .padding(.bottom, geo.size.height * 0.18)

                    Spacer(minLength: 0)

                    // CTA area
                    VStack(spacing: 14) {
                        Button(action: onStart) {
                            HStack(spacing: 8) {
                                Text("Empezar")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                Text("→")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(Color(hex: "050507"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(hex: "F1F5F9"))
                            .cornerRadius(100)
                        }
                        .padding(.horizontal, 24)

                        Text("Al continuar aceptas los Términos y Política de privacidad")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(Color(hex: "94A3B8").opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 40)
                }
                .frame(width: geo.size.width)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Landscape Silhouette

private struct LandscapeSilhouette: View {
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // Layer 1 — farthest hills (darkest teal)
                HillShape(controlHeightRatio: 0.55, peakXRatio: 0.45)
                    .fill(Color(hex: "081818"))
                    .frame(height: geo.size.height * 0.85)
                    .frame(maxWidth: .infinity)

                // Layer 2 — mid hills
                HillShape(controlHeightRatio: 0.50, peakXRatio: 0.62)
                    .fill(Color(hex: "0A2020"))
                    .frame(height: geo.size.height * 0.68)
                    .frame(maxWidth: .infinity)

                // Layer 3 — closer hills
                HillShape(controlHeightRatio: 0.42, peakXRatio: 0.28)
                    .fill(Color(hex: "0C2828"))
                    .frame(height: geo.size.height * 0.52)
                    .frame(maxWidth: .infinity)

                // Layer 4 — foreground (almost black)
                HillShape(controlHeightRatio: 0.35, peakXRatio: 0.70)
                    .fill(Color(hex: "060E0E"))
                    .frame(height: geo.size.height * 0.35)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

private struct HillShape: Shape {
    var controlHeightRatio: CGFloat
    var peakXRatio: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let peakY = h * (1 - controlHeightRatio)
        let peakX = w * peakXRatio

        path.move(to: CGPoint(x: 0, y: h))
        path.addCurve(
            to: CGPoint(x: peakX, y: peakY),
            control1: CGPoint(x: w * 0.1, y: h * 0.85),
            control2: CGPoint(x: peakX * 0.6, y: peakY + h * 0.08)
        )
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.72),
            control1: CGPoint(x: peakX + w * 0.15, y: peakY + h * 0.05),
            control2: CGPoint(x: w * 0.85, y: h * 0.62)
        )
        path.addLine(to: CGPoint(x: w, y: h))
        path.closeSubpath()
        return path
    }
}

// MARK: - Componentes reutilizables (se usarán en próximas pantallas)

private struct OnboardingProgressBar: View {
    let progress: Double  // 0.0 – 1.0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "161820"))
                    .frame(height: 4)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "4C9EEB"))
                    .frame(width: geo.size.width * progress, height: 4)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: 4)
    }
}

// MARK: - Quiz Option (listo para usar en próximas pantallas)

private struct QuizOption: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "F1F5F9"))
                    .multilineTextAlignment(.leading)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "4C9EEB"))
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "0E0F14"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                isSelected ? Color(hex: "4C9EEB") : Color.white.opacity(0.07),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quiz Screen (Steps 1 & 2)

private struct QuizScreen: View {
    let stepLabel: String
    let progress: Double
    let question: String
    let options: [String]
    @Binding var selected: Int?
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            // Nav bar
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(hex: "F1F5F9"))
                        .padding(10)
                        .background(Color(hex: "161820"))
                        .clipShape(Circle())
                }
                Spacer()
                Text(stepLabel)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)
            .padding(.bottom, 16)

            // Progress
            OnboardingProgressBar(progress: progress)
                .padding(.horizontal, 24)
                .padding(.bottom, 36)

            // Question
            Text(question)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "F1F5F9"))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 28)

            // Options
            VStack(spacing: 12) {
                ForEach(options.indices, id: \.self) { idx in
                    QuizOption(
                        text: options[idx],
                        isSelected: selected == idx,
                        action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selected = idx
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // CTA
            Button(action: onContinue) {
                HStack(spacing: 8) {
                    Text("Continuar")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                    Text("→")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    selected != nil
                        ? Color(hex: "4C9EEB")
                        : Color(hex: "4C9EEB").opacity(0.35)
                )
                .cornerRadius(100)
            }
            .disabled(selected == nil)
            .padding(.horizontal, 24)
            .padding(.bottom, 44)
            .animation(.easeInOut(duration: 0.2), value: selected)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "050507").ignoresSafeArea())
    }
}

// MARK: - Multi-Select Screen (Step 3)

private struct MultiSelectScreen: View {
    let stepLabel: String
    let progress: Double
    @Binding var selected: Set<Int>
    let onBack: () -> Void
    let onContinue: () -> Void

    private let categories = OnboardingFearCategory.all
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 0) {

            // Nav bar
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(hex: "F1F5F9"))
                        .padding(10)
                        .background(Color(hex: "161820"))
                        .clipShape(Circle())
                }
                Spacer()
                Text(stepLabel)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)
            .padding(.bottom, 16)

            // Progress
            OnboardingProgressBar(progress: progress)
                .padding(.horizontal, 24)
                .padding(.bottom, 36)

            // Question
            VStack(alignment: .leading, spacing: 8) {
                Text("¿En cuáles situaciones sientes más ansiedad?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "F1F5F9"))
                    .multilineTextAlignment(.leading)

                Text("Puedes elegir varias")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 28)

            // Chips grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(categories.indices, id: \.self) { idx in
                    let cat = categories[idx]
                    let isOn = selected.contains(idx)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            if isOn { selected.remove(idx) }
                            else { selected.insert(idx) }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(cat.emoji)
                                .font(.system(size: 20))
                            Text(cat.label)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color(hex: "F1F5F9"))
                                .lineLimit(1)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(isOn ? Color(hex: "4C9EEB").opacity(0.12) : Color(hex: "0E0F14"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            isOn ? Color(hex: "4C9EEB") : Color.white.opacity(0.07),
                                            lineWidth: isOn ? 1.5 : 1
                                        )
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // CTA
            Button(action: onContinue) {
                HStack(spacing: 8) {
                    Text("Continuar")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                    Text("→")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    !selected.isEmpty
                        ? Color(hex: "4C9EEB")
                        : Color(hex: "4C9EEB").opacity(0.35)
                )
                .cornerRadius(100)
            }
            .disabled(selected.isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 44)
            .animation(.easeInOut(duration: 0.2), value: selected.isEmpty)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "050507").ignoresSafeArea())
    }
}

// MARK: - Result Screen (Step 4)

private struct ResultScreen: View {
    let stepLabel: String
    let progress: Double
    @Binding var userName: String
    let onBack: () -> Void
    let onComplete: () -> Void

    @FocusState private var fieldFocused: Bool

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {

                // Nav bar
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(Color(hex: "F1F5F9"))
                            .padding(10)
                            .background(Color(hex: "161820"))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text(stepLabel)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "94A3B8"))
                }
                .padding(.horizontal, 24)
                .padding(.top, 56)
                .padding(.bottom, 16)

                // Progress
                OnboardingProgressBar(progress: progress)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 36)

                // Big percentage
                Text("73%")
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundColor(Color(hex: "4C9EEB"))
                    .padding(.bottom, 8)

                // Title
                Text("Tu cerebro exagera el peligro social")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "F1F5F9"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 16)

                // Subtitle
                Text("Esto es completamente normal. El 40% de las personas siente que la ansiedad social les limita. Y tiene solución.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 36)

                // Bar chart
                AnxietyBarChart()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)

                // Name field
                VStack(alignment: .leading, spacing: 10) {
                    Text("¿Cómo te llamas?")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "F1F5F9"))

                    TextField("Tu nombre", text: $userName)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "F1F5F9"))
                        .tint(Color(hex: "4C9EEB"))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "0E0F14"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            fieldFocused
                                                ? Color(hex: "4C9EEB")
                                                : Color.white.opacity(0.07),
                                            lineWidth: fieldFocused ? 1.5 : 1
                                        )
                                )
                        )
                        .focused($fieldFocused)
                        .submitLabel(.done)
                        .onSubmit { fieldFocused = false }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 36)

                // CTA
                Button(action: onComplete) {
                    HStack(spacing: 8) {
                        Text("Empezar mi camino")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        Text("→")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color(hex: "4C9EEB"))
                    .cornerRadius(100)
                    .shadow(color: Color(hex: "4C9EEB").opacity(0.35), radius: 16, x: 0, y: 6)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 52)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "050507").ignoresSafeArea())
    }
}

// MARK: - Anxiety Bar Chart

private struct AnxietyBarChart: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("La realidad vs. lo que anticipa tu mente")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Color(hex: "94A3B8"))

            HStack(alignment: .bottom, spacing: 24) {

                // Bar 1 — "Lo que anticipas"
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "EF4444"), Color(hex: "EF4444").opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 64, height: 140)
                        .overlay(
                            Text("10/10")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.top, 10),
                            alignment: .top
                        )
                    Text("Lo que anticipas")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "94A3B8"))
                        .multilineTextAlignment(.center)
                        .frame(width: 72)
                }

                // Bar 2 — "Lo que pasa realmente"
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "10B981"), Color(hex: "10B981").opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 64, height: 68)
                        .overlay(
                            Text("3/10")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.top, 8),
                            alignment: .top
                        )
                    Text("Lo que pasa realmente")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "94A3B8"))
                        .multilineTextAlignment(.center)
                        .frame(width: 80)
                }

                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0E0F14"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }
}

// MARK: - Pantalla de pregunta reutilizable

private struct OnboardingQuestionScreen: View {
    let number: Int
    let total: Int
    let question: String
    let options: [String]
    var icons: [String]? = nil
    var skippable: Bool = false
    var selectedIndex: Int? = nil
    let onBack: () -> Void
    let onAnswer: (Int) -> Void
    var onSkip: (() -> Void)? = nil

    @State private var tappedIndex: Int? = nil

    var progress: Double { Double(number) / Double(total) }

    private func handleTap(_ idx: Int) {
        guard tappedIndex == nil else { return }
        withAnimation(.easeInOut(duration: 0.15)) { tappedIndex = idx }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { onAnswer(idx) }
    }

    var body: some View {
        VStack(spacing: 0) {

            // Nav
            HStack(spacing: 14) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(hex: "F1F5F9"))
                }
                OnboardingProgressBar(progress: progress)
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)
            .padding(.bottom, 32)

            // Título + pregunta
            VStack(alignment: .leading, spacing: 16) {
                Text("Pregunta #\(number)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "F1F5F9"))

                Text(question)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
                    .lineSpacing(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 36)

            // Opciones
            VStack(spacing: 14) {
                ForEach(options.indices, id: \.self) { idx in
                    let isSelected = (tappedIndex ?? selectedIndex) == idx
                    Button { handleTap(idx) } label: {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(isSelected ? Color(hex: "4C9EEB") : Color(hex: "4C9EEB").opacity(icons != nil ? 0 : 1))
                                    .frame(width: 36, height: 36)
                                if let iconList = icons, idx < iconList.count {
                                    Text(iconList[idx])
                                        .font(.system(size: 22))
                                } else {
                                    Text("\(idx + 1)")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                            }

                            Text(options[idx])
                                .font(.system(size: 17, weight: .medium, design: .rounded))
                                .foregroundColor(isSelected ? .white : Color(hex: "F1F5F9"))

                            Spacer()

                            if isSelected {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "4C9EEB"))
                            }
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 18)
                        .background(isSelected ? Color(hex: "4C9EEB").opacity(0.15) : Color(hex: "0D1526"))
                        .cornerRadius(100)
                        .overlay(
                            Capsule()
                                .stroke(
                                    isSelected ? Color(hex: "4C9EEB").opacity(0.7) : Color(hex: "4C9EEB").opacity(0.18),
                                    lineWidth: isSelected ? 1.5 : 1
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(tappedIndex != nil)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            if skippable, let skip = onSkip {
                Button("Omitir", action: skip)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
                    .padding(.bottom, 48)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "050507").ignoresSafeArea())
    }
}

// MARK: - Paywall Screen (Step 22)

private struct PaywallScreen: View {
    let onStart: () -> Void

    private var userName: String {
        UserDefaults.standard.string(forKey: "braver_user_name") ?? "Tú"
    }

    /// Fecha objetivo: 90 días desde hoy
    private var targetDate: String {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        f.locale = Locale(identifier: "es_ES")
        let d = Calendar.current.date(byAdding: .day, value: 90, to: Date()) ?? Date()
        return f.string(from: d)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Fondo
            Color(hex: "050507").ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // ── Sección 1: Plan personalizado ──
                    VStack(spacing: 20) {
                        // Icono checkmark
                        ZStack {
                            Circle()
                                .fill(BraverTheme.accent)
                                .frame(width: 52, height: 52)
                            Image(systemName: "checkmark")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 56)

                        VStack(spacing: 8) {
                            Text("\(userName), hemos creado")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("tu plan personalizado.")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .multilineTextAlignment(.center)

                        Text("Serás valiente para:")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)

                        // Píldora de fecha
                        Text(targetDate)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 40)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )

                        // Divisor
                        Rectangle()
                            .fill(Color.white.opacity(0.07))
                            .frame(height: 1)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)

                        // Estrellas + laurel
                        HStack(spacing: 6) {
                            Text("🏅")
                                .font(.system(size: 26))
                            HStack(spacing: 3) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(hex: "F59E0B"))
                                }
                            }
                            Text("🏅")
                                .font(.system(size: 26))
                        }

                        VStack(spacing: 6) {
                            Text("Conviértete en la mejor")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("versión de ti con Braver")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Más valiente. Más libre. Más tú.")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(BraverTheme.textSecondary)
                                .padding(.top, 4)
                        }
                        .multilineTextAlignment(.center)

                        // Benefit chips
                        PaywallBenefitChips()
                    }
                    .padding(.horizontal, 24)

                    // ── Sección 2: Conquístate ──
                    PaywallFeatureBlock(
                        emoji: "🧠",
                        title: "Conquístate a ti mismo",
                        bullets: [
                            PaywallBullet(icon: "🔒", text: "Desarrolla **autocontrol inquebrantable**"),
                            PaywallBullet(icon: "💪", text: "Vuélvete más **atractivo y seguro**"),
                            PaywallBullet(icon: "🌱", text: "Aumenta tu **autoestima**"),
                            PaywallBullet(icon: "😊", text: "Llena cada día de **orgullo y valentía**"),
                        ],
                        testimonial: PaywallTestimonial(
                            stars: 5,
                            quote: "\"Siempre pensé que era introvertido por naturaleza. Resultó que era miedo. Braver me enseñó que la valentía es un músculo, y ahora lo entreno cada día.\"",
                            author: "Anónimo"
                        )
                    )

                    // ── Sección 3: Relaciones reales ──
                    PaywallFeatureBlock(
                        emoji: "🤝",
                        title: "Construye relaciones reales",
                        bullets: [
                            PaywallBullet(icon: "💡", text: "Desarrolla tu **inteligencia emocional**"),
                            PaywallBullet(icon: "🔗", text: "Sé más **fiable y auténtico**"),
                            PaywallBullet(icon: "❤️", text: "Experimenta **conexión real** con los demás"),
                            PaywallBullet(icon: "📈", text: "Conviértete en quien **mereces ser**"),
                        ],
                        testimonial: PaywallTestimonial(
                            stars: 5,
                            quote: "\"Evitaba salir con gente porque siempre sentía que iba a hacer el ridículo. Ahora soy yo quien propone planes. Nunca pensé que podría cambiar tanto.\"",
                            author: "Anónimo"
                        )
                    )

                    // ── Sección 4: Hábitos diarios ──
                    PaywallDailyHabitsBlock(targetDate: targetDate)

                    // ── Sección 5: Recupera tu energía social ──
                    PaywallFeatureBlock(
                        emoji: "⚡️",
                        title: "Recupera tu energía social",
                        bullets: [
                            PaywallBullet(icon: "🔄", text: "Rompe el ciclo de **evitación automática**"),
                            PaywallBullet(icon: "🎯", text: "Recupera el **foco y la motivación**"),
                            PaywallBullet(icon: "✨", text: "Encuentra **alegría real** en cada interacción"),
                        ],
                        testimonial: PaywallTestimonial(
                            stars: 5,
                            quote: "\"Empecé con el reto más fácil: mirar a los ojos al cajero. Hoy doy charlas en el trabajo. El cambio fue gradual pero real.\"",
                            author: "Anónimo"
                        )
                    )

                    // ── Sección 6: Toma el control ──
                    VStack(spacing: 24) {
                        PaywallFeatureBlock(
                            emoji: "🦁",
                            title: "Toma el control",
                            bullets: [
                                PaywallBullet(icon: "↔️", text: "Aprende a **redirigir el miedo** hacia acción"),
                                PaywallBullet(icon: "🎯", text: "Recupera **foco y autoconfianza**"),
                                PaywallBullet(icon: "🚩", text: "Encuentra **satisfacción real** en la vida"),
                            ],
                            testimonial: nil
                        )

                        // Texto motivador
                        Text("La fuerza de voluntad sola no basta. Necesitas reencuadrar completamente cómo te ves a ti mismo y cómo te relacionas con el mundo.")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 8)
                    }

                    // Espaciado para el botón fijo
                    Spacer().frame(height: 120)
                }
            }

            // ── Botón fijo inferior ──
            VStack(spacing: 0) {
                // Fade superior
                LinearGradient(
                    colors: [Color(hex: "050507").opacity(0), Color(hex: "050507")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 32)

                VStack(spacing: 12) {
                    Button(action: onStart) {
                        Text("Empezar con Braver")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(BraverTheme.accent)
                            .cornerRadius(BraverTheme.radiusPill)
                    }
                    .padding(.horizontal, 24)

                    HStack(spacing: 16) {
                        Label("Empieza hoy", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.success)
                        Label("Sin excusas", systemImage: "flame.fill")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(BraverTheme.bravura)
                    }
                    .padding(.bottom, 36)
                }
                .background(Color(hex: "050507"))
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Paywall subviews

private struct PaywallBenefitChips: View {
    private let chips: [(String, Color)] = [
        ("Mayor confianza",       Color(hex: "4C9EEB")),
        ("Menos ansiedad social", Color(hex: "10B981")),
        ("Más energía",           Color(hex: "F59E0B")),
        ("Mejor comunicación",    Color(hex: "818CF8")),
        ("Más presencia",         Color(hex: "2DD4BF")),
        ("Relaciones profundas",  Color(hex: "F472B6")),
        ("Control emocional",     Color(hex: "F97316")),
    ]

    var body: some View {
        // Wrap layout manual: 2 filas de chips
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                ForEach(Array(chips.prefix(4).enumerated()), id: \.offset) { _, chip in
                    PaywallChip(label: chip.0, color: chip.1)
                }
            }
            HStack(spacing: 8) {
                ForEach(Array(chips.dropFirst(4).enumerated()), id: \.offset) { _, chip in
                    PaywallChip(label: chip.0, color: chip.1)
                }
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 32)
    }
}

private struct PaywallChip: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.vertical, 7)
            .padding(.horizontal, 12)
            .background(color.opacity(0.22))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(color.opacity(0.45), lineWidth: 1))
    }
}

private struct PaywallBullet {
    let icon: String
    let text: String
}

private struct PaywallTestimonial {
    let stars: Int
    let quote: String
    let author: String
}

private struct PaywallFeatureBlock: View {
    let emoji: String
    let title: String
    let bullets: [PaywallBullet]
    let testimonial: PaywallTestimonial?

    var body: some View {
        VStack(spacing: 20) {
            // Emoji grande
            Text(emoji)
                .font(.system(size: 72))
                .padding(.top, 36)

            // Título
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Bullets
            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(bullets.enumerated()), id: \.offset) { _, bullet in
                    HStack(alignment: .top, spacing: 14) {
                        Text(bullet.icon)
                            .font(.system(size: 20))
                            .frame(width: 28)
                        PaywallBulletText(raw: bullet.text)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)

            // Testimonial
            if let t = testimonial {
                PaywallTestimonialView(testimonial: t)
                    .padding(.top, 8)
            }
        }
    }
}

private struct PaywallBulletText: View {
    let raw: String   // soporta **negrita** inline

    var body: some View {
        // Parsea **texto** en bold
        let parts = parseMarkdown(raw)
        parts.reduce(Text("")) { result, part in
            result + part
        }
        .font(.system(size: 16, weight: .regular, design: .rounded))
        .foregroundColor(BraverTheme.textSecondary)
        .fixedSize(horizontal: false, vertical: true)
    }

    private func parseMarkdown(_ s: String) -> [Text] {
        var result: [Text] = []
        var remaining = s
        while !remaining.isEmpty {
            if let start = remaining.range(of: "**"),
               let end = remaining[start.upperBound...].range(of: "**") {
                // Texto antes
                let before = String(remaining[remaining.startIndex..<start.lowerBound])
                if !before.isEmpty {
                    result.append(Text(before)
                        .foregroundColor(BraverTheme.textSecondary))
                }
                // Texto bold
                let bold = String(remaining[start.upperBound..<end.lowerBound])
                result.append(Text(bold)
                    .fontWeight(.bold)
                    .foregroundColor(BraverTheme.textPrimary))
                remaining = String(remaining[end.upperBound...])
            } else {
                result.append(Text(remaining)
                    .foregroundColor(BraverTheme.textSecondary))
                break
            }
        }
        return result.isEmpty ? [Text(s).foregroundColor(BraverTheme.textSecondary)] : result
    }
}

private struct PaywallTestimonialView: View {
    let testimonial: PaywallTestimonial

    var body: some View {
        VStack(spacing: 12) {
            // Estrellas en píldora
            HStack(spacing: 4) {
                ForEach(0..<testimonial.stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "F59E0B"))
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color(hex: "0E1120"))
            .clipShape(Capsule())

            Text(testimonial.quote)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .italic()
                .foregroundColor(BraverTheme.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Text(testimonial.author)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(BraverTheme.textTertiary)

            Rectangle()
                .fill(Color.white.opacity(0.07))
                .frame(height: 1)
                .padding(.horizontal, 24)
                .padding(.top, 4)
        }
    }
}

private struct PaywallDailyHabitsBlock: View {
    let targetDate: String

    private let features: [(String, String)] = [
        ("🎯", "Completa retos diarios graduales"),
        ("📊", "Registra tu SUDS y ve tu progreso"),
        ("🌱", "Cuida tu racha y ve crecer tu planta"),
        ("💡", "Reflexiona en el Momento del día"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Tarjeta oscura
            VStack(spacing: 16) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)

                Text("Hábitos diarios simples")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Braver te enseña hábitos respaldados por la ciencia que hacen posible un cambio real y duradero.")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 4) {
                    Text("Serás valiente para:")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)

                    Text(targetDate)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 28)
                        .background(Color.white.opacity(0.07))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.10), lineWidth: 1))
                }

                Rectangle()
                    .fill(Color.white.opacity(0.07))
                    .frame(height: 1)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Cómo alcanzar tu objetivo:")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 16)

                    ForEach(Array(features.enumerated()), id: \.offset) { i, feat in
                        HStack(spacing: 16) {
                            Text(feat.0)
                                .font(.system(size: 28))
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(10)
                            Text(feat.1)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(BraverTheme.textSecondary)
                            Spacer()
                        }
                        .padding(.bottom, i < features.count - 1 ? 16 : 0)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(24)
            .background(Color(hex: "0A0D1C"))
            .cornerRadius(BraverTheme.radiusLarge)
            .overlay(
                RoundedRectangle(cornerRadius: BraverTheme.radiusLarge)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 32)
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(onCompleted: {})
}

