# Política de Privacidad de Braver

**Última actualización:** 11 de agosto de 2026

## 1. Responsable del tratamiento

**Nombre:** Jorge Sarria Bruned  
**Email de contacto:** jsarriab28@gmail.com  
**País:** España

En adelante, "nosotros", "nuestro" o "Braver".

---

## 2. Qué datos recopilamos y para qué

### 2.1 Datos que nos proporcionas directamente

| Dato | Dónde se introduce | Finalidad |
|------|--------------------|-----------|
| Nombre | Onboarding (opcional) | Personalizar la experiencia |
| Edad | Onboarding (opcional) | Personalizar el contenido |
| Correo electrónico | Registro con email/contraseña (opcional) | Autenticación y recuperación de cuenta |
| Nombre completo | Registro con Apple o Google (opcional) | Identificación de cuenta |

### 2.2 Datos de uso que generamos automáticamente

| Dato | Dónde se almacena | Finalidad |
|------|--------------------|-----------|
| UID anónimo de Firebase | Firebase (Google) | Vincular tu actividad a tu cuenta sin revelar tu identidad real |
| Estado de suscripción (activa / inactiva / cancelada) | Firebase Firestore | Controlar el acceso a las funciones de pago |
| Número de mensajes enviados a Nova por día | Firebase Firestore | Aplicar el límite de 10 mensajes diarios |
| Timestamp de la oferta especial mostrada | Superwall | Garantizar que la oferta solo se muestra una vez |
| Datos de dispositivo (modelo, idioma, versión iOS, fecha de instalación) | Superwall | Mostrar paywalls y gestionar campañas |

### 2.3 Datos que se quedan SOLO en tu dispositivo (nunca salen)

Los siguientes datos se guardan en tu iPhone mediante SwiftData y UserDefaults y **no se transmiten a ningún servidor**:

- Tus retos (título, categoría, nivel de dificultad, estado)
- Historial de completaciones de retos, incluyendo puntuaciones SUDS
- Sesiones de "Momento de calma" y "Prepárate"
- Respuestas del onboarding (género, frecuencia de evitación, categorías de miedos, objetivos)
- Racha de días activos y logros
- Configuración de notificaciones
- Preferencias de categorías de retos

### 2.4 Conversaciones con Nova

Los mensajes que envías a Nova se procesan mediante nuestro servidor (Firebase Cloud Functions) y se reenvían a la API de OpenAI para generar la respuesta. **Braver no almacena el contenido de estos mensajes**: solo guardamos el número de mensajes enviados ese día (para el límite diario), y las conversaciones se eliminan de la memoria del dispositivo al cerrar la app. OpenAI, conforme a su política estándar de uso de datos de la API, puede conservar el contenido de los mensajes hasta 30 días con fines de prevención de abusos, sin usarlo para entrenar sus modelos.

> **Importante:** No compartas en Nova información personal identificable como tu nombre completo, DNI, número de teléfono o datos bancarios.

### 2.5 Datos de salud mental (categoría especial)

La app recopila y procesa información sobre tu ansiedad social, miedos, situaciones de estrés y bienestar emocional. Estos datos se consideran **datos de salud** bajo el Reglamento General de Protección de Datos (RGPD) y reciben una protección especial.

- Los datos del onboarding (tus respuestas al cuestionario inicial) se usan exclusivamente para personalizar tu plan de retos. No se comparten con terceros.
- Los datos de SUDS (Subjective Units of Distress Scale) y el historial de retos permanecen en tu dispositivo.
- El contenido de las conversaciones con Nova no se almacena.

La base legal para tratar esta categoría especial de datos es tu **consentimiento explícito**, que otorgas al aceptar esta política antes de completar el onboarding.

---

## 3. Base legal del tratamiento (RGPD)

| Tratamiento | Base legal |
|-------------|------------|
| Autenticación y gestión de cuenta | Ejecución de contrato (Art. 6.1.b RGPD) |
| Personalización de la experiencia (nombre, edad) | Consentimiento (Art. 6.1.a RGPD) |
| Datos de salud mental del onboarding | Consentimiento explícito (Art. 9.2.a RGPD) |
| Límite de uso de Nova (conteo de mensajes) | Interés legítimo — prevenir abuso del servicio (Art. 6.1.f RGPD) |
| Gestión de suscripciones | Ejecución de contrato (Art. 6.1.b RGPD) |

---

## 4. Con quién compartimos los datos

No vendemos tus datos personales a terceros. Compartimos datos únicamente con los siguientes proveedores de servicios, en la medida estrictamente necesaria:

