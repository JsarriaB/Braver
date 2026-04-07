const {onRequest} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const {initializeApp} = require("firebase-admin/app");
const {getAppCheck} = require("firebase-admin/app-check");
const {getFirestore} = require("firebase-admin/firestore");

const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

initializeApp();
const db = getFirestore();

exports.novaChat = onRequest(
  {secrets: [OPENAI_API_KEY]},
  async (req, res) => {
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type, X-Firebase-AppCheck, X-Installation-ID");

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

    // Verificar Installation ID
    const installationID = req.headers["x-installation-id"];
    if (!installationID) {
      res.status(400).json({error: "Missing installation ID"});
      return;
    }

    if (req.method !== "POST") {
      res.status(405).json({error: "Method not allowed"});
      return;
    }

    try {
      const {messages} = req.body;

      const today = new Date().toISOString().slice(0, 10);
      const usageRef = db.collection("novaUsage").doc(`${installationID}_${today}`);

      await db.runTransaction(async (tx) => {
        const doc = await tx.get(usageRef);
        const current = doc.exists ? (doc.data().count || 0) : 0;

        if (current >= 10) {
          throw new Error("DAILY_LIMIT_REACHED");
        }

        tx.set(
          usageRef,
          {
            installationID,
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
