import 'package:cullinary_vision_app/screens/CameraScreen.dart';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'RecipeDetailScreen.dart';
import 'UserProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // A controller to get the text from the text field
  final TextEditingController _ingredientController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pantry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      // We use Padding to add space around our UI
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. THE CAMERA SCAN BUTTON ---
            const Text(
              "What's in your pantry?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                );
                print("Open Camera Scanner");
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Ingredients with Camera'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 30), // A separator
            // --- 2. THE MANUAL INPUT FIELD ---
            const Text(
              "Or add manually:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ingredientController, // We link the controller here
              decoration: InputDecoration(
                hintText: 'e.g., chicken, tomatoes, rice',
                labelText: 'Ingredients',
                border: const OutlineInputBorder(),
                // Add a search button INSIDE the text field
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // TODO: Send these ingredients to the backend (Person 2's job)
                    final ingredients = _ingredientController.text;
                    print("Search for: $ingredients");

                    // --- ADD THIS NAVIGATION ---
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecipeDetailScreen(),
                      ),
                    );
                    // -------------------------
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. THE RECIPE RESULTS AREA (Placeholder) ---
            const Text(
              "Suggested Recipes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // This is a placeholder. Later, we will replace this
            // with a ListView of recipe cards.
            Expanded(
              child: Center(
                child: Text(
                  "Your recipe results will appear here.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
