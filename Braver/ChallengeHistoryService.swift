import Foundation
import Combine

// MARK: - Modelo de intento

struct ChallengeAttempt: Codable, Identifiable {
    let id: UUID
    let challengeId: String
    let title: String
    let category: String
    let categoryEmoji: String
    let difficultyRaw: String
    let date: Date
    var status: AttemptStatus

    enum AttemptStatus: String, Codable {
        case completed  // "Ya lo hice"
        case attempted  // "Lo intenté"
    }

    var isRetryable: Bool { status == .attempted }
}

// MARK: - Servicio

class ChallengeHistoryService: ObservableObject {

    static let shared = ChallengeHistoryService()

    @Published var attempts: [ChallengeAttempt] = []

    private let key = "braver_challenge_history"

    private init() {
        load()
    }

    // Llamar desde HoyView al confirmar resultado
    func record(challenge: DailyChallenge, status: ChallengeAttempt.AttemptStatus) {
        // Evitar duplicado del mismo reto el mismo día
        let today = Calendar.current.startOfDay(for: Date())
        if attempts.contains(where: {
            $0.challengeId == challenge.id &&
            Calendar.current.startOfDay(for: $0.date) == today
        }) { return }

        let attempt = ChallengeAttempt(
            id: UUID(),
            challengeId: challenge.id,
            title: challenge.title,
            category: challenge.category,
            categoryEmoji: challenge.categoryEmoji,
            difficultyRaw: challenge.difficulty.rawValue,
            date: Date(),
            status: status
        )
        attempts.insert(attempt, at: 0)
        save()
    }

    // IDs de retos intentados (para excluir en selección diaria)
    var attemptedIds: [String] {
        attempts.map { $0.challengeId }
    }

    // Debug
    func clearAll() {
        attempts = []
        UserDefaults.standard.removeObject(forKey: key)
    }

    // MARK: - Persistencia

    private func save() {
        if let data = try? JSONEncoder().encode(attempts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([ChallengeAttempt].self, from: data)
        else { return }
        attempts = saved
    }
}
