import 'package:flutter/material.dart';
import '../widgets/water_glass.dart';

class WaterTestPage extends StatefulWidget {
  const WaterTestPage({super.key});

  @override
  State<WaterTestPage> createState() => _WaterTestPageState();
}

class _WaterTestPageState extends State<WaterTestPage> {
  int waterMl = 0;
  final int target = 2500;

  @override
  Widget build(BuildContext context) {
    final double level = waterMl / target;

    return Scaffold(
      backgroundColor: const Color(0xFF1F2A30),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A30),
        title: const Text(
          "Water Test",
          style: TextStyle(color: Colors.amber),
        ),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 🔥 GLASS + WATER WAVE
            Stack(
              alignment: Alignment.center,
              children: [
                // Animated water
                WaterGlass(level: level),

                // Glass image overlay
                Image.asset(
                  "assets/images/glass.png",
                  width: 180,
                  fit: BoxFit.contain,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// WATER TEXT
            Text(
              "$waterMl / $target ml",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            /// BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      waterMl += 250;
                    });
                  },
                  child: const Text("+250 ml"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      waterMl += 500;
                    });
                  },
                  child: const Text("+500 ml"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

