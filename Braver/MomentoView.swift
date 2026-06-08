import SwiftUI
import SwiftData
import UserNotifications

// MARK: - Container

struct MomentoView: View {
    enum ActiveMode { case entrada, panico, preparate }

    @State private var activeMode: ActiveMode = .entrada
    @State private var showFollowUp = false
    @State private var pendingSessionID: UUID? = nil

    var body: some View {
        ZStack {
            BraverTheme.background.ignoresSafeArea()
            Group {
                switch activeMode {
                case .entrada:
                    ModoEntradaView { mode in
                        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                            activeMode = mode == .panico ? .panico : .preparate
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))

                case .panico:
                    ModoPanicoView {
                        withAnimation(.spring(response: 0.38)) { activeMode = .entrada }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))

                case .preparate:
                    ModoPreparateView {
                        withAnimation(.spring(response: 0.38)) { activeMode = .entrada }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
        }
        .onAppear(perform: checkPendingFollowUp)
        .sheet(isPresented: $showFollowUp) {
            if let id = pendingSessionID {
                FollowUpSheet(sessionID: id) {
                    showFollowUp = false
                    pendingSessionID = nil
                }
            }
        }
    }

    private func checkPendingFollowUp() {
        guard
            let idStr = UserDefaults.standard.string(forKey: "braver_followup_id"),
            let uuid  = UUID(uuidString: idStr),
            let date  = UserDefaults.standard.object(forKey: "braver_followup_at") as? Date,
            Date() >= date
        else { return }
        pendingSessionID = uuid
        UserDefaults.standard.removeObject(forKey: "braver_followup_id")
        UserDefaults.standard.removeObject(forKey: "braver_followup_at")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { showFollowUp = true }
    }
}

// MARK: - Pantalla de entrada

private struct ModoEntradaView: View {
    enum Choice { case panico, preparate }
    let onSelect: (Choice) -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("Braver")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Text("¿Qué necesitas ahora mismo?")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
            }
            .padding(.top, 20)
            .padding(.bottom, 40)

            HStack(spacing: 14) {
                ModoCard(
                    icon: "bolt.fill",
                    title: "Modo Pánico",
                    description: "Estoy en esto\nahora mismo",
                    accent: BraverTheme.bravura
                ) { onSelect(.panico) }

                ModoCard(
                    icon: "scope",
                    title: "Modo Prepárate",
                    description: "Voy a enfrentarme\na algo",
                    accent: BraverTheme.bravura
                ) { onSelect(.preparate) }
            }
            .padding(.horizontal, BraverTheme.screenPadding)

            Spacer()

            Text("Pánico: actúa ahora. Prepárate: planifica antes.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(BraverTheme.textTertiary)
                .padding(.bottom, 28)
        }
    }
}

