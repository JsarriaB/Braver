import Foundation
import Combine

// MARK: - Achievement Model

struct Achievement: Identifiable {
    let id: String
    let icon: String
    let title: String
    let description: String
    let category: AchievementCategory
    let isUnlocked: Bool
}

enum AchievementCategory: String {
    case racha      = "Racha"
    case retos      = "Retos"
    case dificultad = "Dificultad"
    case categorias = "Categorías"
    case momentos   = "Momentos"
}

// MARK: - Service

class AchievementsService: ObservableObject {

    static let shared = AchievementsService()
    private init() {}

    func achievements(
        streak: Int,
        attempts: [ChallengeAttempt],
        momentos: Int
    ) -> [Achievement] {

        let completed   = attempts.filter { $0.status == .completed }
        let totalCount  = completed.count
        let easyCount   = completed.filter { $0.difficultyRaw == "Fácil"    }.count
        let modCount    = completed.filter { $0.difficultyRaw == "Moderado" }.count
        let hardCount   = completed.filter { $0.difficultyRaw == "Difícil"  }.count
        let doneCategories = Set(completed.map { $0.category })
        let allCategories: Set<String> = ["Llamadas","Tiendas","Hablar en público","Ligar","Grupos","Trabajo","Conflictos","Conocer gente"]

        return [
            // MARK: Racha
            Achievement(id: "streak_3",  icon: "flame",          title: "3 días",        description: "3 días en racha",          category: .racha,      isUnlocked: streak >= 3),
            Achievement(id: "streak_7",  icon: "flame.fill",     title: "Una semana",    description: "7 días en racha",          category: .racha,      isUnlocked: streak >= 7),
            Achievement(id: "streak_14", icon: "calendar",       title: "Dos semanas",   description: "14 días en racha",         category: .racha,      isUnlocked: streak >= 14),
            Achievement(id: "streak_21", icon: "calendar.badge.checkmark", title: "21 días", description: "21 días en racha",    category: .racha,      isUnlocked: streak >= 21),
            Achievement(id: "streak_30", icon: "moon.stars.fill", title: "Un mes",       description: "30 días en racha",         category: .racha,      isUnlocked: streak >= 30),
            Achievement(id: "streak_60", icon: "star.fill",      title: "Dos meses",     description: "60 días en racha",         category: .racha,      isUnlocked: streak >= 60),
            Achievement(id: "streak_90", icon: "crown.fill",     title: "Braver",        description: "90 días — plan completo",  category: .racha,      isUnlocked: streak >= 90),

            // MARK: Retos totales
            Achievement(id: "retos_1",   icon: "checkmark.circle",      title: "Primer paso",   description: "Completa 1 reto",    category: .retos, isUnlocked: totalCount >= 1),
            Achievement(id: "retos_3",   icon: "checkmark.circle.fill", title: "En marcha",     description: "Completa 3 retos",   category: .retos, isUnlocked: totalCount >= 3),
            Achievement(id: "retos_5",   icon: "bolt.circle.fill",      title: "Momentum",      description: "Completa 5 retos",   category: .retos, isUnlocked: totalCount >= 5),
            Achievement(id: "retos_10",  icon: "trophy",                title: "Valiente",      description: "Completa 10 retos",  category: .retos, isUnlocked: totalCount >= 10),
            Achievement(id: "retos_20",  icon: "trophy.fill",           title: "Imparable",     description: "Completa 20 retos",  category: .retos, isUnlocked: totalCount >= 20),
            Achievement(id: "retos_30",  icon: "medal.fill",            title: "Veterano",      description: "Completa 30 retos",  category: .retos, isUnlocked: totalCount >= 30),

            // MARK: Dificultad — Fácil
            Achievement(id: "easy_1",  icon: "leaf",       title: "Primer calentamiento", description: "1 reto fácil completado",  category: .dificultad, isUnlocked: easyCount >= 1),
            Achievement(id: "easy_3",  icon: "leaf.fill",  title: "Calentando motores",   description: "3 retos fáciles",          category: .dificultad, isUnlocked: easyCount >= 3),
            Achievement(id: "easy_5",  icon: "wind",       title: "Base sólida",          description: "5 retos fáciles",          category: .dificultad, isUnlocked: easyCount >= 5),

            // MARK: Dificultad — Moderado
            Achievement(id: "mod_1",  icon: "flame",          title: "Subiendo el nivel",   description: "1 reto moderado completado", category: .dificultad, isUnlocked: modCount >= 1),
            Achievement(id: "mod_3",  icon: "flame.fill",     title: "Zona de trabajo",     description: "3 retos moderados",          category: .dificultad, isUnlocked: modCount >= 3),
            Achievement(id: "mod_5",  icon: "bolt",           title: "Zona de confort rota", description: "5 retos moderados",                   category: .dificultad, isUnlocked: modCount >= 5),

            // MARK: Dificultad — Difícil
            Achievement(id: "hard_1", icon: "bolt.fill",        title: "Audaz",     description: "1 reto difícil completado", category: .dificultad, isUnlocked: hardCount >= 1),
            Achievement(id: "hard_3", icon: "bolt.circle.fill", title: "Sin frenos", description: "3 retos difíciles",        category: .dificultad, isUnlocked: hardCount >= 3),
            Achievement(id: "hard_5", icon: "crown",           title: "Élite",              description: "5 retos difíciles",         category: .dificultad, isUnlocked: hardCount >= 5),

            // MARK: Categorías
            Achievement(id: "cat_llamadas",  icon: "phone.fill",         title: "Sin miedo al teléfono", description: "Reto de Llamadas completado",        category: .categorias, isUnlocked: doneCategories.contains("Llamadas")),
            Achievement(id: "cat_tiendas",   icon: "cart.fill",          title: "Comprador seguro",      description: "Reto de Tiendas completado",         category: .categorias, isUnlocked: doneCategories.contains("Tiendas")),
            Achievement(id: "cat_publico",   icon: "mic.fill",           title: "Toma la palabra",       description: "Reto de Hablar en público completado",category: .categorias, isUnlocked: doneCategories.contains("Hablar en público")),
            Achievement(id: "cat_ligar",     icon: "heart.fill",         title: "Corazón valiente",      description: "Reto de Ligar completado",           category: .categorias, isUnlocked: doneCategories.contains("Ligar")),
            Achievement(id: "cat_grupos",    icon: "person.3.fill",      title: "En el grupo",           description: "Reto de Grupos completado",          category: .categorias, isUnlocked: doneCategories.contains("Grupos")),
            Achievement(id: "cat_trabajo",   icon: "briefcase.fill",     title: "Profesional braver",    description: "Reto de Trabajo completado",         category: .categorias, isUnlocked: doneCategories.contains("Trabajo")),
            Achievement(id: "cat_conflicto", icon: "bolt.shield.fill",   title: "Gestión directa",       description: "Reto de Conflictos completado",      category: .categorias, isUnlocked: doneCategories.contains("Conflictos")),
            Achievement(id: "cat_conocer",   icon: "hand.wave.fill",     title: "Conexiones reales",     description: "Reto de Conocer gente completado",   category: .categorias, isUnlocked: doneCategories.contains("Conocer gente")),
            Achievement(id: "cat_all",       icon: "star.circle.fill",   title: "Todoterreno",           description: "Completa 1 reto de cada categoría",  category: .categorias, isUnlocked: allCategories.isSubset(of: doneCategories)),

            // MARK: Momentos Braver
            Achievement(id: "momento_1",  icon: "wind",             title: "Primer respiro",     description: "1 momento Braver",   category: .momentos, isUnlocked: momentos >= 1),
            Achievement(id: "momento_5",  icon: "lungs.fill",       title: "Ritmo propio",       description: "5 momentos Braver",  category: .momentos, isUnlocked: momentos >= 5),
            Achievement(id: "momento_10", icon: "waveform.path.ecg", title: "Maestro del aliento", description: "10 momentos Braver", category: .momentos, isUnlocked: momentos >= 10),
        ]
    }

    func grouped(
        streak: Int,
        attempts: [ChallengeAttempt],
        momentos: Int
    ) -> [(AchievementCategory, [Achievement])] {
        let all = achievements(streak: streak, attempts: attempts, momentos: momentos)
        let order: [AchievementCategory] = [.racha, .retos, .dificultad, .categorias, .momentos]
        return order.map { cat in
            (cat, all.filter { $0.category == cat })
        }
    }
}
