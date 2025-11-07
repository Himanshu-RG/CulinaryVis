import 'package:flutter/material.dart';
import 'SignupScreen.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // 3. The Scaffold is returned here, from the screen widget.
    return Scaffold(
      appBar: AppBar(title: const Text('Login Screen')),
      // Use SingleChildScrollView to prevent overflow when keyboard appears
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Added some padding to the top
            const SizedBox(height: 180),

            const Text(
              'Login',
              style: TextStyle(
                fontSize: 50,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Added a smaller SizedBox
            const SizedBox(height: 20),

            // 4. Added Padding around the Form for better layout
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ), // Adds 16px padding on all sides
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        // Handle value changes
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'Please Enter Email' : null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,

                      // --- 1. THIS IS THE FIX ---
                      obscureText: true, // This hides the password
                      // -------------------------
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your Password',

                        // --- 4. ICON FIX ---
                        prefixIcon: Icon(Icons.lock), // Use Icons.lock
                        // -----------------
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) {
                        // Handle value changes
                      },
                      validator: (value) {
                        return value!.isEmpty ? 'Please Enter Password' : null;
                      },
                    ),

                    const SizedBox(height: 30), // Space before button
                    // --- 2. ADDED LOGIN BUTTON ---
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Add login logic here
                        print("Login button pressed!");
                        // We will add navigation to home screen here
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // Make the button wide
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    // -----------------------------
                  ],
                ),
              ),
            ),

            // --- 3. ADDED SIGN UP NAVIGATION ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    // TODO: Add navigation to SignUpScreen here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            // ---------------------------------
          ],
        ),
      ),
    );
  }
}