private struct ModoCard: View {
    let icon: String
    let title: String
    let description: String
    let accent: Color
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Spacer().frame(height: 28)
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.13))
                        .frame(width: 68, height: 68)
                    Image(systemName: icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(accent)
                }
                Spacer().frame(height: 16)
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Spacer().frame(height: 8)
                Text(description)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                Spacer().frame(height: 28)
            }
            .frame(maxWidth: .infinity)
            .background(BraverTheme.surface)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(accent.opacity(pressed ? 0.55 : 0.28), lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(pressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.22, dampingFraction: 0.7), value: pressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

// MARK: - Modo Pánico (flujo original sin cambios)

private struct ModoPanicoView: View {
    let onBack: () -> Void

    @State private var selectedSituation: String? = nil
    @State private var breathPhase: BreathPhase = .idle
    @State private var breathScale: CGFloat = 0.85
    @State private var breathLabel = "Inhala"
    @State private var secondsRemaining = 0
    @State private var isBreathing = false
    @State private var breathTimer: Timer? = nil
    @State private var currentCycle = 0
    @State private var dataIndex = 0
    @State private var showData = true
    @State private var showGoButton = false

    let maxCycles = 3
    enum BreathPhase { case idle, inhale, hold1, exhale, hold2, done }

    let situations = [
        "📞 Llamada", "🎤 Hablar en público", "🛍️ Dependiente", "💘 Ligar",
        "👥 Grupo", "💼 Trabajo", "😤 Conflicto", "🤝 Conocer gente", "🎥 Crear contenido"
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
            "Cuelgan el teléfono y en 30 segundos ya están pensando en otra cosa."
        ],
        "🎤 Hablar en público": [
            "El público quiere que lo hagas bien. Nadie va a una charla a ver fracasar a alguien.",
            "Los nervios y la emoción son físicamente idénticos. Tu cuerpo está listo para esto.",
            "Cometiste 47 errores gramaticales conversando hoy. Nadie los contó. Esto es igual.",
            "Hablar imperfecto en público es infinitamente mejor que no hablar.",
            "Puedes pausar. Respirar. Beber agua. Es señal de confianza, no de debilidad.",
            "El 73% del público está pensando en sí mismo, no en ti.",
            "Los mejores oradores del mundo siguen sintiéndose nerviosos. La diferencia es que empiezan igual.",
            "Un tropiezo en mitad de un discurso lo humaniza. La perfección distancia. El error conecta."
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
        ],
        "🎥 Crear contenido": [
            "La primera grabación de cualquier creador que admiras era igual de mala. La diferencia es que la subieron.",
            "El 92% de los comentarios en contenido nuevo son neutros o positivos. Tu cerebro solo procesa los negativos.",
            "Una vez que lo subes, deja de ser tuyo. Se convierte en algo que alguien puede necesitar ver.",
            "Nadie recuerda tu primera publicación tanto como tú. Para ellos fue un scroll. Para ti, fue valiente.",
            "La cámara no te hace más juzgable. Ya te juzgaban — o no. Esto no cambia eso.",
            "Las personas que más te importan probablemente te apoyarán. Las que critiquen sin ver el contenido ya lo hacían antes.",
            "Cada día que no creas, alguien con menos conocimiento que tú sí lo hace. Tú podrías ayudar a alguien que ellos no pueden.",
            "La autenticidad no es ausencia de nerviosismo. Es actuar aunque lo tengas."
        ]
    ]

    var currentDatos: [String] { datosBraver[selectedSituation ?? ""] ?? [] }
    var currentDato: String {
        guard !currentDatos.isEmpty else { return "" }
        return currentDatos[dataIndex % currentDatos.count]
    }
    var breathDuration: Double {
        switch breathPhase {
        case .inhale, .hold1, .hold2, .exhale: return 4
        default: return 0.3
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Nav
            HStack {
                Button {
                    withAnimation(.spring(response: 0.3)) { onBack() }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Modos")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                    }
                    .foregroundColor(BraverTheme.textTertiary)
                }
                Spacer()
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.top, 16)
            .padding(.bottom, 4)

            // Header
            VStack(spacing: 4) {
                Text("Modo Pánico")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Text(selectedSituation == nil ? "¿Qué te está dando ansiedad?" : "Respira. Lee. Actúa.")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .animation(.easeInOut(duration: 0.3), value: selectedSituation)
            }
            .padding(.bottom, 24)

            if selectedSituation == nil {
                situationGrid
                    .transition(.opacity.combined(with: .scale(scale: 0.97)))
            } else {
                activeView
                    .transition(.opacity.combined(with: .scale(scale: 0.97)))
            }
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .animation(.spring(response: 0.4), value: selectedSituation)
    }

    var situationGrid: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(situations, id: \.self) { s in
                    Button {
                        withAnimation(.spring(response: 0.35)) {
                            selectedSituation = s
                            dataIndex = 0; showData = true; showGoButton = false
                        }
                        startBreathing()
                    } label: {
                        VStack(spacing: 8) {
                            Text(String(s.prefix(2))).font(.system(size: 32))
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

    var activeView: some View {
        VStack(spacing: 20) {
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
                    .fill(RadialGradient(
                        colors: [BraverTheme.bravura.opacity(0.22), BraverTheme.bravura.opacity(0.06)],
                        center: .center, startRadius: 20, endRadius: 90
                    ))
                    .frame(width: 160, height: 160)
                    .scaleEffect(breathScale)
                    .animation(.easeInOut(duration: breathDuration), value: breathScale)
                VStack(spacing: 6) {
                    if breathPhase == .done {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28)).foregroundColor(BraverTheme.success)
                        Text("Listo")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                    } else {
                        Text(breathLabel)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .transition(.opacity).id(breathLabel)
                        if secondsRemaining > 0 {
                            Text("\(secondsRemaining)")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundColor(BraverTheme.bravura)
                                .transition(.scale.combined(with: .opacity)).id(secondsRemaining)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: breathLabel)
            }
            .onTapGesture {
                if isBreathing { stopBreathing() }
                else if breathPhase != .done { startBreathing() }
            }

            HStack(spacing: 8) {
                ForEach(0..<maxCycles, id: \.self) { i in
                    Circle()
                        .fill(i < currentCycle ? BraverTheme.bravura : BraverTheme.surfaceElevated)
                        .frame(width: 7, height: 7)
                        .animation(.spring(response: 0.3), value: currentCycle)
                }
            }

            if showData && !currentDatos.isEmpty {
                dataCard.transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer()

            VStack(spacing: 12) {
                if showGoButton {
                    Button {
                        StreakService.shared.registerMomentoBraver()
                        withAnimation(.spring(response: 0.3)) { reset() }
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
                    withAnimation(.spring(response: 0.3)) { reset() }
                }
                .buttonStyle(BraverGhostButton())
            }
            .animation(.spring(response: 0.4), value: showGoButton)
            .padding(.bottom, 8)
        }
    }

    var dataCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text(currentDato)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                    .lineSpacing(4).fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity).id(dataIndex)
                    .animation(.easeInOut(duration: 0.25), value: dataIndex)
                Button {
                    withAnimation(.spring(response: 0.3)) { showData = false }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(BraverTheme.textTertiary)
                        .padding(6).background(BraverTheme.surfaceElevated).clipShape(Circle())
                }
                .padding(.leading, 8)
            }
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
                            .padding(.horizontal, 12).padding(.vertical, 8)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusSmall)
                    }
                    Spacer()
                    Text("\(dataIndex + 1) / \(currentDatos.count)")
                        .font(.system(size: 11, design: .rounded)).foregroundColor(BraverTheme.textTertiary)
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            dataIndex = (dataIndex + 1) % currentDatos.count
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(BraverTheme.textTertiary)
                            .padding(.horizontal, 12).padding(.vertical, 8)
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

    // Breathing logic
    func startBreathing() { isBreathing = true; currentCycle = 0; runCycle() }
    func stopBreathing() {
        isBreathing = false
        breathTimer?.invalidate()
        breathTimer = nil
        breathPhase = .idle
        breathLabel = "Toca para continuar"
        secondsRemaining = 0
    }
    func reset() {
        stopBreathing()
        selectedSituation = nil; breathScale = 0.85; breathLabel = "Inhala"
        currentCycle = 0; dataIndex = 0; showData = true; showGoButton = false; breathPhase = .idle
    }
    func runCycle() {
        guard isBreathing, currentCycle < maxCycles else { if isBreathing { finishBreathing() }; return }
        breathPhase = .inhale; breathLabel = "Inhala"
        withAnimation(.easeInOut(duration: 4)) { breathScale = 1.2 }
        countdown(from: 4) {
            guard isBreathing else { return }
            breathPhase = .hold1; breathLabel = "Aguanta"
            countdown(from: 4) {
                guard isBreathing else { return }
                breathPhase = .exhale; breathLabel = "Exhala"
                withAnimation(.easeInOut(duration: 4)) { breathScale = 0.85 }
                countdown(from: 4) {
                    guard isBreathing else { return }
                    breathPhase = .hold2; breathLabel = "Aguanta"
                    countdown(from: 4) { currentCycle += 1; runCycle() }
                }
            }
        }
    }
    func finishBreathing() {
        isBreathing = false; breathPhase = .done
        withAnimation(.spring(response: 0.4)) { showGoButton = true }
    }
    func countdown(from seconds: Int, completion: @escaping () -> Void) {
        breathTimer?.invalidate()
        secondsRemaining = seconds
        var remaining = seconds
        breathTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            remaining -= 1
            withAnimation(.spring(response: 0.2)) { secondsRemaining = remaining }
            if remaining <= 0 {
                timer.invalidate()
                completion()
            }
        }
    }
}

