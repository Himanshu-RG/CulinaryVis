import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginScreen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Placeholder for dislikes - will eventually come from Firestore
  final List<String> _dislikes = [];
  final TextEditingController _dislikeController = TextEditingController();

  @override
  void dispose() {
    _dislikeController.dispose();
    super.dispose();
  }

  // Function to handle logging out
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _addDislike() {
    if (_dislikeController.text.trim().isNotEmpty) {
      setState(() {
        _dislikes.add(_dislikeController.text.trim());
        _dislikeController.clear();
      });
      // TODO: Call backend function to save updated dislikes list to Firestore
    }
  }

  void _removeDislike(String item) {
    setState(() {
      _dislikes.remove(item);
    });
    // TODO: Call backend function to save updated dislikes list to Firestore
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. USER EMAIL SECTION ---
            const Text(
              'My Account',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.teal),
                // Display the real user email, or a fallback if somehow null
                title: Text(user?.email ?? 'No email found'),
                subtitle: const Text('Logged In via Firebase'),
              ),
            ),
            const SizedBox(height: 30),

            // --- 2. MANAGE DISLIKES SECTION ---
            const Text(
              'My Preferences (Allergies / Dislikes)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dislikeController,
              decoration: InputDecoration(
                labelText: 'Add item',
                hintText: 'e.g., peanuts, shellfish',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addDislike,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // List of dislikes
            Expanded(
              child: _dislikes.isEmpty
                  ? const Center(child: Text('No preferences added yet.'))
                  : ListView.builder(
                      itemCount: _dislikes.length,
                      itemBuilder: (context, index) {
                        final item = _dislikes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
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
              onPressed: _signOut, // Calls the _signOut function above
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
