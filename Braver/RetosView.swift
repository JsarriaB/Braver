import SwiftUI

struct RetosView: View {
    @StateObject private var historyService = ChallengeHistoryService.shared
    @State private var selectedTab = 0          // 0 = Historial, 1 = Biblioteca
    @State private var selectedCategory: String? = nil

    let categories = ["Llamadas", "Tiendas", "Hablar en público", "Ligar", "Grupos", "Trabajo", "Conflictos", "Conocer gente"]

    var filteredChallenges: [DailyChallenge] {
        guard let cat = selectedCategory else { return ChallengeLibrary.all }
        return ChallengeLibrary.all.filter { $0.category == cat }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerSection
                tabPicker
                Divider().background(BraverTheme.surfaceBorder.opacity(0.4))

                ScrollView(showsIndicators: false) {
                    if selectedTab == 0 {
                        historialSection
                    } else {
                        bibliotecaSection
                    }
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
                Text("Retos")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Text(selectedTab == 0 ? "Tu historial de intentos" : "\(ChallengeLibrary.all.count) retos disponibles")
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
            ForEach(["Historial", "Biblioteca"], id: \.self) { tab in
                let idx = tab == "Historial" ? 0 : 1
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

    // MARK: Historial

    var historialSection: some View {
        VStack(spacing: 10) {
            if historyService.attempts.isEmpty {
                emptyHistorial
            } else {
                ForEach(historyService.attempts) { attempt in
                    AttemptRow(attempt: attempt)
                }
            }
        }
        .padding(.horizontal, BraverTheme.screenPadding)
        .padding(.top, 16)
        .padding(.bottom, 100)
    }

    var emptyHistorial: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 40))
                .foregroundColor(BraverTheme.textTertiary)
                .padding(.top, 60)
            Text("Aquí aparecerán tus intentos")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(BraverTheme.textPrimary)
            Text("Acepta y completa (o intenta) la misión de hoy\ndesde el tab Hoy para verlo aquí.")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(BraverTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }

    // MARK: Biblioteca

    var bibliotecaSection: some View {
        VStack(spacing: 0) {
            // Filtros de categoría
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    categoryChip(label: "Todos", selected: selectedCategory == nil) {
                        selectedCategory = nil
                    }
                    ForEach(categories, id: \.self) { cat in
                        categoryChip(label: cat, selected: selectedCategory == cat) {
                            selectedCategory = selectedCategory == cat ? nil : cat
                        }
                    }
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.vertical, 12)
            }

            // Lista de retos
            VStack(spacing: 8) {
                ForEach(filteredChallenges) { challenge in
                    BibliotecaRow(
                        challenge: challenge,
                        alreadyDone: historyService.attempts.contains { $0.challengeId == challenge.id && $0.status == .completed }
                    )
                }
            }
            .padding(.horizontal, BraverTheme.screenPadding)
            .padding(.bottom, 100)
        }
    }

    func categoryChip(label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: selected ? .semibold : .regular, design: .rounded))
                .foregroundColor(selected ? .white : BraverTheme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(selected ? BraverTheme.accent : BraverTheme.surfaceElevated)
                .cornerRadius(BraverTheme.radiusPill)
                .overlay(
                    RoundedRectangle(cornerRadius: BraverTheme.radiusPill)
                        .stroke(selected ? Color.clear : BraverTheme.surfaceBorder, lineWidth: 1)
                )
        }
        .animation(.spring(response: 0.2), value: selected)
    }
}

// MARK: - Fila de intento (Historial)

struct AttemptRow: View {
    let attempt: ChallengeAttempt

    var body: some View {
        HStack(spacing: 14) {
            // Icono estado
            ZStack {
                Circle()
                    .fill(iconBg)
                    .frame(width: 38, height: 38)
                Image(systemName: attempt.status == .completed ? "checkmark" : "arrow.counterclockwise")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(attempt.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                    .lineLimit(2)
                HStack(spacing: 6) {
                    Text(attempt.categoryEmoji)
                        .font(.system(size: 11))
                    Text(attempt.category)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                    Text("·")
                        .foregroundColor(BraverTheme.textTertiary)
                    Text(formattedDate)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                }
            }

            Spacer()

            // Badge dificultad
            Text(attempt.difficultyRaw)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(difficultyColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(difficultyColor.opacity(0.12))
                .cornerRadius(BraverTheme.radiusPill)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .braverCard(elevated: true)
    }

    var iconColor: Color {
        attempt.status == .completed ? BraverTheme.success : BraverTheme.warning
    }

    var iconBg: Color {
        attempt.status == .completed ? BraverTheme.success.opacity(0.12) : BraverTheme.warning.opacity(0.12)
    }

    var difficultyColor: Color {
        switch attempt.difficultyRaw {
        case "Fácil":    return Color(hex: "10B981")
        case "Moderado": return Color(hex: "F59E0B")
        default:         return Color(hex: "EF4444")
        }
    }

    var formattedDate: String {
        let cal = Calendar.current
        if cal.isDateInToday(attempt.date) { return "Hoy" }
        if cal.isDateInYesterday(attempt.date) { return "Ayer" }
        let fmt = DateFormatter()
        fmt.dateFormat = "d MMM"
        fmt.locale = Locale(identifier: "es_ES")
        return fmt.string(from: attempt.date)
    }
}

// MARK: - Fila de reto (Biblioteca)

struct BibliotecaRow: View {
    let challenge: DailyChallenge
    let alreadyDone: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(challenge.categoryEmoji)
                .font(.system(size: 22))
                .frame(width: 40, height: 40)
                .background(BraverTheme.surfaceElevated)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(challenge.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                    .lineLimit(2)
                Text(challenge.category)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(BraverTheme.textTertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(challenge.difficulty.rawValue)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(challenge.difficulty.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(challenge.difficulty.color.opacity(0.12))
                    .cornerRadius(BraverTheme.radiusPill)

                if alreadyDone {
                    HStack(spacing: 3) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                        Text("Hecho")
                            .font(.system(size: 10, design: .rounded))
                    }
                    .foregroundColor(BraverTheme.success.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .braverCard(elevated: true)
        .opacity(alreadyDone ? 0.7 : 1)
    }
}
