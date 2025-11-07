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
 *
 * @param {string} data.imageB64 A base64 encoded string of the image.
 * @returns {Promise<{ingredients: string[]}>} A list of ingredients.
 */
export const scanIngredients = functions.https.onCall(async (data, context) => {
  // Log the request data (but not the full image string to avoid clutter)
  functions.logger.info(`Received scan request from user: ${context.auth?.uid}`);

  // 1. Get the image string from the request
  const imageB64 = data.imageB64;
  if (!imageB64) {
    // Send a clear error back to the app if no image is provided
    throw new functions.https.HttpsError(
        "invalid-argument",
        "No image data provided in the request.",
    );
  }

  // --- 2. Call the Custom CV Model ---
  // We will use a mock response for now and log the intended action.
  // In a real scenario, you'd uncomment the axios.post block.
  functions.logger.info(`Sending image to CV Model at: ${CV_MODEL_ENDPOINT}`);

  /*
  // --- REAL API CALL (for later) ---
  // import axios from "axios"; // <-- You'll need to add this back
  try {
    const response = await axios.post(CV_MODEL_ENDPOINT, {
      image: imageB64,
    });

    // Assuming the model returns data like: { "detections": ["apple", "banana"] }
    const ingredients = response.data.detections;
    functions.logger.info("CV Model detected:", ingredients);
    
    // Return the detected ingredients
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
  // Let's pretend the model successfully detected these ingredients
  const mockIngredients = ["apple", "banana", "eggs", "milk"];
  functions.logger.info("Returning MOCK ingredients:", mockIngredients);

  return {ingredients: mockIngredients};
});