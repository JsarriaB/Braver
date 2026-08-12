const {onRequest} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const {initializeApp} = require("firebase-admin/app");
const {getAppCheck} = require("firebase-admin/app-check");
const {getAuth} = require("firebase-admin/auth");
const {getFirestore, FieldValue, Timestamp} = require("firebase-admin/firestore");
const crypto = require("crypto");

// Decisión de seguridad propia (no una regla oficial de Apple/Firebase): si el
// login del usuario no es reciente, exigimos reautenticación antes de borrar la cuenta.
const REAUTH_MAX_AGE_SECONDS = 5 * 60;

const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");
const SUPERWALL_WEBHOOK_SECRET = defineSecret("SUPERWALL_WEBHOOK_SECRET");

// Acceso al secret de Superwall vía process.env (inyectado por Cloud Run en producción)
function getSuperwallSecret() {
  return process.env.SUPERWALL_WEBHOOK_SECRET || SUPERWALL_WEBHOOK_SECRET.value();
}

initializeApp();
const db = getFirestore();

const ACTIVE_EVENTS = new Set([
  "SUBSCRIPTION_START",
  "SUBSCRIPTION_RENEW",
  "FREE_TRIAL_START",
  "TRANSACTION_COMPLETE",
]);
const INACTIVE_EVENTS = new Set([
  "SUBSCRIPTION_CANCEL",
  "SUBSCRIPTION_EXPIRE",
  "SUBSCRIPTION_PAUSE",
  "REFUND",
]);

exports.superwallWebhook = onRequest(
  {secrets: [SUPERWALL_WEBHOOK_SECRET]},
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).send("Method not allowed");
      return;
    }

    // Verificar firma HMAC de Superwall
    const signatureHeader = req.headers["superwall-signature"];
    if (!signatureHeader) {
      res.status(401).send("Missing signature");
      return;
    }

    const parts = Object.fromEntries(
      signatureHeader.split(",").map((p) => p.split("="))
    );
    const timestamp = parts["t"];
    const receivedHash = parts["v1"];
    const rawBody = req.rawBody ? req.rawBody.toString() : JSON.stringify(req.body);

    const expectedHash = crypto
      .createHmac("sha256", SUPERWALL_WEBHOOK_SECRET.value())
      .update(`${timestamp}.${rawBody}`)
      .digest("hex");

    if (receivedHash !== expectedHash) {
      res.status(401).send("Invalid signature");
      return;
    }

    const event = req.body.event;
    const eventName = event?.event_name;
    const firebaseUid = event?.user?.attributes?.firebaseUid;

    if (!firebaseUid) {
      res.status(200).send("No firebaseUid, skipping");
      return;
    }

    let status;
    if (ACTIVE_EVENTS.has(eventName)) status = "active";
    else if (INACTIVE_EVENTS.has(eventName)) status = "inactive";
    else {
      res.status(200).send("Event ignored");
      return;
    }

    const productId = event?.product?.product_identifier ?? null;
    const expiresAtRaw = event?.expires_at;
    const expiresAt = expiresAtRaw
      ? Timestamp.fromDate(new Date(expiresAtRaw * 1000))
      : null;

    await db
      .collection("users")
      .doc(firebaseUid)
      .collection("subscription")
      .doc("current")
      .set(
        {
          status,
          productId,
          expiresAt,
          lastEvent: eventName,
          updatedAt: FieldValue.serverTimestamp(),
        },
        {merge: true}
      );

    res.status(200).send("OK");
  }
);

exports.novaChat = onRequest(
  {secrets: [OPENAI_API_KEY]},
  async (req, res) => {
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type, X-Firebase-AppCheck, X-Firebase-UID");

    if (req.method === "OPTIONS") {
      res.status(204).send("");
      return;
    }

    // Verificar App Check
    const appCheckToken = req.headers["x-firebase-appcheck"];
    if (!appCheckToken) {
      res.status(401).json({error: "Unauthorized"});
      return;
    }

    try {
      await getAppCheck().verifyToken(appCheckToken);
    } catch (err) {
      res.status(401).json({error: "Unauthorized"});
      return;
    }

    // Verificar Firebase UID
    const uid = req.headers["x-firebase-uid"];
    if (!uid) {
      res.status(400).json({error: "Missing Firebase UID"});
      return;
    }

    if (req.method !== "POST") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    try {
      const {messages} = req.body;

      const today = new Date().toISOString().slice(0, 10);
      const usageRef = db.collection("novaUsage").doc(`${uid}_${today}`);

      await db.runTransaction(async (tx) => {
        const doc = await tx.get(usageRef);
        const current = doc.exists ? (doc.data().count || 0) : 0;

        if (current >= 10) {
          throw new Error("DAILY_LIMIT_REACHED");
        }

        tx.set(
          usageRef,
          {
            uid,
            date: today,
            count: current + 1,
            updatedAt: Date.now()
          },
          {merge: true}
        );
      });

      const response = await fetch("https://api.openai.com/v1/chat/completions", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${OPENAI_API_KEY.value()}`
        },
        body: JSON.stringify({
          model: "gpt-4o-mini",
          messages
        })
      });

      const data = await response.json();
      res.status(response.status).json(data);
    } catch (error) {
      if (error.message === "DAILY_LIMIT_REACHED") {
        res.status(429).json({error: "DAILY_LIMIT_REACHED"});
      } else {
        res.status(500).json({
          error: "Server error",
          details: error.message
        });
      }
    }
  }
);

exports.deleteAccount = onRequest(async (req, res) => {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Firebase-AppCheck");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }
  if (req.method !== "POST") {
    res.status(405).json({error: "Method not allowed"});
    return;
  }

  // Verificar App Check (autenticidad de la app, no del usuario)
  const appCheckToken = req.headers["x-firebase-appcheck"];
  if (!appCheckToken) {
    res.status(401).json({error: "Unauthorized"});
    return;
  }
  try {
    await getAppCheck().verifyToken(appCheckToken);
  } catch (err) {
    res.status(401).json({error: "Unauthorized"});
    return;
  }

  // Verificar el ID token real del usuario — el uid sale del token verificado,
  // nunca de un valor enviado sin más por el cliente.
  const authHeader = req.headers["authorization"] || "";
  const idToken = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : null;
  if (!idToken) {
    res.status(401).json({error: "MISSING_ID_TOKEN"});
    return;
  }

  let decodedToken;
  try {
    decodedToken = await getAuth().verifyIdToken(idToken);
  } catch (err) {
    res.status(401).json({error: "INVALID_ID_TOKEN"});
    return;
  }

  const {uid, auth_time: authTime} = decodedToken;
  const nowSeconds = Math.floor(Date.now() / 1000);
  if (nowSeconds - authTime > REAUTH_MAX_AGE_SECONDS) {
    res.status(403).json({error: "REAUTH_REQUIRED"});
    return;
  }

  try {
    // Borra el documento del usuario y todas sus subcolecciones (checkins, completions, subscription...)
    await db.recursiveDelete(db.collection("users").doc(uid));

    // Borra el contador de mensajes de Nova asociado a este uid
    const usageSnapshot = await db.collection("novaUsage").where("uid", "==", uid).get();
    await Promise.all(usageSnapshot.docs.map((doc) => doc.ref.delete()));

    // Borra el usuario de Firebase Auth
    await getAuth().deleteUser(uid);

    res.status(200).json({success: true});
  } catch (error) {
    res.status(500).json({error: "DELETE_FAILED", details: error.message});
  }
});
