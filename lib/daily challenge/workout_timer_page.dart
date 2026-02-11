import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/workout.dart';

class WorkoutTimerPage extends StatefulWidget {
  final Workout workout;
  const WorkoutTimerPage({super.key, required this.workout});

  @override
  State<WorkoutTimerPage> createState() => _WorkoutTimerPageState();
}

class _WorkoutTimerPageState extends State<WorkoutTimerPage> {
  late int totalSeconds;
  late int remainingSeconds;

  Timer? timer;
  bool isRunning = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    totalSeconds = widget.workout.duration * 60;
    remainingSeconds = totalSeconds;
  }

  // ▶ START / ⏸ PAUSE / ▶ RESUME
  void startOrPauseTimer() {
    // START or RESUME
    if (!isRunning) {
      setState(() {
        isRunning = true;
        isPaused = false;
      });

      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds <= 0) {
          t.cancel();
          setState(() {
            isRunning = false;
          });
          saveProgress();
          return;
        }

        setState(() {
          remainingSeconds--;
        });
      });
    }
    // PAUSE
    else {
      timer?.cancel();
      setState(() {
        isRunning = false;
        isPaused = true;
      });
    }
  }

  // ↻ RESET TIMER
  void resetTimer() {
    timer?.cancel();
    setState(() {
      remainingSeconds = totalSeconds;
      isRunning = false;
      isPaused = false;
    });
  }

  // 💾 SAVE TO SUPABASE
  Future<void> saveProgress() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await Supabase.instance.client.from('daily_progress').insert({
      'user_id': user.id,
      'calories': widget.workout.calories,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Workout Completed 🎉")));
  }

  String formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  double progress() => 1 - (remainingSeconds / totalSeconds);

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFF1E2328);
    const Color yellow = Color(0xFFF5C518);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(widget.workout.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// ⏱ TIMER CIRCLE
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 220,
                  width: 220,
                  child: CircularProgressIndicator(
                    value: progress(),
                    strokeWidth: 12,
                    backgroundColor: Colors.white12,
                    color: yellow,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      formatTime(remainingSeconds),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${(progress() * 100).toInt()}% Complete",
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// INFO CARDS
            Row(
              children: [
                _info("Duration", "${widget.workout.duration} min"),
                _info("Level", widget.workout.level),
                _info("Calories", "${widget.workout.calories} kcal"),
              ],
            ),

            const SizedBox(height: 30),

            /// ▶ START / ⏸ PAUSE / ▶ RESUME BUTTON
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: startOrPauseTimer,
                      child: Text(
                        isRunning
                            ? "PAUSE"
                            : isPaused
                            ? "RESUME"
                            : "START",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                /// RESET BUTTON
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: resetTimer,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// 💡 TIPS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2F35),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "💪 Tips",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• Keep your form correct",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "• Breathe steadily throughout",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "• Take breaks if needed",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "• Stay hydrated",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F35),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}