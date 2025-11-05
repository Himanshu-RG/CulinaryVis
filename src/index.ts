import * as functions from "firebase-functions";
import { scanIngredients as scanFn } from "./scanIngredients";

export const helloWorld = functions.https.onRequest((req, res) => {
  res.send("Hello from CulinaryVision backend!");
});

export const scanIngredients = scanFn;
