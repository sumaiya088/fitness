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
  int selectedIndex = -1;

  final Color bg = const Color(0xFF1E2328);
  final Color yellow1 = const Color(0xFFF7D046);
  final Color yellow2 = const Color(0xFFF5C518);
  final Color cardDark = const Color(0xFF2A2F35);

  final List<Map<String, String>> goals = [
    {
      "title": "Lose Weight",
      "img": "assets/images/loose weight.jpg",
    },
    {
      "title": "Build Muscles",
      "img": "assets/images/build muscles.jpg",
    },
    {
      "title": "Keep Fit",
      "img": "assets/images/keep fit.jpg",
    },
  ];

  /// ✅ SAVE GOAL + GO HOME
  Future<void> _saveGoalAndContinue() async {
    if (selectedIndex == -1) return;

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final selectedGoal = goals[selectedIndex]["title"];

    try {
      await supabase.from('user_profile').update({
        'goal': selectedGoal,
      }).eq('id', user.id);

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save goal: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            /// TOP CURVE
            Positioned(
              top: -160,
              right: -140,
              child: _bgCircle(360),
            ),

            /// BOTTOM CURVE
            Positioned(
              bottom: -180,
              left: -160,
              child: _bgCircle(380),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  /// TITLE
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          "Goals & Focus",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Whats Your main goal?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  /// GOAL CARDS
                  _goalCard(0),
                  _goalCard(1),
                  _goalCard(2),

                  const SizedBox(height: 30),

                  /// BUTTON
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed:
                            selectedIndex == -1 ? null : _saveGoalAndContinue,
                        child: const Text(
                          "Lets Go",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// GOAL CARD
  Widget _goalCard(int index) {
    final bool selected = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        height: 86,
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: selected ? null : cardDark,
          gradient: selected
              ? LinearGradient(
                  colors: [yellow1, yellow2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(22),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: yellow2.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),

            /// TEXT
            Expanded(
              child: Text(
                goals[index]["title"]!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.black : Colors.white,
                ),
              ),
            ),

            /// IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
              child: Image.asset(
                goals[index]["img"]!,
                width: 86,
                height: 86,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BACKGROUND CIRCLE
  Widget _bgCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF24313A),
      ),
    );
  }
}


