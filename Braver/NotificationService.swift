import Foundation
import UserNotifications

enum NotificationService {

    // MARK: - Solicitar permiso y programar

    static func requestAndSchedule() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async { scheduleAll() }
        }
    }

    // MARK: - Programar todas las notificaciones

    static func scheduleAll() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        scheduleMorningReminder(center: center)
        scheduleEveningCheckIn(center: center)
    }

    // MARK: - Privadas

    private static func scheduleMorningReminder(center: UNUserNotificationCenter) {
        let content = UNMutableNotificationContent()
        content.title = "Tu misión de hoy te espera 💪"
        content.body = "Abre Braver y acepta el reto del día."
        content.sound = .default

        var components = DateComponents()
        components.hour = 9
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "braver_morning", content: content, trigger: trigger)
        center.add(request)
    }

    private static func scheduleEveningCheckIn(center: UNUserNotificationCenter) {
        let content = UNMutableNotificationContent()
        content.title = "¿Cómo fue tu día? 🌙"
        content.body = "Tómate un momento para registrar cómo te fue."
        content.sound = .default

        var components = DateComponents()
        components.hour = 20
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "braver_evening", content: content, trigger: trigger)
        center.add(request)
    }
}
