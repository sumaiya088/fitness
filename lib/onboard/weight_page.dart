import 'package:flutter/material.dart';
import 'height_page.dart';

class WeightPage extends StatefulWidget {
  final String gender;

  const WeightPage({super.key, required this.gender});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  double weight = 64.0; // Initial weight value in kg
  bool isKg = true; // Track the unit (kg or lbs)

  final double minKg = 30.0;
  final double maxKg = 120.0;

  final double minLbs = 88.0; // 40 kg in lbs
  final double maxLbs = 264.0;

  final Color bgColor = const Color(0xFF1E2328);
  final Color yellow = const Color(0xFFF5C518);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Tell me about yourself',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "What's your current weight?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Current weight value display
              Text(
                '${weight.toStringAsFixed(1)} ${isKg ? 'kg' : 'lbs'}',
                style: TextStyle(
                  color: yellow,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Toggle between kg and lbs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _unitButton("Kg", isKg, () {
                    setState(() {
                      isKg = true;
                    });
                  }),
                  const SizedBox(width: 10),
                  _unitButton("Lbs", !isKg, () {
                    setState(() {
                      isKg = false;
                    });
                  }),
                ],
              ),

              const SizedBox(height: 30),
              // Weight scale slider
              WeightScale(
                initial: weight,
                min: isKg ? minKg : minLbs,
                max: isKg ? maxKg : maxLbs,
                onChanged: (v) {
                  setState(() {
                    weight = v;
                  });
                },
              ),
              const Spacer(),

              // NEXT button
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
                    'NEXT →',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
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

  Widget _unitButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: active ? yellow : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class WeightScale extends StatefulWidget {
  final double initial;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const WeightScale({
    super.key,
    required this.initial,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<WeightScale> createState() => _WeightScaleState();
}

class _WeightScaleState extends State<WeightScale> {
  late double value;

  @override
  void initState() {
    super.initState();
    value = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          value -= details.primaryDelta! * 0.05; // Adjust speed here
          value = value.clamp(widget.min, widget.max);
          widget.onChanged(value);
        });
      },
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: CustomPaint(
          painter: _ScalePainter(
            value: value,
            min: widget.min,
            max: widget.max,
          ),
        ),
      ),
    );
  }
}

class _ScalePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;

  _ScalePainter({
    required this.value,
    required this.min,
    required this.max,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    final Paint tickPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2;

    // scale ticks
    for (int i = (min / 1).toInt(); i <= (max / 1).toInt(); i++) {
      final double x = centerX + (i - (min / 1)) * 12;
      final double height = i % 5 == 0 ? 26 : 14;

      canvas.drawLine(
        Offset(x, size.height / 2 - height / 2),
        Offset(x, size.height / 2 + height / 2),
        tickPaint,
      );
    }

    // center indicator
    final Paint indicatorPaint = Paint()
      ..color = const Color(0xFFF5C518)
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(centerX, 10),
      Offset(centerX, size.height - 10),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
