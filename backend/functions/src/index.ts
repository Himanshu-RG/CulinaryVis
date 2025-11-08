import * as functions from "firebase-functions";
import dotenv from "dotenv";

dotenv.config(); // loads variables from .env

export const hello = functions.https.onRequest((req, res) => {
  const apiKey = process.env.API_KEY;
  const secret = process.env.SECRET_TOKEN;
  res.send(`Your API key (locally) is ${apiKey}, secret is ${secret}`);
});

// Import the Firebase Admin SDK
import * as admin from "firebase-admin";

// Initialize the Firebase Admin SDK
// This gives your functions access to Firebase services
admin.initializeApp();

// --- Your App's Functions Will Be Exported Below ---

export {scanIngredients} from "./scanIngredients";
export {getRecipes} from "./getRecipes";
export {modifyRecipe} from "./modifyRecipe";
export {saveRecipe} from "./saveRecipe";