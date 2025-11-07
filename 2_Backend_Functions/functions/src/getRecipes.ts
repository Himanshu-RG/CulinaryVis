import * as functions from "firebase-functions";
import axios from "axios";
import {defineString} from "firebase-functions/params";

// Define the Spoonacular API key as a secret parameter
const SPOONACULAR_API_KEY = defineString("SPOONACULAR_KEY");

const SPOONACULAR_API_URL =
  "https://api.spoonacular.com/recipes/findByIngredients";

/**
 * A callable function that takes a list of ingredients and finds recipes
 * using the Spoonacular API.
 */
export const getRecipes = functions.https.onCall(async (request) => {
  // NEW: Data is now on request.data
  const ingredients = request.data.ingredients;

  // 1. Validate the input from the app
  if (!ingredients || !Array.isArray(ingredients) || ingredients.length === 0) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "No ingredients list was provided.",
    );
  }

  // 2. Format the ingredients for the Spoonacular API
  const ingredientsString = ingredients.join(",");

  // 3. Set up the parameters for the API call
  const apiParams = {
    apiKey: SPOONACULAR_API_KEY.value(), // Use .value() to access the key
    ingredients: ingredientsString,
    number: 5,
    ranking: 1,
    ignorePantry: true,
  };

  functions.logger.info(`Finding recipes for: ${ingredientsString}`);

  // 4. Call the Spoonacular API
  try {
    const response = await axios.get(SPOONACULAR_API_URL, {params: apiParams});

    functions.logger.info("Successfully fetched recipes from Spoonacular.");
    return response.data;
  } catch (error: unknown) {
    let message = "Unknown error";
    if (error instanceof Error) {
      message = error.message;
    }
    functions.logger.error("Error calling Spoonacular API:", message);
    throw new functions.https.HttpsError(
        "internal",
        "Failed to fetch recipes.",
    );
  }
});