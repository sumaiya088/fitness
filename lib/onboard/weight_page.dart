import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'height_page.dart';
import '../home/home_page.dart';
import '../bmi/bmi_page.dart'; // Make sure this import is here!

class WeightPage extends StatefulWidget {
  final String? gender;
  const WeightPage({super.key, this.gender});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  double weight = 60;
  bool isKg = true;
  bool isLoading = false;

  void switchUnit(bool toKg) {
    if (isKg == toKg) return;
    setState(() {
      if (toKg) {
        weight = weight / 2.205;
      } else {
        weight = weight * 2.205;
      }
      isKg = toKg;
    });
  }

  Future<void> handleNext() async {
    // --- 1. SIGNUP FLOW ---
    // If gender is passed, we go to Height Page to finish profile
    if (widget.gender != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HeightPage(gender: widget.gender!, weight: weight),
        ),
      );
      return;
    }

    // --- 2. LOGIN FLOW (The "Smart" BMI calculation) ---
    setState(() => isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) throw Exception("No active session");

      // Pull the stored Height and Gender we saved during Signup
      final data = await supabase
          .from('user_profile')
          .select('height, gender')
          .eq('id', user.id)
          .single();

      double storedHeight = (data['height'] as num).toDouble();
      String storedGender = data['gender'] as String;

      // Calculate Weight in KG for math if needed
      double weightInKg = isKg ? weight : weight / 2.205;

      // Update the new weight in the database
      await supabase
          .from('user_profile')
          .update({'weight': weightInKg})
          .eq('id', user.id);

      if (!mounted) return;

      // GO STRAIGHT TO BMI PAGE (Measuring BMI based on new weight + stored height)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BmiPage(
            gender: storedGender,
            weight: weightInKg,
            height: storedHeight,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Profile not found. Please Sign Up.")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color yellow = Color(0xFFF5C518);
    return Scaffold(
      backgroundColor: const Color(0xFF1E2328),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (widget.gender != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              const Spacer(),
              const Text(
                "What's your current weight?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitBtn("Kg", isKg, () => switchUnit(true)),
                  const SizedBox(width: 15),
                  _unitBtn("Lbs", !isKg, () => switchUnit(false)),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                "${weight.round()} ${isKg ? "kg" : "lbs"}",
                style: const TextStyle(
                  color: yellow,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: weight,
                min: isKg ? 30 : 66,
                max: isKg ? 200 : 440,
                activeColor: yellow,
                onChanged: (value) => setState(() => weight = value),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: isLoading ? null : handleNext,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "MEASURE BMI →",
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

  Widget _unitBtn(String title, bool active, VoidCallback onTap) {
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