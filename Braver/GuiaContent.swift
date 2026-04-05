import Foundation

// MARK: - All Learning Content

enum GuiaContent {

    static let modules: [LearningModule] = [module1, module2, module3, module4]

    // MARK: - Módulo 1: Entender tu vergüenza

    static let module1 = LearningModule(
        id: "m1",
        title: "Entender tu vergüenza",
        subtitle: "Qué te pasa y por qué te pasa.",
        emoji: "🧠",
        colorHex: "4C9EEB",
        lessons: [
            Lesson(
                id: "m1l1",
                number: 1,
                title: "Qué es la vergüenza de verdad",
                body: """
La timidez, la vergüenza, la ansiedad social y la fobia social no son lo mismo, aunque a veces se confunden. La timidez es una forma de ser: algunas personas son más reservadas por naturaleza. La ansiedad social es el miedo a cómo te ven los demás. La vergüenza social va un paso más allá: es la convicción de que los demás tienen razón en verte negativamente.

La fobia social es la versión más intensa y limitante de todo esto: interfiere de forma significativa en tu vida diaria, en el trabajo, las relaciones y las oportunidades.

La vergüenza no es una emoción puntual que aparece en situaciones concretas. Es más profunda: es la creencia de que hay algo fundamentalmente malo en ti que los demás ya han descubierto, o que descubrirán si te acercas demasiado. No es "me da vergüenza haberme equivocado". Es "soy alguien que se equivoca, y eso confirma lo que ya sabía de mí".

La diferencia importante es esta: la timidez habla de cómo eres; la ansiedad social habla de cómo te ven; la vergüenza habla de quién crees que eres. Y esa creencia es la que esta app te va a ayudar a cuestionar y cambiar.
""",
                keyInsight: "La vergüenza no es una emoción puntual, es la creencia de que hay algo fundamentalmente malo en ti que los demás ya han descubierto.",
                scienceFact: "Investigadores encontraron una correlación positiva entre la ansiedad social y la vergüenza en 35 de 37 estudios analizados, confirmando que estas dos experiencias están muy conectadas en cómo procesamos las situaciones sociales."
            ),
            Lesson(
                id: "m1l2",
                number: 2,
                title: "Por qué tu cerebro quiere esconderte",
                body: """
Hace 200.000 años, ser rechazado por tu grupo era equivalente a morir. Sin tribu, no había comida, no había protección, no había supervivencia. Por eso el cerebro humano desarrolló un sistema de alarma muy sensible al rechazo social: la vergüenza.

Cuando tu amígdala detecta una posible amenaza social, activa el sistema nervioso simpático en milisegundos. Se libera adrenalina y cortisol. El corazón se acelera. La respiración se acorta. La sangre se aleja de la cara y las extremidades. Los músculos se tensan. En algunos casos, la mente se queda en blanco.

Todo esto es exactamente la misma respuesta que tendríamos ante un peligro físico real, como un animal salvaje. El problema es que tu cerebro no distingue bien entre "me puede comer un león" y "me pueden juzgar en una reunión". Activa la misma alarma para los dos.

Tu vergüenza, entonces, no es un defecto. No es que estés roto. Es que tu sistema de supervivencia está demasiado calibrado para detectar amenazas sociales que, en el mundo actual, ya no son peligrosas de verdad. Tu cerebro intenta protegerte del rechazo, aunque ese peligro ahora sea principalmente imaginario.
""",
                keyInsight: "Tu vergüenza no es un defecto tuyo; es una herencia de supervivencia. Tu cerebro está intentando protegerte del rechazo, aunque ahora ese peligro sea principalmente imaginario.",
                scienceFact: "Estudios de neuroimagen (fMRI) muestran que personas con ansiedad social tienen activación exagerada en la amígdala cuando perciben que están siendo evaluadas. Esta respuesta es involuntaria y automática, no una elección consciente."
            ),
            Lesson(
                id: "m1l3",
                number: 3,
                title: "Cuándo la vergüenza te protege y cuándo te limita",
                body: """
No toda vergüenza es mala. Existe una vergüenza sana y una vergüenza tóxica. La sana es proporcional, temporal y respeta tu valor como persona. Aparece cuando haces algo que va en contra de tus valores, te avisa, y luego desaparece cuando corriges el rumbo.

La vergüenza tóxica es desproporcionada, crónica y niega tu valor. No desaparece cuando corriges algo porque no tiene que ver con lo que hiciste. Tiene que ver con lo que crees que eres.

¿Cómo saber si tu vergüenza es tóxica? Hazte estas preguntas:
— ¿Evitas situaciones por miedo a que te juzguen?
— ¿Tus relaciones se han visto limitadas por esto?
— ¿Has dejado de hacer cosas que te importan?
— ¿La ansiedad es desproporcionada al riesgo real?
— ¿Rumias mucho después de las interacciones sociales?

Si respondiste sí a dos o más, tu vergüenza está dejando de protegerte para empezar a limitarte. Y eso es lo que trabajaremos en esta app.
""",
                keyInsight: "Tu vergüenza es tóxica no por su intensidad inicial, sino porque has aprendido a evitarla en lugar de atravesarla.",
                scienceFact: "Los investigadores descubrieron que la vergüenza no se reduce naturalmente con la evitación. Para reducirla, necesitas desafiar activamente las creencias que la generan: no soy defectuoso, cometer errores es humano, otros también pasan por esto."
            ),
            Lesson(
                id: "m1l4",
                number: 4,
                title: "Tus disparadores",
                body: """
Cada persona tiene sus propios disparadores: situaciones concretas que activan la respuesta de vergüenza con más intensidad. No son aleatorios. Revelan exactamente qué tipo de juicio social te asusta más.

Los disparadores más comunes incluyen:
— Hablar en público o delante de un grupo
— Hacer llamadas telefónicas
— Situaciones románticas o de ligar
— Entrar a un grupo ya formado
— Tratar con figuras de autoridad
— Estar rodeado de desconocidos
— Ser observado mientras haces algo

Tu cerebro no activa la alarma de vergüenza en cualquier situación. La activa en aquellas donde cree que el riesgo de evaluación negativa es más alto. Por eso tus disparadores son pistas valiosas: te dicen en qué áreas tu sistema de alarma está sobredimensionado.

Identificar tus disparadores específicos es el primer paso para diseñar un plan de acción. No puedes enfrentarte a algo que no has nombrado.
""",
                keyInsight: "Tus disparadores no son aleatorios; revelan exactamente qué tipo de juicio social te asusta más.",
                scienceFact: "El componente central de la ansiedad social es el miedo a la evaluación negativa por parte de otros. El tipo de situaciones que evitas depende de dónde creas que es más probable que ocurra esa evaluación negativa."
            ),
            Lesson(
                id: "m1l5",
                number: 5,
                title: "Tu mapa personal de vergüenza",
                body: """
Tu patrón de vergüenza social se puede mapear usando cuatro componentes que se refuerzan mutuamente:

**Lo que evitas:** Las situaciones, personas y contextos que evitas o de los que escapas antes de tiempo. Cada evitación le dice a tu cerebro que tenía razón en tener miedo.

**Lo que piensas:** Antes de la situación (buscas peligros), durante (te auto-monitoreas en exceso, lo que reduce tu presencia real) y después (rumias sobre cómo salió).

**Lo que sientes:** Las sensaciones físicas de la activación —corazón acelerado, tensión, sudor, mente en blanco— que tu cerebro interpreta como confirmación del peligro.

**Lo que haces:** Las conductas de seguridad: mirar al suelo, hablar poco, ir acompañado siempre, ensayar obsesivamente lo que vas a decir, buscar validación constante.

Estos cuatro elementos forman un círculo que se alimenta a sí mismo. La buena noticia es que los círculos se pueden romper. Y se pueden romper en cualquiera de sus puntos. Esta app te enseñará cómo hacerlo, paso a paso.
""",
                keyInsight: "Tu patrón de vergüenza no es magia; es un círculo que tú mismo alimentas cada día sin saberlo. Y los círculos se pueden romper.",
                scienceFact: "Los estudios muestran que las personas con ansiedad social tienden a focalizarse más en sí mismas durante las interacciones y a rumiar más después. Las intervenciones cognitivo-conductuales que atacan directamente este patrón muestran tamaños de efecto grandes en la reducción de la ansiedad social."
            )
        ]
    )

