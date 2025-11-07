import 'LoginScreen.dart'; // Adjust path
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // This is a placeholder list.
  // Later, we will get this from Firebase.
  final List<String> _dislikes = ['Garlic', 'Ginger'];
  final TextEditingController _dislikeController = TextEditingController();

  void _addDislike() {
    if (_dislikeController.text.isNotEmpty) {
      setState(() {
        _dislikes.add(_dislikeController.text);
        _dislikeController.clear();
      });
      // TODO: Tell Person 2 to save this to Firebase
    }
  }

  void _removeDislike(String item) {
    setState(() {
      _dislikes.remove(item);
    });
    // TODO: Tell Person 2 to remove this from Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. USER EMAIL (Placeholder) ---
            const Text(
              'My Account',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.teal),
                title: const Text('user.email@gmail.com'), // Placeholder
                subtitle: const Text('Logged In'),
              ),
            ),
            const SizedBox(height: 30),

            // --- 2. MANAGE DISLIKES ---
            const Text(
              'My Preferences',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dislikeController,
              decoration: InputDecoration(
                labelText: 'Add a dislike or allergy',
                hintText: 'e.g., peanuts, cilantro',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addDislike,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // This displays the list of dislikes
            Expanded(
              child: ListView.builder(
                itemCount: _dislikes.length,
                itemBuilder: (context, index) {
                  final item = _dislikes[index];
                  return Card(
                    child: ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeDislike(item),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. LOG OUT BUTTON ---
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red[400], // A different color
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
