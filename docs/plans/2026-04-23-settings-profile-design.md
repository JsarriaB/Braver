# Design: Pantalla de Ajustes / Perfil

## Entrada
Icono ⚙️ en el header de HoyView, a la derecha del badge de fuego. Abre un sheet modal.

## Secciones

### Perfil
- Nombre editable (UserDefaults: `braver_user_name`)

### Mis retos
- "Quiero trabajar más": selector de 1 categoría favorita → retos de esa categoría priorizados
- "No quiero ver retos de": selección múltiple, máximo 3 categorías excluidas → retos de esas categorías filtrados
- Categorías: Llamadas, Tiendas, Grupos, Citas, Trabajo, Conocer gente, Conflictos, Otro
- Persistencia: UserDefaults (`braver_favorite_category`, `braver_excluded_categories`)

### Notificaciones
- Toggle general on/off (UserDefaults: `braver_notifications_enabled`)
- Hora recordatorio mañana (default 9:00) → reprograma `braver_morning`
- Hora check-in noche (default 20:00) → reprograma `braver_evening`

### Suscripción
- Banner estado plan actual
- Botón "Gestionar suscripción" → abre URL de gestión de Apple

### Legal
- Privacy Policy → placeholder URL en Safari
- Terms & Conditions → placeholder URL en Safari

### App
- Versión (Bundle version automática)
- "Eliminar todos mis datos" → Alert de confirmación → borra UserDefaults + SwiftData

## Estilo
- Sheet con fondo `BraverTheme.background`
- Secciones con `SectionHeader`
- Items con `braverCard(elevated: true)`
- Tipografía `.rounded` igual que el resto de la app

## Archivos a crear/modificar
- **Crear:** `Braver/AjustesView.swift` — sheet completo
- **Modificar:** `Braver/HoyView.swift` — añadir icono ⚙️ en header y state `showAjustes`
- **Modificar:** `Braver/NotificationService.swift` — añadir funciones para horas configurables
- **Modificar:** `Braver/ChallengeLibrary.swift` — filtrar/priorizar por categorías del perfil
