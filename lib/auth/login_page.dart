import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../onboard/gender_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;

  // Login function with error handling
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      // Show error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password.")),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.session == null) {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      } else {
        // Navigate to the next page after successful login
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GenderPage()),
        );
      }
    } on AuthException catch (e) {
      // Handle auth exceptions
      String msg = e.message.toLowerCase().contains('invalid login')
          ? "Incorrect email or password"
          : e.message;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      // Handle any other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2328), // Set background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dumbbell Icon moved up slightly
              const Icon(
                Icons.fitness_center,
                size: 60,
                color: Colors.indigoAccent,  // Set the color for the icon
              ),
              const SizedBox(height: 15),  // Decreased space between the icon and text

              // Welcome Back Text moved up slightly and yellow color
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.yellow,  // Set the color to yellow
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),  // Increase space before the text field

              // Email Address Input
              _inputField(controller: emailController, hint: 'Email Address'),

              const SizedBox(height: 20),

              // Password Input moved closer to the "Forgot Password"
              _inputField(
                controller: passwordController,
                hint: 'Password',
                isPassword: true,
              ),

              const SizedBox(height: 10),  // Reduced space between password and "Forgot Password"

              // Forgot Password Link moved closer
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Forgot password tapped')),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.yellow, fontSize: 13),
                  ),
                ),
              ),

              const SizedBox(height: 20), // Added space before "Keep me logged in" and "Login" button

              // Keep me logged in Checkbox
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                    activeColor: Colors.yellow,
                  ),
                  const Text(
                    'Keep me logged in',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Login Button (yellow background)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,  // Correct parameter for background color
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: login, // Trigger login function
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Input Field Widget
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black),  // Text color is black inside the white box
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,  // White background for input fields
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),  // Black hint text
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
