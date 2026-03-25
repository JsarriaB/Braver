import Foundation

/// Banco de consejos/datos para la tarjeta "Dato de hoy" en HoyView.
/// Distintos de los datos de Braver — estos son educativos/motivacionales,
/// no de apoyo inmediato en situación de ansiedad.
enum DatosHoy {

    static func random() -> DatoDelDia {
        let all = datos
        let index = Int(Date().timeIntervalSince1970 / 86400) % all.count
        return all[index]
    }

    static let datos: [DatoDelDia] = [
        DatoDelDia(tag: "Terapia cognitiva",
                   text: "Tu cerebro confunde incomodidad con peligro. No son lo mismo. La ansiedad que sientes es tu sistema de alarma disparado de más, no una señal real de amenaza."),

        DatoDelDia(tag: "Neurociencia",
                   text: "Cada vez que actúas con miedo, el cerebro registra que sobreviviste. Con el tiempo, la amígdala reduce su respuesta. La valentía es literalmente un entrenamiento cerebral."),

        DatoDelDia(tag: "Exposición gradual",
                   text: "La terapia de exposición es el tratamiento más efectivo para la ansiedad social con una tasa de mejora del 85%. La idea es simple: enfrentarte a lo que temes, en dosis controladas."),

        DatoDelDia(tag: "Vergüenza social",
                   text: "La vergüenza necesita audiencia. El valor no. Nadie más vive en tu cabeza ni lleva la cuenta de tus momentos incómodos."),

        DatoDelDia(tag: "El efecto spotlight",
                   text: "Crees que todos te miran cuando cometes un error. Es el efecto foco. En realidad, las personas están ocupadas pensando en sí mismas, no en ti."),

        DatoDelDia(tag: "Biología",
                   text: "Los nervios y la emoción producen exactamente los mismos síntomas físicos. La diferencia está en cómo los interpretas. Reencuadra 'estoy nervioso' como 'estoy activado'."),

        DatoDelDia(tag: "Acción primero",
                   text: "No esperes a sentirte seguro para actuar. La seguridad viene después de la acción, no antes. Actuar con miedo es exactamente lo que significa ser valiente."),

        DatoDelDia(tag: "Terapia cognitiva",
                   text: "Las predicciones catastróficas casi nunca se cumplen. Tu cerebro exagera el peligro social por un promedio del 68%. La realidad siempre es más manejable de lo que anticipas."),

        DatoDelDia(tag: "Hábito",
                   text: "La evitación es el mayor mantenedor de la ansiedad. Cada vez que evitas algo que te da miedo, le dices a tu cerebro que tenía razón de asustarse. Romper el ciclo requiere entrar."),

        DatoDelDia(tag: "Psicología",
                   text: "El rechazo social duele porque evolutivamente era peligroso. Hace 50.000 años, ser excluido del grupo era mortal. Hoy no lo es. Tu cerebro todavía no lo sabe."),

        DatoDelDia(tag: "Respiración",
                   text: "Respirar lento activa el nervio vago y reduce la respuesta de estrés en segundos. Cuatro segundos al inhalar, cuatro al retener, cuatro al exhalar. Es neurobiología, no magia."),

        DatoDelDia(tag: "Autocompasión",
                   text: "Tratarte a ti mismo con la misma amabilidad que le darías a un amigo en tu situación reduce la ansiedad más que cualquier autocrítica. La dureza no te hace más fuerte."),

        DatoDelDia(tag: "Ansiedad social",
                   text: "El 40% de las personas siente que la ansiedad social les limita en algún momento de su vida. No estás roto. Eres humano. Y esto tiene solución."),

        DatoDelDia(tag: "Neuroplasticidad",
                   text: "El cerebro adulto puede cambiar. Cada reto que completas crea nuevas conexiones neuronales. Con suficiente práctica, lo que hoy te paraliza mañana será automático."),

        DatoDelDia(tag: "El coste de evitar",
                   text: "Cada vez que evitas una situación por miedo, el precio que pagas no es solo ese momento. Es la historia que te cuentas sobre ti mismo: 'soy alguien que no puede'."),

        DatoDelDia(tag: "ACT",
                   text: "La Terapia de Aceptación y Compromiso propone algo contraintuitivo: no luches contra la ansiedad. Obsérvala, nómbrala, y actúa igual. El miedo no necesita desaparecer para que tú actúes."),

        DatoDelDia(tag: "El primer paso",
                   text: "El momento más difícil de cualquier reto es la anticipación. Una vez dentro de la situación, el 90% de las personas reporta que fue más fácil de lo esperado."),

        DatoDelDia(tag: "Identidad",
                   text: "Cada acción que tomas con miedo es un voto por el tipo de persona que quieres ser. La identidad se construye con acciones, no con intenciones."),

        DatoDelDia(tag: "Comparación",
                   text: "Compararte con quien parece no tener miedo es comparar tu interior con el exterior de otros. Todos tienen miedo. Los que actúan han decidido que el miedo no es una señal de stop."),

        DatoDelDia(tag: "Mindfulness",
                   text: "La ansiedad vive en el futuro. Cuando notas que tu mente está anticipando catástrofes, tráela al presente. ¿Qué está pasando ahora mismo, en este segundo?"),

        DatoDelDia(tag: "El error útil",
                   text: "Cometer un error social no te hace memorable de forma negativa. Las personas olvidan el 80% de las interacciones en 48 horas. Tú recuerdas el 100% de las tuyas."),

        DatoDelDia(tag: "Confort",
                   text: "La zona de confort no es un lugar seguro. Es un lugar donde dejas de crecer. Cada vez que la expandes, aunque sea un centímetro, te llevas ese centímetro para siempre."),

        DatoDelDia(tag: "Conexión",
                   text: "Las conexiones más profundas nacen de la autenticidad, no de la perfección. Cuando te muestras tal cual eres, das permiso a los demás para hacer lo mismo."),

        DatoDelDia(tag: "Ciencia del hábito",
                   text: "Se necesitan entre 21 y 66 días para que un comportamiento nuevo se vuelva automático. Los primeros días son los más difíciles. Después, el esfuerzo decrece exponencialmente."),

        DatoDelDia(tag: "Resiliencia",
                   text: "La resiliencia no se construye evitando el malestar. Se construye atravesándolo y descubriendo que puedes. Cada incomodidad superada te hace literalmente más resistente."),

        DatoDelDia(tag: "Terapia cognitiva",
                   text: "Los pensamientos automáticos negativos no son hechos. Son interpretaciones. Pregúntate: ¿qué evidencia tengo de que esto es verdad? Casi nunca hay respuesta."),

        DatoDelDia(tag: "El juicio ajeno",
                   text: "La mayoría de personas están demasiado preocupadas por su propia imagen para juzgarte a ti con detalle. El juicio que más te daña es el tuyo propio."),

        DatoDelDia(tag: "Progreso",
                   text: "El progreso en ansiedad social no es lineal. Habrá días malos. Lo que importa es la tendencia, no cada punto individual. Un paso atrás no borra los diez hacia adelante."),

        DatoDelDia(tag: "Dopamina",
                   text: "Completar algo que te daba miedo libera dopamina. Es el cerebro recompensándote por haber actuado. Con el tiempo, empezarás a buscar ese subidón."),

        DatoDelDia(tag: "Autenticidad",
                   text: "Intentar parecer lo que no eres consume energía enorme y da resultados pobres. Ser auténtico, aunque imperfecto, es siempre más eficiente y más magnético."),
    ]
}
