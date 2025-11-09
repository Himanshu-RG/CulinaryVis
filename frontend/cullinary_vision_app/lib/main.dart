import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Make sure this import path matches exactly where you put your file
import 'screens/LoginScreen.dart';

void main() async {
  // These two lines are required to use Firebase before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Culinary Vision', // Updated title
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // It's good practice to set a consistent visual density
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // This sets the LoginScreen as the first screen of the app
      home: const LoginScreen(),
    );
  }
}
