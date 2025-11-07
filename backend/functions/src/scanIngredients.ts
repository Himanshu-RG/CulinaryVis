import * as functions from "firebase-functions";
// Note: The 'axios' import was removed as it's not used in the mock setup.
// When you implement the real API call, you will need to add it back.

// This is the (pretend) URL where your trained YOLO model is hosted.
// We'll use a placeholder for now.
const CV_MODEL_ENDPOINT =
  "https://your-yolo-model-api.example.com/predict";

/**
 * A callable function that takes an image, sends it to the CV model,
 * and returns a list of detected ingredients.
 */
export const scanIngredients = functions.https.onCall(async (request) => {
  // NEW: Auth info is now on request.auth
  const uid = request.auth?.uid;
  functions.logger.info(`Received scan request from user: ${uid}`);

  // 1. Get the image string from the request
  // NEW: Data is now on request.data
  const imageB64 = request.data.imageB64;
  if (!imageB64) {
    // Send a clear error back to the app if no image is provided
    throw new functions.https.HttpsError(
        "invalid-argument",
        "No image data provided in the request.",
    );
  }

  // --- 2. Call the Custom CV Model ---
  functions.logger.info(`Sending image to CV Model at: ${CV_MODEL_ENDPOINT}`);

  /*
  // --- REAL API CALL (for later) ---
  // import axios from "axios"; // <-- You'll need to add this back
  try {
    const response = await axios.post(CV_MODEL_ENDPOINT, {
      image: imageB64,
    });

    const ingredients = response.data.detections;
    functions.logger.info("CV Model detected:", ingredients);
    
    return { ingredients: ingredients };

  } catch (error) {
    functions.logger.error("Error calling CV Model:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to process image with CV model.",
    );
  }
  */

  // --- MOCK RESPONSE (for now) ---
  const mockIngredients = ["apple", "banana", "eggs", "milk"];
  functions.logger.info("Returning MOCK ingredients:", mockIngredients);

  return {ingredients: mockIngredients};
});