// src/scanIngredients.ts
import * as functions from "firebase-functions";
import axios from "axios";

export const scanIngredients = functions.https.onRequest(async (req, res) => {
  try {
    // Accepts either base64 image (req.body.imageBase64) or an image URL (req.body.imageUrl)
    const { imageBase64, imageUrl } = req.body ?? {};

    if (!imageBase64 && !imageUrl) {
      return res.status(400).json({ success: false, error: "imageBase64 or imageUrl required" });
    }

    // For now: return a mocked set of detections (replace with real CV call later)
    const mocked = [
      { name: "tomato", confidence: 0.95 },
      { name: "onion", confidence: 0.89 },
      { name: "garlic", confidence: 0.82 }
    ];

    // Example: if you later run a local CV service, you can call it like:
    // const cvResp = await axios.post("http://localhost:8000/infer", { imageBase64, imageUrl });
    // const detections = cvResp.data;

    return res.json({ success: true, ingredients: mocked });
  } catch (err: any) {
    console.error("scanIngredients error:", err);
    return res.status(500).json({ success: false, error: err?.message ?? "unknown" });
  }
});