    // MARK: - Módulo 2: La trampa de la evitación

    static let module2 = LearningModule(
        id: "m2",
        title: "La trampa de la evitación",
        subtitle: "Por qué evitar te da alivio corto pero te empeora a largo plazo.",
        emoji: "🚪",
        colorHex: "F97316",
        lessons: [
            Lesson(
                id: "m2l1",
                number: 1,
                title: "El alivio que te engaña",
                body: """
Cuando evitas algo que te da miedo, tu ansiedad baja de inmediato. Eso se llama refuerzo negativo: eliminas algo desagradable (la ansiedad) con tu comportamiento (la evitación), así que tu cerebro aprende que evitar = seguridad.

El problema es lo que pasa después. Como nunca entraste en la situación, tu cerebro nunca tuvo la oportunidad de aprender que no era tan peligrosa. Así que la próxima vez, activa la misma alarma, igual de fuerte. O más fuerte, porque el historial de evitación refuerza la creencia de que el peligro era real.

Y así se va construyendo el ciclo: evitar genera alivio, el alivio refuerza la evitación, la evitación aumenta el miedo a largo plazo.

El alivio que sientes al evitar es completamente real y completamente engañoso al mismo tiempo. Tu cerebro lo interpreta como prueba de que tomaste la decisión correcta. Pero lo único que hizo fue posponer el problema, añadiéndole intereses.
""",
                keyInsight: "El alivio de la evitación es el anzuelo que mantiene el miedo atrapado en tu vida.",
                scienceFact: "Los comportamientos de seguridad y la evitación mantienen la ansiedad a largo plazo porque el alivio se atribuye erróneamente a la conducta de escape, reforzando la creencia de que el peligro era real. Sin exposición, el cerebro nunca aprende que estaba equivocado."
            ),
            Lesson(
                id: "m2l2",
                number: 2,
                title: "Las conductas que te hacen sentir 'seguro'",
                body: """
Las conductas de seguridad son comportamientos que usas para reducir la ansiedad en el momento sin salir de la situación. Las más comunes incluyen:

— Mirar al suelo o evitar el contacto visual
— Hablar muy poco o muy despacio
— Usar el teléfono como escudo
— Ensayar obsesivamente lo que vas a decir
— Ir siempre acompañado
— Salir antes de tiempo de eventos sociales
— Beber alcohol para desinhibirte
— Buscar validación constante de otros
— Hacer chistes autodeprecativos para adelantarte al juicio

El problema es que estas conductas, aunque alivian tu ansiedad en el momento, refuerzan exactamente los resultados que temes. Evitar el contacto visual parece inseguridad. Hablar muy poco parece frialdad. Ensayar en exceso hace que suenes artificial.

Y hay algo aún más importante: como usas estas conductas, nunca descubres que no las necesitabas. Si terminas una situación social relativamente bien, te dices "fue porque ensayé mucho" o "fue porque tuve a mi amigo conmigo". La conducta de seguridad se lleva el crédito, no tú.
""",
                keyInsight: "Tus comportamientos de seguridad alivian tu ansiedad en el corto plazo, pero la mantienen viva a largo plazo.",
                scienceFact: "Los estudios muestran que cuando las personas reducen o eliminan sus comportamientos de seguridad durante la exposición, experimentan una mayor reducción de ansiedad a largo plazo que quienes los mantienen. Las muletas impiden aprender que no las necesitabas."
            ),
            Lesson(
                id: "m2l3",
                number: 3,
                title: "El sobreanálisis antes, durante y después",
                body: """
La ansiedad social opera en tres momentos, no solo en el instante de la situación:

**Antes:** Tu mente busca peligros anticipando la situación. "¿Y si no sé qué decir?", "¿Y si me pongo rojo?", "¿Y si la gago?". Esta anticipación aumenta tu activación fisiológica antes de que pase nada.

**Durante:** Te hipermonitoreas a ti mismo. Parte de tu atención está en lo que dices, y otra parte está observándote desde fuera, evaluando cómo te ves. Este procesamiento en dos canales hace que no estés realmente presente, lo cual paradójicamente aumenta la probabilidad de los errores que temes.

**Después:** La rumiación post-evento. Repasas la situación buscando evidencia de que lo hiciste mal. Magnificas los momentos incómodos. Minimizas los momentos que salieron bien. Y concluyes que fue un desastre.

Este sobreanálisis es una trampa porque parece útil ("solo estoy siendo cuidadoso") pero en realidad mantiene y amplifica la ansiedad. No te protege. Te atrapa.
""",
                keyInsight: "Tu sobre-análisis no te protege; te atrapa en un bucle de pensamiento que aumenta tu ansiedad antes, durante y después de cada situación social.",
                scienceFact: "Un meta-análisis de 2024 encontró una asociación moderada entre la rumiación post-evento y la ansiedad social. Las intervenciones cognitivo-conductuales que atacan directamente este patrón muestran tamaños de efecto grandes en la reducción de síntomas."
            ),
            Lesson(
                id: "m2l4",
                number: 4,
                title: "El miedo al juicio de los demás",
                body: """
Uno de los pilares de la ansiedad social es el "efecto spotlight": la ilusión de que estás constantemente siendo observado y evaluado por los demás. Que cada pequeño error tuyo es notado, recordado y comentado.

Un estudio famoso mostró esto con claridad. Estudiantes universitarios que llevaban camisetas con una imagen ridícula predijeron que aproximadamente el 50% de sus compañeros las notarían. La cifra real fue alrededor del 25%.

¿Por qué sobrestimamos tanto? Porque nuestra propia experiencia de nosotros mismos es muy vívida y presente. Sabemos exactamente qué llevamos puesto, cómo nos sentimos, qué acabamos de decir. Y asumimos que los demás tienen acceso a esa misma información. No es así. Los demás están pensando en sí mismos.

El efecto spotlight es aún más pronunciado en personas con ansiedad social, pero es universal. El público que temes es mucho menos crítico y menos atento de lo que tu ansiedad te hace creer.
""",
                keyInsight: "El público que temes es mucho menos crítico y menos atento de lo que tu ansiedad te hace creer.",
                scienceFact: "Los estudios sobre el efecto spotlight (Gilovich, Medvec & Savitsky, 2000) muestran que las personas sistemáticamente sobrestiman cuánto otros las notan y las juzgan. En personas con mayor ansiedad social, esta sobrestimación es aún más pronunciada."
            ),
            Lesson(
                id: "m2l5",
                number: 5,
                title: "Cómo la evitación va encogiendo tu mundo",
                body: """
La evitación no se queda estática. Si no la detienes, crece. Empieza por pequeñas cosas que evitas aquí y allá. Pero con el tiempo, el patrón se generaliza.

Primero evitas eventos donde no conoces a nadie. Luego evitas situaciones donde podrías tener que hablar en grupo. Luego tu trabajo empieza a limitarse porque evitas ciertas interacciones. Luego las relaciones se vuelven más superficiales porque la intimidad da miedo.

El mundo seguro se encoge. Y lo hace silenciosamente, de forma gradual, sin que lo notes hasta que un día miras atrás y te preguntas cuándo dejaste de hacer las cosas que antes hacías.

Hay algo más: cada vez que evitas algo, te estás diciendo a ti mismo "soy alguien que no puede hacer esto". Con el tiempo, la evitación no es solo un comportamiento. Se convierte en parte de tu identidad. La buena noticia es que la identidad también se puede cambiar. Con acciones pequeñas y consistentes.
""",
                keyInsight: "La evitación te protege del miedo hoy, pero roba tu vida mañana.",
                scienceFact: "La investigación muestra que la evitación tiene un efecto acumulativo: no solo mantiene la ansiedad en situaciones específicas, sino que generaliza a otras áreas de la vida, aumentando progresivamente la depresión y la soledad. Pero reducir la evitación, incluso en pequeños pasos, genera mejoras dramáticas en el bienestar."
            )
        ]
    )

