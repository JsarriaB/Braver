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
    let body: String
    let keyInsight: String
    let scienceFact: String
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
