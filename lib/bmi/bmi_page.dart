import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../goals/main_goal_page.dart';

class BmiPage extends StatelessWidget {
  final String gender;
  final double weight; // kg
  final double height; // cm

  const BmiPage({
    super.key,
    required this.gender,
    required this.weight,
    required this.height,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiStatus {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal Weight";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF1E2328);
    const Color yellow = Color(0xFFF5C518);
    const Color cardColor = Color(0xFF2A2F35);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              /// TITLE
              const Text(
                'BMI Result',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// BMI CIRCLE
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF7D046), Color(0xFFF5C518)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    bmi.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// STATUS
              Text(
                bmiStatus,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              /// INFO CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _infoRow("Gender", gender),
                    _infoRow("Weight", "${weight.toInt()} kg"),
                    _infoRow("Height", "${height.toInt()} cm"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// BMI RANGE BAR
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "BMI Range",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final barWidth = constraints.maxWidth;
                      final indicatorX =
                          _bmiIndicatorX(bmi, barWidth);

                      return Stack(
                        children: [
                          Row(
                            children: const [
                              _ScaleBar(Colors.red),
                              _ScaleBar(Colors.blue),
                              _ScaleBar(Colors.orange),
                              _ScaleBar(Colors.purple),
                            ],
                          ),
                          Positioned(
                            left: indicatorX,
                            top: -6,
                            child: Container(
                              width: 4,
                              height: 20,
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
                ],
              ),

              const Spacer(),

              /// ✅ NEXT BUTTON (SUPABASE SAVE)
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
                  onPressed: () async {
                    final supabase = Supabase.instance.client;
                    final user = supabase.auth.currentUser;

                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User not logged in"),
                        ),
                      );
                      return;
                    }

                    try {
                      /// ✅ SAVE DATA TO user_profile
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
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to save data: $e"),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// INFO ROW
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

  /// BMI INDICATOR POSITION
  static double _bmiIndicatorX(double bmi, double width) {
    final value = bmi.clamp(0, 40);
    final percent = value / 40;
    return (width * percent) - 2;
  }
}

/// SCALE BAR
class _ScaleBar extends StatelessWidget {
  final Color color;
  const _ScaleBar(this.color);

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
