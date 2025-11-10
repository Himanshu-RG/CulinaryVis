// --- 1. ADD THESE IMPORTS ---
import 'package:cloud_functions/cloud_functions.dart';
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
  final TextEditingController _ingredientController = TextEditingController();

  // --- 1. UPDATE THE TYPE OF _recipes ---
  bool _isLoading = false;
  List<Map<String, dynamic>> _recipes = []; // Changed from List<dynamic>

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  // --- 3. CREATE THE FUNCTION TO CALL YOUR BACKEND ---
  Future<void> _getRecipes() async {
    if (_ingredientController.text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
      _recipes = [];
    });

    try {
      final List<String> ingredients = _ingredientController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (ingredients.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getRecipes',
      );

      final HttpsCallableResult result = await callable.call({
        'ingredients': ingredients,
      });

      // --- 2. THIS IS THE FIX ---
      // We must manually cast the List<dynamic> from Firebase
      // into a List<Map<String, dynamic>>.
      final List<dynamic> rawList = List<dynamic>.from(result.data);
      final List<Map<String, dynamic>> recipeList = rawList
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      setState(() {
        _recipes = recipeList; // Assign the correctly typed list
        _isLoading = false;
      });
      // --- END OF FIX ---
    } on FirebaseFunctionsException catch (e) {
      print('Firebase Function Error: ${e.code} ${e.message}');
      setState(() => _isLoading = false);
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (Camera Button and Manual Input sections are unchanged)
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
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Ingredients with Camera'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Or add manually:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ingredientController,
              decoration: InputDecoration(
                hintText: 'e.g., chicken, tomatoes, rice',
                labelText: 'Ingredients (comma separated)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _getRecipes,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Suggested Recipes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _recipes.isEmpty
                  ? Center(
                      child: Text(
                        "Your recipe results will appear here.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        // 'recipe' is now correctly typed as Map<String, dynamic>
                        final recipe = _recipes[index];
                        final String title = recipe['title'] ?? 'No Title';
                        final String imageUrl = recipe['image'] ?? '';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.restaurant,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.restaurant,
                                      color: Colors.grey,
                                    ),
                                  ),
                            title: Text(title),
                            subtitle: Text("Likes: ${recipe['likes'] ?? 0}"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // This will no longer cause an error
                                      RecipeDetailScreen(recipe: recipe),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
