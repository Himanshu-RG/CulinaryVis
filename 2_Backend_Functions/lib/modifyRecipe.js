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
exports.modifyRecipe = void 0;
const functions = __importStar(require("firebase-functions"));
const generative_ai_1 = require("@google/generative-ai");
// Get the Gemini API key from Firebase environment configuration
// We will set this up in the Firebase console later.
const GEMINI_API_KEY = functions.config().gemini.key;
// Initialize the Gemini AI client
const genAI = new generative_ai_1.GoogleGenerativeAI(GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash-preview-09-2025' });
/**
 * A callable function that uses the Gemini AI to modify a recipe.
 *
 * @param {string} data.recipeText The original recipe (as a string).
 * @param {string} data.request The user's modification request (e.g., "make it vegan").
 * @returns {Promise<{modifiedRecipe: string}>} The new, modified recipe text.
 */
exports.modifyRecipe = functions.https.onCall(async (data, context) => {
    const { recipeText, request } = data;
    // 1. Validate the input
    if (!recipeText) {
        throw new functions.https.HttpsError('invalid-argument', 'No recipe text was provided.');
    }
    if (!request) {
        throw new functions.https.HttpsError('invalid-argument', 'No modification request was provided.');
    }
    functions.logger.info(`Modifying recipe with request: "${request}"`);
    // 2. Create the prompt for the AI
    const prompt = `
    You are a helpful culinary assistant.
    A user has provided a recipe and a request.
    Your task is to rewrite the recipe based on the user's request.
    Respond with ONLY the new, complete recipe text. Do not add any conversational text like "Here is the modified recipe:".

    ---
    ORIGINAL RECIPE:
    ${recipeText}
    ---
    USER REQUEST:
    ${request}
    ---
    MODIFIED RECIPE:
  `;
    // 3. Call the Gemini API
    try {
        const result = await model.generateContent(prompt);
        const response = await result.response;
        const modifiedRecipe = response.text();
        functions.logger.info('Successfully modified recipe with Gemini.');
        // 4. Return the new recipe
        return { modifiedRecipe: modifiedRecipe };
    }
    catch (error) {
        functions.logger.error('Error calling Gemini API:', error.message);
        throw new functions.https.HttpsError('internal', 'Failed to modify recipe with AI.');
    }
});
//# sourceMappingURL=modifyRecipe.js.map