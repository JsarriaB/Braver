# Plan de mejora — Braver

---

## Contexto

Braver es una app de ansiedad social con base clínica (CBT + terapia de exposición). Sus puntos fuertes son Nova (IA generativa real), el sistema SUDS, el Orb de 9 etapas, el Momento Braver, el diario nocturno, y un framework clínico sólido. Su debilidad actual: las lecciones son texto puro y pasivo.

Este plan mejora la app en tres frentes sin cambiar lo que ya funciona bien.

---

## FASE 1 — Nuevo motor de módulos (wizard por capas)

### Qué es

Todas las lecciones (existentes y nuevas) pasan de ser un scroll de texto a ser un wizard de 8-12 pantallas variadas. Una pantalla = una idea. Nunca más de 3-4 líneas de texto seguidas. Entre ideas, siempre algo interactivo o visual.

### Tipos de pantalla (LessonScreenType)

Cada lección es un array de pantallas. Cada pantalla tiene un tipo:

- **intro** — Portada de la lección. Ilustración grande + título + subtítulo + botón "Vamos". Una por lección.
- **diagnostico** — Pregunta inicial con 3-4 opciones. Personaliza el tono pero no bifurca el contenido. Una por lección.
- **teoria** — Máx 3 líneas de texto + icono pequeño + idea clave destacada en teal. El texto más corto posible.
- **carrusel** — Tarjeta deslizable (2-3 cards) con ejemplos del mismo concepto. Puntos de paginación abajo.
- **tabs** — 2-3 pestañas sobre el mismo concepto desde ángulos distintos. Ej: "Antes / Durante / Después".
- **ejercicio_identifica** — El usuario toca los elementos correctos de una lista. Feedback verde/rojo por ítem con explicación breve.
- **ejercicio_matching** — El usuario empareja dos columnas. Feedback visual al completar.
- **ejercicio_construye** — El usuario selecciona piezas para armar una frase, pensamiento o respuesta. Barra de progreso amarillo → naranja (mal) → verde (bien).
- **cierre_visual** — Ilustración grande + frase resumen del insight de la lección. Sin botón atrás, solo "Continuar".
- **resumen** — Tarjeta con 3 puntos clave de la lección. Estilo card oscura con iconos.
- **celebracion** — "Lección completada" + métricas (+1 lección, lección X de 5, racha actual). Animación del Orb si corresponde.
- **rating** — "¿Cuánto resuena esto contigo hoy?" 5 emojis (nada → mucho). Si puntúa 1-2: aparece campo libre "¿Hay algo que te está bloqueando?".

### Cambios en el código

**GuiaModels.swift**
- Añadir enum `LessonScreenType` con todos los tipos listados arriba
- Añadir struct `LessonScreen` con: `type`, `title`, `body`, `items` (array), `options` (array para ejercicios), `correctAnswers`
- Cambiar struct `Lesson` para que en vez de `body: String` tenga `screens: [LessonScreen]`

**GuiaView.swift**
- Nuevo componente `LessonWizardView`: recibe una `Lesson` y renderiza sus pantallas en secuencia
- Nuevo componente `LessonScreenView`: switch sobre `LessonScreenType`, renderiza el componente correcto
- Componentes individuales: `IntroScreenView`, `DiagnosticoScreenView`, `TeoriaScreenView`, `CarruselScreenView`, `TabsScreenView`, `EjercicioIdentificaView`, `EjercicioMatchingView`, `EjercicioConstruyeView`, `CierreVisualView`, `ResumenScreenView`, `CelebracionScreenView`, `RatingScreenView`
- Barra de progreso en el header (X de Y pantallas)
- Botón X para cerrar (con confirmación si llevas más de 3 pantallas)
- Transiciones: slide horizontal entre pantallas

**GuiaContent.swift**
- Reescritura completa de las 20 lecciones usando el nuevo formato de arrays de `LessonScreen`
- El contenido clínico se mantiene pero se divide en unidades mínimas

---

## FASE 2 — Rediseño de los 4 módulos existentes

### Estructura tipo de una lección rediseñada

Ejemplo: "El alivio que te engaña" (Módulo 2 — La trampa de la evitación)

1. **intro** — "El alivio que te engaña" / "Tu cerebro aprendió un truco que juega en tu contra"
2. **diagnostico** — "¿Qué haces cuando sientes que la ansiedad sube?" / Opciones: Salgo de la situación / Me pongo los auriculares / Miro el móvil / Me quedo pero sin participar
3. **teoria** — "Eso se llama refuerzo negativo. Evitas → te alivias → tu cerebro aprende que evitar funciona." / Idea clave: "El alivio es real. El aprendizaje también."
4. **carrusel** — 3 ejemplos de conductas de evitación cotidianas
5. **tabs** — "Lo que parece / Lo que realmente pasa"
6. **ejercicio_identifica** — "¿Cuáles de estas son conductas de seguridad?" — 6 comportamientos, feedback verde/rojo
7. **cierre_visual** — "Cada vez que evitas, le enseñas a tu cerebro que el mundo es peligroso."
8. **resumen** — 3 puntos clave
9. **celebracion** — métricas
10. **rating** — "¿Cuánto resuena esto contigo?"

