import 'package:flutter/material.dart';
import 'height_page.dart';

class WeightPage extends StatefulWidget {
  final String gender;
  const WeightPage({super.key, required this.gender});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  double weight = 55;
  bool isKg = true;

  final Color bg = const Color(0xFF1E2328);
  final Color yellow = const Color(0xFFF5C518);

  double get min => isKg ? 40 : 88;
  double get max => isKg ? 120 : 264;

  void switchUnit(bool toKg) {
    setState(() {
      if (toKg && !isKg) {
        weight = weight / 2.205;
      } else if (!toKg && isKg) {
        weight = weight * 2.205;
      }
      isKg = toKg;
      weight = weight.clamp(min, max);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              const Text(
                "What's your weight?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// UNIT SWITCH
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitBtn("Kg", isKg, () => switchUnit(true)),
                  const SizedBox(width: 12),
                  _unitBtn("Lbs", !isKg, () => switchUnit(false)),
                ],
              ),

              const SizedBox(height: 32),

              /// VALUE
              Text(
                "${weight.round()} ${isKg ? "kg" : "lbs"}",
                style: TextStyle(
                  color: yellow,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// SLIDER
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: yellow,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: yellow,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: weight,
                  min: min,
                  max: max,
                  onChanged: (v) {
                    setState(() => weight = v);
                  },
                ),
              ),

              const Spacer(),

              /// NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HeightPage(
                          gender: widget.gender,
                          weight: weight,
                        ),
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _unitBtn(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? yellow : Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
