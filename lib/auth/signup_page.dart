import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../onboard/gender_page.dart'; 
// ✅ BMI না, GENDER
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool rememberMe = false;

  final Color bgColor = const Color(0xFF1E2328);
  final Color yellow = const Color(0xFFF5C518);

  Future<void> signup() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    await Supabase.instance.client.auth.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    // ✅ SIGNUP → GENDER PAGE (FIXED)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GenderPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 40),

              /// 🏋️ LOGO (same as before)
              Icon(
                Icons.fitness_center,
                size: 60,
                color: Colors.indigoAccent,
              ),

              const SizedBox(height: 16),

              /// Title
              Text(
                'Sign Up',
                style: TextStyle(
                  color: yellow,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              /// Email
              _label('Email Address'),
              _inputField(
                controller: emailController,
                hint: 'Enter your email',
              ),

              const SizedBox(height: 20),

              /// Password
              _label('Password'),
              _inputField(
                controller: passwordController,
                hint: 'Enter your password',
                isPassword: true,
              ),

              const SizedBox(height: 20),

              /// Confirm Password
              _label('Confirm Password'),
              _inputField(
                controller: confirmPasswordController,
                hint: 'Confirm your password',
                isPassword: true,
              ),

              const SizedBox(height: 12),

              /// Remember Me
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: yellow,
                    onChanged: (value) {
                      setState(() => rememberMe = value!);
                    },
                  ),
                  const Text(
                    'Remember me',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: signup,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an Account? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: yellow,
                        fontWeight: FontWeight.bold,
                      ),
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

  /// 🔹 Label
  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  /// 🔹 Input Field
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

