import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

// MARK: - Model

struct EveningCheckIn: Codable, Identifiable {
    let id: UUID
    let date: Date
    let mood: String        // emoji: "😌" "😬" "😤"
    let moodLabel: String   // "Bien" "Regular" "Mal"
    let note: String?

    init(mood: String, moodLabel: String, note: String?) {
        self.id = UUID()
        self.date = Date()
        self.mood = mood
        self.moodLabel = moodLabel
        self.note = note
    }
}

// MARK: - Service

class EveningCheckInService: ObservableObject {

    static let shared = EveningCheckInService()

    @Published var checkIns: [EveningCheckIn] = []

    private let key = "braver_evening_checkins"

    private init() { load() }

    var hasCheckInToday: Bool {
        guard let latest = checkIns.first else { return false }
        return Calendar.current.isDateInToday(latest.date)
    }

    func save(mood: String, moodLabel: String, note: String?) {
        guard !hasCheckInToday else { return }
        let entry = EveningCheckIn(mood: mood, moodLabel: moodLabel, note: note)
        checkIns.insert(entry, at: 0)
        persist()
        syncToFirestore(entry)
    }

    private func syncToFirestore(_ entry: EveningCheckIn) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = [
            "date": Timestamp(date: entry.date),
            "mood": entry.mood,
            "moodLabel": entry.moodLabel,
            "note": entry.note as Any
        ]
        Task {
            try? await Firestore.firestore()
                .collection("users").document(uid)
                .collection("checkins").document(entry.id.uuidString)
                .setData(data)
        }
    }

    // MARK: - Persistence

    private func persist() {
        if let data = try? JSONEncoder().encode(checkIns) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([EveningCheckIn].self, from: data)
        else { return }
        checkIns = saved
    }
}
