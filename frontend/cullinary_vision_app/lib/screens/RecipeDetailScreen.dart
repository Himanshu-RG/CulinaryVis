import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipe Title Will Go Here")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. RECIPE IMAGE (Placeholder) ---
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    // We'll load a real image here later
                    image: NetworkImage(
                      'https://via.placeholder.com/600x400.png?text=Recipe+Image',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- 2. INGREDIENTS SECTION ---
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '• 1 cup Chicken\n'
                '• 2 cloves Garlic\n'
                '• 1 tbsp Olive Oil\n'
                '• ... (and so on)',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // --- 3. INSTRUCTIONS SECTION ---
              const Text(
                'Instructions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. Heat the olive oil in a pan.\n\n'
                '2. Add the garlic and chicken.\n\n'
                '3. Cook until the chicken is golden brown.\n\n'
                '4. ... (and so on)',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),

              // --- 4. NUTRITION SECTION ---
              const Text(
                'Nutritional Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '• Calories: 450\n'
                '• Protein: 30g\n'
                '• Fat: 15g\n'
                '• Carbs: 20g',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
