import SwiftUI

// MARK: - Modelo

struct DailyChallenge: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let category: String
    let categoryEmoji: String
    let difficulty: ChallengeDifficulty

    enum ChallengeDifficulty: String {
        case easy     = "Fácil"
        case moderate = "Moderado"
        case hard     = "Difícil"

        var color: Color {
            switch self {
            case .easy:     return Color(hex: "10B981")
            case .moderate: return Color(hex: "F59E0B")
            case .hard:     return Color(hex: "EF4444")
            }
        }
    }
}

// MARK: - Biblioteca

enum ChallengeLibrary {

    static let all: [DailyChallenge] = easy + moderate + hard

    // MARK: FÁCIL

    static let easy: [DailyChallenge] = [
        // Llamadas
        DailyChallenge(id: "e01", title: "Llama a una tienda para preguntar su horario", subtitle: "Solo necesitas 30 segundos y una pregunta.", category: "Llamadas", categoryEmoji: "📞", difficulty: .easy),
        DailyChallenge(id: "e02", title: "Llama al médico para pedir cita en vez de hacerlo online", subtitle: "Son exactamente las mismas palabras, solo por teléfono.", category: "Llamadas", categoryEmoji: "📞", difficulty: .easy),
        DailyChallenge(id: "e03", title: "Llama a un amigo sin motivo, solo para saludar", subtitle: "No necesitas excusa para llamar a alguien.", category: "Llamadas", categoryEmoji: "📞", difficulty: .easy),
        DailyChallenge(id: "e04", title: "Llama a un restaurante para preguntar si tienen mesa", subtitle: "Una pregunta, una respuesta, listo.", category: "Llamadas", categoryEmoji: "📞", difficulty: .easy),
        DailyChallenge(id: "e05", title: "Llama a información para buscar un número que no tienes", subtitle: "Están ahí exactamente para eso.", category: "Llamadas", categoryEmoji: "📞", difficulty: .easy),

        // Tiendas
        DailyChallenge(id: "e06", title: "Pregunta dónde está un producto en el supermercado", subtitle: "El personal está ahí para ayudarte.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .easy),
        DailyChallenge(id: "e07", title: "Pide que te pongan menos de algo en tu pedido", subtitle: "Sin gluten, sin sal, sin cebolla — lo que sea.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .easy),
        DailyChallenge(id: "e08", title: "Pregunta el precio de algo caro sin intención de comprarlo", subtitle: "No estás obligado a comprar nada.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .easy),
        DailyChallenge(id: "e09", title: "Pide una bolsa en la caja sin que te la ofrezcan", subtitle: "Una frase. Eso es todo.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .easy),
        DailyChallenge(id: "e10", title: "Devuelve algo a una tienda con ticket", subtitle: "Tienes todo el derecho. Ellos lo saben.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .easy),
        DailyChallenge(id: "e11", title: "Pide más agua o servilletas en un restaurante", subtitle: "Tu comodidad importa.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .easy),
        DailyChallenge(id: "e12", title: "Saluda a la cajera por su nombre si lleva placa", subtitle: "Un saludo humaniza la transacción.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .easy),

        // Hablar en público
        DailyChallenge(id: "e13", title: "Di tu opinión sobre una peli cuando alguien te pregunta", subtitle: "No tienes que justificar lo que te gusta.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .easy),
        DailyChallenge(id: "e14", title: "Haz una pregunta en un grupo de WhatsApp donde solo lees", subtitle: "Una pregunta sencilla es suficiente.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .easy),
        DailyChallenge(id: "e15", title: "Pide indicaciones a alguien en la calle", subtitle: "A todo el mundo le piden indicaciones alguna vez.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .easy),
        DailyChallenge(id: "e16", title: "Pregunta la hora a un desconocido", subtitle: "La interacción más corta del mundo.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .easy),
        DailyChallenge(id: "e17", title: "Di 'gracias' en voz alta al conductor del autobús al bajar", subtitle: "Voz audible. No susurres.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .easy),

        // Ligar
        DailyChallenge(id: "e18", title: "Mantén el contacto visual con alguien que te parece atractivo/a 3 segundos", subtitle: "Tres segundos es todo. No tienes que decir nada.", category: "Ligar", categoryEmoji: "💘", difficulty: .easy),
        DailyChallenge(id: "e19", title: "Sonríe a alguien que te parece atractivo/a", subtitle: "Sin palabras. Solo una sonrisa sincera.", category: "Ligar", categoryEmoji: "💘", difficulty: .easy),
        DailyChallenge(id: "e20", title: "Da un 'me gusta' a una foto de alguien que te gusta en redes", subtitle: "El primer gesto no compromete a nada.", category: "Ligar", categoryEmoji: "💘", difficulty: .easy),

        // Grupos
        DailyChallenge(id: "e21", title: "Di 'hola' al entrar a una habitación donde hay gente", subtitle: "Un saludo al entrar es lo más natural del mundo.", category: "Grupos", categoryEmoji: "👥", difficulty: .easy),
        DailyChallenge(id: "e22", title: "Responde con algo más que 'bien' cuando alguien te pregunta qué tal", subtitle: "Añade una frase. No tienes que escribir un libro.", category: "Grupos", categoryEmoji: "👥", difficulty: .easy),
        DailyChallenge(id: "e23", title: "Saluda a un vecino al que normalmente ignoras", subtitle: "Un 'buenas' cambia la dinámica.", category: "Grupos", categoryEmoji: "👥", difficulty: .easy),
        DailyChallenge(id: "e24", title: "Haz un comentario en la conversación de un grupo pequeño", subtitle: "Una frase. No tienes que dominar la conversación.", category: "Grupos", categoryEmoji: "👥", difficulty: .easy),

        // Trabajo
        DailyChallenge(id: "e25", title: "Envía un mensaje de voz a un compañero en vez de texto", subtitle: "Tu voz es válida. No tienes que ser perfecto.", category: "Trabajo", categoryEmoji: "💼", difficulty: .easy),
        DailyChallenge(id: "e26", title: "Di 'buenos días' al entrar a la oficina aunque nadie lo diga", subtitle: "Sé el que rompe el hielo.", category: "Trabajo", categoryEmoji: "💼", difficulty: .easy),
        DailyChallenge(id: "e27", title: "Pide ayuda a un compañero con algo en vez de quedarte atascado solo", subtitle: "Pedir ayuda no es debilidad.", category: "Trabajo", categoryEmoji: "💼", difficulty: .easy),
        DailyChallenge(id: "e28", title: "Escribe un comentario positivo en el trabajo de un compañero", subtitle: "El reconocimiento da valor al que lo da y al que lo recibe.", category: "Trabajo", categoryEmoji: "💼", difficulty: .easy),

        // Conflictos
        DailyChallenge(id: "e29", title: "Di que no a un plan al que dirías que sí por compromiso", subtitle: "Tienes derecho a no querer.", category: "Conflictos", categoryEmoji: "😤", difficulty: .easy),
        DailyChallenge(id: "e30", title: "Pide que repitan algo que no has entendido en vez de asentir", subtitle: "No entender no es un fallo. Fingir que sí lo es.", category: "Conflictos", categoryEmoji: "😤", difficulty: .easy),

        // Conocer gente
        DailyChallenge(id: "e31", title: "Preséntate a alguien nuevo en un entorno donde ya te conocen a ti", subtitle: "Tú puedes iniciar.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .easy),
        DailyChallenge(id: "e32", title: "Haz un cumplido sincero a alguien que no conoces bien", subtitle: "Los cumplidos directos son raros y muy bien recibidos.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .easy),
        DailyChallenge(id: "e33", title: "Inicia una conversación comentando algo del entorno", subtitle: "El tiempo, el sitio, lo que sea. Lo obvio funciona.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .easy),
    ]

    // MARK: MODERADO

    static let moderate: [DailyChallenge] = [
        // Llamadas
        DailyChallenge(id: "m01", title: "Llama a atención al cliente para reclamar algo", subtitle: "Tienes razón. Solo exprésalo.", category: "Llamadas", categoryEmoji: "📞", difficulty: .moderate),
        DailyChallenge(id: "m02", title: "Llama para cancelar una cita o reserva", subtitle: "Llamar para cancelar es educado. No es una molestia.", category: "Llamadas", categoryEmoji: "📞", difficulty: .moderate),
        DailyChallenge(id: "m03", title: "Llama a alguien con quien tienes una conversación pendiente", subtitle: "Esa conversación no se va sola.", category: "Llamadas", categoryEmoji: "📞", difficulty: .moderate),
        DailyChallenge(id: "m04", title: "Llama para reservar en un restaurante en hora punta", subtitle: "Peor es no conseguir mesa.", category: "Llamadas", categoryEmoji: "📞", difficulty: .moderate),
        DailyChallenge(id: "m05", title: "Llama para preguntar sobre un servicio o presupuesto", subtitle: "La información no cuesta nada.", category: "Llamadas", categoryEmoji: "📞", difficulty: .moderate),

        // Tiendas
        DailyChallenge(id: "m06", title: "Devuelve algo sin ticket explicando el motivo", subtitle: "Las tiendas tienen políticas de devolución. Úsalas.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .moderate),
        DailyChallenge(id: "m07", title: "Pide cambiar tu mesa en un restaurante porque no estás cómodo/a", subtitle: "Tu comodidad vale más que el compromiso.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .moderate),
        DailyChallenge(id: "m08", title: "Pide descuento en algo — una tienda, un servicio, lo que sea", subtitle: "El 'no' ya lo tienes. El 'sí' solo viene si preguntas.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .moderate),
        DailyChallenge(id: "m09", title: "Quéjate de algo en un restaurante con educación", subtitle: "No te quedes callado. Pide lo que mereces.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .moderate),
        DailyChallenge(id: "m10", title: "Pregunta si pueden hacerte algo a medida o personalizado", subtitle: "Muchas veces pueden. Solo hay que preguntar.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .moderate),

        // Hablar en público
        DailyChallenge(id: "m11", title: "Haz una pregunta en una clase, charla o evento", subtitle: "La mayoría quiere preguntar lo mismo y no se atreve.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .moderate),
        DailyChallenge(id: "m12", title: "Contradice amablemente a alguien en una conversación grupal", subtitle: "Tener otra opinión no es agresivo.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .moderate),
        DailyChallenge(id: "m13", title: "Habla en una reunión aunque no tengas nada urgente que decir", subtitle: "Tu presencia verbal importa.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .moderate),
        DailyChallenge(id: "m14", title: "Cuenta una anécdota tuya en un grupo de más de 4 personas", subtitle: "Tus historias tienen valor.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .moderate),
        DailyChallenge(id: "m15", title: "Presenta tu punto de vista en una discusión sin pedir disculpas", subtitle: "Empezar con 'perdona pero...' debilita lo que dices.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .moderate),

        // Ligar
        DailyChallenge(id: "m16", title: "Manda un mensaje de texto iniciando conversación con alguien que te gusta", subtitle: "El primer mensaje es el más difícil. Y el más importante.", category: "Ligar", categoryEmoji: "💘", difficulty: .moderate),
        DailyChallenge(id: "m17", title: "Pregunta a alguien si quiere quedar para tomar algo", subtitle: "Lo más concreto funciona mejor que insinuar.", category: "Ligar", categoryEmoji: "💘", difficulty: .moderate),
        DailyChallenge(id: "m18", title: "Dile a alguien que te parece interesante sin contexto previo", subtitle: "Directo y honesto es la combinación que funciona.", category: "Ligar", categoryEmoji: "💘", difficulty: .moderate),

        // Grupos
        DailyChallenge(id: "m19", title: "Inicia una conversación con alguien en una sala de espera", subtitle: "El silencio compartido ya es una base.", category: "Grupos", categoryEmoji: "👥", difficulty: .moderate),
        DailyChallenge(id: "m20", title: "Presenta a dos personas que no se conocen en una reunión social", subtitle: "El que presenta es el que conecta.", category: "Grupos", categoryEmoji: "👥", difficulty: .moderate),
        DailyChallenge(id: "m21", title: "Propón un tema de conversación en un grupo donde hay silencio", subtitle: "Alguien tiene que empezar. Sé tú.", category: "Grupos", categoryEmoji: "👥", difficulty: .moderate),
        DailyChallenge(id: "m22", title: "Envía un mensaje de voz a un grupo donde normalmente solo lees", subtitle: "Tu voz tiene presencia que el texto no tiene.", category: "Grupos", categoryEmoji: "👥", difficulty: .moderate),

        // Trabajo
        DailyChallenge(id: "m23", title: "Da tu opinión en una reunión sin que te lo pidan", subtitle: "Si lo piensas, di algo. Para eso estás en esa reunión.", category: "Trabajo", categoryEmoji: "💼", difficulty: .moderate),
        DailyChallenge(id: "m24", title: "Pide feedback a tu jefe o a un compañero sobre tu trabajo", subtitle: "Pedir feedback es señal de madurez profesional.", category: "Trabajo", categoryEmoji: "💼", difficulty: .moderate),
        DailyChallenge(id: "m25", title: "Propón una idea en el trabajo aunque no estés seguro/a del 100%", subtitle: "Las ideas perfectas no existen. Las imperfectas sí.", category: "Trabajo", categoryEmoji: "💼", difficulty: .moderate),
        DailyChallenge(id: "m26", title: "Pide un aumento o reconocimiento que crees que mereces", subtitle: "Nadie va a pedirte que pidas lo que mereces.", category: "Trabajo", categoryEmoji: "💼", difficulty: .moderate),

        // Conflictos
        DailyChallenge(id: "m27", title: "Di a alguien que algo que hizo te molestó", subtitle: "Sin dramatismo. Solo honestidad.", category: "Conflictos", categoryEmoji: "😤", difficulty: .moderate),
        DailyChallenge(id: "m28", title: "Pide disculpas por algo que sabes que hiciste mal", subtitle: "Una disculpa directa vale más que cien rodeos.", category: "Conflictos", categoryEmoji: "😤", difficulty: .moderate),
        DailyChallenge(id: "m29", title: "Establece un límite claro con alguien que lo está cruzando", subtitle: "'Eso no me gusta' es una frase completa.", category: "Conflictos", categoryEmoji: "😤", difficulty: .moderate),

        // Conocer gente
        DailyChallenge(id: "m30", title: "Inicia conversación con alguien que está solo/a en un evento", subtitle: "Seguramente agradecen que te acerques.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .moderate),
        DailyChallenge(id: "m31", title: "Pide el número a alguien con quien has tenido buena conversación", subtitle: "Si la conversación fue buena, tener su número tiene sentido.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .moderate),
        DailyChallenge(id: "m32", title: "Propón quedar a alguien con quien lleváis tiempo sin veros", subtitle: "La iniciativa es lo que mantiene vivas las relaciones.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .moderate),
    ]

    // MARK: DIFÍCIL

    static let hard: [DailyChallenge] = [
        // Llamadas
        DailyChallenge(id: "h01", title: "Llama para quejarte formalmente de un servicio malo", subtitle: "Tienes derecho a exigir lo que pagaste.", category: "Llamadas", categoryEmoji: "📞", difficulty: .hard),
        DailyChallenge(id: "h02", title: "Llama a alguien con quien tienes una conversación incómoda pendiente", subtitle: "Esa llamada no desaparece sola.", category: "Llamadas", categoryEmoji: "📞", difficulty: .hard),
        DailyChallenge(id: "h03", title: "Llama en frío para pedir información sobre un trabajo o proyecto", subtitle: "El teléfono abre puertas que el email deja cerradas.", category: "Llamadas", categoryEmoji: "📞", difficulty: .hard),

        // Tiendas
        DailyChallenge(id: "h04", title: "Devuelve algo que compraste hace tiempo sin motivo urgente", subtitle: "La incomodidad de no hacer nada dura más.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .hard),
        DailyChallenge(id: "h05", title: "Negocia el precio de un servicio o producto de alto valor", subtitle: "Todo es negociable. Lo peor es el 'no' que ya tienes.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .hard),
        DailyChallenge(id: "h06", title: "Quéjate en público de algo que está mal en un servicio", subtitle: "Educado pero claro. No tienes que aguantar.", category: "Tiendas", categoryEmoji: "🛍️", difficulty: .hard),

        // Hablar en público
        DailyChallenge(id: "h07", title: "Habla en una reunión con más de 10 personas sin que te pregunten", subtitle: "Tu voz tiene el mismo derecho que las demás.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .hard),
        DailyChallenge(id: "h08", title: "Da un discurso improvisado de 2 minutos ante desconocidos", subtitle: "Imperfecto y espontáneo es mejor que callado.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .hard),
        DailyChallenge(id: "h09", title: "Presenta tu trabajo o proyecto sin preparación previa", subtitle: "Conoces tu trabajo mejor de lo que crees.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .hard),
        DailyChallenge(id: "h10", title: "Cuenta algo personal en un grupo sin que nadie te lo haya pedido", subtitle: "La vulnerabilidad conecta más que la perfección.", category: "Hablar en público", categoryEmoji: "🎤", difficulty: .hard),

        // Ligar
        DailyChallenge(id: "h11", title: "Acércate a alguien que te parece atractivo/a y entabla conversación", subtitle: "El peor resultado es que no pase nada. Ya tienes eso.", category: "Ligar", categoryEmoji: "💘", difficulty: .hard),
        DailyChallenge(id: "h12", title: "Di directamente a alguien que te gusta que te gustaría volver a verle", subtitle: "La claridad es atractiva. La ambigüedad no.", category: "Ligar", categoryEmoji: "💘", difficulty: .hard),
        DailyChallenge(id: "h13", title: "Propón una cita concreta con lugar y hora a alguien que te gusta", subtitle: "Las cosas concretas pasan. Las vagas no.", category: "Ligar", categoryEmoji: "💘", difficulty: .hard),

        // Grupos
        DailyChallenge(id: "h14", title: "Propón un plan a un grupo de personas que apenas conoces", subtitle: "La iniciativa te posiciona. Siempre.", category: "Grupos", categoryEmoji: "👥", difficulty: .hard),
        DailyChallenge(id: "h15", title: "Cuenta un chiste o historia en un grupo grande y espera la reacción", subtitle: "El silencio después de una broma no es el fin del mundo.", category: "Grupos", categoryEmoji: "👥", difficulty: .hard),
        DailyChallenge(id: "h16", title: "Participa activamente en una dinámica de grupo ante desconocidos", subtitle: "Participar aunque te salga mal es mejor que no participar.", category: "Grupos", categoryEmoji: "👥", difficulty: .hard),

        // Trabajo
        DailyChallenge(id: "h17", title: "Habla en una presentación ante toda la empresa o un grupo grande", subtitle: "El pánico escénico se vence haciéndolo.", category: "Trabajo", categoryEmoji: "💼", difficulty: .hard),
        DailyChallenge(id: "h18", title: "Contradice a tu jefe en una reunión con argumentos", subtitle: "Los buenos jefes valoran que alguien piense diferente.", category: "Trabajo", categoryEmoji: "💼", difficulty: .hard),
        DailyChallenge(id: "h19", title: "Pide una reunión con alguien de alto rango para hablar de tu carrera", subtitle: "Nadie va a gestionar tu carrera por ti.", category: "Trabajo", categoryEmoji: "💼", difficulty: .hard),

        // Conflictos
        DailyChallenge(id: "h20", title: "Pide en público que bajen el volumen de algo que te molesta", subtitle: "Tu comodidad es tan válida como la de los demás.", category: "Conflictos", categoryEmoji: "😤", difficulty: .hard),
        DailyChallenge(id: "h21", title: "Resuelve un conflicto cara a cara que llevas evitando", subtitle: "Cada día que pasa lo hace más difícil.", category: "Conflictos", categoryEmoji: "😤", difficulty: .hard),
        DailyChallenge(id: "h22", title: "Di a alguien importante en tu vida algo que llevas tiempo sin decirle", subtitle: "Las cosas importantes no se dicen solas.", category: "Conflictos", categoryEmoji: "😤", difficulty: .hard),

        // Conocer gente
        DailyChallenge(id: "h23", title: "Ve solo/a a un evento social donde no conoces a nadie", subtitle: "Ir solo/a te obliga a hablar. Es lo mejor que puede pasarte.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .hard),
        DailyChallenge(id: "h24", title: "Únete a una actividad o club nuevo donde eres el desconocido", subtitle: "Todo el mundo fue desconocido algún día.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .hard),
        DailyChallenge(id: "h25", title: "Habla con el organizador de un evento para conocer más gente", subtitle: "El organizador conoce a todo el mundo. Es tu mejor aliado.", category: "Conocer gente", categoryEmoji: "🤝", difficulty: .hard),
    ]

    // MARK: - Selección diaria

    /// Devuelve 2 retos para hoy basándose en los días de progreso del orbe.
    static func todaysChallenges(orbDays: Int, seen: [String] = []) -> [DailyChallenge] {
        let pool = poolForDays(orbDays)
        let available = pool.filter { !seen.contains($0.id) }
        let source = available.isEmpty ? pool : available
        let shuffled = source.shuffled()
        guard shuffled.count >= 2 else { return shuffled }
        return Array(shuffled.prefix(2))
    }

    private static func poolForDays(_ days: Int) -> [DailyChallenge] {
        switch days {
        case 0..<14:  return easy
        case 14..<28: return weighted(easy, moderate, ratio: 0.7)
        case 28..<45: return weighted(easy, moderate, ratio: 0.5)
        case 45..<60: return moderate
        case 60..<75: return weighted(moderate, hard, ratio: 0.7)
        case 75..<90: return weighted(moderate, hard, ratio: 0.5)
        default:      return hard
        }
    }

    private static func weighted(_ primary: [DailyChallenge], _ secondary: [DailyChallenge], ratio: Double) -> [DailyChallenge] {
        let primaryCount = Int(Double(primary.count) * ratio)
        let secondaryCount = Int(Double(secondary.count) * (1 - ratio))
        return Array(primary.shuffled().prefix(primaryCount)) + Array(secondary.shuffled().prefix(secondaryCount))
    }
}
