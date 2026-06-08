import Foundation

// MARK: - All Learning Content

enum GuiaContent {

    static let modules: [LearningModule] = [module1, module2, module3, module4, module5, module6]

    // MARK: - Módulo 1: Entender tu vergüenza

    static let module1 = LearningModule(
        id: "m1",
        title: "Entender tu vergüenza",
        subtitle: "Qué te pasa y por qué te pasa.",
        symbol: "brain.head.profile",
        colorHex: "4C9EEB",
        lessons: [
            Lesson(
                id: "m1l1",
                number: 1,
                title: "Qué es la vergüenza de verdad",
                body: "",
                keyInsight: "",
                scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "Qué es la vergüenza de verdad",
                        subtitle: "Empecemos por entender con qué estamos tratando realmente",
                        icon: "brain.head.profile"
                    ),
                    LessonScreenData(
                        type: .diagnostico,
                        title: "¿Cómo describirías mejor lo que sientes?",
                        choices: [
                            "Me pongo nervioso en situaciones sociales",
                            "Tengo miedo de que me juzguen mal",
                            "Creo que evito cosas por cómo me veo yo mismo",
                            "Siento que hay algo malo en mí que los demás notan"
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "No todo es lo mismo",
                        body: "Timidez, ansiedad social y vergüenza se confunden, pero funcionan de formas muy distintas. La timidez es una forma de ser: reservada, callada. La ansiedad social es el miedo a cómo te ven los demás en situaciones concretas. La vergüenza va un paso más allá.",
                        highlight: "La timidez habla de cómo eres. La ansiedad social habla de cómo te ven. La vergüenza habla de quién crees que eres."
                    ),
                    LessonScreenData(
                        type: .carrusel,
                        title: "Las diferencias que importan",
                        body: "Cada una opera en un nivel diferente.",
                        cards: [
                            LessonCard(
                                title: "Timidez",
                                body: "Una forma de ser. Reservada, callada. No es patológica ni necesariamente genera sufrimiento.",
                                icon: "person.fill"
                            ),
                            LessonCard(
                                title: "Ansiedad social",
                                body: "Miedo a la evaluación de los demás. Aparece en situaciones concretas y se puede trabajar con exposición.",
                                icon: "eye.fill"
                            ),
                            LessonCard(
                                title: "Vergüenza tóxica",
                                body: "La creencia de que hay algo fundamentalmente defectuoso en ti que los demás van a descubrir.",
                                icon: "exclamationmark.triangle.fill"
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "Lo que hace especial a la vergüenza",
                        body: "La vergüenza tóxica no es \"me da vergüenza haberme equivocado\". Es \"soy alguien que se equivoca, y eso confirma lo que ya sabía de mí\". No es una emoción que aparece y desaparece. Es una creencia que filtra todo.",
                        highlight: "La vergüenza no es una emoción puntual. Es la creencia de que hay algo fundamentalmente malo en ti que los demás ya han descubierto."
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿Cuál es vergüenza tóxica?",
                        body: "Toca los pensamientos que son vergüenza tóxica (creencias sobre lo que eres), no solo ansiedad situacional.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "Me pongo nervioso antes de hablar en público",
                                isCorrect: false,
                                explanation: "Eso es ansiedad situacional, no vergüenza tóxica. Es una reacción a una situación concreta."
                            ),
                            IdentifyOption(
                                text: "En el fondo soy aburrido y la gente lo nota",
                                isCorrect: true,
                                explanation: "Vergüenza tóxica: una creencia estable sobre tu valor como persona, no una situación puntual."
                            ),
                            IdentifyOption(
                                text: "Me cuesta llamar por teléfono a desconocidos",
                                isCorrect: false,
                                explanation: "Una dificultad situacional específica. Habla de lo que te cuesta, no de lo que eres."
                            ),
                            IdentifyOption(
                                text: "Si me conocieran de verdad, no les gustaría",
                                isCorrect: true,
                                explanation: "Vergüenza tóxica: la creencia de que tu yo real es defectuoso y hay que ocultarlo."
                            ),
                            IdentifyOption(
                                text: "Me pongo rojo cuando me hablan en grupo",
                                isCorrect: false,
                                explanation: "Una reacción física. No implica una creencia sobre tu valor como persona."
                            ),
                            IdentifyOption(
                                text: "Algo en mí siempre arruina las cosas",
                                isCorrect: true,
                                explanation: "Vergüenza tóxica: atribución interna, estable y global. El patrón más típico."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Lo que aprendiste",
                        keyPoints: [
                            "Timidez, ansiedad social y vergüenza tóxica no son lo mismo — operan en niveles distintos",
                            "La vergüenza tóxica es una creencia sobre quién eres, no sobre lo que sientes en un momento",
                            "Identificarla con precisión es el primer paso para empezar a cambiarla"
                        ]
                    ),
                    LessonScreenData(
                        type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Lección 1 de 5 · Módulo 1"
                    ),
                    LessonScreenData(
                        type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?"
                    )
                ]
            ),
            // m1l2 — Interacción principal: TABS (Antes / Ahora)
            // Arranque directo sin diagnóstico — el gancho histórico es el hook
            Lesson(
                id: "m1l2",
                number: 2,
                title: "Por qué tu cerebro quiere esconderte",
                body: "",
                keyInsight: "",
                scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "Por qué tu cerebro quiere esconderte",
                        subtitle: "Lo que llevas dentro no es un defecto — es prehistoria",
                        icon: "brain.head.profile"
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "Todo empezó hace 200.000 años",
                        body: "Ser rechazado por tu tribu era equivalente a morir. Sin grupo no había comida, ni protección, ni supervivencia. Tu cerebro desarrolló un sistema de alarma extremadamente sensible al rechazo social. Se llama amígdala.",
                        highlight: "La amígdala no distingue entre un león y una reunión incómoda. Activa la misma alarma para los dos."
                    ),
                    LessonScreenData(
                        type: .tabs,
                        title: "El mismo sistema, dos mundos distintos",
                        tabs: [
                            LessonTab(
                                title: "Hace 200.000 años",
                                body: "El rechazo social = muerte. Necesitabas a tu tribu para sobrevivir. Tu amígdala se calibró para detectar cualquier señal de exclusión y responder con alarma máxima. Era una ventaja evolutiva real."
                            ),
                            LessonTab(
                                title: "Hoy",
                                body: "El rechazo social ya no mata. Pero tu amígdala sigue igual de sensible. Cuando alguien te juzga en una reunión, activa la misma cascada de cortisol que ante un depredador. El sistema no se actualizó."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "Lo que pasa en tu cuerpo en milisegundos",
                        body: "Amígdala detecta amenaza social → libera adrenalina y cortisol → corazón se acelera, respiración se acorta, músculos se tensan, mente puede quedarse en blanco. Todo automático. Todo involuntario.",
                        highlight: "Tu vergüenza no es un defecto. Es tu sistema de supervivencia demasiado calibrado para un mundo que ya no existe."
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿Qué son síntomas de alarma evolutiva?",
                        body: "Toca las reacciones que son respuestas automáticas del sistema nervioso, no señales de que algo va mal en ti.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "La mente se queda en blanco cuando me hablan de improviso",
                                isCorrect: true,
                                explanation: "Respuesta automática del sistema nervioso. No es torpeza, es la amígdala cortando el acceso al córtex prefrontal."
                            ),
                            IdentifyOption(
                                text: "No me esfuerzo lo suficiente en situaciones sociales",
                                isCorrect: false,
                                explanation: "Eso es una interpretación sobre ti, no un síntoma fisiológico. La amígdala no produce falta de esfuerzo."
                            ),
                            IdentifyOption(
                                text: "Me ruborizo cuando me señalan delante de otros",
                                isCorrect: true,
                                explanation: "Respuesta vascular automática del sistema nervioso simpático. Completamente involuntaria."
                            ),
                            IdentifyOption(
                                text: "Soy demasiado tímido para este mundo",
                                isCorrect: false,
                                explanation: "Una creencia, no un síntoma. La timidez no es lo mismo que una respuesta de alarma evolutiva."
                            ),
                            IdentifyOption(
                                text: "El corazón se me dispara antes de hablar en grupo",
                                isCorrect: true,
                                explanation: "Respuesta simpática clásica: el corazón acelera para enviar sangre a los músculos ante la amenaza percibida."
                            ),
                            IdentifyOption(
                                text: "Me da vergüenza porque soy inseguro",
                                isCorrect: false,
                                explanation: "Otra interpretación, no un síntoma. La inseguridad es una historia sobre ti, no una reacción del sistema nervioso."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Lo que aprendiste",
                        keyPoints: [
                            "Tu amígdala es un sistema de supervivencia calibrado para amenazas que ya no existen",
                            "Las reacciones físicas que sientes son automáticas e involuntarias — no son defectos",
                            "Entender el origen de la alarma es el primer paso para dejar de creerla a ciegas"
                        ]
                    ),
                    LessonScreenData(
                        type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Lección 2 de 5 · Módulo 1"
                    ),
                    LessonScreenData(
                        type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?"
                    )
                ]
            ),

            // m1l3 — Interacción principal: CARRUSEL con ejemplos cotidianos sana vs tóxica
            // Empieza con diagnóstico introspectivo antes de la teoría
            Lesson(
                id: "m1l3",
                number: 3,
                title: "Cuándo la vergüenza te protege y cuándo te limita",
                body: "",
                keyInsight: "",
                scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "Cuándo te protege y cuándo te limita",
                        subtitle: "No toda vergüenza trabaja en tu contra",
                        icon: "shield.lefthalf.filled"
                    ),
                    LessonScreenData(
                        type: .diagnostico,
                        title: "¿Cuándo suele aparecer tu vergüenza?",
                        choices: [
                            "Cuando creo que he hecho algo mal o fallado a alguien",
                            "Siempre que hay gente mirando, aunque no haya hecho nada",
                            "Cuando alguien me critica, aunque sea con razón",
                            "En casi cualquier interacción social, sin razón clara"
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "Dos tipos de vergüenza",
                        body: "La vergüenza sana es proporcional y temporal: aparece cuando actúas contra tus valores, te avisa, y se va cuando corriges. La vergüenza tóxica es crónica y desproporcionada: no habla de lo que hiciste, habla de lo que eres.",
                        highlight: "La vergüenza sana te corrige. La tóxica te condena."
                    ),
                    LessonScreenData(
                        type: .carrusel,
                        title: "La diferencia en situaciones reales",
                        body: "La misma situación puede activar una u otra.",
                        cards: [
                            LessonCard(
                                title: "Interrumpir a alguien sin querer",
                                body: "Sana: \"Me disculpo y lo tengo en cuenta.\" Tóxica: \"Soy un desastre, siempre lo estropeo todo, seguro que ahora me odia.\"",
                                icon: "person.2.fill"
                            ),
                            LessonCard(
                                title: "Que no te salga bien algo en público",
                                body: "Sana: \"Me puse nervioso, la próxima vez me preparo mejor.\" Tóxica: \"Todo el mundo vio que soy un incompetente. Lo sabía.\"",
                                icon: "eye.fill"
                            ),
                            LessonCard(
                                title: "Que alguien no te responda un mensaje",
                                body: "Sana: \"Estará ocupado.\" Tóxica: \"Le caigo mal. Siempre acabo alejando a la gente de mí.\"",
                                icon: "message.fill"
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿Cuál es vergüenza tóxica?",
                        body: "Toca las reacciones que son vergüenza tóxica — las que hablan de lo que eres, no de lo que hiciste.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "\"Metí la pata. Tengo que disculparme.\"",
                                isCorrect: false,
                                explanation: "Vergüenza sana: proporcional, orientada a la acción, no cuestiona tu valor."
                            ),
                            IdentifyOption(
                                text: "\"Si me conocieran de verdad, se irían.\"",
                                isCorrect: true,
                                explanation: "Vergüenza tóxica: creencia global sobre tu yo, no sobre un acto concreto."
                            ),
                            IdentifyOption(
                                text: "\"No debí decir eso, fue un error.\"",
                                isCorrect: false,
                                explanation: "Vergüenza sana: habla de un comportamiento específico, no de lo que eres."
                            ),
                            IdentifyOption(
                                text: "\"Siempre arruino las cosas cuando importan.\"",
                                isCorrect: true,
                                explanation: "Vergüenza tóxica: generalización permanente sobre ti, no sobre el momento."
                            ),
                            IdentifyOption(
                                text: "\"Llegué tarde, tengo que avisarles.\"",
                                isCorrect: false,
                                explanation: "Respuesta proporcionada a un hecho. Sin condena sobre quien eres."
                            ),
                            IdentifyOption(
                                text: "\"La gente se da cuenta de lo raro que soy.\"",
                                isCorrect: true,
                                explanation: "Vergüenza tóxica: creencia de que hay algo visible y defectuoso en ti que los demás perciben."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Lo que aprendiste",
                        keyPoints: [
                            "La vergüenza sana habla de lo que hiciste. La tóxica habla de lo que eres",
                            "La vergüenza tóxica no desaparece cuando corriges algo — porque no es sobre el acto",
                            "Aprender a distinguirlas te da poder sobre cuál escuchas"
                        ]
                    ),
                    LessonScreenData(
                        type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Lección 3 de 5 · Módulo 1"
                    ),
                    LessonScreenData(
                        type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?"
                    )
                ]
            ),

            // m1l4 — Interacción principal: CARRUSEL de los 8 disparadores con iconos de la app
            // Más largo — termina con ejercicio de introspección sobre qué revelan
            Lesson(
                id: "m1l4",
                number: 4,
                title: "Tus disparadores",
                body: "",
                keyInsight: "",
                scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "Tus disparadores",
                        subtitle: "No son aleatorios — te dicen exactamente dónde trabajar",
                        icon: "bolt.fill"
                    ),
                    LessonScreenData(
                        type: .diagnostico,
                        title: "¿Cuál es tu mayor disparador ahora mismo?",
                        choices: [
                            "Hablar delante de grupos o en público",
                            "Situaciones románticas o de ligar",
                            "Llamadas telefónicas o interacciones inesperadas",
                            "Entrar a espacios donde no conozco a nadie"
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "¿Por qué no todos tienen los mismos?",
                        body: "Tu cerebro no activa la alarma en cualquier situación. La activa donde cree que el riesgo de evaluación negativa es más alto. Esas son exactamente las situaciones donde más te ha herido el rechazo, o donde más lo anticipas.",
                        highlight: "Tus disparadores no son aleatorios. Revelan exactamente qué tipo de juicio social te asusta más."
                    ),
                    LessonScreenData(
                        type: .carrusel,
                        title: "Los 8 disparadores más comunes",
                        body: "Desliza para reconocer los tuyos.",
                        cards: [
                            LessonCard(title: "Llamadas", body: "Hablar por teléfono con desconocidos o en situaciones donde no puedes ver la reacción del otro.", icon: "phone.fill"),
                            LessonCard(title: "Tiendas y servicios", body: "Pedir ayuda, reclamar o interactuar con empleados y cajeros.", icon: "bag.fill"),
                            LessonCard(title: "Grupos", body: "Entrar en una conversación ya formada o participar cuando hay varios presentes.", icon: "person.3.fill"),
                            LessonCard(title: "Citas y ligar", body: "Acercarte a alguien que te atrae o gestionar la posibilidad de rechazo romántico.", icon: "heart.fill"),
                            LessonCard(title: "Trabajo", body: "Opinar en reuniones, pedir algo al jefe, o interactuar con figuras de autoridad.", icon: "briefcase.fill"),
                            LessonCard(title: "Conocer gente", body: "Iniciar conversaciones con desconocidos o en eventos sociales sin estructura.", icon: "person.badge.plus"),
                            LessonCard(title: "Conflictos", body: "Decir que no, defender tu postura o manejar desacuerdos.", icon: "exclamationmark.bubble.fill"),
                            LessonCard(title: "Ser observado", body: "Comer, hablar o actuar cuando sientes que alguien te mira o te evalúa.", icon: "eye.fill")
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "Tus disparadores son pistas",
                        body: "Cada disparador señala una zona donde tu sistema de alarma está sobredimensionado. No son debilidades a esconder. Son el mapa exacto de donde tienes que ir.",
                        highlight: "No puedes enfrentarte a algo que no has nombrado. Nombrar tus disparadores es el primer acto de valentía."
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿Qué revela cada disparador?",
                        body: "Toca las afirmaciones que son verdaderas sobre cómo funcionan los disparadores.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "Tener muchos disparadores significa que tienes más ansiedad que otros",
                                isCorrect: false,
                                explanation: "Los disparadores no miden la cantidad de ansiedad — miden las áreas donde tu sistema de alarma aprendió a activarse."
                            ),
                            IdentifyOption(
                                text: "Mis disparadores me dicen dónde trabaja mi sistema de alarma",
                                isCorrect: true,
                                explanation: "Exacto. Son un mapa de las zonas donde la amígdala ha aprendido a reaccionar."
                            ),
                            IdentifyOption(
                                text: "Si evito mis disparadores, dejarán de afectarme",
                                isCorrect: false,
                                explanation: "Al contrario: la evitación refuerza el disparador. Solo la exposición gradual lo reduce."
                            ),
                            IdentifyOption(
                                text: "Los disparadores pueden cambiar con trabajo y exposición",
                                isCorrect: true,
                                explanation: "Sí. La terapia de exposición actúa directamente sobre los disparadores, reduciéndolos con el tiempo."
                            ),
                            IdentifyOption(
                                text: "Tener disparadores significa que eres más débil que los demás",
                                isCorrect: false,
                                explanation: "Todo el mundo tiene disparadores. La diferencia es el grado de activación y las áreas donde aparecen."
                            ),
                            IdentifyOption(
                                text: "Nombrar mis disparadores es el primer paso para trabajarlos",
                                isCorrect: true,
                                explanation: "Correcto. No puedes trabajar algo que no has identificado con precisión."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Lo que aprendiste",
                        keyPoints: [
                            "Tus disparadores son específicos y revelan dónde tu alarma está sobredimensionada",
                            "Evitarlos los refuerza — solo la exposición gradual los reduce",
                            "Nombrarlos con precisión es el primer paso real para trabajarlos"
                        ]
                    ),
                    LessonScreenData(
                        type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Lección 4 de 5 · Módulo 1"
                    ),
                    LessonScreenData(
                        type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?"
                    )
                ]
            ),

            // m1l5 — Interacción principal: TABS de los 4 componentes del ciclo
            // Lección de síntesis del módulo — más pantallas, más completa
            Lesson(
                id: "m1l5",
                number: 5,
                title: "Tu mapa personal de vergüenza",
                body: "",
                keyInsight: "",
                scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "Tu mapa personal de vergüenza",
                        subtitle: "Cuatro piezas que forman el círculo — y cómo romperlo",
                        icon: "map.fill"
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "Un círculo que se alimenta solo",
                        body: "Tu patrón de vergüenza no es aleatorio ni misterioso. Se puede mapear con exactitud usando cuatro componentes que se refuerzan entre sí. Entenderlos es la clave para interrumpirlos.",
                        highlight: "Tu patrón de vergüenza no es magia. Es un círculo que tú mismo alimentas cada día sin saberlo."
                    ),
                    LessonScreenData(
                        type: .tabs,
                        title: "Los cuatro componentes del ciclo",
                        tabs: [
                            LessonTab(
                                title: "Evitas",
                                body: "Las situaciones, personas y contextos que esquivas o de los que escapas antes de tiempo. Cada evitación le dice a tu cerebro: \"tenía razón en tener miedo\". El círculo se refuerza."
                            ),
                            LessonTab(
                                title: "Piensas",
                                body: "Antes: buscas peligros anticipando la situación. Durante: te monitorizas desde fuera mientras actúas, dividiendo tu atención. Después: rumias buscando pruebas de que lo hiciste mal."
                            ),
                            LessonTab(
                                title: "Sientes",
                                body: "Las sensaciones físicas: corazón acelerado, tensión, sudor, mente en blanco. Tu cerebro las interpreta como confirmación del peligro. \"Si siento tanto miedo, algo malo debe pasar.\""
                            ),
                            LessonTab(
                                title: "Haces",
                                body: "Las conductas de seguridad: mirar al suelo, hablar poco, ensayar en exceso, ir siempre acompañado, buscar validación. Alivian en el momento pero impiden aprender que no las necesitabas."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "La buena noticia",
                        body: "Los círculos se pueden romper. Y se pueden romper en cualquiera de sus cuatro puntos: cambiando lo que evitas, lo que piensas, cómo interpretas lo que sientes, o lo que haces. Esta app trabaja todos.",
                        highlight: "No necesitas arreglarlo todo a la vez. Un punto de entrada es suficiente para que el círculo empiece a aflojarse."
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿A qué parte del ciclo pertenece cada cosa?",
                        body: "Toca las conductas de seguridad — las acciones que alivian en el momento pero mantienen el miedo a largo plazo.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "Ensayar mentalmente lo que voy a decir antes de hablarlo",
                                isCorrect: true,
                                explanation: "Conducta de seguridad clásica. Alivia la ansiedad anticipatoria pero refuerza la creencia de que sin ensayo fallarás."
                            ),
                            IdentifyOption(
                                text: "Notar que el corazón se acelera antes de hablar",
                                isCorrect: false,
                                explanation: "Eso es una sensación del ciclo, no una conducta de seguridad. Las sensaciones son involuntarias."
                            ),
                            IdentifyOption(
                                text: "Ir siempre acompañado a eventos para no estar solo",
                                isCorrect: true,
                                explanation: "Conducta de seguridad: impide aprender que puedes manejarlo solo."
                            ),
                            IdentifyOption(
                                text: "Repasar la conversación después para ver qué salió mal",
                                isCorrect: false,
                                explanation: "Eso es rumiación post-evento — pertenece a la parte \"piensas\" del ciclo, no a las conductas."
                            ),
                            IdentifyOption(
                                text: "Evitar el contacto visual para no llamar la atención",
                                isCorrect: true,
                                explanation: "Conducta de seguridad: paradójicamente puede hacer que parezcas menos seguro, reforzando lo que temes."
                            ),
                            IdentifyOption(
                                text: "Sentir que la mente se queda en blanco de repente",
                                isCorrect: false,
                                explanation: "Una reacción involuntaria del sistema nervioso, no una conducta elegida. No es de seguridad."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Tienes el mapa completo",
                        keyPoints: [
                            "El ciclo tiene 4 puntos: lo que evitas, piensas, sientes y haces — todos se refuerzan entre sí",
                            "Las conductas de seguridad alivian a corto plazo pero mantienen el círculo vivo",
                            "En el próximo módulo aprenderás por qué evitar es la trampa más costosa del ciclo"
                        ]
                    ),
                    LessonScreenData(
                        type: .celebracion,
                        title: "¡Módulo 1 completado!",
                        body: "Has terminado \"Entender tu vergüenza\" 🧠"
                    ),
                    LessonScreenData(
                        type: .rating,
                        title: "¿Cuánto resuena este módulo contigo?"
                    )
                ]
            )
        ]
    )

    // MARK: - Módulo 2: La trampa de la evitación

    static let module2 = LearningModule(
        id: "m2",
        title: "La trampa de la evitación",
        subtitle: "Por qué evitar te da alivio corto pero te empeora a largo plazo.",
        symbol: "arrow.uturn.backward.circle",
        colorHex: "F97316",
        lessons: [

            // m2l1 — Interacción principal: TABS "Lo que parece / Lo que realmente pasa"
            Lesson(
                id: "m2l1",
                number: 1,
                title: "El alivio que te engaña",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "El alivio que te engaña",
                        subtitle: "Por qué la sensación de alivio es la trampa más cara que pagas",
                        icon: "arrow.uturn.backward.circle"
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "Evitar se siente bien. Por eso es peligroso.",
                        body: "Cuando evitas algo que te da miedo, la ansiedad baja inmediatamente. Tu cerebro registra: «evité → me siento bien → la evitación funciona». Eso se llama refuerzo negativo. Y es exactamente cómo se construye una trampa.",
                        highlight: "El alivio de la evitación es completamente real. Y completamente engañoso al mismo tiempo."
                    ),
                    LessonScreenData(
                        type: .tabs,
                        title: "Lo que parece vs lo que realmente pasa",
                        tabs: [
                            LessonTab(
                                title: "Lo que parece",
                                body: "Evitas → te alivias → tomaste la decisión correcta. Tu cerebro interpreta el alivio como confirmación de que el peligro era real y que escapar fue inteligente."
                            ),
                            LessonTab(
                                title: "Lo que pasa",
                                body: "Evitas → nunca descubres que no era tan peligroso → la próxima vez la alarma se activa igual o más fuerte. El miedo crece con cada evitación porque nunca recibe evidencia contraria."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "El ciclo en tres pasos",
                        body: "Evitar → alivio → refuerzo del miedo. El ciclo se repite hasta que el mundo de situaciones «seguras» se hace cada vez más pequeño. Cada evitación le dice a tu cerebro que tenía razón.",
                        highlight: "El alivio de la evitación es el anzuelo que mantiene el miedo atrapado en tu vida."
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿Qué describe el refuerzo negativo?",
                        body: "Toca las afirmaciones que explican correctamente cómo funciona la evitación.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "Evitar algo que da miedo hace que ese miedo desaparezca a largo plazo",
                                isCorrect: false,
                                explanation: "Al contrario: sin exposición, el cerebro nunca aprende que la situación era manejable. El miedo se mantiene o crece."
                            ),
                            IdentifyOption(
                                text: "El alivio que sientes al evitar refuerza el comportamiento de evitación",
                                isCorrect: true,
                                explanation: "Exacto. El alivio actúa como recompensa, haciendo más probable que evites la próxima vez."
                            ),
                            IdentifyOption(
                                text: "Si evito suficientes veces, mi cerebro aprenderá que no hay peligro",
                                isCorrect: false,
                                explanation: "Sin entrar en la situación, no hay información nueva. La evitación confirma el peligro en lugar de desmentirlo."
                            ),
                            IdentifyOption(
                                text: "La exposición gradual interrumpe el ciclo de refuerzo negativo",
                                isCorrect: true,
                                explanation: "Correcto. Entrar en la situación da al cerebro evidencia real de que puede manejarlo."
                            ),
                            IdentifyOption(
                                text: "Sentir alivio al evitar significa que tomaste la decisión correcta",
                                isCorrect: false,
                                explanation: "El alivio es una respuesta neuroquímica, no un juicio sobre si fue la decisión correcta."
                            ),
                            IdentifyOption(
                                text: "Cada evitación aumenta la probabilidad de evitar la próxima vez",
                                isCorrect: true,
                                explanation: "Sí. El patrón se refuerza con la repetición hasta que la evitación se vuelve automática."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Lo que aprendiste",
                        keyPoints: [
                            "El alivio de evitar es real pero engañoso — confirma el peligro en lugar de desmentirlo",
                            "El ciclo evitar → alivio → miedo reforzado se alimenta solo con cada repetición",
                            "La única forma de romperlo es entrar en la situación y obtener evidencia real"
                        ]
                    ),
                    LessonScreenData(type: .celebracion, title: "¡Lección completada!", body: "Lección 1 de 5 · Módulo 2"),
                    LessonScreenData(type: .rating, title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m2l2 — Interacción principal: CARRUSEL de conductas de seguridad
            Lesson(
                id: "m2l2",
                number: 2,
                title: "Las conductas que te hacen sentir seguro",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "Las conductas que te hacen sentir seguro",
                        subtitle: "Las muletas invisibles que impiden que aprendas que no las necesitas",
                        icon: "shield.slash.fill"
                    ),
                    LessonScreenData(
                        type: .diagnostico,
                        title: "¿Cuál usas más tú?",
                        choices: [
                            "Ensayo mentalmente lo que voy a decir antes de decirlo",
                            "Evito el contacto visual o miro el móvil",
                            "Voy siempre acompañado a eventos sociales",
                            "Hablo poco para pasar desapercibido"
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "¿Qué es una conducta de seguridad?",
                        body: "Son comportamientos que usas para reducir la ansiedad sin salir de la situación. En el momento alivian. A largo plazo impiden que aprendas algo fundamental: que podías con ello sin ellas.",
                        highlight: "Si terminas bien una situación y tienes una conducta de seguridad activa, la conducta se lleva el crédito, no tú."
                    ),
                    LessonScreenData(
                        type: .carrusel,
                        title: "Las más comunes — ¿reconoces alguna?",
                        body: "Desliza para verlas.",
                        cards: [
                            LessonCard(title: "Ensayar en exceso", body: "Preparar mentalmente cada frase antes de decirla. Alivia la anticipación pero hace que suenes artificial y te impide estar presente.", icon: "repeat"),
                            LessonCard(title: "Evitar el contacto visual", body: "Mirar al suelo, al teléfono, o a otro lado. Paradójicamente transmite exactamente la inseguridad que intentas esconder.", icon: "eye.slash.fill"),
                            LessonCard(title: "Ir siempre acompañado", body: "Nunca ir solo a eventos o situaciones nuevas. Impide construir la confianza de que puedes manejarlo por tu cuenta.", icon: "person.2.fill"),
                            LessonCard(title: "Hablar poco o muy despacio", body: "Minimizar tu presencia para no dar oportunidad de ser juzgado. Resulta en el efecto contrario: parecer distante o poco interesante.", icon: "speaker.slash.fill"),
                            LessonCard(title: "Chistes autodeprecativos", body: "Adelantarte al juicio burlándote de ti mismo. Alivio momentáneo, pero refuerza la imagen negativa que tienes de ti.", icon: "face.smiling")
                        ]
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿Cuáles son conductas de seguridad?",
                        body: "Toca las que son conductas de seguridad — comportamientos que reducen la ansiedad en el momento a costa del aprendizaje.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "Mirar el móvil cuando hay silencio incómodo",
                                isCorrect: true,
                                explanation: "Conducta de seguridad: evita tolerar la incomodidad del silencio e impide aprender a manejarlo."
                            ),
                            IdentifyOption(
                                text: "Sentir el corazón acelerado antes de hablar",
                                isCorrect: false,
                                explanation: "Una reacción fisiológica involuntaria, no un comportamiento elegido."
                            ),
                            IdentifyOption(
                                text: "Llegar tarde para no tener que hablar al entrar",
                                isCorrect: true,
                                explanation: "Conducta de seguridad: evita el momento de entrada que genera ansiedad, reforzando que es peligroso."
                            ),
                            IdentifyOption(
                                text: "Pensar «voy a hacerlo fatal» antes del evento",
                                isCorrect: false,
                                explanation: "Un pensamiento ansioso, no una conducta. Las conductas de seguridad son acciones, no pensamientos."
                            ),
                            IdentifyOption(
                                text: "Buscar la aprobación de alguien después de hablar",
                                isCorrect: true,
                                explanation: "Conducta de seguridad: la validación externa alivia temporalmente pero aumenta la dependencia de la aprobación ajena."
                            ),
                            IdentifyOption(
                                text: "Ruborizarse al ser presentado a alguien nuevo",
                                isCorrect: false,
                                explanation: "Reacción vascular involuntaria. No es una conducta elegida sino una respuesta del sistema nervioso."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Lo que aprendiste",
                        keyPoints: [
                            "Las conductas de seguridad alivian en el momento pero impiden el aprendizaje real",
                            "Cuando algo sale bien usándolas, la conducta se lleva el crédito — no tú",
                            "Reducirlas gradualmente es parte esencial del proceso de exposición"
                        ]
                    ),
                    LessonScreenData(type: .celebracion, title: "¡Lección completada!", body: "Lección 2 de 5 · Módulo 2"),
                    LessonScreenData(type: .rating, title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m2l3 — Interacción principal: TABS con las 3 fases (Antes / Durante / Después)
            Lesson(
                id: "m2l3",
                number: 3,
                title: "El sobreanálisis antes, durante y después",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "El sobreanálisis antes, durante y después",
                        subtitle: "La ansiedad social no ocurre solo en el momento — opera en tres fases",
                        icon: "clock.arrow.circlepath"
                    ),
                    LessonScreenData(
                        type: .diagnostico,
                        title: "¿Cuándo te afecta más?",
                        choices: [
                            "Anticipando la situación antes de que ocurra",
                            "Durante — pendiente de cómo me estoy viendo yo mismo",
                            "Después, repasando todo lo que pude hacer mal",
                            "Las tres fases me afectan por igual"
                        ]
                    ),
                    LessonScreenData(
                        type: .tabs,
                        title: "Las tres fases del sobreanálisis",
                        tabs: [
                            LessonTab(
                                title: "Antes",
                                body: "Tu mente ensaya el desastre: «¿y si no sé qué decir?», «¿y si me pongo rojo?». Esta anticipación dispara cortisol antes de que pase nada. Llegas a la situación ya activado."
                            ),
                            LessonTab(
                                title: "Durante",
                                body: "Procesamiento en dos canales: una parte actúa, otra parte te observa desde fuera evaluando cómo te ves. Esta división de atención reduce la calidad real de lo que haces — y aumenta los errores que temes."
                            ),
                            LessonTab(
                                title: "Después",
                                body: "Rumiación post-evento: repasas buscando evidencia de que lo hiciste mal. Magnificas los momentos incómodos, minimizas los que salieron bien. Concluyes que fue un desastre aunque no lo fuera."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "Parece prudente. Es una trampa.",
                        body: "El sobreanálisis se disfraza de preparación y autocrítica útil. Pero no te protege de errores. Los aumenta. Y mantiene la ansiedad activa entre situaciones, cuando deberías estar descansando.",
                        highlight: "Tu sobreanálisis no te protege. Te atrapa en un bucle que amplifica exactamente lo que quieres reducir."
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿A qué fase pertenece cada pensamiento?",
                        body: "Toca los pensamientos que son rumiación post-evento — los que ocurren DESPUÉS de la situación.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "«¿Por qué dije eso? Debí haberme callado.»",
                                isCorrect: true,
                                explanation: "Rumiación post-evento: revisar lo que pasó buscando pruebas de que lo hiciste mal."
                            ),
                            IdentifyOption(
                                text: "«¿Y si me quedo en blanco cuando me pregunten algo?»",
                                isCorrect: false,
                                explanation: "Eso es anticipación pre-evento — la fase «antes». Ocurre antes de la situación, no después."
                            ),
                            IdentifyOption(
                                text: "«Seguro que notaron que me puse nervioso.»",
                                isCorrect: true,
                                explanation: "Rumiación post-evento: interpretación retrospectiva de cómo te vieron los demás."
                            ),
                            IdentifyOption(
                                text: "«¿Estoy hablando demasiado rápido ahora mismo?»",
                                isCorrect: false,
                                explanation: "Eso es automonitoreo durante — la fase «mientras». Ocurre en tiempo real, no después."
                            ),
                            IdentifyOption(
                                text: "«Esa pausa que hice fue muy larga, quedé raro.»",
                                isCorrect: true,
                                explanation: "Rumiación post-evento: magnificar un momento específico que probablemente nadie recuerde."
                            ),
                            IdentifyOption(
                                text: "«Estoy sudando, lo van a notar.»",
                                isCorrect: false,
                                explanation: "Automonitoreo durante la situación — fase «durante», no «después»."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Lo que aprendiste",
                        keyPoints: [
                            "La ansiedad social opera en tres fases: anticipación, automonitoreo durante, y rumiación después",
                            "El sobreanálisis se disfraza de preparación pero amplifica la ansiedad en lugar de reducirla",
                            "Reconocer la fase en que estás es el primer paso para interrumpirla"
                        ]
                    ),
                    LessonScreenData(type: .celebracion, title: "¡Lección completada!", body: "Lección 3 de 5 · Módulo 2"),
                    LessonScreenData(type: .rating, title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m2l4 — Interacción principal: CARRUSEL con el efecto spotlight y datos reales
            Lesson(
                id: "m2l4",
                number: 4,
                title: "El miedo al juicio de los demás",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "El miedo al juicio de los demás",
                        subtitle: "El efecto spotlight: por qué crees que te miran mucho más de lo que te miran",
                        icon: "light.beacon.max.fill"
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "El experimento de la camiseta ridícula",
                        body: "En un estudio clásico, estudiantes llevaron camisetas con una imagen ridícula y predijeron que el 50% de sus compañeros las notarían. La cifra real: el 25%. Sobrestimamos el doble de cuánto nos observan.",
                        highlight: "Crees que estás bajo un foco. En realidad, cada persona está pendiente de su propio foco."
                    ),
                    LessonScreenData(
                        type: .carrusel,
                        title: "Por qué nos parece que nos miran tanto",
                        body: "Tres razones concretas.",
                        cards: [
                            LessonCard(
                                title: "Tu experiencia de ti mismo es muy vívida",
                                body: "Sabes exactamente cómo te sientes, qué llevas puesto, qué acabas de decir. Asumes que los demás tienen acceso a esa misma información. No la tienen.",
                                icon: "person.fill.viewfinder"
                            ),
                            LessonCard(
                                title: "Los demás están en su propio foco",
                                body: "Mientras tú te preocupas por cómo te ven, ellos están preocupados por cómo los ven a ellos. La atención de casi todo el mundo está orientada hacia dentro, no hacia ti.",
                                icon: "arrow.turn.left.up"
                            ),
                            LessonCard(
                                title: "La memoria social es muy corta",
                                body: "Incluso cuando algo incómodo ocurre, la gente lo olvida mucho antes de lo que crees. Tu cerebro lo recuerda durante días. El suyo, a menudo, durante minutos.",
                                icon: "clock.arrow.circlepath"
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "En personas con ansiedad social, el efecto es mayor",
                        body: "El efecto spotlight existe en todo el mundo, pero en personas con ansiedad social está amplificado. No porque tengan razón — sino porque su sistema de amenaza está más sensible a las señales de evaluación.",
                        highlight: "El público que temes es mucho menos crítico y atento de lo que tu ansiedad te hace creer."
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿Qué es efecto spotlight?",
                        body: "Toca las afirmaciones que describen correctamente cómo funciona el efecto spotlight.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "Las personas con ansiedad social son realmente más observadas por los demás",
                                isCorrect: false,
                                explanation: "No hay evidencia de esto. El efecto spotlight es una sobrestimación subjetiva, no una diferencia real en cuánto te observan."
                            ),
                            IdentifyOption(
                                text: "Sobrestimamos sistemáticamente cuánto nos notan y nos juzgan",
                                isCorrect: true,
                                explanation: "Correcto. Estudios repetidos muestran que la cifra real siempre es significativamente menor que la predicha."
                            ),
                            IdentifyOption(
                                text: "Si me pongo rojo en público, todos lo recordarán mañana",
                                isCorrect: false,
                                explanation: "La memoria social es muy corta. Lo que para ti es un momento memorable, para los demás suele olvidarse en minutos."
                            ),
                            IdentifyOption(
                                text: "Los demás están tan pendientes de sí mismos como yo de mí mismo",
                                isCorrect: true,
                                explanation: "Exacto. El efecto spotlight es universal: todo el mundo cree que está más en el centro de atención de lo que está."
                            ),
                            IdentifyOption(
                                text: "Sentir que te miran significa que efectivamente te están mirando",
                                isCorrect: false,
                                explanation: "La sensación de ser observado es subjetiva y no correlaciona necesariamente con ser observado de verdad."
                            ),
                            IdentifyOption(
                                text: "El efecto spotlight se reduce cuando se aprende a descentrar la atención de uno mismo",
                                isCorrect: true,
                                explanation: "Correcto. Las técnicas cognitivas que redirigen la atención hacia fuera reducen la intensidad del efecto spotlight."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Lo que aprendiste",
                        keyPoints: [
                            "El efecto spotlight: sobrestimamos el doble de cuánto nos observan y recuerdan",
                            "Los demás están tan pendientes de sí mismos como tú de ti — no hay audiencia crítica esperándote",
                            "La sensación de ser observado es subjetiva, no una medición real de cuánto te miran"
                        ]
                    ),
                    LessonScreenData(type: .celebracion, title: "¡Lección completada!", body: "Lección 4 de 5 · Módulo 2"),
                    LessonScreenData(type: .rating, title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m2l5 — Interacción principal: TABS mostrando la espiral de evitación
            // Lección de cierre del módulo — impacto emocional alto
            Lesson(
                id: "m2l5",
                number: 5,
                title: "Cómo la evitación va encogiendo tu mundo",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(
                        type: .intro,
                        title: "Cómo la evitación encoge tu mundo",
                        subtitle: "Lo que empieza pequeño acaba siendo una vida entera más estrecha",
                        icon: "arrow.down.right.and.arrow.up.left"
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "La evitación no se queda quieta",
                        body: "La evitación no es estática. Crece. Empieza en situaciones concretas y con el tiempo se generaliza a áreas que antes no te daban miedo. El mundo seguro se hace más pequeño sin que lo notes.",
                        highlight: "La evitación te protege del miedo hoy. Pero roba tu vida mañana."
                    ),
                    LessonScreenData(
                        type: .tabs,
                        title: "Cómo se generaliza con el tiempo",
                        tabs: [
                            LessonTab(
                                title: "Al principio",
                                body: "Evitas una cosa específica. Una llamada, un evento donde no conoces a nadie, hablar en una reunión. Parece razonable y manejable. El resto de tu vida sigue igual."
                            ),
                            LessonTab(
                                title: "Con el tiempo",
                                body: "El patrón se expande. Evitas categorías enteras. Tu trabajo se limita porque evitas ciertas interacciones. Tus relaciones se vuelven más superficiales porque la intimidad da miedo. Las oportunidades pasan sin que las aproveches."
                            ),
                            LessonTab(
                                title: "El coste real",
                                body: "Un día miras atrás y te preguntas cuándo dejaste de hacer las cosas que antes hacías. La evitación no solo mantuvo el miedo — se convirtió en parte de tu identidad. «Soy alguien que no puede hacer esto.»"
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .teoria,
                        title: "La buena noticia",
                        body: "La identidad también se cambia. Y se cambia exactamente como se construyó: con acciones repetidas. Cada vez que entras en una situación que antes evitabas, te estás diciendo a ti mismo algo distinto.",
                        highlight: "No necesitas cambiar todo a la vez. Una acción pequeña y consistente es suficiente para que empiece a cambiar quién crees que eres."
                    ),
                    LessonScreenData(
                        type: .ejercicioIdentifica,
                        title: "¿Qué describe la generalización de la evitación?",
                        body: "Toca las afirmaciones que explican correctamente cómo la evitación se expande con el tiempo.",
                        identifyOptions: [
                            IdentifyOption(
                                text: "La evitación puede pasar de situaciones concretas a áreas enteras de la vida",
                                isCorrect: true,
                                explanation: "Correcto. La investigación muestra que la evitación no específica tiende a generalizarse progresivamente."
                            ),
                            IdentifyOption(
                                text: "Si evito las situaciones difíciles suficiente tiempo, acabarán sin importarme",
                                isCorrect: false,
                                explanation: "Sin exposición, el miedo se mantiene o crece. La indiferencia no viene de la evitación, sino de la exposición repetida."
                            ),
                            IdentifyOption(
                                text: "Cada evitación refuerza la creencia de que no puedo manejar esa situación",
                                isCorrect: true,
                                explanation: "Exacto. La evitación no es solo un comportamiento — se convierte en una historia sobre lo que eres capaz de hacer."
                            ),
                            IdentifyOption(
                                text: "La evitación solo afecta a las situaciones que evito, no a otras",
                                isCorrect: false,
                                explanation: "Estudios muestran que la evitación se generaliza a áreas relacionadas, aumentando progresivamente la restricción de vida."
                            ),
                            IdentifyOption(
                                text: "Reducir la evitación, incluso en pasos pequeños, genera mejoras reales en el bienestar",
                                isCorrect: true,
                                explanation: "Correcto. La investigación muestra mejoras significativas incluso con exposiciones graduales y modestas."
                            ),
                            IdentifyOption(
                                text: "Una vez que la evitación forma parte de mi identidad, es muy difícil de cambiar",
                                isCorrect: false,
                                explanation: "La identidad se construye con acciones repetidas — y se cambia igual. Acciones pequeñas y consistentes la reescriben."
                            )
                        ]
                    ),
                    LessonScreenData(
                        type: .resumen,
                        title: "Tienes el Módulo 2 completo",
                        keyPoints: [
                            "La evitación no es estática — crece y se generaliza a áreas enteras de tu vida",
                            "Con el tiempo, la evitación deja de ser un comportamiento y se convierte en identidad",
                            "Cada acción pequeña que contradice la evitación reescribe esa identidad"
                        ]
                    ),
                    LessonScreenData(type: .celebracion, title: "¡Módulo 2 completado!", body: "Has terminado \"La trampa de la evitación\" 🔄"),
                    LessonScreenData(type: .rating, title: "¿Cuánto resuena este módulo contigo?")
                ]
            )
        ]
    )

    // MARK: - Módulo 3: Calmar tu mente y tu cuerpo

    static let module3 = LearningModule(
        id: "m3",
        title: "Calmar tu mente y tu cuerpo",
        subtitle: "Herramientas reales para gestionar la ansiedad cuando llega.",
        symbol: "lungs.fill",
        colorHex: "10B981",
        lessons: [

            // m3l1 — CARRUSEL: síntomas físicos + función evolutiva
            Lesson(
                id: "m3l1",
                number: 1,
                title: "Qué le pasa a tu cuerpo cuando te bloqueas",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Qué le pasa a tu cuerpo",
                        subtitle: "Cada síntoma tiene una razón. Entenderla cambia cómo lo vives.",
                        icon: "lungs.fill"),
                    LessonScreenData(type: .teoria,
                        title: "No estás reaccionando mal",
                        body: "Cuando tu cerebro detecta una amenaza social, activa el mismo sistema de emergencia que usarías ante un depredador. La amígdala dispara la adrenalina en milisegundos.",
                        highlight: "Tu cuerpo no sabe distinguir entre un tigre y una evaluación social. Reacciona igual a los dos."),
                    LessonScreenData(type: .carrusel,
                        title: "Lo que sientes y por qué",
                        cards: [
                            LessonCard(title: "El corazón se dispara", body: "Necesita llevar sangre a los músculos rápido. Fue útil para correr. En una reunión, solo se nota.", icon: "heart.fill"),
                            LessonCard(title: "La voz tiembla", body: "Las cuerdas vocales se tensan por el cortisol. No es un signo de debilidad. Es química pura.", icon: "waveform"),
                            LessonCard(title: "La mente se queda en blanco", body: "El córtex prefrontal (pensamiento racional) se desconecta parcialmente. El modo supervivencia no necesita razonar, necesita actuar.", icon: "brain"),
                            LessonCard(title: "Te ruborizas o palideces", body: "La sangre se redistribuye. Unos se enrojecen (vasodilatación), otros palidecen (vasoconstricción). Ambas son respuestas normales.", icon: "face.smiling"),
                            LessonCard(title: "Los músculos se tensan", body: "Tu cuerpo se prepara para golpear o huir. En una conversación no sirve de nada, pero el sistema no lo sabe.", icon: "figure.strengthtraining.traditional"),
                            LessonCard(title: "Respiras más rápido", body: "Necesitas más oxígeno para actuar. La respiración superficial es señal de alarma. Controlarla es la palanca más directa que tienes.", icon: "wind")
                        ]),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Cuáles son síntomas de ansiedad social?",
                        identifyOptions: [
                            IdentifyOption(text: "Corazón acelerado antes de hablar", isCorrect: true, explanation: "Respuesta clásica del sistema simpático."),
                            IdentifyOption(text: "Emoción cuando algo sale bien", isCorrect: false, explanation: "Eso es alegría, no ansiedad."),
                            IdentifyOption(text: "Mente en blanco al presentar", isCorrect: true, explanation: "El córtex prefrontal se desconecta bajo estrés."),
                            IdentifyOption(text: "Voz temblorosa al conocer alguien", isCorrect: true, explanation: "Las cuerdas vocales reaccionan al cortisol."),
                            IdentifyOption(text: "Cansancio después de entrenar", isCorrect: false, explanation: "Eso es fatiga física, no ansiedad social."),
                            IdentifyOption(text: "Cara roja en situaciones de atención", isCorrect: true, explanation: "El rubor es una respuesta vascular involuntaria.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "Tus síntomas físicos tienen una función evolutiva real.",
                            "No estás reaccionando mal — estás reaccionando exactamente como fuiste diseñado.",
                            "Entender qué pasa en tu cuerpo reduce su poder sobre ti."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Ahora sabes lo que pasa dentro. Eso ya es una ventaja."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m3l2 — TABS: respiración en caja, cada tab = una fase
            Lesson(
                id: "m3l2",
                number: 2,
                title: "La respiración que calma el sistema nervioso",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "La respiración de caja",
                        subtitle: "La única palanca voluntaria sobre tu sistema nervioso automático.",
                        icon: "square"),
                    LessonScreenData(type: .diagnostico,
                        title: "¿Cuándo sueles notar más la ansiedad física?",
                        choices: [
                            "Justo antes de entrar en una situación",
                            "Durante la situación cuando algo va diferente de lo esperado",
                            "Después, revisando mentalmente lo que pasó",
                            "Es bastante constante durante el día"
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "Por qué funciona respirar despacio",
                        body: "La exhalación lenta activa el nervio vago, el \"freno\" del sistema nervioso. En segundos, el corazón se ralentiza y la activación baja. Los Navy SEALs la usan antes de operaciones de alto riesgo.",
                        highlight: "La respiración es el único mecanismo involuntario que también puedes controlar. Eso la convierte en una palanca directa."),
                    LessonScreenData(type: .tabs,
                        title: "Las 4 fases — toca cada una",
                        tabs: [
                            LessonTab(title: "Inhala", body: "Inhala lentamente por la nariz durante 4 segundos. Llena los pulmones desde abajo. Siente cómo el abdomen se expande antes que el pecho."),
                            LessonTab(title: "Aguanta", body: "Retén el aire 4 segundos. Sin tensión. Simplemente sostén. Este momento le da al sistema nervioso una señal de calma."),
                            LessonTab(title: "Exhala", body: "Exhala por la boca durante 4 segundos, lentamente. La exhalación lenta es la clave — activa el nervio vago directamente."),
                            LessonTab(title: "Pausa", body: "Aguanta sin aire 4 segundos antes de volver a inhalar. Repite el ciclo 5 veces para sentir el efecto completo.")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "Úsala antes del pico, no en él",
                        body: "Si esperas a estar en pánico total, cuesta más. La respiración de caja es más efectiva cuando la activas al notar los primeros síntomas.",
                        highlight: "Un ciclo de 5 respiraciones tarda menos de 2 minutos. Hazlo antes de una situación difícil."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Cuándo tiene más sentido usarla?",
                        identifyOptions: [
                            IdentifyOption(text: "5 minutos antes de una reunión importante", isCorrect: true, explanation: "Ideal: actúa preventivamente antes de que la activación suba."),
                            IdentifyOption(text: "Mientras conduces distraído", isCorrect: false, explanation: "No en situaciones donde necesitas toda la atención."),
                            IdentifyOption(text: "Al notar el corazón acelerado antes de hablar", isCorrect: true, explanation: "Perfecta para interceptar la respuesta de estrés al inicio."),
                            IdentifyOption(text: "Cuando ya estás en pánico total", isCorrect: false, explanation: "Puede ayudar, pero funciona mejor antes del pico."),
                            IdentifyOption(text: "Antes de mandar un mensaje difícil", isCorrect: true, explanation: "Cualquier situación de activación moderada es un buen momento.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "La exhalación lenta activa el nervio vago y baja la activación.",
                            "4 segundos × 4 fases × 5 ciclos. Menos de 2 minutos.",
                            "Úsala cuando notes los primeros síntomas, no cuando ya estás en pánico."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Ahora tienes una herramienta que funciona en segundos."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m3l3 — CARRUSEL: pares pensamiento ansioso → reencuadre realista
            Lesson(
                id: "m3l3",
                number: 3,
                title: "Qué hacer con los pensamientos que te hunden",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Reestructuración cognitiva",
                        subtitle: "No es sustituir lo negativo por positivo falso. Es mucho más útil que eso.",
                        icon: "arrow.triangle.2.circlepath"),
                    LessonScreenData(type: .teoria,
                        title: "Los pensamientos ansiosos son hipótesis",
                        body: "Cuando piensas \"voy a quedar fatal\", no es un hecho. Es una predicción. Tu cerebro ansioso trata las predicciones como certezas. El trabajo es tratarlas como lo que son.",
                        highlight: "Un pensamiento ansioso no es verdad solo porque lo sientas con mucha intensidad."),
                    LessonScreenData(type: .carrusel,
                        title: "Del pensamiento al reencuadre",
                        cards: [
                            LessonCard(title: "\"Voy a quedar en blanco\"", body: "Reencuadre: He tenido momentos de mente en blanco antes y he salido adelante. Puedo pausar, respirar, y continuar. El silencio de 3 segundos es menos visible de lo que creo.", icon: "bubble.left"),
                            LessonCard(title: "\"Todos se darán cuenta de que estoy nervioso\"", body: "Reencuadre: Las investigaciones muestran que sobreestimamos cuánto notan los demás nuestros síntomas. Y aunque noten algo, nerviosismo no es incompetencia.", icon: "eye"),
                            LessonCard(title: "\"Si digo algo raro nadie querrá hablar conmigo\"", body: "Reencuadre: Las personas socialmente seguras también dicen cosas raras. La diferencia es que no le dan vueltas. Decir algo torpe no es el fin de nada.", icon: "person.2")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "Las preguntas que ponen a prueba el pensamiento",
                        body: "¿Cuántas veces ha pasado esto antes? ¿Qué evidencia real tengo? ¿Qué le diría a un amigo que pensara esto? ¿Qué es lo peor real que podría pasar?",
                        highlight: "No buscas el pensamiento positivo. Buscas el pensamiento más honesto y preciso posible."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Cuál es un reencuadre realista?",
                        identifyOptions: [
                            IdentifyOption(text: "\"Soy el mejor en esto\"", isCorrect: false, explanation: "Eso es positividad tóxica. Tu cerebro no lo cree."),
                            IdentifyOption(text: "\"He sobrevivido a situaciones similares antes\"", isCorrect: true, explanation: "Evidencia real de tu capacidad. Eso sí funciona."),
                            IdentifyOption(text: "\"No pasa nada, no importa\"", isCorrect: false, explanation: "Minimizar también es evitación. Valida la dificultad."),
                            IdentifyOption(text: "\"Estaré nervioso y aun así puedo hacerlo\"", isCorrect: true, explanation: "Honesto y orientado a la acción. Exactamente esto."),
                            IdentifyOption(text: "\"Todo va a salir perfecto\"", isCorrect: false, explanation: "Tu cerebro lo detecta como falso y lo rechaza."),
                            IdentifyOption(text: "\"La probabilidad de catástrofe real es baja\"", isCorrect: true, explanation: "Poner a prueba la predicción con probabilidad real.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "Los pensamientos ansiosos son predicciones, no hechos. Tratalos como hipótesis.",
                            "El reencuadre no busca lo positivo — busca lo más preciso y honesto.",
                            "Cuatro preguntas: ¿evidencia real? ¿probabilidad? ¿qué pasaría si ocurre? ¿qué le diría a un amigo?"
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Ahora tienes las preguntas que desmontan los pensamientos que te bloquean."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m3l4 — TABS: positividad tóxica vs autocompasión real
            Lesson(
                id: "m3l4",
                number: 4,
                title: "Cómo hablarte mejor sin mentirte",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Autocompasión sin positivismo tóxico",
                        subtitle: "Hay una diferencia enorme entre los dos. Y tu cerebro distingue perfectamente cuál es cuál.",
                        icon: "heart.text.square"),
                    LessonScreenData(type: .diagnostico,
                        title: "¿Cómo sueles hablarte cuando metes la pata en algo social?",
                        choices: [
                            "Me machaco bastante — soy muy crítico conmigo mismo",
                            "Intento ignorarlo y pasar página rápido",
                            "Me digo que no pasa nada aunque por dentro sigo dándole vueltas",
                            "Intento entender qué pasó sin dramatizar"
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "Tu cerebro detecta las mentiras",
                        body: "Cuando te dices \"¡eres increíble, todo irá perfecto!\", tu cerebro compara eso con la experiencia real que tienes. Si no encaja, lo rechaza. La positividad vacía no solo no ayuda — a veces empeora la ansiedad.",
                        highlight: "La autocompasión no niega la dificultad. La valida y añade confianza real en tu capacidad."),
                    LessonScreenData(type: .tabs,
                        title: "Compara las dos formas de hablarte",
                        tabs: [
                            LessonTab(title: "Positividad tóxica", body: "\"¡No pasa nada! ¡Eres genial! ¡Todo va a salir perfecto! ¡No tienes por qué estar nervioso!\"\n\nTu cerebro lo detecta como falso. No corresponde con lo que sientes. Genera más distancia contigo mismo y a veces más vergüenza por no estar a la altura del optimismo forzado."),
                            LessonTab(title: "Autocompasión real", body: "\"Esto es difícil. Es normal que esté nervioso. He pasado por situaciones difíciles antes y he salido. Si sale mal, no me define. Puedo hacerlo aunque no sea perfecto.\"\n\nValida la dificultad sin magnificarla. Da al cerebro una narrativa honesta que puede aceptar y usar.")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "Habla contigo como hablarías con un buen amigo",
                        body: "¿Qué le dirías a alguien que quieres si estuviera nervioso antes de una situación social? Probablemente algo honesto, amable y que le diera fuerza real. Mereces lo mismo.",
                        highlight: "La autocompasión no es una excusa. Es el combustible que te permite actuar a pesar del miedo."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Cuál es autocompasión real?",
                        identifyOptions: [
                            IdentifyOption(text: "\"Voy a hacerlo perfecto, no me preocupo\"", isCorrect: false, explanation: "Niega la dificultad. Positividad tóxica."),
                            IdentifyOption(text: "\"Es normal estar nervioso en esto\"", isCorrect: true, explanation: "Valida la experiencia sin magnificarla."),
                            IdentifyOption(text: "\"No debería sentirme así, soy un desastre\"", isCorrect: false, explanation: "Autocrítica que amplifica la ansiedad."),
                            IdentifyOption(text: "\"He pasado por cosas difíciles y he salido\"", isCorrect: true, explanation: "Evidencia real de resiliencia. Eso sí funciona."),
                            IdentifyOption(text: "\"Simplemente no pienso en ello\"", isCorrect: false, explanation: "Supresión. El pensamiento vuelve con más fuerza."),
                            IdentifyOption(text: "\"Puedo hacerlo aunque no salga perfecto\"", isCorrect: true, explanation: "Orientado a la acción y honesto. Exactamente esto.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "La positividad tóxica no encaja con la realidad y el cerebro la rechaza.",
                            "La autocompasión valida la dificultad y añade confianza real en tu capacidad.",
                            "Habla contigo como hablarías con alguien que quieres de verdad."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Tu voz interna es una herramienta. Ahora sabes cómo usarla bien."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m3l5 — TABS: 3 pasos tolerar malestar — cierre módulo 3
            Lesson(
                id: "m3l5",
                number: 5,
                title: "Aprender a aguantar la incomodidad",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Tolerar el malestar",
                        subtitle: "La incomodidad que aguantas hoy es la libertad que ganas mañana.",
                        icon: "mountain.2"),
                    LessonScreenData(type: .teoria,
                        title: "El malestar no es peligroso",
                        body: "La ansiedad sigue una curva: sube, llega a un pico y luego baja por sí sola si no escapas. Cada vez que te quedas y atraviesas esa curva, tu sistema nervioso aprende que puede manejarlo.",
                        highlight: "Escapar enseña que era peligroso. Quedarte enseña que no lo era."),
                    LessonScreenData(type: .tabs,
                        title: "Los 3 pasos cuando quieres escapar",
                        tabs: [
                            LessonTab(title: "Acepta", body: "No pelees contra la incomodidad — eso solo la amplifica. Di interiormente: \"esto es incómodo y está bien que lo sea\". Aceptar no es rendirse, es dejar de gastar energía en la resistencia."),
                            LessonTab(title: "Observa", body: "Nombra exactamente qué sientes y dónde. ¿Tensión en el pecho? ¿Calor en la cara? ¿Nudo en el estómago? Nombrar las sensaciones activa el córtex prefrontal y reduce su intensidad."),
                            LessonTab(title: "Actúa", body: "No tienes que hacer nada perfecto. Solo quedarte y hacer algo pequeño. Una pregunta. Una frase. Una mirada. La acción mínima le dice a tu cerebro: \"sobreviví y actué\".")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "Lo que pasa cuando no huyes",
                        body: "Cuando haces algo que te da vergüenza sin escapar, tu cerebro aprende algo nuevo: \"puedo sentir ansiedad y seguir a salvo\". A veces la ansiedad baja rápido; otras tarda más. Lo importante no es que desaparezca al instante, sino que compruebes que no necesitas obedecerla.",
                        highlight: "Cada vez que no huyes, tu cerebro guarda una prueba nueva: \"puedo con esto\". Esa prueba compite con el miedo y se hace más fuerte con la práctica."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Cuál es tolerar el malestar?",
                        identifyOptions: [
                            IdentifyOption(text: "Salir de la situación cuando la ansiedad sube", isCorrect: false, explanation: "Eso es evitación. Le dice al cerebro que era peligroso."),
                            IdentifyOption(text: "Nombrar exactamente dónde sientes la tensión", isCorrect: true, explanation: "Observar las sensaciones activa el córtex prefrontal."),
                            IdentifyOption(text: "Mirar el móvil para distraerse", isCorrect: false, explanation: "Conducta de seguridad. Evita la experiencia completa."),
                            IdentifyOption(text: "Quedarte aunque la incomodidad suba al principio", isCorrect: true, explanation: "La ansiedad siempre baja si no escapas. Esto lo demuestra."),
                            IdentifyOption(text: "Aceptar que va a ser incómodo sin pelear contra eso", isCorrect: true, explanation: "Aceptar reduce la resistencia y el gasto de energía."),
                            IdentifyOption(text: "Convencerte de que no te pasa nada", isCorrect: false, explanation: "Supresión cognitiva. No funciona a largo plazo.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "La ansiedad tiene un techo: siempre baja si no escapas.",
                            "Tres pasos: Acepta la incomodidad, Observa sin juzgar, Actúa con algo pequeño.",
                            "Tienes el Módulo 3 completo. Ahora tienes las herramientas para gestionar lo que sientes."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Módulo 3 completado!",
                        body: "Conoces tu cuerpo, tienes herramientas de respiración, de pensamiento y de acción."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena este módulo contigo?")
                ]
            )
        ]
    )

    // MARK: - Módulo 4: Exponerte y ganar terreno

    static let module4 = LearningModule(
        id: "m4",
        title: "Exponerte y ganar terreno",
        subtitle: "Pasar a la acción con una estrategia que funciona.",
        symbol: "figure.walk.motion",
        colorHex: "F59E0B",
        lessons: [

            // m4l1 — CARRUSEL: qué pasa en el cerebro con la exposición
            Lesson(
                id: "m4l1",
                number: 1,
                title: "La ciencia detrás de exponerte",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "La ciencia de la exposición",
                        subtitle: "Por qué enfrentarse al miedo funciona — y por qué evitarlo no.",
                        icon: "figure.walk.motion"),
                    LessonScreenData(type: .teoria,
                        title: "El cerebro aprende por experiencia, no por lógica",
                        body: "Saber que no es peligroso no es suficiente. Tu cerebro ansioso no cree en argumentos — cree en evidencia vivida. La exposición es la forma de darle esa evidencia.",
                        highlight: "No puedes pensar que salgas del miedo. Tienes que actuar para salir de él."),
                    LessonScreenData(type: .carrusel,
                        title: "Lo que pasa en tu cerebro con cada exposición",
                        cards: [
                            LessonCard(title: "1. Tu amígdala dispara la alarma", body: "La amígdala detecta la situación temida y activa la respuesta de estrés. Es automática e instantánea. No la puedes apagar con la mente.", icon: "bolt.fill"),
                            LessonCard(title: "2. Tu cuerpo se prepara para huir", body: "Adrenalina, corazón acelerado, músculos tensos. Todo el sistema de emergencia se activa. Aquí es donde la mayoría escapa.", icon: "arrow.up.right"),
                            LessonCard(title: "3. Si te quedas, el cortex toma el control", body: "El córtex prefrontal empieza a procesar la situación racionalmente. La activación baja. Tu cerebro registra: \"sobreviví, no era tan peligroso\".", icon: "checkmark.shield"),
                            LessonCard(title: "4. Se crea una nueva asociación", body: "Esto se llama aprendizaje de extinción. Tu cerebro no borra el miedo, pero crea una memoria nueva que compite con él: \"esta situación es manejable\".", icon: "plus.circle")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "Cada exposición es una actualización del sistema",
                        body: "No buscas que la ansiedad desaparezca de golpe. Buscas acumular evidencia de que puedes manejarla. Exposición tras exposición, esa evidencia se acumula.",
                        highlight: "La exposición gradual es la intervención con más evidencia científica para la ansiedad social. No hay alternativa más efectiva."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Qué refuerza el miedo y qué lo reduce?",
                        identifyOptions: [
                            IdentifyOption(text: "Salir de una situación cuando la ansiedad sube", isCorrect: false, explanation: "Evitación. Le enseña al cerebro que era peligroso."),
                            IdentifyOption(text: "Quedarte aunque la ansiedad suba al inicio", isCorrect: true, explanation: "Exposición. Permite que el cerebro actualice la amenaza."),
                            IdentifyOption(text: "Hacer pequeñas acciones en situaciones difíciles", isCorrect: true, explanation: "Microexposición. Acumula evidencia de que puedes manejarlo."),
                            IdentifyOption(text: "Evitar situaciones que antes salieron mal", isCorrect: false, explanation: "Generaliza el miedo a más situaciones."),
                            IdentifyOption(text: "Repetir exposiciones aunque sean incómodas", isCorrect: true, explanation: "La repetición es lo que consolida el aprendizaje de extinción.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "El cerebro aprende por experiencia vivida, no por argumentos lógicos.",
                            "La exposición crea una memoria nueva que compite con el miedo.",
                            "Cada exposición, aunque incómoda, actualiza el sistema de amenaza del cerebro."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Ahora entiendes el mecanismo. Ahora sí tiene sentido el siguiente paso."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m4l2 — TABS: cómo usar SUDS antes/durante/después
            Lesson(
                id: "m4l2",
                number: 2,
                title: "Tu brújula de ansiedad: la escala SUDS",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "La escala SUDS",
                        subtitle: "Una forma objetiva de medir tu ansiedad y tomar mejores decisiones.",
                        icon: "gauge.with.needle"),
                    LessonScreenData(type: .teoria,
                        title: "¿Qué es el SUDS?",
                        body: "SUDS (Subjective Units of Distress Scale) es una escala del 0 al 100 que mide tu nivel de activación en cualquier momento. 0 es calma total, 100 es el peor miedo que puedes imaginar.",
                        highlight: "Medir la ansiedad la hace menos abrumadora. Lo que tiene número ya no es un monstruo descontrolado."),
                    LessonScreenData(type: .tabs,
                        title: "Cómo usar el SUDS en cada momento",
                        tabs: [
                            LessonTab(title: "Antes", body: "Mide tu SUDS antes de una situación. Si está por encima de 70, usa respiración de caja para bajar antes de entrar. Si está entre 40-70, es tu zona de trabajo: incómodo pero manejable. Si está bajo 30, puedes buscar retos más difíciles."),
                            LessonTab(title: "Durante", body: "Si puedes, haz una medición mental rápida a los 2-3 minutos de estar en la situación. La ansiedad suele bajar más de lo que predecías. Notar esa bajada es información valiosa para tu cerebro."),
                            LessonTab(title: "Después", body: "Anota el SUDS máximo que alcanzaste y cuándo empezó a bajar. Con el tiempo, verás un patrón: tus picos son más bajos, bajan más rápido. Eso es evidencia de progreso real.")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "La jerarquía de exposición",
                        body: "Para crear tu lista de retos, puntúa cada situación del 0 al 100 con SUDS. Empieza por las que están entre 20-40. Sube de escalón cuando te sientas cómodo en el actual.",
                        highlight: "No saltes del 30 al 75 directamente. Los escalones cercanos son estrategia, no cobardía."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Qué decisión tomar según el SUDS?",
                        identifyOptions: [
                            IdentifyOption(text: "SUDS 80 antes de hablar en público: entrar directamente", isCorrect: false, explanation: "Con activación tan alta, usa respiración de caja primero."),
                            IdentifyOption(text: "SUDS 45: situación adecuada para practicar", isCorrect: true, explanation: "Zona de trabajo ideal: incómodo pero manejable."),
                            IdentifyOption(text: "SUDS 10: buscar una situación más desafiante", isCorrect: true, explanation: "Sin activación suficiente, no hay aprendizaje de extinción."),
                            IdentifyOption(text: "SUDS 90: empujar igual porque la exposición lo baja", isCorrect: false, explanation: "Puede funcionar pero el riesgo de abandono es alto. Mejor prepararse primero."),
                            IdentifyOption(text: "SUDS 55: buen momento para practicar con apoyo", isCorrect: true, explanation: "Zona alta pero abordable. Un buen reto.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "SUDS 0-100: tu medidor de activación en cualquier momento.",
                            "Zona de trabajo principal: 40-60. Empieza en 20-40.",
                            "Medir la ansiedad antes, durante y después revela el progreso que no ves de otra forma."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Tienes una brújula. Ahora sabes exactamente dónde estás en cada momento."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m4l3 — CARRUSEL: microexposiciones por categoría
            Lesson(
                id: "m4l3",
                number: 3,
                title: "Empezar con microexposiciones",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Microexposiciones",
                        subtitle: "Pequeño y consistente es más poderoso que grande y ocasional.",
                        icon: "figure.step.training"),
                    LessonScreenData(type: .diagnostico,
                        title: "¿En qué área sientes más ansiedad social?",
                        choices: [
                            "En situaciones cotidianas con desconocidos",
                            "En el trabajo o entornos de rendimiento",
                            "En situaciones románticas o íntimas",
                            "En grupos de amigos o situaciones sociales"
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "El poder de lo pequeño",
                        body: "Una microexposición es una acción breve, concreta y repetible que te acerca a algo que sueles evitar. Puede durar segundos o unos minutos: saludar, preguntar algo, mandar un mensaje, subir una historia o decir una frase en voz alta.",
                        highlight: "No estás intentando vencer toda tu ansiedad de golpe. Estás enseñándole a tu cerebro, paso a paso, que puede dejar de esconderse."),
                    LessonScreenData(type: .carrusel,
                        title: "Ejemplos por área",
                        cards: [
                            LessonCard(title: "Situaciones cotidianas", body: "Preguntarle la hora a alguien. Mantener contacto visual 3 segundos. Hacer un comentario al cajero. Pedir algo en una cafetería sin ensayarlo.", icon: "person.crop.circle"),
                            LessonCard(title: "Trabajo y rendimiento", body: "Hacer una pregunta en una reunión aunque no sea perfecta. Dar tu opinión en voz alta. Enviar un mensaje de voz. Saludar a alguien que no conoces bien.", icon: "briefcase"),
                            LessonCard(title: "Situaciones sociales y grupos", body: "Unirte a una conversación con una frase. Contar algo breve sobre ti. Iniciar el contacto con alguien primero. Quedarte 10 minutos más cuando quieras irte.", icon: "person.3")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "Consistencia sobre intensidad",
                        body: "Tu cerebro no aprende por intensidad — aprende por repetición. No hace falta que cada exposición sea un gran reto. Hace falta que sean frecuentes.",
                        highlight: "Pequeño todos los días es el principio que más cambia vidas en ansiedad social."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Cuál es una microexposición real?",
                        identifyOptions: [
                            IdentifyOption(text: "Dar un discurso de 30 minutos mañana", isCorrect: false, explanation: "Demasiado salto. Empieza por escalones más pequeños."),
                            IdentifyOption(text: "Preguntar algo a un desconocido hoy", isCorrect: true, explanation: "Pequeño, real, inmediato. Microexposición perfecta."),
                            IdentifyOption(text: "Hacer una pregunta en la próxima reunión", isCorrect: true, explanation: "Acción concreta, específica y manejable."),
                            IdentifyOption(text: "Esperar a sentirte listo para actuar", isCorrect: false, explanation: "La preparación no reduce la ansiedad — la acción sí."),
                            IdentifyOption(text: "Decir una frase cuando normalmente te callarías", isCorrect: true, explanation: "Exactamente la lógica de microexposición.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "Microexposición: acción pequeña (2-5 min) que desafía la zona de confort.",
                            "La repetición frecuente importa más que el tamaño del reto.",
                            "Empieza hoy con algo pequeño. Tu cerebro aprende desde el primer intento."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Tienes ejemplos concretos. El siguiente paso es uno hoy."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m4l4 — TABS: exposición sale mal — Lo que crees / Lo que realmente pasa
            Lesson(
                id: "m4l4",
                number: 4,
                title: "Qué hacer cuando una exposición sale mal",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Cuando sale mal",
                        subtitle: "Una exposición imperfecta que repites es más poderosa que una perfecta que nunca ocurre.",
                        icon: "arrow.clockwise"),
                    LessonScreenData(type: .teoria,
                        title: "Las exposiciones no siempre salen bien. Y eso está bien.",
                        body: "A veces te trabas. A veces dices algo raro. A veces la ansiedad fue alta y se notó. Eso no es un fracaso — es información. Y sigue siendo aprendizaje.",
                        highlight: "La imperfección no invalida el aprendizaje. Seguir es lo que cuenta."),
                    LessonScreenData(type: .tabs,
                        title: "Lo que crees vs lo que realmente pasa",
                        tabs: [
                            LessonTab(title: "Lo que tu cerebro cree", body: "\"Todos se dieron cuenta de que estaba nervioso.\"\n\"Quedé fatal, pensarán que soy incompetente.\"\n\"Eso fue un desastre, no debería haberlo intentado.\"\n\"Nunca voy a mejorar si sigo saliendo tan mal.\""),
                            LessonTab(title: "Lo que realmente pasó", body: "Los demás prestaron mucha menos atención de la que crees. Decir algo torpe es humano y olvidable. La situación duró X minutos y sobreviviste. Tu cerebro registró: \"lo intenté y no fue catastrófico\".")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "El protocolo post-exposición difícil",
                        body: "1. Anota datos, no drama. No \"fue un desastre\" sino \"me trabé en una frase, duró 3 minutos\".\n2. Cuestiona la interpretación. ¿Fue realmente tan malo para todos los presentes?\n3. Repite. La repetición acumula extinción aunque las exposiciones no salgan perfectas.",
                        highlight: "Datos, no drama. Esa es la diferencia entre aprender de una exposición difícil y rumiarlo."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Qué hacer después de una exposición difícil?",
                        identifyOptions: [
                            IdentifyOption(text: "Evitar esa situación durante semanas", isCorrect: false, explanation: "La evitación consolida el miedo. Hay que volver antes."),
                            IdentifyOption(text: "Anotar qué pasó exactamente con datos concretos", isCorrect: true, explanation: "Los datos concretos reemplazan el drama narrativo."),
                            IdentifyOption(text: "Repetir la misma situación pronto", isCorrect: true, explanation: "La repetición acumula extinción incluso con exposiciones imperfectas."),
                            IdentifyOption(text: "Convencerte de que en realidad no salió tan mal", isCorrect: false, explanation: "No es negarlo — es evaluar con precisión, no magnificar."),
                            IdentifyOption(text: "Preguntar qué evidencia real tienes del \"desastre\"", isCorrect: true, explanation: "Cuestionar la interpretación catastrófica con evidencia real.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "Las exposiciones imperfectas siguen siendo aprendizaje válido.",
                            "Datos, no drama: anota qué pasó exactamente, no la narrativa que construyes.",
                            "Repite. La extinción se acumula exposición tras exposición, no de una sola vez."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Ahora los traspiés son parte del proceso, no el fin del proceso."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m4l5 — TABS: mantener el cambio — cierre módulo 4
            Lesson(
                id: "m4l5",
                number: 5,
                title: "Cómo mantener el cambio y no volver a esconderte",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Mantener el cambio",
                        subtitle: "El cambio no es un destino. Es un camino que se mantiene con práctica.",
                        icon: "flag.checkered"),
                    LessonScreenData(type: .teoria,
                        title: "Si paras, la ansiedad vuelve",
                        body: "La ansiedad social no se cura de golpe. Si dejas de exponerte, el miedo vuelve gradualmente. No al punto de partida, pero vuelve. La solución no es esfuerzo heroico — es consistencia pequeña.",
                        highlight: "No necesitas grandes gestos. Necesitas algo pequeño, hecho regularmente."),
                    LessonScreenData(type: .tabs,
                        title: "Las claves para no volver a esconderte",
                        tabs: [
                            LessonTab(title: "Consistencia pequeña", body: "Una acción pequeña cada semana mantiene lo ganado mejor que una gran exposición mensual. Una pregunta en reuniones. Una conversación con un desconocido. Un mensaje de voz. La regularidad importa más que el tamaño."),
                            LessonTab(title: "Días malos esperados", body: "Habrá días con más ansiedad. Ajusta las expectativas ese día, pero no lo interpretes como \"he vuelto a empezar\". Un día difícil no borra el progreso. Es parte del proceso, no el fin."),
                            LessonTab(title: "Conectar con tus valores", body: "¿Por qué empezaste? ¿Qué quieres que tu vida incluya que ahora no incluye? Cuando la motivación flaquea, esa pregunta la renueva. El progreso tiene sentido cuando está conectado a algo que importa.")
                        ]),
                    LessonScreenData(type: .teoria,
                        title: "El progreso es invisible si no lo registras",
                        body: "Hace tres meses las llamadas eran terribles. Ahora son incómodas pero manejables. El cambio real es lento y acumulativo. Sin registro, parece que no has avanzado. Por eso existe el diario en esta app.",
                        highlight: "Lo que no se mide, no se ve. Y lo que no se ve, no motiva."),
                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Qué ayuda a mantener el cambio?",
                        identifyOptions: [
                            IdentifyOption(text: "Una microexposición semanal, siempre", isCorrect: true, explanation: "Consistencia pequeña es más efectiva que esfuerzo puntual."),
                            IdentifyOption(text: "Interpretar un día malo como regresión total", isCorrect: false, explanation: "Un día difícil no borra el aprendizaje acumulado."),
                            IdentifyOption(text: "Registrar el progreso con datos concretos", isCorrect: true, explanation: "El registro hace visible el cambio que de otro modo no se percibe."),
                            IdentifyOption(text: "Esperar a tener mucha motivación para actuar", isCorrect: false, explanation: "La acción genera motivación, no al revés."),
                            IdentifyOption(text: "Recordar por qué empezaste cuando flaquea la motivación", isCorrect: true, explanation: "Conectar con valores renueva el compromiso de forma sostenible.")
                        ]),
                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "Consistencia pequeña vence a la perfección ocasional. Siempre.",
                            "Los días malos son parte del proceso. No significan que hayas vuelto a empezar.",
                            "Has completado los primeros 4 módulos. La base está. Los módulos 5 y 6 están esperándote."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Módulo 4 completado!",
                        body: "Tienes la ciencia, las herramientas y la estrategia. El siguiente paso es tuyo."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena este módulo contigo?")
                ]
            )
        ]
    )

    // MARK: - Módulo 5: Ponlo en práctica

    static let module5 = LearningModule(
        id: "m5",
        title: "Ponlo en práctica",
        subtitle: "Situaciones reales. Herramientas reales. Sin rodeos.",
        symbol: "bolt.fill",
        colorHex: "8B5CF6",
        lessons: [

            // m5l1 — LA PRIMERA CONVERSACIÓN
            // Interacción principal: CARRUSEL con pares "bloqueo → apertura"
            // Ejercicio: identifica cuál es apertura real vs excusa disfrazada (mezclado)
            Lesson(
                id: "m5l1",
                number: 1,
                title: "La primera conversación",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "La primera conversación",
                        subtitle: "El momento antes de abrir la boca es el más difícil. El momento después casi siempre es mejor de lo que esperabas.",
                        icon: "bubble.left.and.bubble.right"),

                    LessonScreenData(type: .diagnostico,
                        title: "¿Qué te pasa justo antes de hablar con alguien que no conoces?",
                        choices: [
                            "Mi mente se queda en blanco — no sé qué decir",
                            "Me preocupa que piensen que soy raro o pesado",
                            "Empiezo a ensayar mentalmente lo que voy a decir y no arranco",
                            "Simplemente no lo hago — me convenzo de que no hace falta"
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "Lo que la ciencia encontró sobre hablar con extraños",
                        body: "Nicholas Epley (Universidad de Chicago) hizo que personas en el metro hablaran con desconocidos. Lo que encontró: los desconocidos disfrutaron la conversación mucho más de lo que los participantes predijeron. Y los propios participantes también.",
                        highlight: "Tu cerebro predice rechazo. Los datos predicen conexión. El experimento lleva décadas replicándose con el mismo resultado."),

                    LessonScreenData(type: .carrusel,
                        title: "Del pensamiento que bloquea a la apertura real",
                        cards: [
                            LessonCard(
                                title: "\"No tengo nada interesante que decir\"",
                                body: "Apertura: Comenta algo del contexto compartido. Estás en el mismo sitio que esa persona. Eso ya es suficiente. \"¿Llevas mucho tiempo esperando?\" No necesitas ser interesante. Solo presente.",
                                icon: "lightbulb"),
                            LessonCard(
                                title: "\"Va a pensar que soy raro por hablarle\"",
                                body: "Apertura: El 80% de las personas están esperando que alguien tome la iniciativa. Iniciar una conversación no es raro — es lo que hacen las personas socialmente seguras exactamente igual que tú. La diferencia: ellas no lo piensan tanto.",
                                icon: "person.wave.2"),
                            LessonCard(
                                title: "\"¿Y si no sé cómo continuar la conversación?\"",
                                body: "Apertura: No hace falta que dure 20 minutos. Una conversación de 2 minutos cuenta. Empieza con una observación, una pregunta o un comentario. Si no fluye, no pasa nada. Lo intentaste. Eso ya es la exposición.",
                                icon: "clock")
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "La fórmula más sencilla que existe",
                        body: "Observación + pregunta abierta. \"Qué cola tan larga, ¿sabes si suele ir así?\" No necesitas más. Las conversaciones se construyen solas si arrancas. El cerebro ansioso sobreestima lo que tienes que hacer.",
                        highlight: "No tienes que ser interesante. Tienes que estar presente y hacer una pregunta."),

                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Apertura real o excusa disfrazada?",
                        identifyOptions: [
                            IdentifyOption(text: "\"Luego le hablo, ahora no es buen momento\"", isCorrect: false, explanation: "Excusa clásica. El momento perfecto no llega — lo creas tú."),
                            IdentifyOption(text: "Comentar algo del entorno compartido", isCorrect: true, explanation: "Contexto compartido es la apertura más natural que existe."),
                            IdentifyOption(text: "\"Primero veo si parece simpático/a\"", isCorrect: false, explanation: "Evaluar antes de actuar es otra forma de no actuar nunca."),
                            IdentifyOption(text: "Hacer una pregunta aunque no sea perfecta", isCorrect: true, explanation: "Imperfecto y real siempre gana a perfecto e imaginario."),
                            IdentifyOption(text: "\"Seguro que está ocupado/a\"", isCorrect: false, explanation: "Suposición sin evidencia. Estás leyendo su mente — y mal."),
                            IdentifyOption(text: "Decir una frase corta y ver qué pasa", isCorrect: true, explanation: "La conversación se construye sola si le das una oportunidad de empezar.")
                        ]),

                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "Tu cerebro predice rechazo. La ciencia predice conexión. Los dos no pueden tener razón.",
                            "No necesitas ser interesante — solo presente. Observación + pregunta abierta es suficiente.",
                            "No hay momento perfecto. Hay momentos que usas y momentos que dejas pasar."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Ahora tienes la fórmula y la evidencia. El siguiente paso es una conversación real."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m5l2 — EN GRUPOS
            // Interacción principal: TABS "Lo que tu cerebro dice / Lo que estadísticamente pasa"
            // Ejercicio: identifica el momento real para unirse — framing distinto, mezclado
            Lesson(
                id: "m5l2",
                number: 2,
                title: "Entrar en una conversación de grupo",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Entrar en grupos",
                        subtitle: "El miedo a interrumpir es una de las formas más comunes de evitación disfrazada de educación.",
                        icon: "person.3.fill"),

                    LessonScreenData(type: .diagnostico,
                        title: "Cuando hay una conversación en marcha y quieres unirte, ¿qué pasa?",
                        choices: [
                            "Me quedo en el borde esperando el momento perfecto que nunca llega",
                            "Me convenzo de que no tengo nada relevante que añadir",
                            "Entro pero luego me arrepiento de lo que dije",
                            "Directamente no lo intento y busco otra cosa que hacer"
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "No siempre existe un hueco perfecto",
                        body: "En una conversación viva, no siempre existe un hueco perfecto. A veces pequeñas señales como \"sí\", \"claro\", \"total\" o una frase breve de apoyo se viven como interés, no como interrupción. La clave es sumar algo y volver a escuchar.",
                        highlight: "Entrar en una conversación no siempre es invadir. A veces es solo mostrar que estás ahí."),

                    LessonScreenData(type: .tabs,
                        title: "Lo que tu cerebro dice vs lo que pasa",
                        tabs: [
                            LessonTab(title: "Tu cerebro dice...", body: "\"Voy a cortar el hilo y parecer pesado.\"\n\"No es el momento, espero un poco más.\"\n\"Se han dado cuenta de que quiero entrar y me están ignorando.\"\n\"Si digo algo raro, todos lo recordarán.\"\n\nTu cerebro está construyendo una narrativa de rechazo anticipado en tiempo real."),
                            LessonTab(title: "Lo que estadísticamente pasa", body: "La mayoría de las personas en grupos están encantadas de que alguien nuevo se una — rompe la tensión de los silencios.\n\nLo que tú llamas \"cortar\" muchas veces se percibe como energía.\n\nEn el 90% de los casos, si metes algo raro, el grupo lo absorbe y sigue. No es el escándalo que tu cerebro predice.")
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "La técnica del puente",
                        body: "Para unirte a una conversación en marcha sin sentirte invasivo: conecta con lo que acaban de decir. \"Eso que dices de X...\" o \"Justo pensaba en eso...\" Es un puente, no una interrupción. Le dices al grupo que estabas escuchando.",
                        highlight: "Unirte a una conversación mostrando que escuchaste es la señal social más positiva que puedes dar."),

                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Cuándo es un buen momento para entrar?",
                        identifyOptions: [
                            IdentifyOption(text: "Cuando acaban de terminar un punto y hay pausa breve", isCorrect: true, explanation: "La pausa natural es la señal más clara para entrar."),
                            IdentifyOption(text: "Esperar a que nadie esté hablando", isCorrect: false, explanation: "Ese momento casi nunca llega en grupos. Seguirás esperando."),
                            IdentifyOption(text: "Conectando con algo que alguien acaba de decir", isCorrect: true, explanation: "El puente es la entrada más fluida que existe."),
                            IdentifyOption(text: "Solo si tienes algo brillante que aportar", isCorrect: false, explanation: "Eso es el estándar imposible que usa tu cerebro para bloquearte."),
                            IdentifyOption(text: "Cuando hay una pregunta abierta en el aire", isCorrect: true, explanation: "Una pregunta sin respuesta inmediata es una invitación directa."),
                            IdentifyOption(text: "Cuando llevas 10 minutos en el grupo sin decir nada", isCorrect: false, explanation: "El tiempo que llevas callado no justifica seguir callado — lo hace más incómodo.")
                        ]),

                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "El miedo a interrumpir es evitación disfrazada de educación.",
                            "Técnica del puente: conecta con lo que acaban de decir para entrar sin cortar.",
                            "Las reglas de los grupos son más flexibles de lo que tu cerebro ansioso te dice."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "La próxima vez que estés fuera de una conversación, tienes el puente."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m5l3 — EN EL TRABAJO
            // Interacción principal: CARRUSEL con 3 situaciones reales (reunión, pedir, opinar)
            // Ejercicio: framing distinto — "¿Qué respuesta te hace más visible sin ser un desastre?"
            Lesson(
                id: "m5l3",
                number: 3,
                title: "Ansiedad social en el trabajo",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Ansiedad social en el trabajo",
                        subtitle: "Según ADAA, entre empleados con trastornos de ansiedad, un 43% evita participar en reuniones. En el caso de la ansiedad social, este tipo de situaciones puede ser especialmente difícil porque implica hablar, ser observado o sentirse juzgado.",
                        icon: "building.2"),

                    LessonScreenData(type: .teoria,
                        title: "El coste real de quedarse callado",
                        body: "Un estudio de la ADAA encontró que el 55% de las personas con ansiedad social han rechazado ascensos por las exigencias sociales que conllevan. No es falta de talento. Es el coste silencioso de evitar.",
                        highlight: "La ansiedad social en el trabajo no solo afecta cómo te sientes. Afecta cuánto ganas, qué proyectos te llegan y dónde acabas en cinco años."),

                    LessonScreenData(type: .carrusel,
                        title: "Tres situaciones reales — pensamiento típico + reframe",
                        cards: [
                            LessonCard(
                                title: "En una reunión",
                                body: "Tienes una idea. Tu cerebro dice: \"¿Y si es una tontería?\"\nReframe: Los que hablan en reuniones no tienen mejores ideas — tienen menos miedo de que salgan mal. Tu idea no es peor. Tu filtro es más alto.",
                                icon: "person.2.wave.2"),
                            LessonCard(
                                title: "Pedir algo o dar feedback",
                                body: "Necesitas pedir un recurso o decirle algo difícil a alguien. Tu cerebro dice: \"Va a molestarle.\"\nReframe: Las personas que piden con claridad y dan feedback honesto son las que más se respetan en equipos. No las que callan y acumulan.",
                                icon: "bubble.left.and.exclamationmark.bubble.right"),
                            LessonCard(
                                title: "Dar tu opinión cuando nadie pregunta",
                                body: "El grupo toma una dirección que no te convence. Tu cerebro dice: \"No es mi lugar.\"\nReframe: \"No es mi lugar\" es evitación de baja intensidad. Las personas que añaden perspectivas sin que se las pidan son las que construyen reputación profesional real.",
                                icon: "lightbulb.max")
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "La diferencia entre ansiedad social y ansiedad de rendimiento",
                        body: "Ansiedad de rendimiento: miedo a hacerlo mal. Ansiedad social: miedo a cómo te ven mientras lo haces. En el trabajo coexisten las dos. Separarlas ayuda — porque tienen soluciones distintas.",
                        highlight: "Si tu miedo es al juicio de los demás más que al resultado, es ansiedad social. Y la exposición gradual funciona igual aquí que en cualquier otro contexto."),

                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Asertivo en el trabajo o evitación disfrazada?",
                        identifyOptions: [
                            IdentifyOption(text: "\"Luego se lo digo, ahora no es el momento\"", isCorrect: false, explanation: "El \"luego\" suele ser nunca. Es evitación con fecha indefinida."),
                            IdentifyOption(text: "Hacer una pregunta en la reunión aunque no sea perfecta", isCorrect: true, explanation: "Participar imperfectamente es infinitamente más visible que no participar."),
                            IdentifyOption(text: "\"No digo nada para no molestar al equipo\"", isCorrect: false, explanation: "Quedarse callado para no molestar es evitación, no consideración."),
                            IdentifyOption(text: "Enviar un mensaje después de la reunión con tu idea", isCorrect: true, explanation: "Si en directo es muy difícil, por escrito también cuenta. Es exposición gradual real."),
                            IdentifyOption(text: "\"Mi jefe ya lo sabe, no hace falta que lo diga yo\"", isCorrect: false, explanation: "Clásica racionalización para no tener que hablar. Tu voz importa igual."),
                            IdentifyOption(text: "Pedir feedback sobre tu trabajo aunque da vértigo", isCorrect: true, explanation: "Pedir feedback es exposición y aprendizaje al mismo tiempo. Doble ganancia.")
                        ]),

                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "El 55% de personas con ansiedad social han rechazado ascensos. El silencio tiene un coste profesional real.",
                            "No tienes mejores ideas callado. Solo tienes más filtros. Baja el filtro, no la idea.",
                            "Exposición gradual funciona igual en el trabajo: empieza por preguntas pequeñas, no por discursos."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "La próxima reunión es una oportunidad. Una frase. Una pregunta. Eso es todo."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m5l4 — CITAS Y RECHAZO
            // Interacción principal: TABS con datos reales de la investigación
            // Ejercicio: framing completamente diferente — "¿pensamiento catastrófico o realista?"
            Lesson(
                id: "m5l4",
                number: 4,
                title: "Citas y miedo al rechazo",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "El miedo al rechazo",
                        subtitle: "Lo que más duele no es que te digan que no. Es no haberte atrevido a preguntarlo.",
                        icon: "heart.slash"),

                    LessonScreenData(type: .diagnostico,
                        title: "¿Qué es lo que más te frena cuando te gusta alguien?",
                        choices: [
                            "El miedo a que me rechacen explícitamente",
                            "No saber si le gusto — la ambigüedad me paraliza",
                            "Me convenzo de que no es el momento o la situación",
                            "El miedo a cambiar una dinámica que ya funciona"
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "El rechazo social y el dolor: lo que dice la neurociencia",
                        body: "Investigadores de UCLA estudiaron con resonancia magnética qué ocurre en el cerebro cuando una persona se siente excluida socialmente. Los participantes jugaban a Cyberball, un juego virtual de lanzar una pelota, hasta que dejaban de recibir pases. Durante esa exclusión aumentó la actividad en el córtex cingulado anterior dorsal, una zona relacionada con el malestar del dolor físico.",
                        highlight: "El rechazo social no es \"solo mental\": puede activar zonas cerebrales relacionadas con el dolor físico. No significa que sea el mismo dolor, pero sí ayuda a entender por qué ser excluido puede doler tanto."),

                    LessonScreenData(type: .tabs,
                        title: "Lo que tu cerebro predice vs los datos reales",
                        tabs: [
                            LessonTab(title: "Lo que tu cerebro predice", body: "\"Si me dice que no, me hundiré.\"\n\"Prefiero no saber — así no duele.\"\n\"Si lo intento y sale mal, lo habré estropeado todo.\"\n\"Es mejor dejarlo pasar que arriesgarme.\"\n\nTu cerebro convierte la posibilidad de dolor en certeza para justificar la evitación."),
                            LessonTab(title: "Lo que dice la investigación", body: "Un estudio de Joel, Plaks y MacDonald encontró que, al recordar arrepentimientos románticos, las personas mencionaban oportunidades perdidas más de 3 veces más que rechazos reales. Otros estudios clásicos sobre arrepentimiento muestran algo parecido: a corto plazo duele más haberlo intentado y fallar, pero con el tiempo suele pesar más no haberlo intentado.\n\nEn otro experimento del mismo estudio, el 41% eligió intentarlo con la persona que prefería aunque tenía solo un 5% de probabilidad de éxito, en vez de elegir a alguien más accesible.")
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "El rechazo es un dato, no un veredicto",
                        body: "Que alguien no esté disponible, no te corresponda o no sea el momento no dice nada sobre tu valor como persona. Son variables del contexto de esa persona, no una evaluación de quién eres tú.",
                        highlight: "\"No\" es información sobre la situación, no sobre ti. Tu cerebro ansioso los confunde. Separarlos cambia todo."),

                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Catastrofización o reencuadre realista?",
                        identifyOptions: [
                            IdentifyOption(text: "\"Si me rechaza, confirma que no soy suficiente\"", isCorrect: false, explanation: "Catastrofización. Un rechazo es un dato sobre el contexto, no un veredicto sobre ti."),
                            IdentifyOption(text: "\"Las estadísticas dicen que el arrepentimiento dura más que el rechazo\"", isCorrect: true, explanation: "Reencuadre basado en evidencia real. Exactamente así funciona esto."),
                            IdentifyOption(text: "\"Es mejor no arriesgar para protegerme\"", isCorrect: false, explanation: "Protegerte de oportunidades también es un coste. Tu cerebro lo omite."),
                            IdentifyOption(text: "\"Puedo manejar un no — ya lo he hecho antes\"", isCorrect: true, explanation: "Evidencia de resiliencia real. Tu historial importa más que tu predicción ansiosa."),
                            IdentifyOption(text: "\"Si lo intento una vez y sale mal, ya no hay vuelta atrás\"", isCorrect: false, explanation: "Las situaciones sociales son dinámicas. Nada es tan permanente como parece en el momento de ansiedad."),
                            IdentifyOption(text: "\"No intentarlo tiene un coste. Intentarlo también. Elijo actuar.\"", isCorrect: true, explanation: "Aceptar el riesgo con información real. Esto es exactamente lo contrario a la evitación.")
                        ]),

                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "Tu cerebro procesa el rechazo como dolor físico — es biología, no sensibilidad.",
                            "3x más arrepentimiento por no intentarlo que por ser rechazado. Los datos son claros.",
                            "El rechazo es información sobre el contexto, no un veredicto sobre tu valor."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Lección completada!",
                        body: "Ahora tienes los datos. La próxima vez que dudes, recuerda el 3x."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena esto contigo hoy?")
                ]
            ),

            // m5l5 — DECIR QUE NO
            // Interacción principal: CARRUSEL con 3 situaciones (pasiva, agresiva, asertiva)
            // Ejercicio: framing completamente distinto — identifica cuál puedes decir SIN disculparte
            Lesson(
                id: "m5l5",
                number: 5,
                title: "Decir que no sin destrozarte por dentro",
                body: "", keyInsight: "", scienceFact: "",
                screens: [
                    LessonScreenData(type: .intro,
                        title: "Decir que no",
                        subtitle: "La culpa que sientes antes de decir que no es el mecanismo exacto que te hace decir que sí cuando no quieres.",
                        icon: "hand.raised"),

                    LessonScreenData(type: .diagnostico,
                        title: "¿Qué pasa por tu cabeza cuando tienes que negarle algo a alguien?",
                        choices: [
                            "Siento culpa anticipada — me parece que le estoy fallando",
                            "Me preocupa que se enfade o que cambie la relación",
                            "Busco una excusa que suene más aceptable que \"no quiero\"",
                            "Digo que sí y luego me arrepiento"
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "La culpa anticipada es un mecanismo de evitación",
                        body: "Sentir culpa antes de decir que no es tu sistema de alarma social diciéndote que podrías perder conexión o aprobación. Pero la investigación muestra lo contrario: poner límites con claridad genera más confianza y respeto, no menos.",
                        highlight: "No pones límites para protegerte. Los pones para que la relación sea real. Las relaciones sin límites se construyen sobre lo que finges querer, no sobre lo que eres."),

                    LessonScreenData(type: .carrusel,
                        title: "La misma situación — tres respuestas distintas",
                        cards: [
                            LessonCard(
                                title: "Respuesta pasiva",
                                body: "Te piden que cubras un turno que no quieres. Dices: \"Bueno... supongo que sí, si de verdad lo necesitas...\"\n\nResultado: dices sí cuando querías decir no. Resentimiento acumulado. La otra persona no sabe que te ha costado algo.",
                                icon: "minus.circle"),
                            LessonCard(
                                title: "Respuesta agresiva",
                                body: "Dices: \"¿Por qué siempre me pides a mí? No puedo, ya está.\"\n\nResultado: el límite existe pero con daño colateral. La otra persona recibe el límite envuelto en reproches. Se defiende en vez de entenderte.",
                                icon: "exclamationmark.triangle"),
                            LessonCard(
                                title: "Respuesta asertiva",
                                body: "Dices: \"Ahora mismo no puedo, tengo otros compromisos. Si surge otro momento, me dices.\"\n\nResultado: límite claro, tono neutral, sin excusas elaboradas. La otra persona entiende el no sin sentirse atacada. Tú no te sientes mal después.",
                                icon: "checkmark.circle")
                        ]),

                    LessonScreenData(type: .teoria,
                        title: "El \"no\" que no necesita ser explicado",
                        body: "Dar demasiadas explicaciones al decir que no activa el efecto contrario: parece que pides permiso para negarte. Un \"no\" con una razón breve es suficiente. Dos razones ya empieza a sonar a justificación.",
                        highlight: "\"No puedo\" no necesita un párrafo. Cuantas más explicaciones añades, más vulnerable queda el límite."),

                    LessonScreenData(type: .ejercicioIdentifica,
                        title: "¿Cuál de estas puedes decir sin disculparte?",
                        identifyOptions: [
                            IdentifyOption(text: "\"Ay, es que tengo mil cosas, lo siento mucho, de verdad...\"", isCorrect: false, explanation: "Exceso de explicaciones = el no queda debilitado. Parece que pides permiso."),
                            IdentifyOption(text: "\"Ahora mismo no puedo, gracias por pensar en mí\"", isCorrect: true, explanation: "Claro, breve, sin drama. Esto es un no asertivo."),
                            IdentifyOption(text: "\"No me apetece y ya está, ¿hay algún problema?\"", isCorrect: false, explanation: "El límite está pero con actitud defensiva que invita al conflicto."),
                            IdentifyOption(text: "\"Este fin de semana no, pero podría el siguiente\"", isCorrect: true, explanation: "No con alternativa. Mantiene la relación sin ceder en lo que no puedes."),
                            IdentifyOption(text: "\"Bueno... si no hay nadie más... supongo\"", isCorrect: false, explanation: "Condicional pasivo. Dices sí cuando querías decir no. Resentimiento garantizado."),
                            IdentifyOption(text: "\"No puedo comprometerme a eso ahora mismo\"", isCorrect: true, explanation: "Límite temporal sin drama ni explicaciones. Funciona en casi cualquier contexto.")
                        ]),

                    LessonScreenData(type: .resumen,
                        keyPoints: [
                            "La culpa anticipada es el mecanismo que te hace decir sí cuando no quieres. Reconocerla no la elimina, pero la neutraliza.",
                            "Un no asertivo: breve, neutro, sin excusas elaboradas. No pides permiso para tener un límite.",
                            "Los límites no destruyen relaciones. Las construyen sobre lo que eres, no sobre lo que finges querer."
                        ]),
                    LessonScreenData(type: .celebracion,
                        title: "¡Módulo 5 completado!",
                        body: "5 módulos completados. Queda uno más — el de la cámara. Pero ya tienes todo lo que necesitas para empezar."),
                    LessonScreenData(type: .rating,
                        title: "¿Cuánto resuena este módulo contigo?")
                ]
            )
        ]
    )

    // MARK: - Módulo 6: Vergüenza ante la cámara

    static let module6 = LearningModule(
        id: "m6",
        title: "Vergüenza ante la cámara",
        subtitle: "Para quien sabe que crear contenido es una opción, pero le da vértigo.",
        symbol: "camera.fill",
        colorHex: "F43F5E",
        lessons: [ m6l1, m6l2, m6l3, m6l4, m6l5 ]
    )

    static let m6l1 = Lesson(
        id: "m6l1",
        number: 1,
        title: "Tu cerebro y la cámara",
        body: "",
        keyInsight: "",
        scienceFact: "",
        screens: [
            LessonScreenData(
                type: .intro,
                title: "Tu cerebro y la cámara",
                subtitle: "Por qué encender la cámara activa la misma alarma que hablar ante 500 personas",
                icon: "camera.fill"
            ),
            LessonScreenData(
                type: .teoria,
                title: "La misma alarma, dos agravantes",
                body: "Cuando enciendes la cámara, tu amígdala activa el mismo sistema de defensa que cuando te enfrentas a un público real. No distingue entre los dos. Pero crear contenido añade dos factores extra que el hablar en público no tiene: la permanencia digital y la audiencia potencialmente masiva.",
                highlight: "Tu cerebro no ve la diferencia entre un directo para 3 personas y uno para 300.000. El miedo parece desproporcionado porque está calibrado para lo peor posible, no para la realidad."
            ),
            LessonScreenData(
                type: .carrusel,
                title: "Cuándo se activa la alarma",
                cards: [
                    LessonCard(title: "Al encender la cámara", body: "El primer momento. Tu cuerpo interpreta 'me van a ver' como una amenaza social real. El corazón se acelera, la voz cambia. Es fisiológico, no es que seas raro.", icon: "camera.circle.fill"),
                    LessonCard(title: "Al verte en pantalla", body: "Verse a uno mismo genera hiperconciencia. Notas cada gesto, cada palabra. En conversación normal no te ves. En cámara sí. Esa diferencia es artificial — los demás no te ven igual que tú.", icon: "eye.fill"),
                    LessonCard(title: "Al darle a subir", body: "El momento de mayor activación. 'Ya no hay vuelta atrás.' La permanencia digital se percibe como irreversible — aunque puedas borrar el contenido en cualquier momento.", icon: "arrow.up.circle.fill"),
                    LessonCard(title: "Al leer los comentarios", body: "Tu cerebro busca activamente el comentario negativo en medio de cien positivos. Es un sesgo de negatividad evolutivo. No lo puedes desactivar, pero sí puedes contextualizarlo.", icon: "text.bubble.fill")
                ]
            ),
            LessonScreenData(
                type: .teoria,
                title: "Lo que cambia cuando lo entiendes",
                body: "Saber que el miedo es una respuesta calibrada para el peor caso — no para la realidad — no lo elimina. Pero sí cambia tu relación con él. El miedo dice 'peligro.' Tú ahora puedes responder: 'Falsa alarma. Pero gracias.'",
                highlight: "La permanencia digital y la audiencia masiva son amenazas percibidas, no reales, hasta que los datos las confirmen. Y los datos rara vez confirman lo peor."
            ),
            LessonScreenData(
                type: .ejercicioIdentifica,
                title: "¿Cuál de estos miedos es específico de crear contenido?",
                body: "Toca los que solo aparecen al crear contenido digital, no en situaciones sociales normales.",
                identifyOptions: [
                    IdentifyOption(text: "Que me vean tartamudear en un vídeo guardado para siempre", isCorrect: true, explanation: "Específico del contenido: la permanencia digital. En una conversación en vivo, el momento pasa. Aquí queda grabado."),
                    IdentifyOption(text: "Ponerme nervioso al hablar con desconocidos", isCorrect: false, explanation: "Ansiedad social general — existe también fuera de la cámara, en cualquier conversación cara a cara."),
                    IdentifyOption(text: "Que mis conocidos vean que he fallado públicamente", isCorrect: true, explanation: "Específico del contenido: la audiencia conocida. El contenido digital llega precisamente a quienes te conocen — eso no pasa en ansiedad social general."),
                    IdentifyOption(text: "No saber qué decir cuando alguien me habla", isCorrect: false, explanation: "Ansiedad social general — el bloqueo verbal ocurre en conversaciones presenciales igual que en cámara.")
                ]
            ),
            LessonScreenData(
                type: .resumen,
                title: "Lo que te llevas",
                keyPoints: [
                    "La cámara activa el mismo sistema de alarma que hablar en público, con dos agravantes únicos",
                    "Permanencia digital y audiencia conocida son las amenazas específicas del contenido",
                    "Son amenazas percibidas, no reales — hasta que los datos las confirmen, y rara vez lo hacen"
                ]
            ),
            LessonScreenData(type: .celebracion,
                title: "Lección 1 completada",
                body: "Ya sabes por qué tu cerebro reacciona así. Eso ya es una ventaja."),
            LessonScreenData(type: .rating,
                title: "¿Cuánto resuena esta lección contigo?")
        ]
    )

    static let m6l2 = Lesson(
        id: "m6l2",
        number: 2,
        title: "El filtro no soluciona el problema",
        body: "",
        keyInsight: "",
        scienceFact: "",
        screens: [
            LessonScreenData(
                type: .intro,
                title: "El filtro no soluciona el problema",
                subtitle: "Por qué los filtros y los avatares de IA son evitación disfrazada de estrategia",
                icon: "wand.and.stars"
            ),
            LessonScreenData(
                type: .diagnostico,
                title: "¿Has usado alguna vez alguna de estas estrategias?",
                choices: [
                    "Filtros que cambian mi cara para parecer diferente",
                    "Avatar de IA en vez de aparecer yo",
                    "Voz modificada para no reconocerme",
                    "Ninguna de estas — nunca he creado contenido"
                ]
            ),
            LessonScreenData(
                type: .teoria,
                title: "La promesa del filtro",
                body: "Los filtros y las herramientas de IA para ocultar la cara prometen lo mismo: crear sin exponerte. Parece una solución inteligente — reduces el riesgo mientras sigues haciendo contenido. Pero hay un problema que no ves a corto plazo.",
                highlight: "Usar IA para ocultar tu cara es evitación digital. Funciona a corto plazo. A largo plazo, amplifica el miedo porque nunca le das a tu cerebro la oportunidad de aprender que la exposición no es peligrosa."
            ),
            LessonScreenData(
                type: .tabs,
                title: "El filtro: promesa vs realidad",
                tabs: [
                    LessonTab(title: "Lo que promete", body: "Puedo crear contenido sin exponerme. Reduzco el riesgo de juicio. Consigo seguidores sin mostrarme. Puedo ir construyendo audiencia mientras 'me preparo'."),
                    LessonTab(title: "Lo que realmente pasa", body: "El miedo a mostrarte sigue igual — o peor. Nunca produces la experiencia correctora que necesita tu cerebro. Si tu audiencia crece, la presión de revelarte aumenta. Las cuentas con mayor engagement a largo plazo muestran imperfección, no la ocultan.")
                ]
            ),
            LessonScreenData(
                type: .teoria,
                title: "Hay una diferencia entre gradual y evitación",
                body: "Empezar con voz sin cara, o con manos en pantalla, no es evitación. Es exposición gradual — vas subiendo escalones con intención de llegar más arriba. La evitación es cuando la estrategia se convierte en el destino: 'siempre usaré filtros'. Ahí el miedo se queda exactamente donde está.",
                highlight: "La pregunta no es '¿muestro mi cara?' sino '¿esta estrategia me acerca a exponerme o me da una excusa para no hacerlo?'"
            ),
            LessonScreenData(
                type: .ejercicioIdentifica,
                title: "¿Qué es evitación disfrazada de estrategia?",
                body: "Toca las que son evitación — estrategias que tienen excusa pero no dirección.",
                identifyOptions: [
                    IdentifyOption(text: "Publicar solo texto un mes mientras me acostumbro al formato", isCorrect: false, explanation: "Exposición gradual legítima: tiene un período definido y una intención de avanzar al siguiente escalón."),
                    IdentifyOption(text: "Usar siempre un avatar de IA porque 'mi contenido es mejor así'", isCorrect: true, explanation: "Evitación: 'siempre' y 'mejor así' son señales de que la estrategia se ha convertido en el destino. No hay dirección de avance."),
                    IdentifyOption(text: "Grabar con cara borrosa esta semana, con cara visible la siguiente", isCorrect: false, explanation: "Exposición gradual: hay un plan concreto de escalón a escalón con fecha."),
                    IdentifyOption(text: "Usar filtros indefinidamente para 'sentirme mejor antes de mostrarme'", isCorrect: true, explanation: "Evitación: 'indefinidamente' es la palabra clave. No hay fecha ni intención de reducir la dependencia al filtro.")
                ]
            ),
            LessonScreenData(
                type: .resumen,
                title: "Lo que te llevas",
                keyPoints: [
                    "Los filtros y avatares de IA aplazan el miedo — no lo resuelven",
                    "La diferencia entre gradual y evitación está en si la estrategia tiene dirección de avance",
                    "La autenticidad imperfecta genera más conexión y engagement que la perfección artificial"
                ]
            ),
            LessonScreenData(type: .celebracion,
                title: "Lección 2 completada",
                body: "Ahora entiendes la diferencia entre estrategia y evitación. Eso cambia todo."),
            LessonScreenData(type: .rating,
                title: "¿Cuánto resuena esta lección contigo?")
        ]
    )

    static let m6l3 = Lesson(
        id: "m6l3",
        number: 3,
        title: "Hay un camino gradual",
        body: "",
        keyInsight: "",
        scienceFact: "",
        screens: [
            LessonScreenData(
                type: .intro,
                title: "Hay un camino gradual",
                subtitle: "La escalera de exposición digital: 8 escalones, sin orden obligatorio",
                icon: "stairs"
            ),
            LessonScreenData(
                type: .teoria,
                title: "No existe un único camino",
                body: "La exposición gradual funciona cuando defines escalones claros y los subes con intención. En contenido digital hay un camino natural — pero no es el único. Lo que importa no es por dónde empiezas, sino que cada escalón se repita hasta que el SUDS baje antes de pasar al siguiente.",
                highlight: "Algunos empiezan desde el escalón 5 directamente. Otros necesitan el 1. Los dos son válidos. Lo que no funciona es quedarse en el mismo escalón para siempre."
            ),
            LessonScreenData(
                type: .carrusel,
                title: "Los 8 escalones de la exposición digital",
                cards: [
                    LessonCard(title: "Escalón 1 · Texto anónimo", body: "Escribe sobre tu área en X, Reddit o LinkedIn sin foto de perfil real. El contenido existe, tú eres invisible. SUDS típico: 15-25.", icon: "pencil.circle.fill"),
                    LessonCard(title: "Escalón 2 · Audio sin cara", body: "Graba un podcast, nota de voz pública o clip de audio. Tu voz existe, tu imagen no. SUDS típico: 25-40.", icon: "mic.circle.fill"),
                    LessonCard(title: "Escalón 3 · Objeto o manos", body: "Vídeos donde aparecen tus manos, tus herramientas, lo que creas — sin cara. Estás en pantalla. Solo no se ve tu cara. SUDS típico: 30-45.", icon: "hand.raised.fill"),
                    LessonCard(title: "Escalón 4 · Voz sobre imagen", body: "Tu voz explica algo mientras se ve texto, imágenes o pantalla. Presencia total de voz, presencia cero de imagen tuya. SUDS típico: 35-50.", icon: "waveform.circle.fill"),
                    LessonCard(title: "Escalón 5 · Cara borrosa o de espaldas", body: "Apareces en vídeo pero no eres reconocible. Estás ahí. Tu cuerpo lo sabe. SUDS típico: 45-60.", icon: "person.crop.circle.badge.questionmark"),
                    LessonCard(title: "Escalón 6 · Cara visible sin hablar", body: "Se te ve la cara, en un timelapse o vídeo silencioso. Sin palabras, pero presente. SUDS típico: 55-70.", icon: "person.crop.circle.fill"),
                    LessonCard(title: "Escalón 7 · Hablar a cámara", body: "Tu cara, tu voz, tus palabras. Grabado. Sin tiempo real. Puedes repetir. Puedes editar. SUDS típico: 65-80.", icon: "video.circle.fill"),
                    LessonCard(title: "Escalón 8 · Directo", body: "Sin edición posible. En tiempo real. La exposición máxima. Una vez que lo haces, todo lo demás es fácil. SUDS típico: 75-90.", icon: "livephoto")
                ]
            ),
            LessonScreenData(
                type: .teoria,
                title: "Cómo usar esta escalera",
                body: "Elige el escalón donde tu SUDS sea entre 40 y 60. Si es menos de 40, súbelo. Si es más de 60, bájalo. Haz ese escalón hasta que el SUDS baje al menos 15 puntos antes de subir al siguiente. No hay prisa. Hay dirección.",
                highlight: "El error más común es saltar al escalón 7 desde el 1 y rendirse. El segundo error es quedarse en el 2 indefinidamente porque 'todavía no estoy listo'."
            ),
            LessonScreenData(
                type: .ejercicioIdentifica,
                title: "¿Exposición gradual real o evitación con otro nombre?",
                body: "Toca las que son exposición gradual de verdad.",
                identifyOptions: [
                    IdentifyOption(text: "Llevo 3 semanas en el escalón 2 y el SUDS ya bajó a 20 — voy a probar el 3", isCorrect: true, explanation: "Exposición gradual correcta: esperas a que el SUDS baje antes de avanzar, y luego avanzas."),
                    IdentifyOption(text: "Llevo un año en el escalón 4 porque 'mi nicho no necesita cara'", isCorrect: false, explanation: "Evitación: 'mi nicho no necesita cara' es una racionalización. No hay intención de avanzar."),
                    IdentifyOption(text: "Empiezo en el escalón 5 aunque me da más miedo, porque sé que puedo", isCorrect: true, explanation: "Exposición gradual: elegir un escalón difícil con intención consciente es exactamente el mecanismo correcto."),
                    IdentifyOption(text: "Vuelvo al escalón 1 porque tuve un comentario malo en el escalón 3", isCorrect: false, explanation: "Evitación por retroceso: un comentario negativo no justifica bajar tres escalones. Es una respuesta de huida, no de aprendizaje.")
                ]
            ),
            LessonScreenData(
                type: .resumen,
                title: "Lo que te llevas",
                keyPoints: [
                    "8 escalones de exposición digital: desde texto anónimo hasta directo en vivo",
                    "No hay un punto de entrada obligatorio — hay uno correcto para ti ahora mismo",
                    "Cada escalón se repite hasta que el SUDS baja al menos 15 puntos antes de subir"
                ]
            ),
            LessonScreenData(type: .celebracion,
                title: "Lección 3 completada",
                body: "Tienes la escalera. Ahora elige tu escalón."),
            LessonScreenData(type: .rating,
                title: "¿Cuánto resuena esta lección contigo?")
        ]
    )

    static let m6l4 = Lesson(
        id: "m6l4",
        number: 4,
        title: "El perfeccionismo te tiene parado",
        body: "",
        keyInsight: "",
        scienceFact: "",
        screens: [
            LessonScreenData(
                type: .intro,
                title: "El perfeccionismo te tiene parado",
                subtitle: "Por qué 'todavía no estoy listo' es otra forma de decir 'prefiero no arriesgarme'",
                icon: "clock.badge.xmark"
            ),
            LessonScreenData(
                type: .diagnostico,
                title: "¿Con cuál de estas frases te has identificado alguna vez?",
                choices: [
                    "Cuando tenga mejor cámara, empiezo",
                    "Cuando sepa más sobre el tema, lo explico",
                    "Cuando pierda peso / cambie algo de mi aspecto, me grabo",
                    "Ninguna — nunca he postergado por esto"
                ]
            ),
            LessonScreenData(
                type: .teoria,
                title: "El perfeccionismo como evitación",
                body: "El perfeccionismo no es un estándar de calidad elevado. Es un sistema de evitación con una justificación socialmente aceptable. Cuando dices 'todavía no estoy listo', en realidad estás diciendo 'prefiero no arriesgarme a que salga mal'. La preparación interminable es la forma más cómoda de no empezar.",
                highlight: "Dato real: los creadores más grandes del mundo tienen primeros vídeos con menos de 200 visualizaciones, mala iluminación y audio deficiente. La diferencia entre ellos y quien nunca empezó es que lo publicaron."
            ),
            LessonScreenData(
                type: .tabs,
                title: "Lo que crees vs. lo que dicen los datos",
                tabs: [
                    LessonTab(title: "Lo que crees que pasará", body: "Si publico algo imperfecto, me juzgarán. Necesito la cámara correcta. Tengo que dominar el tema al 100% antes de hablar. Si el primer vídeo es malo, nadie me va a tomar en serio después."),
                    LessonTab(title: "Lo que dicen los datos", body: "El 90% de los espectadores no recuerdan el primer vídeo de un creador que siguen ahora. La consistencia importa más que la calidad inicial. Cuentas con publicación regular superan a cuentas con vídeos perfectos pero esporádicos.")
                ]
            ),
            LessonScreenData(
                type: .teoria,
                title: "La diferencia entre preparación y perfeccionismo",
                body: "Prepararse tiene un fin: tienes lo suficiente para comunicar algo útil. El perfeccionismo no tiene fin: siempre hay algo más que mejorar antes de empezar. La señal de que has cruzado la línea es cuando la preparación ya no te reduce el miedo — solo lo aplaza.",
                highlight: "'Listo' no es un estado. Es una decisión. El momento en que decides que tienes suficiente para empezar — eso es estar listo."
            ),
            LessonScreenData(
                type: .ejercicioIdentifica,
                title: "¿Preparación legítima o perfeccionismo disfrazado?",
                body: "Toca las que son preparación real — con un fin concreto y proporcional.",
                identifyOptions: [
                    IdentifyOption(text: "Practico el tema 3 veces antes de grabarlo para tener fluidez", isCorrect: true, explanation: "Preparación legítima: tiene un objetivo concreto (fluidez) y un límite claro (3 veces)."),
                    IdentifyOption(text: "Llevo 6 meses tomando cursos de edición antes de publicar mi primer vídeo", isCorrect: false, explanation: "Perfeccionismo: 6 meses de cursos antes del primer vídeo es preparación sin fin. El primer vídeo no requiere saber editar."),
                    IdentifyOption(text: "Compro un micrófono porque el audio de mi móvil tiene eco que distorsiona", isCorrect: true, explanation: "Preparación legítima: soluciona un problema técnico real y proporcional. No es vanidad, es una barrera real para el oyente."),
                    IdentifyOption(text: "Espero a tener 1.000 seguidores en otra red antes de empezar a grabar", isCorrect: false, explanation: "Perfeccionismo: condición arbitraria sin relación lógica con la capacidad de grabar. Es una excusa disfrazada de requisito.")
                ]
            ),
            LessonScreenData(
                type: .resumen,
                title: "Lo que te llevas",
                keyPoints: [
                    "El perfeccionismo es evitación con justificación socialmente aceptable",
                    "La preparación tiene un fin; el perfeccionismo no — siempre hay algo más",
                    "'Listo' no es un estado que llega solo. Es una decisión que tomas tú."
                ]
            ),
            LessonScreenData(type: .celebracion,
                title: "Lección 4 completada",
                body: "El siguiente paso no es prepararte más. Es publicar."),
            LessonScreenData(type: .rating,
                title: "¿Cuánto resuena esta lección contigo?")
        ]
    )

    static let m6l5 = Lesson(
        id: "m6l5",
        number: 5,
        title: "Crear sin que te destroce la respuesta",
        body: "",
        keyInsight: "",
        scienceFact: "",
        screens: [
            LessonScreenData(
                type: .intro,
                title: "Crear sin que te destroce la respuesta",
                subtitle: "Los 3 escenarios que más temes después de publicar — y cómo responder a cada uno",
                icon: "shield.fill"
            ),
            LessonScreenData(
                type: .teoria,
                title: "El después también da miedo",
                body: "Publicar no es el único momento de ansiedad. El después tiene sus propios disparadores: nadie lo ve, alguien dice algo malo, o alguien que conoces lo descubre. Cada uno activa un tipo diferente de malestar. Tener una respuesta preparada para cada uno cambia lo que pasa después.",
                highlight: "No puedes controlar la respuesta. Sí puedes decidir cómo interpretarla — y esa interpretación determina si publicas la próxima vez o no."
            ),
            LessonScreenData(
                type: .carrusel,
                title: "Los 3 escenarios que más temes",
                cards: [
                    LessonCard(title: "Nadie lo ve", body: "Subes algo y hay 0 interacciones. Silencio total. Respuesta CBT: Todo el contenido empieza con cero. El algoritmo tarda en calibrar. Lo que estás haciendo ahora es entrenar, no actuar. Publica el siguiente.", icon: "eye.slash.fill"),
                    LessonCard(title: "Un comentario negativo", body: "Un comentario negativo puede doler muchísimo, no porque tenga razón, sino porque toca justo el miedo que estás intentando superar: ser juzgado, rechazado o ridiculizado. Tu cerebro tiende a fijarse más en lo negativo — por eso ese comentario puede parecer enorme, aunque esté rodeado de apoyo o silencio.", icon: "text.bubble.fill"),
                    LessonCard(title: "Lo ven personas que conoces", body: "Un compañero, un familiar, alguien de tu pasado. Respuesta CBT: Los que te conocen reaccionan en dos grupos: los que te apoyan (mayoría) y los que critican (pocos). Los que critican ya tenían esa opinión antes — tu contenido no la creó.", icon: "person.2.fill")
                ]
            ),
            LessonScreenData(
                type: .teoria,
                title: "Construir una relación sana con el feedback",
                body: "La meta no es no sentir nada cuando publicas. Es poder publicar aunque sientas. Crear un ritual de desconexión post-publicación ayuda: publica, cierra la app, haz algo que nada tiene que ver con el contenido. Revisa las métricas después de 48 horas, no antes.",
                highlight: "Los creadores que duran no son los que no sienten ansiedad. Son los que han aprendido a publicar aunque la tengan."
            ),
            LessonScreenData(
                type: .ejercicioIdentifica,
                title: "¿Respuesta sana o espiral de evitación?",
                body: "Toca las respuestas sanas — las que no alimentan el ciclo de evitación.",
                identifyOptions: [
                    IdentifyOption(text: "Publico, cierro la app y vuelvo a mirar las métricas en 48 horas", isCorrect: true, explanation: "Respuesta sana: el ritual de desconexión post-publicación reduce la ansiedad y rompe el ciclo de revisión compulsiva."),
                    IdentifyOption(text: "Borro el vídeo a las 2 horas porque nadie lo vio todavía", isCorrect: false, explanation: "Espiral de evitación: borrar elimina la oportunidad de aprendizaje y refuerza la creencia de que publicar es peligroso."),
                    IdentifyOption(text: "Leo el comentario negativo, lo anoto como dato, y publico el siguiente vídeo", isCorrect: true, explanation: "Respuesta sana: tratar el comentario como dato en vez de veredicto es la respuesta CBT correcta."),
                    IdentifyOption(text: "No publico más hasta que el primer vídeo tenga 100 likes", isCorrect: false, explanation: "Espiral de evitación: la condición de los 100 likes es perfeccionismo post-publicación. Bloquea el progreso con una condición arbitraria.")
                ]
            ),
            LessonScreenData(
                type: .resumen,
                title: "Tienes el módulo completo. Ahora toca grabar.",
                keyPoints: [
                    "Los 3 escenarios más temidos post-publicación tienen respuesta CBT concreta",
                    "No vas a eliminar la ansiedad — vas a publicar aunque la tengas",
                    "Los creadores que duran separan el valor de su contenido de la reacción que recibe"
                ]
            ),
            LessonScreenData(type: .celebracion,
                title: "¡Módulo 6 completado!",
                body: "Tienes el módulo de contenido completo. Ahora toca grabar."),
            LessonScreenData(type: .rating,
                title: "¿Cuánto resuena este módulo contigo?")
        ]
    )
}
