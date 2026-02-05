import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../onboard/gender_page.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPageLoading = false;
  bool isPasswordHidden = true;
  bool isRememberMeChecked = false;

  // --- CLASSY ERROR SNACKBAR ---
  // VIVA TIP: This is a reusable helper function to keep the code clean.
  void showStatusLine(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green.shade700,
        behavior: SnackBarBehavior.floating, // Makes it look modern/classy
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> startSignupProcess() async {
    // 1. Check for empty boxes
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showStatusLine("Please fill in your details");
      return;
    }

    // 2. Check for matching passwords
    if (passwordController.text != confirmPasswordController.text) {
      showStatusLine("Passwords do not match");
      return;
    }

    // 3. Check password length
    if (passwordController.text.length < 6) {
      showStatusLine("Password must be at least 6 characters");
      return;
    }

    setState(() => isPageLoading = true);

    try {
      await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      showStatusLine("Account created successfully!", isError: false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GenderPage()),
        );
      }
    } on AuthException catch (e) {
      // CLASSY TRANSLATIONS FOR DATABASE ERRORS
      if (e.message.contains("already registered")) {
        showStatusLine("This email is already in use");
      } else if (e.message.contains("network")) {
        showStatusLine("Check your internet connection");
      } else {
        showStatusLine("Registration failed. Please try again.");
      }
    } catch (error) {
      showStatusLine("Something went wrong");
    } finally {
      if (mounted) setState(() => isPageLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // I kept your UI code exactly the same as you had it below...
    return Scaffold(
      backgroundColor: const Color(0xFF1E2328),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60.0),
            const Center(
              child: Icon(
                Icons.fitness_center,
                size: 80.0,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10.0),
            const Center(
              child: Text(
                "Create Account",
                style: TextStyle(
                  color: Color(0xFFF5C518),
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const Text(
              "Email Address",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text("Password", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8.0),
            TextField(
              controller: passwordController,
              obscureText: isPasswordHidden,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Min 6 characters",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => isPasswordHidden = !isPasswordHidden),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Confirm Password",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: confirmPasswordController,
              obscureText: isPasswordHidden,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Re-enter password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: isRememberMeChecked,
                  onChanged: (newValue) =>
                      setState(() => isRememberMeChecked = newValue!),
                  activeColor: const Color(0xFFF5C518),
                ),
                const Text(
                  "Remember me",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              height: 55.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5C518),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  if (!isPageLoading) startSignupProcess();
                },
                child: isPageLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color(0xFFF5C518),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
