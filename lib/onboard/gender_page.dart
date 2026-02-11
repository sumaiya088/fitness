import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../onboard/weight_page.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  // We start by assuming 'male' is selected
  String selectedGender = 'male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. BACKGROUND COLOR
      backgroundColor: const Color(0xFF1E2328),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "What's your gender?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),

              // 2. MALE SELECTION AREA
              GestureDetector(
                onTap: () {
                  // When tapped, we tell Flutter to update the UI
                  setState(() {
                    selectedGender = 'male';
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // If selectedGender is male, use yellow. Otherwise, use grey.
                        color: selectedGender == 'male'
                            ? const Color(0xFFF5C518)
                            : Colors.grey.shade800,
                      ),
                      child: const Icon(
                        Icons.male,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Male",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 3. FEMALE SELECTION AREA
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'female';
                  });
                },
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedGender == 'female'
                            ? const Color(0xFFF5C518)
                            : Colors.grey.shade800,
                      ),
                      child: const Icon(
                        Icons.female,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Female",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 4. NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5C518),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to WeightPage and pass the gender variable
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WeightPage(gender: selectedGender),
                      ),
                    );
                  },
                  child: const Text(
                    "NEXT",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}