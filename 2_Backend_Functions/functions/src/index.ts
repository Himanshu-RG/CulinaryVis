// Import the Firebase Admin SDK
import * as admin from "firebase-admin";

// Initialize the Firebase Admin SDK
// This gives your functions access to Firebase services
admin.initializeApp();

// --- Your App's Functions Will Be Exported Below ---

export {scanIngredients} from "./scanIngredients";
export {getRecipes} from "./getRecipes";
export {modifyRecipe} from "./modifyRecipe";
