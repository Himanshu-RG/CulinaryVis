import * as functions from "firebase-functions";
import {GoogleGenerativeAI} from "@google/generative-ai";
import {defineString} from "firebase-functions/params";

// Define the Gemini API key as a secret parameter
const GEMINI_API_KEY = defineString("GEMINI_KEY");

// Initialize the Gemini AI client
let genAI: GoogleGenerativeAI;
let model: any;

const initializeGenAI = () => {
  if (!genAI) {
    genAI = new GoogleGenerativeAI(GEMINI_API_KEY.value());
    model = genAI.getGenerativeModel({
      model: "gemini-2.5-flash-preview-09-2025",
    });
  }
};

/**
 * A callable function that uses the Gemini AI to modify a recipe.
 */
export const modifyRecipe = functions.https.onCall(async (request) => {
  initializeGenAI(); // Ensure the client is initialized

  // NEW: Data is now on request.data
  const {recipeText, request: userRequest} = request.data;

  // 1. Validate the input
  if (!recipeText) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "No recipe text was provided.",
    );
  }
  if (!userRequest) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "No modification request was provided.",
    );
  }

  functions.logger.info(`Modifying recipe with request: "${userRequest}"`);

  // 2. Create the prompt for the AI
  const prompt = `
    You are a helpful culinary assistant.
    A user has provided a recipe and a request.
    Your task is to rewrite the recipe based on the user's request.
    Respond with ONLY the new, complete recipe text. Do not add any 
    conversational text like "Here is the modified recipe:".

    ---
    ORIGINAL RECIPE:
    ${recipeText}
    ---
    USER REQUEST:
    ${userRequest}
    ---
    MODIFIED RECIPE:
  `;

  // 3. Call the Gemini API
  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const modifiedRecipe = response.text();

    functions.logger.info("Successfully modified recipe with Gemini.");

    // 4. Return the new recipe
    return {modifiedRecipe: modifiedRecipe};
  } catch (error: unknown) {
    let message = "Unknown error";
    if (error instanceof Error) {
      message = error.message;
    }
    functions.logger.error("Error calling Gemini API:", message);
    throw new functions.https.HttpsError(
        "internal",
        "Failed to modify recipe with AI.",
    );
  }
});