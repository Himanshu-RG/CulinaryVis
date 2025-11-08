import * as functions from "firebase-functions";
import {getFirestore, FieldValue} from "firebase-admin/firestore";

// Get a reference to your new Firestore database
const db = getFirestore();

/**
 * A callable function to save a recipe to a user's private collection.
 */
export const saveRecipe = functions.https.onCall(async (request) => {
  // 1. Get the user's ID from the request.
  // This is critical for security.
  const uid = request.auth?.uid;
  if (!uid) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "You must be logged in to save a recipe.",
    );
  }

  // 2. Get the recipe data from the app.
  const {recipeName, recipeText} = request.data;
  if (!recipeName || !recipeText) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with 'recipeName' and 'recipeText'.",
    );
  }

  // 3. Create a new document in Firestore.
  // This is the core logic!
  // We are creating a document inside a "savedRecipes" sub-collection
  // that lives on the user's document.
  // Path: /users/{userId}/savedRecipes/{newRecipeId}
  try {
    const newRecipeRef = await db
        .collection("users")
        .doc(uid)
        .collection("savedRecipes")
        .add({
          name: recipeName,
          text: recipeText,
          savedAt: FieldValue.serverTimestamp(), // Add a "saved on" date
        });

    functions.logger.info(`User ${uid} saved new recipe: ${newRecipeRef.id}`);

    // 4. Send back a success message.
    return {
      success: true,
      recipeId: newRecipeRef.id,
      message: "Recipe saved successfully!",
    };
  } catch (error: unknown) {
    let message = "Unknown error";
    if (error instanceof Error) {
      message = error.message;
    }
    functions.logger.error(`Error saving recipe for user ${uid}:`, message);
    throw new functions.https.HttpsError("internal", "Failed to save recipe.");
  }
});