# Ajustes/Perfil Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Añadir pantalla de ajustes/perfil accesible desde el icono ⚙️ en HoyView, con secciones de perfil, preferencias de retos, notificaciones, suscripción, legal y datos.

**Architecture:** Sheet modal presentado desde HoyView. Vista nueva `AjustesView.swift` autocontenida. Las preferencias de categorías se persisten en UserDefaults y se aplican en `ChallengeLibrary.todaysChallenges`. Las horas de notificaciones reprograman las notificaciones existentes.

**Tech Stack:** SwiftUI, UserDefaults, UNUserNotificationCenter, SuperwallKit

---

### Task 1: Añadir icono ⚙️ en HoyView

**Files:**
- Modify: `Braver/HoyView.swift` — header section

**Step 1: Añadir state y sheet**

En `HoyView`, añadir:
```swift
@State private var showAjustes = false
```

Y al final del body (después del `.sheet(isPresented: $showPledge)`):
```swift
.sheet(isPresented: $showAjustes) {
    AjustesView()
}
```

**Step 2: Añadir icono en headerSection**

Modificar `headerSection` — después de `streakBadge`, añadir:
```swift
Button {
    showAjustes = true
} label: {
    Image(systemName: "gearshape.fill")
        .font(.system(size: 18))
        .foregroundColor(BraverTheme.textTertiary)
        .padding(10)
        .background(BraverTheme.surfaceElevated)
        .clipShape(Circle())
}
```

**Step 3: Commit**
```bash
git add Braver/HoyView.swift
git commit -m "feat: add settings gear icon to HoyView header"
```

---

### Task 2: Crear AjustesView.swift — estructura base y sección Perfil

**Files:**
- Create: `Braver/AjustesView.swift`

**Step 1: Crear el fichero con estructura base**

```swift
import SwiftUI
import SuperwallKit

struct AjustesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userName = UserDefaults.standard.string(forKey: "braver_user_name") ?? ""

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
}
```

**Step 2: Añadir sección Perfil**

```swift
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
```

**Step 3: Commit**
```bash
git add Braver/AjustesView.swift
git commit -m "feat: create AjustesView with profile section"
```

---

### Task 3: Sección Mis Retos (categorías favorita y excluidas)

**Files:**
- Modify: `Braver/AjustesView.swift`

Las categorías disponibles son las de `SituationCategory` en BraverModels.swift:
Llamadas, Tiendas, Grupos, Citas, Trabajo, Conocer gente, Conflictos, Otro

**Step 1: Añadir states**

```swift
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
```

**Step 2: Añadir sección retosSection**

```swift
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
                        .opacity(!isExcluded && excludedCategories.count >= 3 ? 0.4 : 1)
                    }
                    .disabled(!isExcluded && excludedCategories.count >= 3)
                }
            }
        }
        .padding(BraverTheme.cardPadding)
        .braverCard(elevated: true)
    }
}
```

**Step 3: Commit**
```bash
git add Braver/AjustesView.swift
git commit -m "feat: add challenge category preferences to AjustesView"
```

---

### Task 4: Aplicar preferencias de categorías en ChallengeLibrary

**Files:**
- Modify: `Braver/ChallengeLibrary.swift` — función `todaysChallenges`

**Step 1: Modificar todaysChallenges para leer preferencias**

```swift
static func todaysChallenges(orbDays: Int, seen: [String] = []) -> [DailyChallenge] {
    let favoriteCategory = UserDefaults.standard.string(forKey: "braver_favorite_category") ?? ""
    let excludedCategories: [String] = {
        guard let data = UserDefaults.standard.data(forKey: "braver_excluded_categories"),
              let arr = try? JSONDecoder().decode([String].self, from: data) else { return [] }
        return arr
    }()

    var pool = poolForDays(orbDays)

    // Filtrar excluidas
    if !excludedCategories.isEmpty {
        let filtered = pool.filter { !excludedCategories.contains($0.category) }
        if !filtered.isEmpty { pool = filtered }
    }

    // Priorizar favorita (40% del pool si existe)
    if !favoriteCategory.isEmpty {
        let favPool = pool.filter { $0.category == favoriteCategory }
        let restPool = pool.filter { $0.category != favoriteCategory }
        if !favPool.isEmpty {
            pool = Array(favPool.shuffled().prefix(max(1, pool.count * 2 / 5))) + restPool
        }
    }

    let available = pool.filter { !seen.contains($0.id) }
    let source = available.isEmpty ? pool : available
    let shuffled = source.shuffled()
    guard shuffled.count >= 2 else { return shuffled }
    return Array(shuffled.prefix(2))
}
```

