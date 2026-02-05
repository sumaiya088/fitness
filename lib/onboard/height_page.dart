import 'package:flutter/material.dart';
import '../bmi/bmi_page.dart';

class HeightPage extends StatefulWidget {
  final String gender;
  final double weight;

  const HeightPage({super.key, required this.gender, required this.weight});

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  // 1. SIMPLE VARIABLES
  double heightValue = 170.0; // The default height
  bool isCmSelected = true; // Toggle for CM or FT

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2328),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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

              const SizedBox(height: 40),
              const Text(
                "What's your height?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // 2. UNIT SWITCHER (CM / FT)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CM Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCmSelected
                          ? const Color(0xFFF5C518)
                          : Colors.grey[800],
                    ),
                    onPressed: () => setState(() => isCmSelected = true),
                    child: const Text("Cm"),
                  ),
                  const SizedBox(width: 10),
                  // FT Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isCmSelected
                          ? const Color(0xFFF5C518)
                          : Colors.grey[800],
                    ),
                    onPressed: () => setState(() => isCmSelected = false),
                    child: const Text("Ft"),
                  ),
                ],
              ),

              const Spacer(),

              // 3. HEIGHT DISPLAY
              Text(
                isCmSelected
                    ? "${heightValue.toInt()} cm"
                    : "${(heightValue / 30.48).toStringAsFixed(1)} ft",
                style: const TextStyle(
                  color: Color(0xFFF5C518),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // 4. THE SLIDER
              Slider(
                value: heightValue,
                min: 100.0,
                max: 250.0,
                activeColor: const Color(0xFFF5C518),
                onChanged: (value) {
                  setState(() {
                    heightValue = value; // Update the height as you slide
                  });
                },
              ),

              const Spacer(),

              // 5. NAVIGATE TO BMI PAGE
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BmiPage(
                          gender: widget.gender,
                          weight: widget.weight,
                          height: heightValue,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "CALCULATE BMI →",
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
}
