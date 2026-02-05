import 'package:flutter/material.dart';
import '../auth/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color yellow = Color(0xFFF5C518);

    return Scaffold(
      // We use a Stack to layer things on top of each other
      body: Stack(
        children: [
          // LAYER 1: The Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash.jpeg',
              fit: BoxFit.cover, // This makes the image fill the whole screen
            ),
          ),

          // LAYER 2: The Dark Filter (Overlay)
          // This makes the white text easier to read over the image
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // LAYER 3: The Text and Button (At the bottom)
          Positioned(
            bottom: 50,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SMALL STEPS\nBIG CHANGES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // THE BUTTON
                SizedBox(
                  width: double.infinity, // Full width button
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Move to the Login Page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
