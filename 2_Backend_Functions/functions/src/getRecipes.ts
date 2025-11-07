import * as functions from "firebase-functions";
import axios from "axios";

// Get the Spoonacular API key from Firebase environment configuration
// We will set this up in the Firebase console later, not in the code.
const SPOONACULAR_API_KEY = functions.config().spoonacular.key;

const SPOONACULAR_API_URL = "https://api.spoonacular.com/recipes/findByIngredients";

/**
 * A callable function that takes a list of ingredients and finds recipes
 * using the Spoonacular API.
 *
 * @param {string[]} data.ingredients A list of ingredient names.
 * @returns {Promise<any>} A list of recipe objects from Spoonacular.
 */
export const getRecipes = functions.https.onCall(async (data, context) => {
  const ingredients = data.ingredients;

  // 1. Validate the input from the app
  if (!ingredients || !Array.isArray(ingredients) || ingredients.length === 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "No ingredients list was provided.",
    );
  }

  // 2. Format the ingredients for the Spoonacular API
  // (e.g., "apple,banana,eggs")
  const ingredientsString = ingredients.join(",");

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
    const response = await axios.get(SPOONACULAR_API_URL, {params: apiParams});

    // Log and return the recipes
    functions.logger.info("Successfully fetched recipes from Spoonacular.");
    return response.data; // This will be an array of recipe objects
  } catch (error: any) {
    functions.logger.error("Error calling Spoonacular API:", error.message);
    // Pass the error message back to the app
    throw new functions.https.HttpsError(
      "internal",
      "Failed to fetch recipes.",
    );
  }
});
