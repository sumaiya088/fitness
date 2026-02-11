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

  // -------- BMI LOGIC --------
  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiStatus {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
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
              _buildHeader(context),

              const SizedBox(height: 30),

              // BMI Circle
              _buildBmiCircle(),

              const SizedBox(height: 12),

              // BMI Status (depends on BMI value)
              Text(
                bmiStatus,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              // Info Card
              _buildInfoCard(cardColor),

              const SizedBox(height: 30),

              // Plain BMI Range (1st UI style)
              _buildRangeSection(cardColor),

              const SizedBox(height: 36),

              // Next Button
              _buildNextButton(context, yellow),
            ],
          ),
        ),
      ),
    );
  }

  // -------- UI PARTS --------

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

  Widget _buildRangeSection(Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Standard BMI Range:",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          _PlainRow("Underweight", "Below 18.5"),
          _PlainRow("Normal", "18.5 – 24.9"),
          _PlainRow("Overweight", "25.0 – 29.9"),
          _PlainRow("Obese", "30.0 and Above"),
        ],
      ),
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

          await supabase.from('user_profile').update({
            'gender': gender,
            'weight': weight.round(),
            'height': height.round(),
          }).eq('id', user.id);

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

// -------- SUPPORT WIDGET --------

class _PlainRow extends StatelessWidget {
  final String title;
  final String value;

  const _PlainRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
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
