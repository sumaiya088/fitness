import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../bmi/bmi_page.dart';

class HeightPage extends StatefulWidget {
  final String gender;
  final double weight;

  const HeightPage({super.key, required this.gender, required this.weight});

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  final _supabase = Supabase.instance.client;
  double heightValue = 170.0; // Slider value
  bool isCmSelected = true;
  bool isLoading = false;

  Future<void> saveProfileAndContinue() async {
    setState(() => isLoading = true);

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Database insert → int required
      await _supabase.from('user_profile').upsert({
        'id': user.id,
        'gender': widget.gender,
        'weight': widget.weight.toInt(), // convert to int
        'height': heightValue.toInt(),    // convert to int
      });

      if (!mounted) return;

      // Navigate to BmiPage → double parameters
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BmiPage(
            gender: widget.gender,
            weight: widget.weight,       // double, keep for calculation
            height: heightValue,         // double, keep for calculation
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent,
          ),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitBtn(
                    "Cm",
                    isCmSelected,
                    () => setState(() => isCmSelected = true),
                  ),
                  const SizedBox(width: 10),
                  _unitBtn(
                    "Ft",
                    !isCmSelected,
                    () => setState(() => isCmSelected = false),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                isCmSelected
                    ? "${heightValue.toInt()} cm"
                    : "${(heightValue / 30.48).toStringAsFixed(1)} ft",
                style: const TextStyle(
                  color: yellow,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                value: heightValue,
                min: 100.0,
                max: 250.0,
                activeColor: yellow,
                onChanged: (value) => setState(() => heightValue = value),
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
                  onPressed: isLoading ? null : saveProfileAndContinue,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
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

  Widget _unitBtn(String label, bool selected, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? const Color(0xFFF5C518) : Colors.grey[800],
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.black : Colors.white),
      ),
    );
  }
}