// MARK: - Modo Prepárate

private struct ModoPreparateView: View {
    @Environment(\.modelContext) private var context
    let onBack: () -> Void

    @State private var step = 0
    @State private var situacion = ""
    @State private var preocupacion = ""
    @State private var suds: Double = 40
    @State private var contextoExtra = ""
    @State private var novaResponse = ""
    @State private var isLoadingNova = false
    @State private var chatHistory: [NovaMessage] = []
    @State private var chatInput = ""
    @State private var exchangeCount = 0
    @State private var showCancelAlert = false
    @FocusState private var chatFocused: Bool

    let maxExchanges = 3
    let accent = BraverTheme.bravura

    let situaciones: [(String, String)] = [
        ("📞", "Llamada difícil"),
        ("🎤", "Reunión o presentación"),
        ("👋", "Hablar por primera vez"),
        ("💘", "Algo romántico"),
        ("⚡", "Enfrentar un conflicto"),
        ("🎥", "Crear o subir contenido"),
        ("✏️", "Otra cosa")
    ]
    let preocupaciones: [(String, String)] = [
        ("👁", "Que me juzguen"),
        ("🧠", "Quedarme en blanco"),
        ("❌", "Que salga mal"),
        ("😰", "Que se note que estoy nervioso"),
        ("💬", "No saber qué decir"),
        ("✏️", "Otra cosa")
    ]

