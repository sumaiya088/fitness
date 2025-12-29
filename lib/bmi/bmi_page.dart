import 'package:flutter/material.dart';
import '../home/home_page.dart';

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
              /// Title
              const Text(
                'BMI Result',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// BMI Circle
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

              /// Status
              Text(
                bmiStatus,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              /// Info Card (NO AGE)
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

              /// BMI RANGE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "BMI Range",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),

                  Stack(
                    children: [
                      Row(
                        children: const [
                          _ScaleBar(Colors.blue),
                          _ScaleBar(Colors.green),
                          _ScaleBar(Colors.orange),
                          _ScaleBar(Colors.red),
                        ],
                      ),

                      Positioned(
                        left: _indicatorPosition(bmi),
                        child: Container(
                          height: 14,
                          width: 4,
                          decoration: BoxDecoration(
                            color: yellow,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Under",
                          style: TextStyle(
                              color: Colors.white54, fontSize: 11)),
                      Text("Normal",
                          style: TextStyle(
                              color: Colors.white54, fontSize: 11)),
                      Text("Over",
                          style: TextStyle(
                              color: Colors.white54, fontSize: 11)),
                      Text("Obese",
                          style: TextStyle(
                              color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              /// NEXT
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );
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

  static double _indicatorPosition(double bmi) {
    if (bmi < 18.5) return 10;
    if (bmi < 25) return 80;
    if (bmi < 30) return 160;
    return 240;
  }
}

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
