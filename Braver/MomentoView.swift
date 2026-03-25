import SwiftUI

struct MomentoView: View {
    @State private var selectedSituation: String? = nil
    @State private var breathPhase: BreathPhase = .idle
    @State private var breathScale: CGFloat = 0.85
    @State private var breathLabel = "Inhala"
    @State private var secondsRemaining = 0
    @State private var isBreathing = false
    @State private var currentCycle = 0
    @State private var dataIndex = 0
    @State private var showData = true
    @State private var showGoButton = false

    let maxCycles = 3

    enum BreathPhase {
        case idle, inhale, hold1, exhale, hold2, done
    }

    let situations = [
        "📞 Llamada",
        "🎤 Hablar en público",
        "🛍️ Dependiente",
        "💘 Ligar",
        "👥 Grupo",
        "💼 Trabajo",
        "😤 Conflicto",
        "🤝 Conocer gente"
    ]

    let datosBraver: [String: [String]] = [
        "📞 Llamada": [
            "La persona que coge el teléfono ha atendido 200 llamadas hoy. No recuerda la anterior. Tú eres una más.",
            "No pueden verte. No pueden juzgar tu cara. Solo escuchan tu voz durante 90 segundos.",
            "El peor resultado: te dicen que no. El mejor: consigues lo que necesitas. Las probabilidades no están en tu contra.",
            "Están ahí para ayudarte. Literalmente les pagan para eso.",
            "Si te equivocas con una palabra, no importa. Ellos tampoco recuerdan sus propias llamadas.",
            "En 10 minutos habrá terminado. Y tú habrás hecho algo que tu yo de hace un año evitaba.",
            "El 95% de las llamadas que tememos duran menos de 3 minutos. Tres minutos.",
            "Cuelgan el teléfono y en 30 segundos ya están pensando en otra cosa. Tú existes para ellos el tiempo que dura la llamada."
        ],
        "🎤 Hablar en público": [
            "El público quiere que lo hagas bien. Nadie va a una charla a ver fracasar a alguien.",
            "Los nervios y la emoción son físicamente idénticos. Tu cuerpo está listo para esto.",
            "Cometiste 47 errores gramaticales conversando hoy. Nadie los contó. Esto es igual.",
            "Hablar imperfecto en público es infinitamente mejor que no hablar.",
            "Puedes pausar. Respirar. Beber agua. Es señal de confianza, no de debilidad.",
            "El 73% del público está pensando en sí mismo, no en ti.",
            "Los mejores oradores del mundo siguen sintiéndose nerviosos. La diferencia es que empiezan igual.",
            "Un tropieza en mitad de un discurso lo humaniza. La perfección distancia. El error conecta."
        ],
        "🛍️ Dependiente": [
            "En 3 minutos ese dependiente ni sabrá que exististe. Tú sí recordarás que lo hiciste.",
            "Su trabajo es ayudarte. No juzgarte. Literalmente.",
            "Han visto a miles de personas hoy. Tú eres uno más, y eso es perfecto.",
            "¿Qué es lo peor que puede pasar? ¿Que digan 'no tenemos'? Eso no es fracaso, es información.",
            "No van a recordar tu cara. Pero tú recordarás que te atreviste.",
            "Preguntarles es exactamente para lo que están ahí. No les molesta. Es su trabajo.",
            "Llevan horas esperando que alguien les pregunte algo. Eres bienvenido.",
            "El dependiente más antipático del mundo ha olvidado tu cara antes de que llegues a la puerta."
        ],
        "💘 Ligar": [
            "Somos 8.000 millones de personas. Si dice que no, tienes 7.999.999.999 opciones más.",
            "El rechazo no dice nada de ti. Dice que no era el momento o la persona.",
            "La persona más atractiva de la sala también tiene miedo al rechazo. La diferencia es que actúa igual.",
            "Arrepentirte de no haberlo intentado dura mucho más que el rechazo.",
            "El peor resultado es que sigas tu día igual que estaba. No has perdido nada.",
            "Un 'no' cierra una puerta. No intentarlo las cierra todas.",
            "El atractivo más universal no es la belleza ni el dinero. Es la persona que se atreve.",
            "Una pregunta directa y honesta es más atractiva que dos horas de insinuaciones."
        ],
        "👥 Grupo": [
            "Nadie está tan pendiente de ti como crees. Están pensando en sí mismos.",
            "El efecto foco: crees que todos te miran. Intenta recordar quién llegó tarde a la última reunión. No puedes. Ellos tampoco te recuerdan a ti.",
            "Hablar poco en un grupo no te hace raro. Te hace interesante.",
            "Una frase en el momento adecuado vale más que el silencio que te pesa.",
            "Todos en ese grupo sienten algo parecido a lo que tú sientes ahora.",
            "No tienes que caerle bien a todo el mundo. Solo tienes que estar ahí.",
            "El grupo ya está formado. Solo tienes que entrar. La puerta no está cerrada.",
            "La incomodidad que sientes en grupo es social, no real. Tu cuerpo exagera la amenaza."
        ],
        "💼 Trabajo": [
            "Tu opinión tiene valor. Si no la dices, nadie sabrá que la tienes.",
            "Equivocarse en el trabajo no acaba carreras. Callarse sí puede hacerlo.",
            "Tu jefe ya ha olvidado tu último error. Tú no. Ese es el problema.",
            "Pedir ayuda no te hace menos capaz. Te hace eficiente.",
            "La mayoría de tus compañeros sienten lo mismo que tú en las reuniones.",
            "Decir 'no sé, voy a averiguarlo' es una respuesta profesional perfecta.",
            "El que habla en las reuniones no siempre tiene las mejores ideas. Pero sí las más visibles.",
            "Tu carrera no la va a gestionar nadie más. Habla. Propón. Aparece."
        ],
        "😤 Conflicto": [
            "Evitar el conflicto no lo resuelve. Lo deja crecer hasta que duele más.",
            "Decir lo que piensas con respeto nunca es un error.",
            "La otra persona probablemente también está esperando que alguien diga algo.",
            "Un conflicto resuelto a tiempo vale más que diez evitados.",
            "No tienes que ganar. Solo tienes que decir lo que necesitas decir.",
            "El respeto que te tienes a ti mismo empieza por defender lo que es tuyo.",
            "Callar por miedo al conflicto no es paz. Es tensión acumulada.",
            "Las personas que te respetan de verdad aprecian que seas directo. Las que no, no te merecen."
        ],
        "🤝 Conocer gente": [
            "La gente que vale la pena siempre aprecia a quien da el primer paso.",
            "Casi nadie recuerda exactamente qué dijiste. Recuerdan cómo les hiciste sentir.",
            "Todo el mundo está esperando que alguien empiece. Sé ese alguien.",
            "Ser auténtico funciona mejor que ser perfecto. Siempre.",
            "El peor primer encuentro se convierte en anécdota. El mejor, en amistad.",
            "Si te sale mal, ya tienes algo de qué reírte juntos después.",
            "Las mejores personas de tu vida fueron desconocidos hasta que alguien habló primero.",
            "No necesitas un guion perfecto. Necesitas empezar."
        ]
    ]