    var sudsLabel: String {
        switch Int(suds) {
        case 0...25:  return "Tranquilo/a"
        case 26...45: return "Un poco incómodo/a"
        case 46...65: return "Bastante ansioso/a"
        case 66...80: return "Muy activado/a"
        default:      return "Al límite"
        }
    }
    var sudsColor: Color {
        switch Int(suds) {
        case 0...30:  return BraverTheme.success
        case 31...55: return Color(hex: "F59E0B")
        case 56...75: return Color(hex: "F97316")
        default:      return Color(hex: "EF4444")
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Barra de progreso + X
            HStack(spacing: 12) {
                HStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(i <= step ? accent : BraverTheme.surfaceElevated)
                            .frame(height: 3)
                            .animation(.spring(response: 0.35), value: step)
                    }
                }
                Button {
                    if step == 0 { onBack() } else { showCancelAlert = true }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(BraverTheme.textTertiary)
                        .padding(8)
                        .background(BraverTheme.surfaceElevated)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.top, 16)
            .padding(.bottom, 8)

            switch step {
            case 0: stepSituacion
            case 1: stepPreocupacion
            case 2: stepSUDS
            case 3: stepContexto
            case 4: stepNova
            default: EmptyView()
            }
        }
        .alert("¿Salir del modo Prepárate?", isPresented: $showCancelAlert) {
            Button("Quedarme", role: .cancel) {}
            Button("Salir", role: .destructive) { onBack() }
        } message: {
            Text("Perderás el progreso de esta sesión.")
        }
    }

    // MARK: Step 1 — ¿Qué vas a hacer?
    var stepSituacion: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                stepHeader(
                    title: "¿A qué te vas a enfrentar?",
                    subtitle: "Elige lo que más se acerca a tu situación."
                )
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(situaciones, id: \.1) { emoji, label in
                        PrepOption(emoji: emoji, label: label, accent: accent, isSelected: situacion == label) {
                            situacion = label
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
                                withAnimation(.spring(response: 0.38)) { step = 1 }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.top, 12).padding(.bottom, 24)
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal:   .move(edge: .leading).combined(with: .opacity)
        ))
    }

    // MARK: Step 2 — ¿Qué te preocupa?
    var stepPreocupacion: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                stepHeader(
                    title: "¿Qué es lo que más te preocupa?",
                    subtitle: "Lo que más pesa cuando piensas en ello."
                )
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(preocupaciones, id: \.1) { emoji, label in
                        PrepOption(emoji: emoji, label: label, accent: accent, isSelected: preocupacion == label) {
                            preocupacion = label
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
                                withAnimation(.spring(response: 0.38)) { step = 2 }
                            }
                        }
                    }
                }
                Button {
                    withAnimation(.spring(response: 0.38)) { step = 0 }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left").font(.system(size: 12, weight: .semibold))
                        Text("Cambiar situación").font(.system(size: 13, design: .rounded))
                    }
                    .foregroundColor(BraverTheme.textTertiary)
                }
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.top, 12).padding(.bottom, 24)
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal:   .move(edge: .leading).combined(with: .opacity)
        ))
    }

    // MARK: Step 3 — SUDS
    var stepSUDS: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    stepHeader(
                        title: "¿Cuánta ansiedad sientes ahora?",
                        subtitle: "SUDS: 0 = calma total  ·  100 = máximo miedo."
                    )
                    VStack(spacing: 18) {
                        HStack(alignment: .lastTextBaseline, spacing: 6) {
                            Text("\(Int(suds))")
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .foregroundColor(sudsColor)
                                .animation(.spring(response: 0.2), value: Int(suds))
                                .frame(minWidth: 80, alignment: .trailing)
                            Text("/ 100")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                        Text(sudsLabel)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(sudsColor)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .animation(.easeInOut(duration: 0.2), value: sudsLabel)

                        Slider(value: $suds, in: 0...100, step: 1)
                            .tint(sudsColor)
                            .animation(.easeInOut(duration: 0.15), value: sudsColor)

                        HStack {
                            Text("Tranquilo/a")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                            Spacer()
                            Text("Al límite")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                        }
                    }
                    .padding(20)
                    .braverCard(elevated: false)
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 12).padding(.bottom, 24)
            }
            Button { withAnimation(.spring(response: 0.38)) { step = 3 } } label: {
                Text("Continuar")
            }
            .buttonStyle(BraverPrimaryButton(color: accent))
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.bottom, 28)
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal:   .move(edge: .leading).combined(with: .opacity)
        ))
    }

    // MARK: Step 4 — Contexto (opcional)
    var stepContexto: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    stepHeader(
                        title: "¿Algo más específico?",
                        subtitle: "Opcional. Cuanto más contexto tenga Nova, más precisa será."
                    )

                    // Chips resumen
                    HStack(spacing: 8) {
                        contextChip(label: situacion)
                        contextChip(label: preocupacion)
                        contextChip(label: "SUDS \(Int(suds))")
                    }

                    TextEditor(text: $contextoExtra)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .scrollContentBackground(.hidden)
                        .background(BraverTheme.surface)
                        .cornerRadius(BraverTheme.radiusMedium)
                        .overlay(
                            RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                .stroke(BraverTheme.surfaceBorder, lineWidth: 1)
                        )
                        .frame(minHeight: 110)
                        .overlay(alignment: .topLeading) {
                            if contextoExtra.isEmpty {
                                Text("Ej: «Es una presentación ante mi jefe. Me pone muy nervioso cuando me hace preguntas en directo.»")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(BraverTheme.textTertiary)
                                    .padding(.top, 8).padding(.leading, 5)
                                    .allowsHitTesting(false)
                            }
                        }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 12).padding(.bottom, 24)
            }
            VStack(spacing: 10) {
                Button { Task { await loadNova() } } label: { Text("Hablar con Nova") }
                    .buttonStyle(BraverPrimaryButton(color: accent))
                Button("Saltar este paso") { Task { await loadNova() } }
                    .buttonStyle(BraverGhostButton())
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.bottom, 28)
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal:   .move(edge: .leading).combined(with: .opacity)
        ))
    }

    // MARK: Step 5 — Nova responde
    var stepNova: some View {
        VStack(spacing: 0) {
            if isLoadingNova {
                Spacer()
                VStack(spacing: 16) {
                    ProgressView().tint(accent).scaleEffect(1.3)
                    Text("Nova está preparando tu sesión...")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                }
                Spacer()
            } else {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            if !novaResponse.isEmpty {
                                novaCard(text: novaResponse)
                            }
                            ForEach(chatHistory) { msg in
                                if msg.isUser {
                                    HStack {
                                        Spacer(minLength: 48)
                                        Text(msg.text)
                                            .font(.system(size: 14, design: .rounded))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 14).padding(.vertical, 10)
                                            .background(accent)
                                            .cornerRadius(16)
                                    }
                                } else {
                                    novaCard(text: msg.text)
                                }
                            }
                            if exchangeCount >= maxExchanges {
                                Text("Tienes lo que necesitas. Ve a por ello.")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(BraverTheme.textTertiary)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 4)
                            }
                            Color.clear.frame(height: 1).id("bottom")
                        }
                        .padding(.horizontal, BraverTheme.screenPadding)
                        .padding(.top, 12).padding(.bottom, 8)
                    }
                    .onChange(of: chatHistory.count) { _ in
                        withAnimation { proxy.scrollTo("bottom") }
                    }
                }

                Divider().background(BraverTheme.surfaceBorder)

                VStack(spacing: 12) {
                    if exchangeCount < maxExchanges && !novaResponse.isEmpty {
                        HStack(spacing: 10) {
                            TextField("Pregunta algo más...", text: $chatInput)
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(BraverTheme.textPrimary)
                                .padding(.horizontal, 14).padding(.vertical, 10)
                                .background(BraverTheme.surface)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(BraverTheme.surfaceBorder, lineWidth: 1)
                                )
                                .focused($chatFocused)

                            Button {
                                let text = chatInput.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !text.isEmpty else { return }
                                chatInput = ""; chatFocused = false
                                Task { await sendFollowUp(text) }
                            } label: {
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 38, height: 38)
                                    .background(chatInput.trimmingCharacters(in: .whitespaces).isEmpty
                                                ? BraverTheme.surfaceElevated : accent)
                                    .clipShape(Circle())
                            }
                            .disabled(chatInput.trimmingCharacters(in: .whitespaces).isEmpty)
                            .animation(.easeInOut(duration: 0.2), value: chatInput.isEmpty)
                        }

                        let remaining = maxExchanges - exchangeCount
                        Text("\(remaining) respuesta\(remaining == 1 ? "" : "s") más disponible\(remaining == 1 ? "" : "s")")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                    }

                    Button { goForIt() } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "bolt.fill")
                            Text("Voy a por ello")
                        }
                    }
                    .buttonStyle(BraverPrimaryButton(color: accent))
                    .opacity(novaResponse.isEmpty ? 0.4 : 1)
                    .disabled(novaResponse.isEmpty)
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 14).padding(.bottom, 28)
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal:   .move(edge: .leading).combined(with: .opacity)
        ))
    }

    // MARK: Helpers

    func stepHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(BraverTheme.textPrimary)
            Text(subtitle)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(BraverTheme.textSecondary)
        }
    }

    func contextChip(label: String) -> some View {
        Text(label)
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundColor(accent)
            .padding(.horizontal, 10).padding(.vertical, 5)
            .background(accent.opacity(0.1))
            .cornerRadius(20)
    }

    func novaCard(text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle().fill(accent.opacity(0.14)).frame(width: 32, height: 32)
                Text("N")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(accent)
            }
            Text(text)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(BraverTheme.textPrimary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .braverCard(elevated: false)
    }

    // MARK: Actions

    func loadNova() async {
        withAnimation(.spring(response: 0.38)) { step = 4 }
        isLoadingNova = true
        do {
            let response = try await NovaService.shared.prepararSituacion(
                situacion: situacion, preocupacion: preocupacion,
                suds: Int(suds), contexto: contextoExtra
            )
            withAnimation(.spring(response: 0.35)) {
                novaResponse = response
                isLoadingNova = false
            }
        } catch {
            isLoadingNova = false
            novaResponse = "No he podido conectar ahora mismo. Pero tienes lo que necesitas: situación identificada, preocupación clara, SUDS medido. Respira y actúa — observa qué pasa."
        }
    }

    func sendFollowUp(_ text: String) async {
        guard exchangeCount < maxExchanges else { return }
        withAnimation { chatHistory.append(NovaMessage(text: text, isUser: true)) }
        exchangeCount += 1

        // Build history: initial Nova response + all previous messages (sin el que acabamos de añadir)
        var historyForNova: [NovaMessage] = [NovaMessage(text: novaResponse, isUser: false)]
        if chatHistory.count > 1 { historyForNova.append(contentsOf: chatHistory.dropLast()) }

        do {
            let response = try await NovaService.shared.seguirPreparando(history: historyForNova, userText: text)
            withAnimation { chatHistory.append(NovaMessage(text: response, isUser: false)) }
        } catch {
            withAnimation {
                chatHistory.append(NovaMessage(
                    text: "Parece que hay un problema de conexión. Confía en lo que ya tienes.",
                    isUser: false
                ))
            }
        }
    }

    func goForIt() {
        let session = PreparateSession(
            situacion: situacion, preocupacion: preocupacion,
            sudsPrediccion: Int(suds), contextoExtra: contextoExtra, novaResponse: novaResponse
        )
        context.insert(session)
        do {
            try context.save()
        } catch {
            print("⚠️ Error guardando sesión: \(error)")
        }

        UserDefaults.standard.set(session.id.uuidString, forKey: "braver_followup_id")
        UserDefaults.standard.set(Date().addingTimeInterval(30 * 60), forKey: "braver_followup_at")
        scheduleFollowUpNotification(id: session.id)

        StreakService.shared.registerMomentoBraver()
        withAnimation(.spring(response: 0.38)) { onBack() }
    }

    func scheduleFollowUpNotification(id: UUID) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            let content = UNMutableNotificationContent()
            content.title = "¿Cómo fue?"
            content.body = "Hace 30 minutos ibas a enfrentarte a algo. Registra cómo salió de verdad."
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30 * 60, repeats: false)
            let req = UNNotificationRequest(identifier: "braver.preparate.\(id.uuidString)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(req)
        }
    }
}