    // MARK: - Módulo 3: Calmar tu mente y tu cuerpo

    static let module3 = LearningModule(
        id: "m3",
        title: "Calmar tu mente y tu cuerpo",
        subtitle: "Herramientas reales para gestionar la ansiedad cuando llega.",
        emoji: "🫁",
        colorHex: "10B981",
        lessons: [
            Lesson(
                id: "m3l1",
                number: 1,
                title: "Qué le pasa a tu cuerpo cuando te bloqueas",
                body: """
Cuando tu amígdala detecta una amenaza social, activa el sistema nervioso simpático en cuestión de milisegundos. Las glándulas suprarrenales liberan epinefrina (adrenalina) y cortisol. Esto produce una cascada de cambios físicos:

— El corazón se acelera para llevar más sangre a los músculos
— La respiración se hace más rápida y superficial
— La sangre se aleja de la cara y las extremidades (por eso palideces o te ruborizas)
— Los músculos se tensan, listos para actuar
— La voz puede temblar o cambiar de tono
— En casos intensos, la mente se queda en blanco

Todo esto está diseñado para un propósito: prepararte para luchar, huir o quedarte paralizado ante un peligro físico. El problema es que esta maquinaria se activa igual ante una evaluación social percibida.

No estás reaccionando mal. Estás reaccionando exactamente como tu sistema nervioso fue diseñado. Pero ese diseño no distingue entre amenazas físicas reales y amenazas sociales percibidas.
""",
                keyInsight: "Tu cuerpo reacciona a la amenaza percibida igual que a la real, pero eso no significa que el peligro exista.",
                scienceFact: "Investigadores describen cómo la amígdala activa el sistema nervioso simpático en milisegundos, liberando epinefrina desde las glándulas suprarrenales. Esta reacción no diferencia entre amenazas físicas reales y amenazas sociales percibidas."
            ),
            Lesson(
                id: "m3l2",
                number: 2,
                title: "Cómo bajar revoluciones antes de exponerte",
                body: """
Existe una técnica que usan los Navy SEALs antes de situaciones de alto estrés: la respiración en caja (box breathing). Es simple, efectiva y tiene base neurofisiológica sólida.

**Cómo hacerlo:**
1. Inhala lentamente durante 4 segundos
2. Aguanta el aire 4 segundos
3. Exhala lentamente durante 4 segundos
4. Aguanta sin aire 4 segundos
5. Repite el ciclo 5-10 veces

¿Por qué funciona? La exhalación lenta activa el nervio vago, que es como el "freno" de tu sistema nervioso. Cuando el nervio vago se activa, el sistema nervioso parasimpático toma el control: el corazón se ralentiza, la respiración se normaliza, la activación baja.

La respiración es el único mecanismo involuntario de tu sistema nervioso que también puedes controlar voluntariamente. Eso la convierte en una palanca directa sobre tu estado interno.

**Importante:** úsala antes de que la ansiedad llegue a su pico. Si esperas a estar en pánico total, cuesta más. Úsala cuando notes los primeros síntomas.
""",
                keyInsight: "La respiración lenta es el único mecanismo que controlas voluntariamente y que calma tu sistema nervioso directamente.",
                scienceFact: "Un estudio de 2024 sobre prácticas breves de respiración estructurada encontró que sesiones de 5 a 10 minutos mejoran significativamente el estado de ánimo y reducen la activación fisiológica medible, incluyendo la frecuencia cardíaca y los niveles de cortisol."
            ),
            Lesson(
                id: "m3l3",
                number: 3,
                title: "Qué hacer con los pensamientos que te hunden",
                body: """
La reestructuración cognitiva no es sustituir pensamientos negativos por positivos falsos. Es algo más honesto y más útil: poner a prueba tus predicciones catastróficas contra la evidencia real.

Cuando tienes un pensamiento como "voy a parecer raro", no te digas "¡no, soy genial!". En su lugar, pregúntate:
— ¿Cuántas veces me ha pasado esto antes?
— ¿Qué evidencia real tengo de que va a ocurrir?
— ¿Qué probabilidad real tiene?
— ¿Qué pasaría si ocurriera? ¿Sería tan catastrófico?

Un reencuadre realista sería algo así: "Probablemente estaré nervioso, eso es normal. Puedo hablar aunque esté nervioso. La mayoría de la gente entiende que hablar en público es difícil. Incluso si meto la pata, eso es humano."

No te mientes. Solo te niegas a tratar una predicción como un hecho. Los pensamientos ansiosos son hipótesis, no realidades. Tratalos como lo que son: posibilidades que hay que probar, no verdades que hay que aceptar.
""",
                keyInsight: "Los pensamientos ansiosos son predicciones, no hechos. Pruébalos contra la evidencia real.",
                scienceFact: "Meta-análisis de 2024 sobre reestructuración cognitiva muestran que esta técnica es especialmente efectiva para la ansiedad social porque interrumpe el ciclo entre pensamientos amenazantes y comportamientos de evitación, reduciendo síntomas en un 60% de los casos estudiados."
            ),
            Lesson(
                id: "m3l4",
                number: 4,
                title: "Cómo hablarte mejor sin mentirte",
                body: """
Hay una diferencia crucial entre la positividad tóxica y la autocompasión real.

La positividad tóxica suena así: "¡Todo va a ir perfecto! ¡Eres increíble! ¡No pasa nada!" Tu cerebro la detecta como falsa y la rechaza, porque no corresponde con la realidad que estás viviendo.

La autocompasión real suena así: "Esto es difícil. Es normal que esté nervioso. He pasado por cosas difíciles antes y he salido adelante. Si sale mal, no me define."

La autocompasión valida la dificultad sin magnificarla. No te dice que todo es fácil, sino que eres capaz de manejar lo que no es fácil. Es la diferencia entre hablar contigo mismo como un crítico despiadado o como un buen amigo que te quiere y confía en ti.

¿Qué le dirías a un amigo tuyo que tuviera miedo antes de una situación social? Probablemente no le dirías "¡no seas ridículo, es facilísimo!". Le dirías algo honesto, amable y que le diera fuerza. Habla contigo mismo igual.
""",
                keyInsight: "La autocompasión no es una excusa; es el combustible que te permite actuar a pesar del miedo.",
                scienceFact: "Investigación de Kristin Neff (University of Texas) muestra que la autocompasión está vinculada a mayores niveles de bienestar psicológico y menores niveles de ansiedad. A diferencia de la positividad tóxica, reduce la vergüenza y aumenta la motivación para actuar."
            ),
            Lesson(
                id: "m3l5",
                number: 5,
                title: "Aprender a aguantar la incomodidad",
                body: """
La tolerancia al malestar es una de las habilidades más poderosas que puedes desarrollar. Viene de la Terapia Dialéctica Conductual (DBT) y su premisa es simple: el malestar no es peligroso. Es solo incómodo.

Cuando sientes el impulso de escapar de una situación ansiosa, lo que en realidad estás haciendo es enseñarle a tu cerebro que esa situación es tan peligrosa que hay que huir. Pero si te quedas, si toleras la incomodidad, tu cerebro recibe una información diferente: "Sobreviví. No era tan peligroso."

El proceso en tres pasos:
1. **Acepta** que va a ser incómodo. No pelees contra la incomodidad, eso solo la amplifica.
2. **Observa** exactamente qué sientes y dónde lo sientes. ¿Tensión en el pecho? ¿Calor en la cara? Nombrar las sensaciones las hace más manejables.
3. **Respira y haz pequeñas acciones.** No tienes que hacer nada perfecto. Solo quedarte y hacer algo pequeño.

La ansiedad sigue una curva natural: sube, llega a un pico, y luego baja por sí sola si no escapas. Cada vez que atraviesas esa curva, tu sistema nervioso aprende que puede manejarlo.
""",
                keyInsight: "La incomodidad que toleras hoy es la libertad que ganas mañana.",
                scienceFact: "Investigación sobre habilidades de tolerancia al distrés en DBT sugiere que la capacidad de tolerar la angustia sin evitarla es un predictor más fuerte de recuperación a largo plazo que la reducción inicial de la ansiedad durante el tratamiento."
            )
        ]
    )

