import 'package:flutter/material.dart';
import '../bmi/bmi_page.dart';

class HeightPage extends StatefulWidget {
  final String gender;
  final double weight; // kg

  const HeightPage({
    super.key,
    required this.gender,
    required this.weight,
  });

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  double height = 170; // cm
  bool isCm = true;

  final Color bgColor = const Color(0xFF1E2328);
  final Color yellow = const Color(0xFFF5C518);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "What's your height?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// FT / CM toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitButton('Ft', !isCm),
                  const SizedBox(width: 10),
                  _unitButton('Cm', isCm),
                ],
              ),

              const SizedBox(height: 40),

              /// Height value
              Text(
                isCm
                    ? '${height.toInt()} cm'
                    : '${(height / 30.48).toStringAsFixed(1)} ft',
                style: TextStyle(
                  color: yellow,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Slider(
                value: height,
                min: 120,
                max: 220,
                divisions: 100,
                activeColor: yellow,
                inactiveColor: Colors.grey,
                onChanged: (v) => setState(() => height = v),
              ),

              const SizedBox(height: 50),

              /// NEXT BUTTON
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
                        builder: (_) => BmiPage(
                          gender: widget.gender,
                          weight: widget.weight,
                          height: height,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'NEXT →',
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

  Widget _unitButton(String text, bool selected) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? yellow : Colors.grey.shade800,
        foregroundColor: Colors.black,
      ),
      onPressed: () {
        setState(() {
          isCm = text == 'Cm';
        });
      },
      child: Text(text),
    );
  }
}
