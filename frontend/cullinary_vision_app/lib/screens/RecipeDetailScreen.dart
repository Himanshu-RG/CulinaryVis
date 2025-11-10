import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  // --- 1. ACCEPT THE RECIPE DATA ---
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Extract data safely, providing defaults if something is missing
    final String title = recipe['title'] ?? 'No Title';
    final String imageUrl = recipe['image'] ?? '';
    final int likes = recipe['likes'] ?? 0;

    // Spoonacular's 'findByIngredients' endpoint returns limited data.
    // It gives us 'usedIngredients' and 'missedIngredients'.
    // We'll combine them to show a full ingredient list.
    final List<dynamic> usedIngredients = recipe['usedIngredients'] ?? [];
    final List<dynamic> missedIngredients = recipe['missedIngredients'] ?? [];
    final List<dynamic> allIngredients = [
      ...usedIngredients,
      ...missedIngredients,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(title, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 2. RECIPE IMAGE ---
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.restaurant,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // --- 3. LIKES / POPULARITY ---
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    '$likes Likes',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- 4. INGREDIENTS SECTION ---
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Use a ListView.builder so we don't have to manually format strings
              ListView.builder(
                shrinkWrap:
                    true, // Important: lets ListView sit inside SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Disables scrolling for this inner list
                itemCount: allIngredients.length,
                itemBuilder: (context, index) {
                  final ingredient = allIngredients[index];
                  final String name =
                      ingredient['original'] ??
                      ingredient['name'] ??
                      'Unknown ingredient';
                  // Check if this ingredient was "missed" (user doesn't have it)
                  // We can highlight it if we want.
                  final bool isMissed = missedIngredients.contains(ingredient);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 18,
                            color: isMissed ? Colors.orange : Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              // Optional: Bold missing ingredients so user knows what to buy
                              fontWeight: isMissed
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isMissed
                                  ? Colors.orange[800]
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              // --- 5. NOTE ABOUT INSTRUCTIONS ---
              // The 'findByIngredients' API endpoint does NOT return full instructions.
              // To get instructions, you need to make a SECOND API call using the recipe ID.
              // For now, we will show a placeholder explaining this.
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Looking for Instructions?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The current API call only returns ingredients. To see full instructions and nutrition, we need to implement a second API call using this recipe\'s ID.',
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