    // MARK: - Módulo 4: Exponerte y ganar terreno

    static let module4 = LearningModule(
        id: "m4",
        title: "Exponerte y ganar terreno",
        subtitle: "Pasar a la acción con una estrategia que funciona.",
        emoji: "🏆",
        colorHex: "F59E0B",
        lessons: [
            Lesson(
                id: "m4l1",
                number: 1,
                title: "La regla que más te va a cambiar: exponerte poco a poco",
                body: """
La terapia de exposición es la intervención con mayor evidencia científica para la ansiedad social. La idea es deceptivamente simple: enfrenta lo que temes, en dosis controladas, hasta que tu cerebro aprenda que no era tan peligroso.

Cuando evitas, tu cerebro registra: "buena decisión, ese era un peligro real". Cuando te expones y no pasa nada catastrófico (o pasa algo incómodo pero sobrevivible), tu cerebro registra algo muy diferente: "espera, eso no fue tan malo como creía".

Ese proceso de actualización se llama aprendizaje de extinción. No es solo habituación (que la ansiedad baje con la repetición). Es que tu cerebro crea una nueva asociación: antes pensaba "situación X = peligro"; ahora aprende "situación X = incómodo pero manejable".

La clave del gradual: empieza por situaciones que te activan pero que puedes manejar. Si empiezas directamente por lo más difícil, la probabilidad de escapar antes de tiempo es alta. Y escapar en medio de la exposición refuerza el miedo, no lo reduce.
""",
                keyInsight: "Cada exposición pequeña es una pieza de evidencia de que no es peligroso. Acumula suficientes piezas y tu miedo cambia.",
                scienceFact: "Investigación publicada en Scientific Reports (2020) muestra que el aprendizaje de extinción —no solo la habituación— es el mecanismo central por el que la terapia de exposición funciona, y el que predice mejores resultados a largo plazo."
            ),
            Lesson(
                id: "m4l2",
                number: 2,
                title: "Cómo crear tu lista de retos",
                body: """
Una jerarquía de exposición es una lista personalizada de situaciones que temes, ordenadas de menos a más difícil. La clave es que sea tuya: situaciones reales de tu vida, no situaciones genéricas.

**Para crearla:**
1. Identifica las situaciones que realmente te generan ansiedad
2. Para cada una, crea variantes de fácil a difícil
3. Usa la escala SUDS (0-100) para puntuar cada una
4. Asegúrate de que tu lista cubre el rango 20-80

La escala SUDS es tu brújula:
— 0-20: Sin ansiedad significativa
— 20-40: Incómodo pero manejable → aquí empiezas
— 40-60: Claramente difícil → zona de trabajo principal
— 60-80: Muy desafiante pero posible → objetivos avanzados
— 80-100: Máximo miedo → objetivo final

Evita saltar del 30 al 75 directamente. Los escalones tienen que ser cercanos. La graduación no es cobardía, es estrategia.
""",
                keyInsight: "Tu escalera de retos es tu mapa. Sigue los peldaños, no saltes al final.",
                scienceFact: "Investigación clínica muestra que las jerarquías de exposición creadas por el propio paciente tienen tasas de cumplimiento significativamente más altas y generan mayor sensación de autoeficacia durante el proceso."
            ),
            Lesson(
                id: "m4l3",
                number: 3,
                title: "Empezar por microexposiciones",
                body: """
Las microexposiciones son acciones pequeñas (5-10 minutos) que desafían tu zona de confort sin sobrepasarla. Son la forma más poderosa de empezar porque son lo suficientemente pequeñas para que las hagas, y lo suficientemente reales para que le enseñen algo a tu cerebro.

Algunos ejemplos:
— Mantener contacto visual con alguien durante 3 segundos
— Preguntarle la hora a un desconocido
— Hacer una pregunta en un grupo pequeño
— Decir una frase en una conversación donde normalmente te callas
— Pedir algo en una tienda
— Mandar un mensaje de voz en lugar de texto

El poder de las microexposiciones está en la repetición, no en el tamaño. Una microexposición que haces cinco veces a la semana es exponencialmente más efectiva que una gran exposición que haces una vez al mes.

"Pequeño y consistente" es el principio que más cambia vidas en el trabajo con la ansiedad social. No necesitas grandes gestos heroicos. Necesitas muchas acciones pequeñas, repetidas con regularidad.
""",
                keyInsight: "Pequeño y consistente es más poderoso que grande y ocasional.",
                scienceFact: "Estudios de protocolos de exposición muestran que múltiples exposiciones breves (5-10 minutos) generan tanto aprendizaje de extinción como exposiciones prolongadas, con una tasa de abandono significativamente menor."
            ),
            Lesson(
                id: "m4l4",
                number: 4,
                title: "Qué hacer cuando una exposición sale mal",
                body: """
Las exposiciones no siempre salen bien. A veces te trabas. A veces dices algo raro. A veces la incomodidad es alta. Eso no es un fracaso, es información.

Cuando una exposición es incómoda: tu voz tembló, dijiste algo torpe, sentiste que te ruborizabas. ¿Y qué pasó? Sobreviviste. Tu predicción catastrófica no se cumplió, o se cumplió parcialmente y fue mucho más manejable de lo que esperabas.

**Qué hacer después de una exposición difícil:**
1. **Anota lo que realmente pasó** (datos, no drama). No "fue un desastre" sino "me puse nervioso al hablar, me trabé en una palabra, la conversación duró 3 minutos".
2. **Cuestiona tu interpretación catastrófica.** ¿Lo que pasó fue realmente tan malo? ¿Cómo lo vería alguien objetivo?
3. **Repite.** La repetición acumula evidencia de extinción incluso cuando las exposiciones no salen perfectas.

Una exposición incómoda que repites es más poderosa que una perfecta que nunca ocurre. La imperfección no invalida el aprendizaje.
""",
                keyInsight: "Una exposición incómoda que repites es más poderosa que una perfecta que nunca ocurre.",
                scienceFact: "Investigación sobre aprendizaje inhibitorio muestra que la exposición imperfecta —donde la ansiedad no baja completamente— sigue siendo efectiva para la extinción del miedo cuando se repite con consistencia."
            ),
            Lesson(
                id: "m4l5",
                number: 5,
                title: "Cómo mantener el cambio y no volver a esconderte",
                body: """
El cambio en la ansiedad social no es un destino al que se llega y ya está. Es un camino que se mantiene con práctica. Si paras de exponerte, la ansiedad vuelve gradualmente. No al punto de partida, pero vuelve.

**Cómo mantener lo ganado:**

**Consistencia pequeña:** Es más efectivo hacer algo pequeño cada semana que hacer algo grande cada mes. Una llamada telefónica semanal que antes evitabas, un comentario en reuniones, una conversación con un desconocido.

**Espera los días malos:** Habrá días de más estrés, de más miedo, donde la ansiedad sube. Ajusta tus expectativas ese día, pero no lo interpretes como un fracaso ni como que "has vuelto a empezar".

**Conecta con tus valores:** ¿Por qué empezaste? ¿Qué quieres que tu vida incluya que ahora no incluye? Cuando la motivación flaquea, volver a esa pregunta renueva el compromiso.

**Documenta tu progreso:** Hace tres meses las llamadas eran terribles. Ahora son incómodas pero manejables. El progreso real es lento y puede ser invisible si no lo registras. Por eso existe el diario en esta app.
""",
                keyInsight: "La consistencia pequeña vence a la perfección ocasional. Cada día es una oportunidad para mantener lo que ganaste.",
                scienceFact: "Meta-análisis en psicología clínica muestra que la intervención de prevención de recaídas basada en TCC reduce la recurrencia de ansiedad en un 40% comparado con no aplicar ninguna estrategia de mantenimiento."
            )
        ]
    )
}
