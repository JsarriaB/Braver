import Foundation
import Combine
import FirebaseAuth
import FirebaseAppCheck

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

    private static let preparateSystemPrompt = """
    Eres Nova, coach de ansiedad social dentro de Braver. El usuario va a enfrentarse a una \
    situación social ahora mismo y necesita preparación concreta, no consuelo vacío.

    Reglas:
    - Primera respuesta: máximo 120 palabras. Sin encabezados ni numeración visible.
    - Estructura: 1 frase reconociendo la situación específica / 2-3 pasos muy concretos para \
    ese momento exacto / 1 frase de reencuadre basado en evidencia.
    - Chat de seguimiento: máximo 4 líneas. Siempre orientadas a la acción, nunca a consolar.
    - Tono: coaching directo, no terapéutico. Nada de positividad tóxica.
    - Habla siempre en español.
    - Nunca des diagnósticos ni reemplaces ayuda profesional.
    """

    private init() {}

    // MARK: - Chat estándar (Nova tab)

    func send(history: [NovaMessage], userText: String) async throws -> String {
        var messages: [[String: String]] = [["role": "system", "content": Self.systemPrompt]]
        for msg in history.suffix(12) {
            messages.append(["role": msg.isUser ? "user" : "assistant", "content": msg.text])
        }
        messages.append(["role": "user", "content": userText])
        return try await makeRequest(messages: messages)
    }

    // MARK: - Modo Prepárate

    func prepararSituacion(situacion: String, preocupacion: String, suds: Int, contexto: String) async throws -> String {
        let userText = """
        Situación: \(situacion)
        Principal preocupación: \(preocupacion)
        Nivel de reto ahora mismo: \(suds)/100\(contexto.isEmpty ? "" : "\nContexto extra: \(contexto)")
        """
        let messages: [[String: String]] = [
            ["role": "system", "content": Self.preparateSystemPrompt],
            ["role": "user", "content": userText]
        ]
        return try await makeRequest(messages: messages)
    }

    func seguirPreparando(history: [NovaMessage], userText: String) async throws -> String {
        var messages: [[String: String]] = [["role": "system", "content": Self.preparateSystemPrompt]]
        for msg in history {
            messages.append(["role": msg.isUser ? "user" : "assistant", "content": msg.text])
        }
        messages.append(["role": "user", "content": userText])
        return try await makeRequest(messages: messages)
    }

    // MARK: - Network

    private func makeRequest(messages: [[String: String]]) async throws -> String {
        isLoading = true
        defer { isLoading = false }

        let body: [String: Any] = ["messages": messages]
        var request = URLRequest(url: functionURL, timeoutInterval: 30)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let appCheckToken = try await AppCheck.appCheck().token(forcingRefresh: false)
        request.setValue(appCheckToken.token, forHTTPHeaderField: "X-Firebase-AppCheck")

        let uid = Auth.auth().currentUser?.uid ?? "anonymous"
        request.setValue(uid, forHTTPHeaderField: "X-Firebase-UID")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode == 429 {
            throw NovaError.dailyLimitReached
        }
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NovaError.apiError("HTTP \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        }
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let err = json["error"] as? String, err == "DAILY_LIMIT_REACHED" {
            throw NovaError.dailyLimitReached
        }
        guard
            let json    = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let choices = json["choices"] as? [[String: Any]],
            let first   = choices.first,
            let message = first["message"] as? [String: Any],
            let content = message["content"] as? String
        else { throw NovaError.apiError("Respuesta inesperada") }

        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
