import 'package:flutter/material.dart';
import 'height_page.dart';

class WeightPage extends StatefulWidget {
  final String gender;
  const WeightPage({super.key, required this.gender});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  // 1. SIMPLE STATE
  double weight = 60; // Default weight
  bool isKg = true; // Toggle for Kg or Lbs

  // 2. UNIT CONVERSION LOGIC
  // This function changes the number when you click Kg or Lbs
  void switchUnit(bool toKg) {
    if (isKg == toKg) return; // Do nothing if already selected

    setState(() {
      if (toKg) {
        weight = weight / 2.205; // Convert Lbs to Kg
      } else {
        weight = weight * 2.205; // Convert Kg to Lbs
      }
      isKg = toKg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2328),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const Spacer(),
              const Text(
                "What's your weight?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // 3. UNIT SELECTOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitButton("Kg", isKg, () => switchUnit(true)),
                  const SizedBox(width: 15),
                  _unitButton("Lbs", !isKg, () => switchUnit(false)),
                ],
              ),

              const SizedBox(height: 40),

              // 4. WEIGHT DISPLAY
              Text(
                "${weight.round()} ${isKg ? "kg" : "lbs"}",
                style: const TextStyle(
                  color: Color(0xFFF5C518),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 5. SLIDER
              Slider(
                value: weight,
                // Adjust min/max based on the unit
                min: isKg ? 30 : 66,
                max: isKg ? 200 : 440,
                activeColor: const Color(0xFFF5C518),
                onChanged: (value) => setState(() => weight = value),
              ),

              const Spacer(),

              // 6. NEXT BUTTON
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HeightPage(gender: widget.gender, weight: weight),
                      ),
                    );
                  },
                  child: const Text(
                    "NEXT →",
                    style: TextStyle(
                      color: Colors.black,
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

  // 7. HELPER FOR BUTTONS
  Widget _unitButton(String title, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFF5C518) : Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
