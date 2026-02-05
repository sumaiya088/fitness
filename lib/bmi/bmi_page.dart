import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../goals/main_goal_page.dart';

class BmiPage extends StatelessWidget {
  final String gender;
  final double weight;
  final double height;

  const BmiPage({
    super.key,
    required this.gender,
    required this.weight,
    required this.height,
  });

  // --- MATH LOGIC (Easy to explain) ---
  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiStatus {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  int get activeIndex {
    if (bmi < 18.5) return 0;
    if (bmi < 25) return 1;
    if (bmi < 30) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF1E2328);
    const yellow = Color(0xFFF5C518);
    const cardColor = Color(0xFF2A2F35);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 1. HEADER ROW
              _buildHeader(context),

              const SizedBox(height: 30),

              // 2. THE GRADIENT CIRCLE
              _buildBmiCircle(),

              const SizedBox(height: 12),
              Text(
                bmiStatus,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              // 3. INFO CARD (Gender, Weight, Height)
              _buildInfoCard(cardColor),

              const SizedBox(height: 30),

              // 4. THE BMI RANGE SECTION (The Bar and the Legend)
              _buildRangeSection(yellow),

              const SizedBox(height: 36),

              // 5. THE NEXT BUTTON
              _buildNextButton(context, yellow),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER METHODS (These make your code look professional) ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "BMI Result",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildBmiCircle() {
    return Container(
      height: 170,
      width: 170,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFF7D046), Color(0xFFF5C518)],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        bmi.toStringAsFixed(1),
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildInfoCard(Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _infoRow("Gender", gender),
          _infoRow(
            "Weight",
            "${weight.toInt()} kg / ${(weight * 2.205).toInt()} lb",
          ),
          _infoRow("Height", "${height.toInt()} cm"),
        ],
      ),
    );
  }

  Widget _buildRangeSection(Color yellow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("BMI Range", style: TextStyle(color: Colors.white)),
        const SizedBox(height: 14),

        // THE COLORED BAR WITH INDICATOR
        LayoutBuilder(
          builder: (context, constraints) {
            final segmentWidth = constraints.maxWidth / 4;
            final indicatorX =
                (segmentWidth * activeIndex) + (segmentWidth / 2) - 2;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  children: const [
                    _ScaleBar(color: Colors.red),
                    _ScaleBar(color: Colors.green),
                    _ScaleBar(color: Colors.orange),
                    _ScaleBar(color: Colors.purple),
                  ],
                ),
                Positioned(
                  left: indicatorX,
                  top: -8,
                  child: Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // THE LEGEND (The dots and descriptions you wanted back!)
        const Legend(color: Colors.red, text: "Underweight (<18.5)"),
        const Legend(color: Colors.green, text: "Normal (18.5 – 24.9)"),
        const Legend(color: Colors.orange, text: "Overweight (25 – 29.9)"),
        const Legend(color: Colors.purple, text: "Obese (30+)"),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context, Color yellow) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () async {
          final supabase = Supabase.instance.client;
          final user = supabase.auth.currentUser;
          if (user == null) return;

          await supabase
              .from('user_profile')
              .update({
                'gender': gender,
                'weight': weight.round(),
                'height': height.round(),
              })
              .eq('id', user.id);

          if (!context.mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainGoalPage(
                gender: gender,
                weight: weight,
                height: height,
                bmi: bmi,
              ),
            ),
          );
        },
        child: const Text(
          "NEXT",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

// --- SUPPORTING WIDGETS (The Legend and Bar segments) ---

class _ScaleBar extends StatelessWidget {
  final Color color;
  const _ScaleBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String text;
  const Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}