    var currentDatos: [String] {
        guard let s = selectedSituation else { return [] }
        return datosBraver[s] ?? []
    }

    var currentDato: String {
        guard !currentDatos.isEmpty else { return "" }
        return currentDatos[dataIndex % currentDatos.count]
    }

    var breathDuration: Double {
        switch breathPhase {
        case .inhale:        return 4
        case .hold1, .hold2: return 4
        case .exhale:        return 4
        default:             return 0.3
        }
    }

    var body: some View {
        ZStack {
            BraverTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 4) {
                    Text("Braver")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                    Text(selectedSituation == nil ? "¿Qué te está dando ansiedad?" : "Respira. Lee. Actúa.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .animation(.easeInOut(duration: 0.3), value: selectedSituation)
                }
                .padding(.top, 20)
                .padding(.bottom, 28)

                if selectedSituation == nil {
                    // MARK: - Situation selector
                    situationGrid
                        .transition(.opacity.combined(with: .scale(scale: 0.97)))
                } else {
                    // MARK: - Active state
                    activeView
                        .transition(.opacity.combined(with: .scale(scale: 0.97)))
                }
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .animation(.spring(response: 0.4), value: selectedSituation)
        }
    }

    // MARK: - Situation Grid

    var situationGrid: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(situations, id: \.self) { s in
                    Button {
                        withAnimation(.spring(response: 0.35)) {
                            selectedSituation = s
                            dataIndex = 0
                            showData = true
                            showGoButton = false
                        }
                        startBreathing()
                    } label: {
                        VStack(spacing: 8) {
                            Text(String(s.prefix(2)))
                                .font(.system(size: 32))
                            Text(s.drop(while: { !$0.isWhitespace }).trimmingCharacters(in: .whitespaces))
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(BraverTheme.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(BraverTheme.surface)
                        .cornerRadius(BraverTheme.radiusMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                .stroke(BraverTheme.surfaceBorder, lineWidth: 1)
                        )
                    }
                }
            }

            Text("Toca la que más te pese ahora mismo")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(BraverTheme.textTertiary)
                .padding(.top, 4)
        }
    }

    // MARK: - Active View

    var activeView: some View {
        VStack(spacing: 20) {
            // Breathing circle
            ZStack {
                Circle()
                    .stroke(BraverTheme.bravura.opacity(0.08), lineWidth: 1)
                    .frame(width: 240, height: 240)
                    .scaleEffect(breathScale * 1.2)
                    .animation(.easeInOut(duration: breathDuration), value: breathScale)

                Circle()
                    .stroke(BraverTheme.bravura.opacity(0.18), lineWidth: 2)
                    .frame(width: 200, height: 200)
                    .scaleEffect(breathScale * 1.05)
                    .animation(.easeInOut(duration: breathDuration), value: breathScale)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                BraverTheme.bravura.opacity(0.22),
                                BraverTheme.bravura.opacity(0.06)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 90
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(breathScale)
                    .animation(.easeInOut(duration: breathDuration), value: breathScale)

                VStack(spacing: 6) {
                    if breathPhase == .done {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(BraverTheme.success)
                        Text("Listo")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                    } else {
                        Text(breathLabel)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .transition(.opacity)
                            .id(breathLabel)
                        if secondsRemaining > 0 {
                            Text("\(secondsRemaining)")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(BraverTheme.bravura)
                                .transition(.scale.combined(with: .opacity))
                                .id(secondsRemaining)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: breathLabel)
            }
            .onTapGesture {
                if isBreathing {
                    stopBreathing()
                } else if breathPhase != .done {
                    startBreathing()
                }
            }

            // Cycle dots
            HStack(spacing: 8) {
                ForEach(0..<maxCycles, id: \.self) { i in
                    Circle()
                        .fill(i < currentCycle ? BraverTheme.bravura : BraverTheme.surfaceElevated)
                        .frame(width: 7, height: 7)
                        .animation(.spring(response: 0.3), value: currentCycle)
                }
            }

            // Data card
            if showData && !currentDatos.isEmpty {
                dataCard
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer()

            // Bottom buttons
            VStack(spacing: 12) {
                if showGoButton {
                    Button {
                        StreakService.shared.registerMomentoBraver()
                        withAnimation(.spring(response: 0.3)) {
                            reset()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "bolt.fill")
                            Text("Voy a por ello")
                        }
                    }
                    .buttonStyle(BraverPrimaryButton(color: BraverTheme.bravura))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Button("Cambiar situación") {
                    withAnimation(.spring(response: 0.3)) {
                        reset()
                    }
                }
                .buttonStyle(BraverGhostButton())
            }
            .animation(.spring(response: 0.4), value: showGoButton)
            .padding(.bottom, 8)
        }
    }

    // MARK: - Data Card

    var dataCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text(currentDato)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
                    .id(dataIndex)
                    .animation(.easeInOut(duration: 0.25), value: dataIndex)

                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showData = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(BraverTheme.textTertiary)
                        .padding(6)
                        .background(BraverTheme.surfaceElevated)
                        .clipShape(Circle())
                }
                .padding(.leading, 8)
            }

            // Navigation arrows
            if currentDatos.count > 1 {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            dataIndex = (dataIndex - 1 + currentDatos.count) % currentDatos.count
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(BraverTheme.textTertiary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusSmall)
                    }

                    Spacer()

                    Text("\(dataIndex + 1) / \(currentDatos.count)")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)

                    Spacer()

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            dataIndex = (dataIndex + 1) % currentDatos.count
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(BraverTheme.textTertiary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusSmall)
                    }
                }
                .padding(.top, 14)
            }
        }
        .padding(BraverTheme.cardPadding)
        .braverCard(elevated: true)
    }

    // MARK: - Breathing Logic

    func startBreathing() {
        isBreathing = true
        currentCycle = 0
        runCycle()
    }

    func stopBreathing() {
        isBreathing = false
        breathPhase = .idle
        breathLabel = "Toca para continuar"
        secondsRemaining = 0
    }

    func reset() {
        stopBreathing()
        selectedSituation = nil
        breathScale = 0.85
        breathLabel = "Inhala"
        currentCycle = 0
        dataIndex = 0
        showData = true
        showGoButton = false
        breathPhase = .idle
    }

    func runCycle() {
        guard isBreathing else { return }
        guard currentCycle < maxCycles else {
            finishBreathing()
            return
        }
        breathPhase = .inhale
        breathLabel = "Inhala"
        withAnimation(.easeInOut(duration: 4)) { breathScale = 1.2 }
        countdown(from: 4) {
            guard isBreathing else { return }
            breathPhase = .hold1
            breathLabel = "Aguanta"
            countdown(from: 4) {
                guard isBreathing else { return }
                breathPhase = .exhale
                breathLabel = "Exhala"
                withAnimation(.easeInOut(duration: 4)) { breathScale = 0.85 }
                countdown(from: 4) {
                    guard isBreathing else { return }
                    breathPhase = .hold2
                    breathLabel = "Aguanta"
                    countdown(from: 4) {
                        currentCycle += 1
                        runCycle()
                    }
                }
            }
        }
    }

    func finishBreathing() {
        isBreathing = false
        breathPhase = .done
        withAnimation(.spring(response: 0.4)) {
            showGoButton = true
        }
    }

    func countdown(from seconds: Int, completion: @escaping () -> Void) {
        secondsRemaining = seconds
        for i in 0..<seconds {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                withAnimation(.spring(response: 0.2)) {
                    secondsRemaining = seconds - i
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(seconds)) {
            completion()
        }
    }
}
