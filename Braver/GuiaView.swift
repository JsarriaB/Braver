import SwiftUI

struct GuiaView: View {
    @StateObject private var progress = GuiaProgress.shared
    @State private var selectedTab = 0   // 0 = Aprender, 1 = Nova

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerSection
                tabPicker
                Divider().background(BraverTheme.surfaceBorder.opacity(0.4))

                if selectedTab == 0 {
                    aprenderSection
                } else {
                    NovaView()
                }
            }
            .background(BraverTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    // MARK: Header

    var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Guía")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Text(selectedTab == 0 ? "Aprende cómo funciona tu mente" : "Tu asistente personal")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
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
            ForEach(["Aprender", "Nova"], id: \.self) { tab in
                let idx = tab == "Aprender" ? 0 : 1
                Button {
                    withAnimation(.spring(response: 0.3)) { selectedTab = idx }
                } label: {
                    VStack(spacing: 6) {
                        Text(tab)
                            .font(.system(size: 15, weight: selectedTab == idx ? .semibold : .regular, design: .rounded))
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

    // MARK: Aprender

    var aprenderSection: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 14) {
                ForEach(GuiaContent.modules) { module in
                    NavigationLink(destination: ModuleDetailView(module: module)) {
                        ModuleCard(module: module, progress: progress)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                miedoVsRealidadCard
                    .padding(.top, 8)
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }

    var miedoVsRealidadCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 14))
                    .foregroundColor(BraverTheme.accent)
                Text("Miedo vs Realidad")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
            }

            HStack(alignment: .bottom, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("68%")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(BraverTheme.bravura)
                    Text("Tu cerebro exagera\nel peligro social")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                HStack(alignment: .bottom, spacing: 8) {
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(BraverTheme.danger.opacity(0.7))
                            .frame(width: 32, height: 88)
                        Text("Miedo")
                            .font(.system(size: 10, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                    }
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(BraverTheme.success.opacity(0.8))
                            .frame(width: 32, height: 88 * 0.32)
                        Text("Real")
                            .font(.system(size: 10, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                    }
                }
            }

            Divider().background(BraverTheme.surfaceBorder)

            Text("En promedio, la ansiedad real es un **68% menor** que la anticipada. Este número bajará con la práctica.")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(BraverTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(BraverTheme.cardPadding)
        .braverCard(elevated: true)
    }
}

// MARK: - Module Card

struct ModuleCard: View {
    let module: LearningModule
    @ObservedObject var progress: GuiaProgress

    var completedCount: Int { progress.completedCount(in: module) }
    var progressFraction: Double { Double(completedCount) / Double(module.lessonCount) }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(module.color.opacity(0.12))
                        .frame(width: 50, height: 50)
                    Image(systemName: module.symbol)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(module.color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(module.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .multilineTextAlignment(.leading)
                    Text(module.subtitle)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(BraverTheme.textTertiary)
            }

            // Progress bar
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(completedCount) de \(module.lessonCount) lecciones")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                    Spacer()
                    if completedCount == module.lessonCount {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 11))
                            Text("Completo")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(BraverTheme.success)
                    }
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.06))
                            .frame(height: 3)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(module.color)
                            .frame(width: geo.size.width * progressFraction, height: 3)
                            .animation(.spring(response: 0.4), value: progressFraction)
                    }
                }
                .frame(height: 3)
            }
        }
        .padding(BraverTheme.cardPadding)
        .background(BraverTheme.surfaceElevated)
        .cornerRadius(BraverTheme.radiusMedium)
    }
}

// MARK: - Module Detail View