// MARK: - Opción de preparate

private struct PrepOption: View {
    let emoji: String
    let label: String
    let accent: Color
    let isSelected: Bool
    let onTap: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                Text(emoji).font(.system(size: 28))
                Text(label)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? accent : BraverTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(isSelected ? accent.opacity(0.1) : BraverTheme.surface)
            .cornerRadius(BraverTheme.radiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                    .stroke(isSelected ? accent.opacity(0.5) : BraverTheme.surfaceBorder,
                            lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(pressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.22, dampingFraction: 0.7), value: pressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded   { _ in pressed = false }
        )
    }
}

// MARK: - Follow-up Sheet

private struct FollowUpSheet: View {
    @Environment(\.modelContext) private var context
    @Query private var sessions: [PreparateSession]

    let sessionID: UUID
    let onDismiss: () -> Void

    @State private var sudsReal: Double = 50
    @State private var saved = false

    var session: PreparateSession? { sessions.first { $0.id == sessionID } }

    var sudsColor: Color {
        switch Int(sudsReal) {
        case 0...30:  return BraverTheme.success
        case 31...55: return Color(hex: "F59E0B")
        case 56...75: return Color(hex: "F97316")
        default:      return Color(hex: "EF4444")
        }
    }

    var body: some View {
        ZStack {
            BraverTheme.background.ignoresSafeArea()

            if saved {
                savedView.transition(.scale.combined(with: .opacity))
            } else {
                formView.transition(.opacity)
            }
        }
        .animation(.spring(response: 0.4), value: saved)
    }

