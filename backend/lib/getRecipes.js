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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getRecipes = void 0;
const functions = __importStar(require("firebase-functions"));
const axios_1 = __importDefault(require("axios"));
// Get the Spoonacular API key from Firebase environment configuration
// We will set this up in the Firebase console later, not in the code.
const SPOONACULAR_API_KEY = functions.config().spoonacular.key;
const SPOONACULAR_API_URL = 'https://api.spoonacular.com/recipes/findByIngredients';
/**
 * A callable function that takes a list of ingredients and finds recipes
 * using the Spoonacular API.
 *
 * @param {string[]} data.ingredients A list of ingredient names.
 * @returns {Promise<any>} A list of recipe objects from Spoonacular.
 */
exports.getRecipes = functions.https.onCall(async (data, context) => {
    const ingredients = data.ingredients;
    // 1. Validate the input from the app
    if (!ingredients || !Array.isArray(ingredients) || ingredients.length === 0) {
        throw new functions.https.HttpsError('invalid-argument', 'No ingredients list was provided.');
    }
    // 2. Format the ingredients for the Spoonacular API
    // (e.g., "apple,banana,eggs")
    const ingredientsString = ingredients.join(',');
    // 3. Set up the parameters for the API call
    const apiParams = {
        apiKey: SPOONACULAR_API_KEY,
        ingredients: ingredientsString,
        number: 5, // Let's ask for 5 recipes
        ranking: 1, // Maximize used ingredients
        ignorePantry: true,
    };
    functions.logger.info(`Finding recipes for: ${ingredientsString}`);
    // 4. Call the Spoonacular API
    try {
        const response = await axios_1.default.get(SPOONACULAR_API_URL, { params: apiParams });
        // Log and return the recipes
        functions.logger.info('Successfully fetched recipes from Spoonacular.');
        return response.data; // This will be an array of recipe objects
    }
    catch (error) {
        functions.logger.error('Error calling Spoonacular API:', error.message);
        // Pass the error message back to the app
        throw new functions.https.HttpsError('internal', 'Failed to fetch recipes.');
    }
});
//# sourceMappingURL=getRecipes.js.map