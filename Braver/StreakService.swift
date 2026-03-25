import Foundation
import Combine

/// Gestiona el streak diario (🔥) y el progreso de orbe de forma independiente.
/// - Streak: sube con solo abrir la app cada día.
/// - OrbProgress: sube solo cuando el usuario completa y confirma un reto.
class StreakService: ObservableObject {

    static let shared = StreakService()

    @Published var streakDays: Int = 0
    @Published var orbProgressDays: Int = 0
    @Published var momentosBraver: Int = 0

    private let streakKey       = "braver_streak_days"
    private let orbKey          = "braver_orb_days"
    private let lastOpenKey     = "braver_last_open_date"
    private let lastCompleteKey = "braver_last_complete_date"
    private let momentosKey     = "braver_momentos_braver"

    private init() {
        streakDays      = UserDefaults.standard.integer(forKey: streakKey)
        orbProgressDays = UserDefaults.standard.integer(forKey: orbKey)
        momentosBraver  = UserDefaults.standard.integer(forKey: momentosKey)
    }

    // MARK: - Llamar al abrir la app

    func registerAppOpen() {
        let today = Calendar.current.startOfDay(for: Date())
        let defaults = UserDefaults.standard

        if let lastData = defaults.object(forKey: lastOpenKey) as? Date {
            let last = Calendar.current.startOfDay(for: lastData)
            let diff = Calendar.current.dateComponents([.day], from: last, to: today).day ?? 0

            if diff == 0 {
                return // ya contado hoy
            } else if diff == 1 {
                streakDays += 1 // día consecutivo
            } else {
                streakDays = 1 // racha rota
            }
        } else {
            streakDays = 1 // primer uso
        }

        defaults.set(streakDays, forKey: streakKey)
        defaults.set(today, forKey: lastOpenKey)
    }

    // MARK: - Llamar al completar un reto

    func registerChallengeCompleted() {
        let today = Calendar.current.startOfDay(for: Date())
        let defaults = UserDefaults.standard

        if let lastData = defaults.object(forKey: lastCompleteKey) as? Date {
            let last = Calendar.current.startOfDay(for: lastData)
            if Calendar.current.isDate(last, inSameDayAs: today) {
                return // ya completó un reto hoy
            }
        }

        orbProgressDays += 1
        defaults.set(orbProgressDays, forKey: orbKey)
        defaults.set(today, forKey: lastCompleteKey)
    }

    // MARK: - Llamar al pulsar "Voy a por ello" en Braver

    func registerMomentoBraver() {
        momentosBraver += 1
        UserDefaults.standard.set(momentosBraver, forKey: momentosKey)
    }

    // MARK: - Solo para debug/testing

    func reset() {
        streakDays = 0
        orbProgressDays = 0
        UserDefaults.standard.removeObject(forKey: streakKey)
        UserDefaults.standard.removeObject(forKey: orbKey)
        UserDefaults.standard.removeObject(forKey: lastOpenKey)
        UserDefaults.standard.removeObject(forKey: lastCompleteKey)
    }
}

