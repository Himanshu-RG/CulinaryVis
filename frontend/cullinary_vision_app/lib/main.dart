import 'package:flutter/material.dart';
// import './screens/SignupScreen.dart';
import './screens/LoginScreen.dart';
// import './screens/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

// 1. MyApp is now a StatelessWidget.
// It only builds the MaterialApp *once*.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      title: 'Login Screen',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Sets the app's theme color
      ),
      home: const LoginScreen(), // The home is now its own widget
    );
  }
}
