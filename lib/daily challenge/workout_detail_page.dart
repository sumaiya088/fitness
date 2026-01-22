import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/workout.dart';
import 'workout_timer_page.dart';

class WorkoutDetailPage extends StatefulWidget {
  final Workout workout;
  const WorkoutDetailPage({super.key, required this.workout});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late VideoPlayerController _controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();

    // ✅ FIXED VIDEO PATH
    _controller = VideoPlayerController.asset(
      'assets/videos/${widget.workout.videoFile}',
    )..initialize().then((_) {
        setState(() {
          isReady = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1E2328);
    const yellow = Color(0xFFF5C518);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(widget.workout.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🎥 VIDEO
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isReady
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),

            const SizedBox(height: 8),

            /// ▶ PLAY / PAUSE (ONLY VIDEO)
            Center(
              child: IconButton(
                iconSize: 42,
                icon: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Text(
              widget.workout.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// INFO
            Row(
              children: [
                _info("Duration", "${widget.workout.duration} min"),
                _info("Level", widget.workout.level),
                _info("Calories", "${widget.workout.calories} kcal"),
              ],
            ),

            const SizedBox(height: 30),

            /// 🟡 START WORKOUT → TIMER PAGE
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
                      builder: (_) =>
                          WorkoutTimerPage(workout: widget.workout),
                    ),
                  );
                },
                child: const Text(
                  "START WORKOUT",
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
    );
  }

  Widget _info(String t, String v) {
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
            Text(t, style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 6),
            Text(
              v,
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
