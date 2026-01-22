import 'dart:math';
import 'package:flutter/material.dart';

class WaterGlass extends StatefulWidget {
  final double level; // 0.0 - 1.0

  const WaterGlass({super.key, required this.level});

  @override
  State<WaterGlass> createState() => _WaterGlassState();
}

class _WaterGlassState extends State<WaterGlass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(); // 🔥 repeat is MUST
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(160, 220),
          painter: _WaterPainter(
            progress: widget.level,
            wavePhase: _controller.value,
          ),
        );
      },
    );
  }
}

class _WaterPainter extends CustomPainter {
  final double progress;
  final double wavePhase;

  _WaterPainter({
    required this.progress,
    required this.wavePhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final double level = progress.clamp(0.0, 1.0);
    final double waterTop = size.height * (1 - level);

    const double waveHeight = 8;
    final double waveLength = size.width;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, waterTop);

    for (double x = 0; x <= size.width; x++) {
      final y = waterTop +
          sin((x / waveLength * 2 * pi) + (wavePhase * 2 * pi)) *
              waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    // Clip to glass area
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 10, size.width - 40, size.height - 20),
        const Radius.circular(18),
      ),
    );

    canvas.drawPath(path, paint);
    canvas.restore();

    // Glass outline (for testing)
    final outline = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 10, size.width - 40, size.height - 20),
        const Radius.circular(18),
      ),
      outline,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
