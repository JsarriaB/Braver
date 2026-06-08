import SwiftUI
import Foundation
import Combine

// MARK: - Learning Module & Lesson

struct LearningModule: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let symbol: String      // SF Symbol name
    let colorHex: String
    let lessons: [Lesson]

    var color: Color { Color(hex: colorHex) }
    var lessonCount: Int { lessons.count }
}

struct Lesson: Identifiable {
    let id: String
    let number: Int
    let title: String
    // Legacy fields — used when screens == nil (old LessonDetailView)
    let body: String
    let keyInsight: String
    let scienceFact: String
    // Wizard format — if set, opens LessonWizardView instead
    var screens: [LessonScreenData]? = nil
}

// MARK: - Wizard Screen Types

enum LessonScreenType {
    case intro             // portada: ilustración + título + subtítulo
    case diagnostico       // pregunta con opciones, sin respuesta correcta
    case teoria            // texto corto + idea clave destacada
    case carrusel          // tarjetas deslizables con ejemplos
    case tabs              // 2-3 pestañas con perspectivas distintas
    case ejercicioIdentifica  // el usuario toca los correctos de una lista
    case resumen           // 3 puntos clave al final de la lección
    case celebracion       // "lección completada" con métricas
    case rating            // "¿cuánto resuena esto contigo?"
}

// MARK: - Supporting Types

struct LessonCard: Identifiable {
    let id = UUID()
    let title: String
    let body: String
    var icon: String = ""
}

struct LessonTab {
    let title: String
    let body: String
}

struct IdentifyOption: Identifiable {
    let id = UUID()
    let text: String
    let isCorrect: Bool
    var explanation: String = ""
}

// MARK: - Screen Data

struct LessonScreenData {
    let type: LessonScreenType
    var title: String = ""
    var subtitle: String = ""
    var body: String = ""
    var highlight: String = ""           // idea clave / highlight box
    var icon: String = ""               // SF Symbol para intro
    var choices: [String] = []          // opciones del diagnóstico
    var cards: [LessonCard] = []        // carrusel
    var tabs: [LessonTab] = []          // tabs
    var identifyOptions: [IdentifyOption] = []  // ejercicio identifica
    var keyPoints: [String] = []        // resumen
}

// MARK: - Nova Chat Message

struct NovaMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// MARK: - Lesson Progress (1 per day, no accumulation)

class GuiaProgress: ObservableObject {
    static let shared = GuiaProgress()

    private let completedKey  = "braver_completed_lessons"
    private let lastDoneKey   = "braver_last_lesson_date"

    @Published var completedIds: Set<String> = []
    private var lastLessonDate: Date?

    private init() { load() }

    // Has the user already completed a lesson today?
    var hasCompletedLessonToday: Bool {
        guard let date = lastLessonDate else { return false }
        return Calendar.current.isDateInToday(date)
    }

    // Can the user mark this lesson complete right now?
    func canComplete(_ id: String) -> Bool {
        if completedIds.contains(id) { return false }   // already done
        return !hasCompletedLessonToday                 // not used today's slot
    }

    func markCompleted(_ id: String) {
        guard canComplete(id) else { return }
        completedIds.insert(id)
        lastLessonDate = Date()
        save()
    }

    func isCompleted(_ id: String) -> Bool {
        completedIds.contains(id)
    }

    func completedCount(in module: LearningModule) -> Int {
        module.lessons.filter { completedIds.contains($0.id) }.count
    }

    // MARK: Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(Array(completedIds)) {
            UserDefaults.standard.set(data, forKey: completedKey)
        }
        UserDefaults.standard.set(lastLessonDate, forKey: lastDoneKey)
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: completedKey),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            completedIds = Set(ids)
        }
        lastLessonDate = UserDefaults.standard.object(forKey: lastDoneKey) as? Date
    }
}
