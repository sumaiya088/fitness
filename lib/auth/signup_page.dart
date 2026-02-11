import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../onboard/gender_page.dart'; // Starts the one-time setup
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

  bool isPageLoading = false;
  bool isPasswordHidden = true;

  // Modern Snackbar Helper
  void showStatusLine(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> startSignupProcess() async {
    // 1. Validations
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showStatusLine("Please fill in your details");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showStatusLine("Passwords do not match");
      return;
    }

    setState(() => isPageLoading = true);

    try {
      // 2. Create User in Supabase
      await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      showStatusLine("Account created!", isError: false);

      // 3. Navigate to Gender Page (The Start of Onboarding)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GenderPage()),
      );
    } on AuthException catch (e) {
      showStatusLine(e.message);
    } catch (error) {
      showStatusLine("Something went wrong");
    } finally {
      if (mounted) setState(() => isPageLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color yellow = Color(0xFFF5C518);

    return Scaffold(
      backgroundColor: const Color(0xFF1E2328),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 80,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    color: yellow,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Email
              const Text(
                "Email Address",
                style: TextStyle(color: Colors.white70),
              ),
              _inputBox(emailController, "Enter your email", false),

              const SizedBox(height: 20),

              // Password
              const Text("Password", style: TextStyle(color: Colors.white70)),
              _inputBox(passwordController, "Min 6 characters", true),

              const SizedBox(height: 20),

              // Confirm Password
              const Text(
                "Confirm Password",
                style: TextStyle(color: Colors.white70),
              ),
              _inputBox(confirmPasswordController, "Re-enter password", true),

              const SizedBox(height: 30),

              // Signup Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isPageLoading ? null : startSignupProcess,
                  child: isPageLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Switch to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                    child: const Text(
                      "Sign In",
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

  // Reusable Input box to keep code easy to read
  Widget _inputBox(TextEditingController controller, String hint, bool isPass) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass && isPasswordHidden,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          suffixIcon: isPass
              ? IconButton(
                  icon: Icon(
                    isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => isPasswordHidden = !isPasswordHidden),
                )
              : null,
        ),
      ),
    );
  }
}
