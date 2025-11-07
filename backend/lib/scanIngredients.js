"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.scanIngredients = void 0;
const functions = __importStar(require("firebase-functions"));
// This is the (pretend) URL where your trained YOLO model is hosted.
// We'll use a placeholder for now.
const CV_MODEL_ENDPOINT = 'https://your-yolo-model-api.example.com/predict';
/**
 * A callable function that takes an image, sends it to the CV model,
 * and returns a list of detected ingredients.
 *
 * @param {string} data.imageB64 A base64 encoded string of the image.
 * @returns {Promise<{ingredients: string[]}>} A list of ingredients.
 */
exports.scanIngredients = functions.https.onCall(async (data, context) => {
    var _a;
    // Log the request data (but not the full image string to avoid clutter)
    functions.logger.info(`Received scan request from user: ${(_a = context.auth) === null || _a === void 0 ? void 0 : _a.uid}`);
    // 1. Get the image string from the request
    const imageB64 = data.imageB64;
    if (!imageB64) {
        // Send a clear error back to the app if no image is provided
        throw new functions.https.HttpsError('invalid-argument', 'No image data provided in the request.');
    }
    // --- 2. Call the Custom CV Model ---
    // We will use a mock response for now and log the intended action.
    // In a real scenario, you'd uncomment the axios.post block.
    functions.logger.info(`Sending image to CV Model at: ${CV_MODEL_ENDPOINT}`);
    /*
    // --- REAL API CALL (for later) ---
    try {
      const response = await axios.post(CV_MODEL_ENDPOINT, {
        image: imageB64,
      });
  
      // Assuming the model returns data like: { "detections": ["apple", "banana"] }
      const ingredients = response.data.detections;
      functions.logger.info('CV Model detected:', ingredients);
      
      // Return the detected ingredients
      return { ingredients: ingredients };
  
    } catch (error) {
      functions.logger.error('Error calling CV Model:', error);
      throw new functions.https.HttpsError(
        'internal',
        'Failed to process image with CV model.',
      );
    }
    */
    // --- MOCK RESPONSE (for now) ---
    // Let's pretend the model successfully detected these ingredients
    const mockIngredients = ['apple', 'banana', 'eggs', 'milk'];
    functions.logger.info('Returning MOCK ingredients:', mockIngredients);
    return { ingredients: mockIngredients };
});
//# sourceMappingURL=scanIngredients.js.map