### Los 4 módulos — estructura de sus 5 lecciones

**Módulo 1 — Entender tu vergüenza**
1. Qué es la vergüenza de verdad → teoria + carrusel (vergüenza vs timidez vs ansiedad social) + ejercicio_identifica
2. Por qué tu cerebro quiere esconderte → teoria + tabs (amenaza real / amenaza percibida) + ejercicio_matching
3. Vergüenza sana vs vergüenza tóxica → teoria + carrusel + ejercicio_construye
4. Tus detonadores personales → diagnostico extendido + teoria + ejercicio_identifica
5. El ciclo de la vergüenza → teoria + tabs + ejercicio_matching + cierre_visual

**Módulo 2 — La trampa de la evitación**
1. El alivio que te engaña → (ver ejemplo detallado arriba)
2. Las conductas que te hacen sentir seguro → teoria + carrusel + ejercicio_identifica
3. Antes, durante y después → teoria + tabs (rumiación pre/durante/post) + ejercicio_matching
4. El efecto foco → teoria + carrusel + ejercicio_construye
5. Cómo la evitación se generaliza → teoria + tabs + ejercicio_identifica + cierre_visual

**Módulo 3 — Calmar tu mente y tu cuerpo**
1. Qué le pasa a tu cuerpo → teoria + carrusel (síntomas físicos + su función evolutiva) + ejercicio_identifica
2. La respiración de caja → teoria + tabs + ejercicio_construye (el ciclo: inhala/aguanta/exhala/aguanta)
3. Reestructuración cognitiva → teoria + carrusel (3 ejemplos pensamiento → alternativa) + ejercicio_matching
4. La autocompasión sin positivismo tóxico → teoria + tabs + ejercicio_identifica
5. Tolerar el malestar → teoria + carrusel + ejercicio_construye + cierre_visual

**Módulo 4 — Exponerte y ganar terreno**
1. La ciencia de la exposición → teoria + carrusel (qué pasa en el cerebro) + ejercicio_matching
2. La escala SUDS → teoria + tabs (cómo usar SUDS antes/durante/después) + ejercicio_construye
3. Microexposiciones → teoria + carrusel (ejemplos por categoría) + ejercicio_identifica
4. Cuando una exposición sale mal → teoria + tabs + ejercicio_matching
5. Mantener el cambio → teoria + carrusel + ejercicio_construye + cierre_visual

---

## FASE 3 — Quinto módulo: "Ponlo en práctica"

### Qué es

Módulo nuevo. Mismo formato wizard. Diferencia clave: siempre parte de la ansiedad primero, no de la técnica. Primero identifica el pensamiento que bloquea, luego da la herramienta.

### 5 lecciones

**Lección 1 — La primera conversación**
- diagnostico: "¿Qué es lo primero que pasa por tu cabeza cuando tienes que hablar con alguien que no conoces?"
- teoria: "No tengo nada interesante que decir" como distorsión cognitiva
- carrusel: 3 aperturas desde el contexto compartido con capa CBT (pensamiento que bloquea → apertura)
- ejercicio_construye: armar una apertura contextual en dos partes
- cierre_visual + resumen + celebracion + rating

**Lección 2 — En grupos**
- diagnostico: "¿Qué te impide entrar en una conversación que ya está en marcha?"
- teoria: el miedo a interrumpir como lectura mental ("pensarán que soy pesado")
- tabs: "Lo que crees que pasará / Lo que estadísticamente pasa"
- ejercicio_matching: situación en grupo → pensamiento de evitación → alternativa asertiva
- cierre_visual + resumen + celebracion + rating

**Lección 3 — En el trabajo**
- diagnostico: "¿En qué momento del trabajo sientes más ansiedad social?"
- teoria: diferencia entre ansiedad de rendimiento y ansiedad social en contexto laboral
- carrusel: 3 situaciones (reunión, pedir algo, opinar) con pensamiento típico y reframe
- ejercicio_identifica: "¿Cuál de estas respuestas es asertiva, cuál es evitación?"
- cierre_visual + resumen + celebracion + rating

**Lección 4 — Citas y rechazo**
- diagnostico: "¿Qué es lo que más te frena cuando te gusta alguien?"
- teoria: el rechazo como dato, no como veredicto
- ejercicio_construye: "Construye el peor escenario real" — reducir la catastrofización paso a paso
- tabs: "Lo que significa el rechazo para tu cerebro / Lo que significa en la realidad"
- cierre_visual + resumen + celebracion + rating