**Step 2: Commit**
```bash
git add Braver/ChallengeLibrary.swift
git commit -m "feat: apply category preferences to daily challenge selection"
```

---

### Task 5: Sección Notificaciones con horas configurables

**Files:**
- Modify: `Braver/AjustesView.swift`
- Modify: `Braver/NotificationService.swift`

**Step 1: Actualizar NotificationService para horas configurables**

Añadir al enum NotificationService:
```swift
static func scheduleMorningAt(hour: Int, minute: Int) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["braver_morning"])
    let content = UNMutableNotificationContent()
    content.title = "Tu misión de hoy te espera 💪"
    content.body = "Abre Braver y acepta el reto del día."
    content.sound = .default
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    center.add(UNNotificationRequest(identifier: "braver_morning", content: content, trigger: trigger))
}

static func scheduleEveningAt(hour: Int, minute: Int) {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["braver_evening"])
    let content = UNMutableNotificationContent()
    content.title = "¿Cómo fue tu día? 🌙"
    content.body = "Tómate un momento para registrar cómo te fue."
    content.sound = .default
    var components = DateComponents()
    components.hour = hour
    components.minute = minute
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    center.add(UNNotificationRequest(identifier: "braver_evening", content: content, trigger: trigger))
}
```

**Step 2: Añadir notificacionesSection en AjustesView**

```swift
@State private var notificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "braver_notifications_enabled")
@State private var morningTime: Date = {
    let h = UserDefaults.standard.integer(forKey: "braver_morning_hour").nonZero(default: 9)
    let m = UserDefaults.standard.integer(forKey: "braver_morning_minute")
    return Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: Date()) ?? Date()
}()
@State private var eveningTime: Date = {
    let h = UserDefaults.standard.integer(forKey: "braver_evening_hour").nonZero(default: 20)
    let m = UserDefaults.standard.integer(forKey: "braver_evening_minute")
    return Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: Date()) ?? Date()
}()
```

Nota: como Int no tiene `.nonZero`, usar directamente:
```swift
let h = UserDefaults.standard.object(forKey: "braver_morning_hour") as? Int ?? 9
```

```swift
var notificacionesSection: some View {
    VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
        SectionHeader(title: "Notificaciones")
        VStack(spacing: 0) {
            // Toggle general
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

                // Mañana
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

                // Noche
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
```

**Step 3: Commit**
```bash
git add Braver/AjustesView.swift Braver/NotificationService.swift
git commit -m "feat: configurable notification times in settings"
```

---

### Task 6: Secciones Suscripción, Legal y App

**Files:**
- Modify: `Braver/AjustesView.swift`

**Step 1: Añadir suscripcionSection**

```swift
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
```

**Step 2: Añadir legalSection**

```swift
var legalSection: some View {
    VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
        SectionHeader(title: "Legal")
        VStack(spacing: 0) {
            legalRow(title: "Política de privacidad", icon: "hand.raised.fill", url: "https://placeholder.braver.app/privacy")
            Divider().background(BraverTheme.surfaceBorder)
            legalRow(title: "Términos y condiciones", icon: "doc.text.fill", url: "https://placeholder.braver.app/terms")
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
```

**Step 3: Añadir appSection con versión y borrar datos**

```swift
@State private var showDeleteConfirm = false

var appSection: some View {
    VStack(alignment: .leading, spacing: BraverTheme.itemSpacing) {
        SectionHeader(title: "App")
        VStack(spacing: 0) {
            // Versión
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

            // Borrar datos
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
```

**Step 4: Commit**
```bash
git add Braver/AjustesView.swift
git commit -m "feat: complete AjustesView with subscription, legal and app sections"
```

---

## Verificación final

1. Ejecutar en simulador
2. Abrir tab Hoy → verificar icono ⚙️ visible en header
3. Tocar ⚙️ → sheet abre correctamente
4. Cambiar nombre → cierra sheet → saludo actualizado en header
5. Seleccionar categoría favorita → relanzar app → reto de hoy es de esa categoría
6. Excluir 3 categorías → verificar que no aparecen en retos
7. Activar/desactivar notificaciones → cambiar hora → verificar en Settings del sistema
8. Tocar Privacy Policy → Safari abre placeholder URL
9. Tocar Eliminar datos → confirmar → app vuelve a onboarding
