import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_page.dart';

class MainGoalPage extends StatefulWidget {
  final String gender;
  final double weight;
  final double height;
  final double bmi;

  const MainGoalPage({
    super.key,
    required this.gender,
    required this.weight,
    required this.height,
    required this.bmi,
  });

  @override
  State<MainGoalPage> createState() => _MainGoalPageState();
}

class _MainGoalPageState extends State<MainGoalPage> {
  // -1 means no goal is selected yet
  int selectedIndex = -1;

  // The 3 goals for our list
  final List<String> goalTitles = ["Lose Weight", "Build Muscles", "Keep Fit"];
  final List<String> goalImages = [
    "assets/images/loose weight.jpg",
    "assets/images/build muscles.jpg",
    "assets/images/keep fit.jpg",
  ];

  // Logic to save data to Supabase
  Future<void> saveGoalAndContinue() async {
    if (selectedIndex == -1) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        // Update the 'goal' column in the user_profile table
        await Supabase.instance.client
            .from('user_profile')
            .update({'goal': goalTitles[selectedIndex]})
            .eq('id', user.id);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } catch (e) {
        debugPrint("Error saving goal: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Standard yellow color used for our theme
    const Color yellowTheme = Color(0xFFF5C518);

    return Scaffold(
      backgroundColor: const Color(0xFF1E2328), // Dark Background
      // --- ADDED APPBAR TO MATCH OTHER PAGES ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2328),
        elevation: 0,
        iconTheme: const IconThemeData(color: yellowTheme), // Yellow Back Arrow
        title: const Text(
          "Goals & Focus",
          style: TextStyle(color: yellowTheme, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "What's your main goal?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // --- THE GOAL LIST ---
              // Using a simple 'for loop' to create the selection cards
              for (int i = 0; i < 3; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = i; // Highlight the selected card
                    });
                  },
                  child: Container(
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      // Toggle between Yellow and Dark Gray
                      color: selectedIndex == i
                          ? yellowTheme
                          : const Color(0xFF2A2F35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            goalTitles[i],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              // Text turns black when background is yellow
                              color: selectedIndex == i
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        // Image on the right side of the card
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.asset(
                            goalImages[i],
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const Spacer(), // Pushes button to the bottom
              // --- LETS GO BUTTON ---
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowTheme,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  // Button is disabled (null) until something is selected
                  onPressed: selectedIndex == -1 ? null : saveGoalAndContinue,
                  child: const Text(
                    "Let's Go",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

