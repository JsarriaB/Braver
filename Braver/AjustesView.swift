import SwiftUI
import UserNotifications
import SuperwallKit

struct AjustesView: View {
    @Environment(\.dismiss) private var dismiss

    // MARK: - Perfil
    @State private var userName = UserDefaults.standard.string(forKey: "braver_user_name") ?? ""

    // MARK: - Retos
    @State private var favoriteCategory: String = UserDefaults.standard.string(forKey: "braver_favorite_category") ?? ""
    @State private var excludedCategories: [String] = {
        guard let data = UserDefaults.standard.data(forKey: "braver_excluded_categories"),
              let arr = try? JSONDecoder().decode([String].self, from: data) else { return [] }
        return arr
    }()
    let allCategories: [(String, String)] = [
        ("Llamadas", "📞"), ("Tiendas", "🛍️"), ("Grupos", "👥"),
        ("Citas", "💬"), ("Trabajo", "💼"), ("Conocer gente", "🤝"),
        ("Conflictos", "⚡"), ("Otro", "🎯")
    ]

    // MARK: - Notificaciones
    @State private var notificationsEnabled: Bool = {
        if UserDefaults.standard.object(forKey: "braver_notifications_enabled") == nil { return true }
        return UserDefaults.standard.bool(forKey: "braver_notifications_enabled")
    }()
    @State private var morningTime: Date = {
        let h = UserDefaults.standard.object(forKey: "braver_morning_hour") as? Int ?? 9
        let m = UserDefaults.standard.object(forKey: "braver_morning_minute") as? Int ?? 0
        return Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: Date()) ?? Date()
    }()
    @State private var eveningTime: Date = {
        let h = UserDefaults.standard.object(forKey: "braver_evening_hour") as? Int ?? 20
        let m = UserDefaults.standard.object(forKey: "braver_evening_minute") as? Int ?? 0
        return Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: Date()) ?? Date()
    }()

    // MARK: - App
    @State private var showDeleteConfirm = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: BraverTheme.sectionSpacing) {
                    perfilSection
                    retosSection
                    notificacionesSection
                    suscripcionSection
                    legalSection
                    appSection
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 60)
            }
            .background(BraverTheme.background.ignoresSafeArea())
            .navigationTitle("Ajustes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(BraverTheme.textTertiary)
                            .font(.system(size: 20))
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Perfil

    var perfilSection: some View {
        VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
            SectionHeader(title: "Perfil")
            VStack(alignment: .leading, spacing: 12) {
                Text("Tu nombre")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                TextField("¿Cómo te llamas?", text: $userName)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                    .padding(14)
                    .background(BraverTheme.surfaceElevated)
                    .cornerRadius(BraverTheme.radiusSmall)
                    .onChange(of: userName) { _, newValue in
                        UserDefaults.standard.set(newValue, forKey: "braver_user_name")
                    }
            }
            .padding(BraverTheme.cardPadding)
            .braverCard(elevated: true)
        }
    }

    // MARK: - Retos

    var retosSection: some View {
        VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
            SectionHeader(title: "Mis Retos")

            // Favorita
            VStack(alignment: .leading, spacing: 10) {
                Text("Quiero trabajar más en...")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.textSecondary)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(allCategories, id: \.0) { cat, emoji in
                        let isSelected = favoriteCategory == cat
                        Button {
                            favoriteCategory = isSelected ? "" : cat
                            UserDefaults.standard.set(favoriteCategory, forKey: "braver_favorite_category")
                        } label: {
                            HStack(spacing: 6) {
                                Text(emoji).font(.system(size: 14))
                                Text(cat)
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(isSelected ? .white : BraverTheme.textSecondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(isSelected ? BraverTheme.accent : BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusSmall)
                        }
                    }
                }
            }
            .padding(BraverTheme.cardPadding)
            .braverCard(elevated: true)

            // Excluidas (max 3)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("No quiero ver retos de...")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                    Spacer()
                    Text("\(excludedCategories.count)/3")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                }
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(allCategories, id: \.0) { cat, emoji in
                        let isExcluded = excludedCategories.contains(cat)
                        let isDisabled = !isExcluded && excludedCategories.count >= 3
                        Button {
                            if isExcluded {
                                excludedCategories.removeAll { $0 == cat }
                            } else if excludedCategories.count < 3 {
                                excludedCategories.append(cat)
                            }
                            if let data = try? JSONEncoder().encode(excludedCategories) {
                                UserDefaults.standard.set(data, forKey: "braver_excluded_categories")
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text(emoji).font(.system(size: 14))
                                Text(cat)
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(isExcluded ? .white : BraverTheme.textSecondary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                Spacer()
                                if isExcluded {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(isExcluded ? BraverTheme.danger.opacity(0.8) : BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusSmall)
                            .opacity(isDisabled ? 0.4 : 1)
                        }
                        .disabled(isDisabled)
                    }
                }
            }
            .padding(BraverTheme.cardPadding)
            .braverCard(elevated: true)
        }
    }

    // MARK: - Notificaciones

    var notificacionesSection: some View {
        VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
            SectionHeader(title: "Notificaciones")
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundColor(BraverTheme.accent)
                        .frame(width: 28)
                    Text("Activar notificaciones")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                    Spacer()
                    Toggle("", isOn: $notificationsEnabled)
                        .tint(BraverTheme.accent)
                        .onChange(of: notificationsEnabled) { _, enabled in
                            UserDefaults.standard.set(enabled, forKey: "braver_notifications_enabled")
                            if enabled {
                                NotificationService.requestAndSchedule()
                            } else {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            }
                        }
                }
                .padding(BraverTheme.cardPadding)

                if notificationsEnabled {
                    Divider().background(BraverTheme.surfaceBorder)

                    HStack {
                        Image(systemName: "sunrise.fill")
                            .foregroundColor(BraverTheme.warning)
                            .frame(width: 28)
                        Text("Recordatorio mañana")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Spacer()
                        DatePicker("", selection: $morningTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .onChange(of: morningTime) { _, t in
                                let h = Calendar.current.component(.hour, from: t)
                                let m = Calendar.current.component(.minute, from: t)
                                UserDefaults.standard.set(h, forKey: "braver_morning_hour")
                                UserDefaults.standard.set(m, forKey: "braver_morning_minute")
                                NotificationService.scheduleMorningAt(hour: h, minute: m)
                            }
                    }
                    .padding(BraverTheme.cardPadding)

                    Divider().background(BraverTheme.surfaceBorder)

                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(BraverTheme.accent)
                            .frame(width: 28)
                        Text("Check-in noche")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Spacer()
                        DatePicker("", selection: $eveningTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .colorScheme(.dark)
                            .onChange(of: eveningTime) { _, t in
                                let h = Calendar.current.component(.hour, from: t)
                                let m = Calendar.current.component(.minute, from: t)
                                UserDefaults.standard.set(h, forKey: "braver_evening_hour")
                                UserDefaults.standard.set(m, forKey: "braver_evening_minute")
                                NotificationService.scheduleEveningAt(hour: h, minute: m)
                            }
                    }
                    .padding(BraverTheme.cardPadding)
                }
            }
            .braverCard(elevated: true)
        }
    }

    // MARK: - Suscripción

    var suscripcionSection: some View {
        VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
            SectionHeader(title: "Suscripción")
            Button {
                Superwall.shared.register(placement: "campaign_trigger")
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(BraverTheme.accent.opacity(0.15))
                            .frame(width: 40, height: 40)
                        Image(systemName: "crown.fill")
                            .font(.system(size: 18))
                            .foregroundColor(BraverTheme.accent)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Braver Pro")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Text("Ver planes y gestionar suscripción")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(BraverTheme.textTertiary)
                }
                .padding(BraverTheme.cardPadding)
                .braverCard(elevated: true)
            }
        }
    }

    // MARK: - Legal

    var legalSection: some View {
        VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
            SectionHeader(title: "Legal")
            VStack(spacing: 0) {
                legalRow(title: "Política de privacidad", icon: "hand.raised.fill", url: "https://jsarriab.github.io/Braver/docs/privacy-policy")
                Divider().background(BraverTheme.surfaceBorder)
                legalRow(title: "Términos y condiciones", icon: "doc.text.fill", url: "https://jsarriab.github.io/Braver/docs/terms-and-conditions")
            }
            .braverCard(elevated: true)
        }
    }

    private func legalRow(title: String, icon: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundColor(BraverTheme.textTertiary)
                    .frame(width: 28)
                Text(title)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12))
                    .foregroundColor(BraverTheme.textTertiary)
            }
            .padding(BraverTheme.cardPadding)
        }
    }

    // MARK: - App

    var appSection: some View {
        VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
            SectionHeader(title: "App")
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(BraverTheme.textTertiary)
                        .frame(width: 28)
                    Text("Versión")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(BraverTheme.textPrimary)
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                }
                .padding(BraverTheme.cardPadding)

                Divider().background(BraverTheme.surfaceBorder)

                Button {
                    showDeleteConfirm = true
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(BraverTheme.danger)
                            .frame(width: 28)
                        Text("Eliminar todos mis datos")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(BraverTheme.danger)
                        Spacer()
                    }
                    .padding(BraverTheme.cardPadding)
                }
                .confirmationDialog("¿Eliminar todos los datos?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                    Button("Eliminar", role: .destructive) {
                        let keys = ["braver_user_name", "braver_user_age", "braver_onboarding_completed",
                                    "braver_notifications_enabled", "braver_morning_hour", "braver_morning_minute",
                                    "braver_evening_hour", "braver_evening_minute", "braver_favorite_category",
                                    "braver_excluded_categories", "braver_challenge_accepted_date",
                                    "braver_challenge_recorded_date", "braver_todays_challenge_ids",
                                    "braver_todays_challenge_date"]
                        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
                        dismiss()
                    }
                    Button("Cancelar", role: .cancel) {}
                } message: {
                    Text("Esta acción no se puede deshacer. Se borrarán tu progreso, retos y configuración.")
                }
            }
            .braverCard(elevated: true)
        }
    }
}
