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
exports.modifyRecipe = exports.getRecipes = exports.scanIngredients = exports.helloWorld = void 0;
// Import the Firebase Admin SDK
const admin = __importStar(require("firebase-admin"));
// Import Firebase Functions
const functions = __importStar(require("firebase-functions"));
// Initialize the Firebase Admin SDK
// This gives your functions access to Firebase services
admin.initializeApp();
/**
 * A simple "Hello World" test function.
 * You can call this from your browser to make sure deployment is working.
 * To delete this later, just remove the 5 lines below.
 */
exports.helloWorld = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from CulinaryVision Backend!");
});
// --- Your App's Functions Will Be Exported Below ---
var scanIngredients_1 = require("./scanIngredients");
Object.defineProperty(exports, "scanIngredients", { enumerable: true, get: function () { return scanIngredients_1.scanIngredients; } });
var getRecipes_1 = require("./getRecipes"); // <-- THIS IS THE NEW LINE
Object.defineProperty(exports, "getRecipes", { enumerable: true, get: function () { return getRecipes_1.getRecipes; } });
var modifyRecipe_1 = require("./modifyRecipe");
Object.defineProperty(exports, "modifyRecipe", { enumerable: true, get: function () { return modifyRecipe_1.modifyRecipe; } });
//# sourceMappingURL=index.js.map