    var formView: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(BraverTheme.surfaceElevated)
                .frame(width: 36, height: 4)
                .padding(.top, 12).padding(.bottom, 28)

            VStack(alignment: .leading, spacing: 6) {
                Text("¿Cómo fue?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                if let s = session {
                    Text("Predijiste \(s.sudsPrediccion)/100 de ansiedad. ¿Cuánta fue realmente?")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.bottom, 28)

            VStack(spacing: 14) {
                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text("\(Int(sudsReal))")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundColor(sudsColor)
                        .animation(.spring(response: 0.2), value: Int(sudsReal))
                    Text("/ 100")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Slider(value: $sudsReal, in: 0...100, step: 1)
                    .tint(sudsColor)
                    .animation(.easeInOut(duration: 0.15), value: sudsColor)

                HStack {
                    Text("Tranquilo/a")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                    Spacer()
                    Text("Al límite")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                }
            }
            .padding(20)
            .braverCard(elevated: false)
            .padding(.horizontal, BraverTheme.screenPadding)

            Spacer()

            Button { saveFollowUp() } label: { Text("Guardar") }
                .buttonStyle(BraverPrimaryButton(color: BraverTheme.bravura))
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.bottom, 32)
        }
    }

    var savedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(BraverTheme.success)

            if let s = session, let real = s.sudsReal {
                let diff = s.sudsPrediccion - real
                if diff > 0 {
                    Text("Predijiste \(s.sudsPrediccion). Fue \(real).")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Tu cerebro exageró el peligro en \(diff) puntos.\nY tú lo demostraste.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .multilineTextAlignment(.center)
                } else if diff == 0 {
                    Text("Exactamente como lo predijiste.")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Lo enfrentaste. Eso es lo que cuenta.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Fue más difícil de lo esperado.")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    Text("Lo enfrentaste igual. Eso es exactamente lo que importa.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(40)
    }

    func saveFollowUp() {
        guard let s = session else { onDismiss(); return }
        s.sudsReal = Int(sudsReal)
        do {
            try context.save()
        } catch {
            print("⚠️ Error guardando follow-up: \(error)")
        }
        saved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { onDismiss() }
    }
}
