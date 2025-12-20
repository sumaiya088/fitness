import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup_page.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  final Color bgColor = const Color(0xFF1E2328);
  final Color yellow = const Color(0xFFF5C518);

  Future<void> login() async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
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

              /// 🏋️ Dumbbell Icon
              Icon(
                Icons.fitness_center,
                size: 60,
                color: Colors.indigoAccent,
              ),

              const SizedBox(height: 16),

              /// Welcome Text
              Text(
                'Welcome Back',
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

              const SizedBox(height: 12),

              /// Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: yellow,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 10),

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
                    'Keep me Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Login Button
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
                  onPressed: login,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupPage()),
                      );
                    },
                    child: Text(
                      'Sign Up',
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

  /// 🔹 Label Widget
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

  /// 🔹 Input Field Widget
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

