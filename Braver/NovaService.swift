import Foundation
import Combine
import FirebaseAppCheck
import FirebaseInstallations

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

    private let functionURL = URL(string: "https://us-central1-braver-4d2bc.cloudfunctions.net/novaChat")!

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

    private init() {}

    // MARK: - Enviar a Firebase Function

    func send(history: [NovaMessage], userText: String) async throws -> String {
        isLoading = true
        defer { isLoading = false }

        var messages: [[String: String]] = [
            ["role": "system", "content": Self.systemPrompt]
        ]
        for msg in history.suffix(12) {
            messages.append(["role": msg.isUser ? "user" : "assistant", "content": msg.text])
        }
        messages.append(["role": "user", "content": userText])

        let body: [String: Any] = ["messages": messages]

        var request = URLRequest(url: functionURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let appCheckToken = try await AppCheck.appCheck().token(forcingRefresh: false)
        request.setValue(appCheckToken.token, forHTTPHeaderField: "X-Firebase-AppCheck")

        let installationID = try await Installations.installations().installationID()
        request.setValue(installationID, forHTTPHeaderField: "X-Installation-ID")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode == 429 {
            throw NovaError.dailyLimitReached
        }

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NovaError.apiError("HTTP \(code)")
        }

        // Comprobar también si la respuesta JSON contiene DAILY_LIMIT_REACHED
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let errorMsg = json["error"] as? String,
           errorMsg == "DAILY_LIMIT_REACHED" {
            throw NovaError.dailyLimitReached
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

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
