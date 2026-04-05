import Foundation
import Combine

// MARK: - Error

enum NovaError: LocalizedError {
    case dailyLimitReached
    case apiError(String)
    case offTopic

    var errorDescription: String? {
        switch self {
        case .dailyLimitReached:
            return "Has usado tus 10 mensajes de hoy. Vuelve mañana — Nova te estará esperando."
        case .apiError:
            return "Ha habido un problema de conexión. Inténtalo de nuevo."
        case .offTopic:
            return "Solo puedo ayudarte con temas de ansiedad social y vergüenza."
        }
    }
}

// MARK: - Service

@MainActor
class NovaService: ObservableObject {

    static let shared = NovaService()

    @Published var isLoading = false
    @Published var dailyUsed: Int = 0

    let dailyLimit = 10

    private let usedKey = "nova_daily_used"
    private let dateKey = "nova_last_date"

    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? ""
    }

    var remaining: Int { max(0, dailyLimit - dailyUsed) }
    var hasMessagesLeft: Bool { remaining > 0 }

    private static let systemPrompt = """
    Eres Nova, una asistente empática dentro de Braver, una app para superar la ansiedad social. \
    Tu único rol es ayudar con ansiedad social, vergüenza social, miedo al juicio, timidez, \
    exposición gradual y temas directamente relacionados.

    Reglas que debes seguir siempre:
    - Responde SOLO sobre ansiedad social, vergüenza o temas directamente relacionados. \
    Si el usuario pregunta sobre cualquier otra cosa, dile con amabilidad que solo puedes ayudar con esos temas.
    - Tus respuestas deben tener entre 3 y 5 líneas cortas. Nunca más.
    - Habla siempre en español, en tono cercano, cálido y tranquilizador. Transmite calma y seguridad.
    - Al inicio de cada conversación, haz hasta 2 preguntas breves para entender mejor la situación \
    antes de dar reflexiones o consejos. Una vez tengas contexto, ofrece reflexiones prácticas y concretas.
    - Nunca des diagnósticos médicos ni reemplaces la ayuda de un profesional.
    """

    private init() {
        resetIfNewDay()
        dailyUsed = UserDefaults.standard.integer(forKey: usedKey)
    }

    // MARK: - Pedir respuesta a OpenAI

    func send(history: [NovaMessage], userText: String) async throws -> String {
        resetIfNewDay()
        guard hasMessagesLeft else { throw NovaError.dailyLimitReached }

        isLoading = true
        defer { isLoading = false }

        var apiMessages: [[String: String]] = [
            ["role": "system", "content": Self.systemPrompt]
        ]
        for msg in history.suffix(12) {
            apiMessages.append(["role": msg.isUser ? "user" : "assistant", "content": msg.text])
        }
        apiMessages.append(["role": "user", "content": userText])

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": apiMessages,
            "max_tokens": 220,
            "temperature": 0.75
        ]

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw NovaError.apiError("URL inválida")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NovaError.apiError("HTTP \(code)")
        }

        guard
            let json    = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let choices = json["choices"] as? [[String: Any]],
            let first   = choices.first,
            let message = first["message"] as? [String: Any],
            let content = message["content"] as? String
        else {
            throw NovaError.apiError("Respuesta inesperada")
        }

        dailyUsed += 1
        UserDefaults.standard.set(dailyUsed, forKey: usedKey)
        UserDefaults.standard.set(Date(), forKey: dateKey)

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Reset diario a las 00:00

    private func resetIfNewDay() {
        let defaults = UserDefaults.standard
        if let last = defaults.object(forKey: dateKey) as? Date,
           !Calendar.current.isDateInToday(last) {
            defaults.set(0, forKey: usedKey)
            dailyUsed = 0
        }
    }
}
