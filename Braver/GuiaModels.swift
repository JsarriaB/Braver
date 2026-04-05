import SwiftUI
import Foundation
import Combine

// MARK: - Learning Module & Lesson

struct LearningModule: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let emoji: String
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

// MARK: - Lesson Progress

class GuiaProgress: ObservableObject {
    static let shared = GuiaProgress()

    private let key = "braver_completed_lessons"
    @Published var completedIds: Set<String> = []

    private init() { load() }

    func markCompleted(_ id: String) {
        completedIds.insert(id)
        save()
    }

    func isCompleted(_ id: String) -> Bool {
        completedIds.contains(id)
    }

    func completedCount(in module: LearningModule) -> Int {
        module.lessons.filter { completedIds.contains($0.id) }.count
    }

    private func save() {
        if let data = try? JSONEncoder().encode(Array(completedIds)) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let ids = try? JSONDecoder().decode([String].self, from: data)
        else { return }
        completedIds = Set(ids)
    }
}