struct ModuleDetailView: View {
    let module: LearningModule
    @StateObject private var progress = GuiaProgress.shared

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Module header
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(module.color.opacity(0.12))
                                .frame(width: 60, height: 60)
                            Image(systemName: module.symbol)
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(module.color)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(module.title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(BraverTheme.textPrimary)
                            Text(module.subtitle)
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(BraverTheme.textSecondary)
                        }
                    }
                    .padding(BraverTheme.cardPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(module.color.opacity(0.08))
                    .cornerRadius(BraverTheme.radiusMedium)
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)

                // Lessons
                VStack(spacing: 10) {
                    ForEach(module.lessons) { lesson in
                        NavigationLink(destination: LessonDetailView(lesson: lesson, moduleColor: module.color)) {
                            LessonRow(lesson: lesson, color: module.color, isCompleted: progress.isCompleted(lesson.id))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
        .background(BraverTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(module.title)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Lesson Row

struct LessonRow: View {
    let lesson: Lesson
    let color: Color
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(isCompleted ? color.opacity(0.2) : BraverTheme.surfaceElevated)
                    .frame(width: 38, height: 38)
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(color)
                } else {
                    Text("\(lesson.number)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(lesson.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                Text("Lección \(lesson.number)")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(BraverTheme.textTertiary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(BraverTheme.textTertiary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .braverCard(elevated: true)
    }
}

// MARK: - Lesson Detail View

struct LessonDetailView: View {
    let lesson: Lesson
    let moduleColor: Color
    @StateObject private var progress = GuiaProgress.shared
    @Environment(\.dismiss) private var dismiss

    var isCompleted: Bool { progress.isCompleted(lesson.id) }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                // Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Lección \(lesson.number)")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(moduleColor)
                    Text(lesson.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Body text
                Text(lesson.body)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)

                // Key insight
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 13))
                            .foregroundColor(moduleColor)
                        Text("Idea clave")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(moduleColor)
                    }
                    Text(lesson.keyInsight)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                        .lineSpacing(4)
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

                // Science fact
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "flask.fill")
                            .font(.system(size: 12))
                            .foregroundColor(BraverTheme.warning)
                        Text("Respaldo científico")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.warning)
                    }
                    Text(lesson.scienceFact)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(BraverTheme.cardPadding)
                .braverCard(elevated: true)

                // Mark complete button
                if isCompleted {
                    Label("Lección completada", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(BraverTheme.success)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(BraverTheme.success.opacity(0.1))
                        .cornerRadius(BraverTheme.radiusPill)
                } else if progress.hasCompletedLessonToday {
                    VStack(spacing: 8) {
                        Label("Vuelve mañana", systemImage: "moon.zzz.fill")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusPill)
                        Text("Solo 1 lección por día. Vuelve mañana para continuar.")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(BraverTheme.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    Button {
                        progress.markCompleted(lesson.id)
                    } label: {
                        Label("Marcar como leída", systemImage: "checkmark.circle")
                    }
                    .buttonStyle(BraverPrimaryButton(color: moduleColor))
                }
                Spacer().frame(height: 4)
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.top, 20)
            .padding(.bottom, 60)
        }
        .background(BraverTheme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Nova Chat View

struct NovaView: View {
    @StateObject private var service = NovaService.shared
    @State private var messages: [NovaMessage] = []
    @State private var inputText = ""
    @State private var errorText: String? = nil
    @FocusState private var isInputFocused: Bool

    let suggestions = [
        "Me da miedo hablar en público",
        "¿Cómo hago una llamada difícil?",
        "Acabo de evitar una situación",
        "No sé por dónde empezar"
    ]

    var body: some View {
        VStack(spacing: 0) {
            if messages.isEmpty {
                emptyState
            } else {
                chatList
            }

            inputBar
        }
    }

    // MARK: Empty state

    var emptyState: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                Spacer(minLength: 30)

                VStack(spacing: 12) {
                    Text("✨")
                        .font(.system(size: 48))
                    Text("Hola, soy Nova")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                    Text("Tu asistente para la ansiedad social.\nCuéntame qué te preocupa ahora mismo.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Temas frecuentes")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                        .padding(.horizontal, BraverTheme.screenPadding)

                    ForEach(suggestions, id: \.self) { suggestion in
                        Button {
                            sendMessage(suggestion)
                        } label: {
                            HStack {
                                Text(suggestion)
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(BraverTheme.textPrimary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(BraverTheme.textTertiary)
                            }
                            .padding(.horizontal, BraverTheme.cardPadding)
                            .padding(.vertical, 14)
                            .braverCard(elevated: true)
                            .padding(.horizontal, BraverTheme.screenPadding)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: Chat list

    var chatList: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                            .id(message.id)
                    }
                    if service.isLoading {
                        HStack(spacing: 8) {
                            Text("✨")
                                .font(.system(size: 20))
                            ProgressView()
                                .tint(BraverTheme.accent)
                            Spacer()
                        }
                        .padding(.horizontal, BraverTheme.screenPadding)
                        .id("loading")
                    }
                    if let error = errorText {
                        Text(error)
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(BraverTheme.warning)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, BraverTheme.screenPadding)
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 16)
            }
            .onChange(of: messages.count) { _ in
                withAnimation {
                    proxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
            .onChange(of: service.isLoading) { loading in
                if loading {
                    withAnimation { proxy.scrollTo("loading", anchor: .bottom) }
                }
            }
        }
    }

    // MARK: Input bar

    var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Escribe aquí...", text: $inputText)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(BraverTheme.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .background(BraverTheme.surfaceElevated)
                .cornerRadius(BraverTheme.radiusPill)
                .focused($isInputFocused)

            Button {
                sendMessage(inputText)
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(inputText.isEmpty ? BraverTheme.textTertiary : BraverTheme.accent)
            }
            .disabled(inputText.isEmpty)
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.vertical, 12)
        .background(BraverTheme.background)
        .overlay(
            Rectangle()
                .fill(BraverTheme.surfaceBorder)
                .frame(height: 1),
            alignment: .top
        )
    }

    // MARK: Logic

    func sendMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard !service.isLoading else { return }
        let userMsg = NovaMessage(text: text, isUser: true)
        withAnimation { messages.append(userMsg) }
        inputText = ""
        isInputFocused = false
        errorText = nil

        Task {
            do {
                let reply = try await service.send(history: messages, userText: text)
                let novaMsg = NovaMessage(text: reply, isUser: false)
                withAnimation { messages.append(novaMsg) }
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
}

// MARK: - Chat Bubble

struct ChatBubble: View {
    let message: NovaMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser { Spacer(minLength: 60) }

            if !message.isUser {
                Text("✨")
                    .font(.system(size: 20))
                    .frame(width: 32, height: 32)
                    .background(BraverTheme.accent.opacity(0.12))
                    .clipShape(Circle())
            }

            Text(message.text)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(message.isUser ? .white : BraverTheme.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(message.isUser ? BraverTheme.accent : BraverTheme.surfaceElevated)
                .cornerRadius(18)
                .cornerRadius(message.isUser ? 4 : 18, corners: message.isUser ? .bottomRight : .bottomLeft)
                .fixedSize(horizontal: false, vertical: true)

            if !message.isUser { Spacer(minLength: 60) }
        }
    }
}

// MARK: - Corner radius helper

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Nova Responses

enum NovaResponse {

    static func generate(for input: String) -> String {
        let lower = input.lowercased()

        if lower.contains("llamada") || lower.contains("teléfono") || lower.contains("telefono") {
            return "Las llamadas son uno de los retos más comunes. Recuerda: la persona que responde no puede verte, solo te oye 90 segundos. Antes de marcar, haz 4 respiraciones lentas. Escribe la primera frase que vas a decir, solo la primera. El resto fluye solo. ¿Quieres que repasemos juntos qué vas a decir?"
        }
        if lower.contains("público") || lower.contains("hablar") || lower.contains("grupo") {
            return "Hablar en público activa el mismo miedo que hablar con desconocidos, amplificado. Lo que más ayuda: recuerda que el público quiere que lo hagas bien. Nadie va a verte fracasar con placer. Haz una pausa antes de empezar. Respira. Habla más lento de lo que crees que deberías. ¿Es una presentación concreta lo que te preocupa?"
        }
        if lower.contains("evit") {
            return "Acabas de evitar algo, y eso genera alivio inmediato pero aumenta el miedo a largo plazo. Lo más útil ahora: no te juzgues. Pregúntate: ¿puedo hacer una versión más pequeña de lo que evité en las próximas 24 horas? Una versión mini que sí puedas hacer. La acción pequeña rompe el ciclo."
        }
        if lower.contains("miedo") || lower.contains("ansiedad") || lower.contains("nervios") {
            return "Lo que sientes es real y tiene sentido. Tu amígdala está intentando protegerte, aunque la amenaza sea social y no física. Una cosa concreta ahora: respira cuatro segundos, aguanta cuatro, exhala cuatro. Esto activa el nervio vago directamente. ¿Hay una situación específica que te está generando esto?"
        }
        if lower.contains("empezar") || lower.contains("por dónde") || lower.contains("donde") {
            return "El mejor punto de partida es siempre el más pequeño posible. No el más impresionante, el más pequeño. Elige una cosa que evites normalmente y hazla en su versión más fácil esta semana. Por ejemplo: si evitas saludar a desconocidos, empieza por darle los buenos días al cajero del supermercado. ¿Cuál es tu mayor área de evitación ahora mismo?"
        }
        if lower.contains("vergüenza") || lower.contains("ridículo") || lower.contains("juicio") {
            return "La vergüenza necesita audiencia. Y esa audiencia que temes existe mucho menos de lo que crees. El efecto spotlight está muy documentado: sobreestimamos enormemente cuánto nos observan y recuerdan. La mayoría de personas están pensando en sí mismas. ¿Qué situación concreta te genera esa sensación de estar siendo juzgado?"
        }
        if lower.contains("ligar") || lower.contains("cita") || lower.contains("romántico") || lower.contains("romantico") || lower.contains("atractiv") {
            return "El rechazo romántico duele porque evolutivamente tenía consecuencias reales. Pero hoy no las tiene. Lo peor que puede pasar es que tu día siga igual que antes de intentarlo. Lo que diferencia a las personas que consiguen lo que quieren en este área no es que no tengan miedo, es que actúan aunque lo tengan. ¿Hay una situación concreta que estás evitando?"
        }
        if lower.contains("trabajo") || lower.contains("jefe") || lower.contains("reunión") || lower.contains("reunion") {
            return "En el trabajo, el silencio se interpreta como falta de iniciativa o de ideas. Tu opinión tiene valor aunque no estés seguro al 100%. Una técnica útil: en la próxima reunión, comprométete a decir al menos una cosa. Solo una. No tiene que ser perfecta. La visibilidad se construye así, con pequeñas presencias repetidas."
        }

        // Default response
        let defaults = [
            "Cuéntame más. ¿En qué situación concreta aparece eso que describes?",
            "Entiendo. ¿Hace cuánto tiempo te limita esto de esa forma?",
            "Eso tiene mucho sentido. La ansiedad social funciona así para la mayoría de personas. ¿Cuál diría que es tu mayor área de evitación?",
            "Gracias por contarme. ¿Hay algún reto de la app que hayas probado ya relacionado con esto?"
        ]
        return defaults.randomElement()!
    }
}
