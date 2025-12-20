import 'package:flutter/material.dart';
import '../auth/login_page.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final Color bgColor = const Color(0xFF0F0F0F);
  final Color yellow = const Color(0xFFF5C518);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [

          /// 🔵 Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          /// 🌑 Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          /// 📝 Text + Button
          Positioned(
            bottom: 50,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Text
                const Text(
                  'SMALL STEPS\nBIG CHANGES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 24),

                /// GET STARTED BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
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