### Firebase / Google LLC
- **Servicio:** Autenticación, base de datos (Firestore), funciones de backend, seguridad (App Check)
- **Datos compartidos:** UID, nombre, edad, email (si registras cuenta), estado de suscripción, conteo de mensajes Nova, datos de dispositivo
- **País:** Estados Unidos (con garantías adecuadas: Cláusulas Contractuales Estándar)
- **Política:** [https://firebase.google.com/support/privacy](https://firebase.google.com/support/privacy)

### Google LLC (Sign in with Google)
- **Servicio:** Autenticación opcional con tu cuenta de Google
- **Datos compartidos:** Nombre y email de tu cuenta de Google (solo si eliges esta opción)
- **Política:** [https://policies.google.com/privacy](https://policies.google.com/privacy)

### Superwall Inc.
- **Servicio:** Gestión de paywalls, campañas y suscripciones
- **Datos compartidos:** UID de Firebase, datos de dispositivo, estado de suscripción, eventos de compra
- **País:** Estados Unidos
- **Política:** [https://superwall.com/privacy](https://superwall.com/privacy)

### OpenAI OpCo LLC
- **Servicio:** Procesamiento de mensajes de Nova (IA)
- **Datos compartidos:** Contenido del mensaje enviado (sin identificadores personales). OpenAI puede conservarlo hasta 30 días con fines de prevención de abusos, sin usarlo para entrenar sus modelos (política estándar de uso de datos de la API)
- **País:** Estados Unidos
- **Política:** [https://openai.com/policies/api-data-usage-policies](https://openai.com/policies/api-data-usage-policies)

### Apple Inc.
- **Servicio:** Autenticación (Sign in with Apple), compras in-app (StoreKit), seguridad (App Attest)
- **Datos compartidos:** Gestionados directamente por Apple según sus propias condiciones
- **Política:** [https://www.apple.com/legal/privacy/](https://www.apple.com/legal/privacy/)

---

## 5. Cuánto tiempo conservamos los datos

| Dato | Período de conservación |
|------|------------------------|
| Cuenta de usuario (nombre, edad, UID) | Mientras mantengas la cuenta activa. Se borra de inmediato, de forma permanente, al eliminar la cuenta desde la app |
| Estado de suscripción | Mientras dure la relación contractual + el período legal requerido |
| Conteo de mensajes Nova | 90 días desde la fecha del registro |
| Datos en tu dispositivo (SwiftData) | Hasta que desinstales la app o uses "Eliminar cuenta y todos mis datos" en Ajustes |
| Contenido de mensajes con Nova en OpenAI | Hasta 30 días (política estándar de prevención de abusos de OpenAI) |

---

## 6. Tus derechos

Bajo el RGPD y la LOPDGDD (Ley Orgánica 3/2018), tienes derecho a:

- **Acceso:** Solicitar qué datos tenemos sobre ti
- **Rectificación:** Corregir datos incorrectos
- **Supresión ("derecho al olvido"):** Desde la app, en *Ajustes → Eliminar cuenta y todos mis datos*, puedes eliminar tu cuenta y todos tus datos de forma inmediata y permanente: perfil, historial y check-ins en nuestros servidores, la cuenta en sí, y todo lo guardado en tu dispositivo. Si iniciaste sesión con Apple, también se revoca el acceso concedido a Braver. Esto no cancela una suscripción activa de Apple, que debes gestionar por separado desde los Ajustes de tu iPhone. Si no puedes acceder a la app, también puedes solicitar la eliminación escribiéndonos
- **Portabilidad:** Recibir tus datos en formato estructurado
- **Oposición y limitación:** Oponerte a ciertos tratamientos o limitar su uso
- **Retirada del consentimiento:** Puedes retirar tu consentimiento en cualquier momento sin que esto afecte a la licitud del tratamiento previo
- **Reclamación ante la AEPD:** Si consideras que vulneramos tu privacidad, puedes reclamar ante la Agencia Española de Protección de Datos en [www.aepd.es](https://www.aepd.es)

Para ejercer cualquiera de estos derechos, escríbenos a: **jsarriab28@gmail.com**

---

## 7. Menores de edad

Braver está dirigida a personas de **16 años o más**. No recopilamos conscientemente datos de menores de 16 años. Si eres menor de esa edad, no debes usar la app. Si creemos que hemos recogido datos de un menor de 16 años sin el consentimiento de su tutor legal, los eliminaremos a la mayor brevedad posible.

Si eres padre, madre o tutor y crees que tu hijo/a menor de 16 años ha creado una cuenta, contáctanos en jsarriab28@gmail.com.

---

## 8. Transferencias internacionales de datos

Algunos de nuestros proveedores (Firebase/Google, Superwall, OpenAI) se encuentran en Estados Unidos. Las transferencias de datos a estos países se realizan con las garantías adecuadas mediante **Cláusulas Contractuales Estándar** aprobadas por la Comisión Europea, o bajo el marco del EU-U.S. Data Privacy Framework cuando sea aplicable.

---

## 9. Seguridad

Aplicamos medidas técnicas y organizativas adecuadas para proteger tus datos:

- **Firebase App Check** y **App Attest de Apple**: verifican que las solicitudes provienen de la app legítima, no de bots
- **Autenticación anónima automática**: usamos un UID anónimo antes de que te registres, evitando recopilar datos de identidad innecesarios
- **HTTPS/TLS**: todas las comunicaciones con nuestros servidores están cifradas
- **Sin almacenamiento de contraseñas**: las contraseñas se gestionan exclusivamente por Firebase Authentication

Sin embargo, ningún sistema es 100% seguro. En caso de brecha de seguridad que afecte a tus derechos, te notificaremos en el plazo legalmente establecido.

---

## 10. Notificaciones push

La app envía **notificaciones locales** (generadas en tu propio dispositivo, no desde nuestros servidores) como recordatorios matutinos y el check-in nocturno. Puedes desactivarlas en cualquier momento desde *Ajustes → Notificaciones* dentro de la app, o desde los ajustes de tu iPhone.

---

## 11. Cambios en esta política

Podemos actualizar esta política para reflejar cambios en la app o en la legislación aplicable. Cuando hagamos cambios materiales, te lo comunicaremos mediante una notificación dentro de la app o por email (si tienes cuenta registrada). La fecha de "Última actualización" al inicio del documento indica cuándo se realizó el último cambio.

---

## 12. Contacto

Para cualquier consulta sobre privacidad o para ejercer tus derechos:

**Jorge Sarria Bruned**  
Email: jsarriab28@gmail.com
