import Foundation
import SwiftData

// MARK: - Enums

enum SituationCategory: String, Codable, CaseIterable {
    case llamadas     = "Llamadas"
    case tiendas      = "Tiendas"
    case grupos       = "Grupos"
    case citas        = "Citas"
    case trabajo      = "Trabajo"
    case conocerGente = "Conocer gente"
    case conflictos   = "Conflictos"
    case otro         = "Otro"

    var emoji: String {
        switch self {
        case .llamadas:     return "📞"
        case .tiendas:      return "🛍️"
        case .grupos:       return "👥"
        case .citas:        return "💬"
        case .trabajo:      return "💼"
        case .conocerGente: return "🤝"
        case .conflictos:   return "⚡"
        case .otro:         return "🎯"
        }
    }
}

enum RetoStatus: String, Codable {
    case active   = "active"
    case dominado = "dominado"
    case paused   = "paused"
}

enum VariantLevel: String, Codable {
    case suave    = "suave"
    case estandar = "estandar"
    case valiente = "valiente"

    var label: String {
        switch self {
        case .suave:    return "Suave"
        case .estandar: return "Estándar"
        case .valiente: return "Valiente"
        }
    }

    var sfSymbol: String {
        switch self {
        case .suave:    return "leaf.fill"
        case .estandar: return "flame.fill"
        case .valiente: return "bolt.fill"
        }
    }
}

enum CompletionType: String, Codable {
    case completed = "completed"
    case attempted = "attempted"
    case skipped   = "skipped"

    var label: String {
        switch self {
        case .completed: return "Completado"
        case .attempted: return "Intentado"
        case .skipped:   return "Evitado"
        }
    }
}

enum MomentoType: String, Codable {
    case preSituation = "pre_situation"
    case midPanic     = "mid_panic"
}

enum DayStatus: String, Codable {
    case completed = "completed"
    case attempted = "attempted"
    case skipped   = "skipped"
    case noEntry   = "no_entry"
}

// MARK: - SwiftData Models

@Model
class UserProfile {
    var id: UUID
    var name: String
    var createdAt: Date
    var currentStreak: Int
    var longestStreak: Int
    var lastEngagementDate: Date?
    var totalMomentosDeValor: Int
    var onboardingCompleted: Bool

    init(name: String = "") {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.currentStreak = 0
        self.longestStreak = 0
        self.totalMomentosDeValor = 0
        self.onboardingCompleted = false
    }
}

@Model
class Reto {
    var id: UUID
    var title: String
    var categoryRaw: String
    var baseSUDS: Int
    var statusRaw: String
    var fearedOutcome: String
    var aiReframe: String?
    var createdAt: Date
    var dominatedAt: Date?

    @Relationship(deleteRule: .cascade) var variants: [RetoVariant] = []

    var category: SituationCategory {
        get { SituationCategory(rawValue: categoryRaw) ?? .otro }
        set { categoryRaw = newValue.rawValue }
    }

    var status: RetoStatus {
        get { RetoStatus(rawValue: statusRaw) ?? .active }
        set { statusRaw = newValue.rawValue }
    }

    var activeVariant: RetoVariant? {
        variants
            .filter { $0.isUnlocked && !$0.isDominado }
            .sorted { a, b in
                let order: [VariantLevel] = [.suave, .estandar, .valiente]
                let ai = order.firstIndex(of: a.level) ?? 0
                let bi = order.firstIndex(of: b.level) ?? 0
                return ai < bi
            }
            .first
    }

    init(title: String, category: SituationCategory, baseSUDS: Int, fearedOutcome: String = "") {
        self.id = UUID()
        self.title = title
        self.categoryRaw = category.rawValue
        self.baseSUDS = baseSUDS
        self.statusRaw = RetoStatus.active.rawValue
        self.fearedOutcome = fearedOutcome
        self.createdAt = Date()
    }
}

@Model
class RetoVariant {
    var id: UUID
    var title: String
    var targetSUDS: Int
    var levelRaw: String
    var completionCount: Int
    var isUnlocked: Bool
    var isDominado: Bool

    @Relationship(deleteRule: .cascade) var completions: [ChallengeCompletion] = []

    var level: VariantLevel {
        get { VariantLevel(rawValue: levelRaw) ?? .suave }
        set { levelRaw = newValue.rawValue }
    }

    init(title: String, targetSUDS: Int, level: VariantLevel, isUnlocked: Bool = false) {
        self.id = UUID()
        self.title = title
        self.targetSUDS = targetSUDS
        self.levelRaw = level.rawValue
        self.completionCount = 0
        self.isUnlocked = isUnlocked
        self.isDominado = false
    }
}

@Model
class ChallengeCompletion {
    var id: UUID
    var predictedSUDS: Int
    var actualSUDS: Int
    var outcomeText: String
    var aiInsight: String?
    var completionTypeRaw: String
    var date: Date

    var completionType: CompletionType {
        get { CompletionType(rawValue: completionTypeRaw) ?? .completed }
        set { completionTypeRaw = newValue.rawValue }
    }

    var sudsReduction: Int { predictedSUDS - actualSUDS }

    init(predictedSUDS: Int, actualSUDS: Int, outcomeText: String, type: CompletionType) {
        self.id = UUID()
        self.predictedSUDS = predictedSUDS
        self.actualSUDS = actualSUDS
        self.outcomeText = outcomeText
        self.completionTypeRaw = type.rawValue
        self.date = Date()
    }
}

@Model
class MomentoSession {
    var id: UUID
    var date: Date
    var durationSeconds: Int
    var momentoTypeRaw: String
    var situationSelected: String?
    var groundingText: String?

    var momentoType: MomentoType {
        get { MomentoType(rawValue: momentoTypeRaw) ?? .preSituation }
        set { momentoTypeRaw = newValue.rawValue }
    }

    init(type: MomentoType, durationSeconds: Int = 0) {
        self.id = UUID()
        self.date = Date()
        self.durationSeconds = durationSeconds
        self.momentoTypeRaw = type.rawValue
    }
}