**Lección 5 — Decir que no**
- diagnostico: "¿Qué pasa por tu cabeza cuando tienes que negarle algo a alguien?"
- teoria: la culpa anticipada como mecanismo de evitación
- ejercicio_identifica: "¿Cuál es asertiva, cuál es agresiva, cuál es pasiva?" — 6 frases
- ejercicio_construye: armar una negativa asertiva en tres partes
- cierre_visual + resumen + celebracion + rating

---

## FASE 4 — MomentoView: Modo Pánico + Modo Prepárate

### Pantalla de entrada

Al abrir la pestaña "Braver", nueva pantalla de selección:
- **Modo Pánico** — "Estoy en una situación ahora mismo" → flujo actual sin cambios
- **Modo Prepárate** — "Voy a enfrentarme a algo" → wizard nuevo

### Modo Prepárate — wizard de 5 pasos

**Paso 1 — ¿Qué vas a hacer?**
Opciones: Llamada difícil / Reunión o presentación / Hablar con alguien por primera vez / Algo romántico / Enfrentar un conflicto / Otra cosa (campo libre)

**Paso 2 — ¿Qué es lo que más te preocupa?**
Opciones: Que me juzguen / Quedarme en blanco / Que salga mal / Ponerme nervioso de forma visible / No saber qué decir / Otra cosa (campo libre)

**Paso 3 — ¿Cuánta ansiedad sientes ahora?**
Slider SUDS 0-100. Se guarda como `sudsPrediccion` en un nuevo modelo `PreparateSession`.

**Paso 4 — ¿Algo más específico?**
Campo de texto opcional. Placeholder: "Si quieres que Nova lo entienda mejor, cuéntale el contexto."

**Paso 5 — Nova responde**
Con todo el contexto, Nova genera 1 mensaje:
- Reconoce la situación específica
- Da 2-3 pasos concretos para ese momento
- Cierra con 1 frase de reframe
- Tono: coaching directo, no terapéutico, ~120 palabras

Debajo: botón "Hablar un poco más" → chat limitado a 3 intercambios. Después: "Tienes lo que necesitas. Ve a por ello."

Botón principal: **"Voy a por ello"** → registra la sesión, programa notificación push a los 30 min.

### Post-situación

Notificación push a los 30 minutos: "¿Cómo fue? Registra cómo te fue de verdad."
Al tocarla: pantalla mínima con slider SUDS + campo de texto opcional. Guarda `sudsReal`.

### Nuevo dato en ProgresoView

Nueva tarjeta en Resumen: **"Tus predicciones vs la realidad"**
- Par SUDS predicción / SUDS real de las últimas sesiones
- Mensaje si el SUDS real fue menor que el predicho: "Tu cerebro exagera el peligro. Y tú lo estás demostrando."

### Cambios en el código

**MomentoView.swift**
- Nueva pantalla de selección Pánico / Prepárate
- Nuevo flujo `PreparateWizardView` con los 5 pasos
- Lógica para programar notificación push local a los 30 min
- Pantalla de SUDS post-situación

**NovaService.swift**
- Nuevo método `prepararSituacion(situacion:preocupacion:suds:contexto:)` con el prompt construido
- Contador de intercambios por sesión Prepárate (máx 3)

**BraverModels.swift**
- Nuevo modelo SwiftData `PreparateSession`: id, situacion, preocupacion, sudsPrediccion, sudsReal (opcional), fecha, novaResponse

**ProgresoView.swift**
- Nueva tarjeta con los pares SUDS predicción/real

---

## Orden de implementación

| Fase | Qué | Por qué este orden |
|------|-----|--------------------|
| 1 | Motor de wizard (modelos + componentes SwiftUI) | Sin esto nada de lo demás se puede construir |
| 2 | Rediseño de los 4 módulos existentes | Mejora inmediata visible, contenido ya existe |
| 3 | Quinto módulo "Ponlo en práctica" | Contenido nuevo sobre infraestructura ya lista |
| 4 | MomentoView: Modo Pánico + Modo Prepárate | Flujo más complejo, va al final cuando el resto está estable |

---

## Notas

- El estilo visual de Braver se mantiene en todo: fondo oscuro, teal, BraverTheme en todos los componentes nuevos
- Ninguna pantalla nueva rompe la navegación existente — todo se añade dentro de GuiaView y MomentoView
- El progreso de lecciones ya completadas se respeta al migrar al nuevo formato
- El límite de 1 lección por día (GuiaProgress.swift) se mantiene
- Nova en Modo Prepárate es independiente del límite de 10 mensajes del chat — contador propio (sugerido: 3 sesiones Prepárate por día)
