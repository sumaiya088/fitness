import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../daily challenge/workout_detail_page.dart';
import '../services/workout_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WorkoutService service = WorkoutService();
  String userGoal = "Keep Fit";

  @override
  void initState() {
    super.initState();
    _loadUserGoal();
  }

  Future<void> _loadUserGoal() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('user_profile')
        .select('goal')
        .eq('id', user.id)
        .maybeSingle();

    if (mounted && data != null) {
      setState(() {
        userGoal = data['goal'] ?? "Keep Fit";
      });
    }
  }

  // 🔥 ONLY THIS IS GOAL BASED
  List<Map<String, String>> goalExercises() {
    if (userGoal == "Lose Weight") {
      return [
        {"title": "Jumping Jacks", "img": "assets/images/jumping.jpg"},
        {"title": "Burpees", "img": "assets/images/burpees.png"},
      ];
    }

    if (userGoal == "Build Muscles") {
      return [
        {"title": "Bicep Curl", "img": "assets/images/bicep curl.png"},
        {"title": "Shoulder Press", "img": "assets/images/shoulder press.jpg"},
      ];
    }

    // Keep Fit
    return [
      {"title": "Yoga Stretch", "img": "assets/images/yoga stretch.jpg"},
      {"title": "Mobility FLow", "img": "assets/images/mobility flow.jpg"},
    ];
  }

  Future<void> openWorkout(BuildContext context, String title) async {
    try {
      final workout = await service.getWorkoutByTitle(title);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WorkoutDetailPage(workout: workout),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workout not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFF1E2328);
    const Color yellow = Color(0xFFF5C518);
    const Color cardDark = Color(0xFF2A2F35);

    final exercises = goalExercises();

    return Scaffold(
      backgroundColor: bg,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: yellow,
        currentIndex: 0,
       
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ===== GREETING =====
              const Text(
                "Hello!\nGood Morning 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 24),

              // ===== DAILY CHALLENGES (UNCHANGED) =====
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: yellow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Daily\nChallenges",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Image.asset("assets/images/daily.png", height: 90),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Take the challenges",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Icon(Icons.timer, size: 16),
                          SizedBox(width: 4),
                          Text("20 min", style: TextStyle(fontSize: 12)),
                          SizedBox(width: 12),
                          Icon(Icons.play_circle_fill),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ===== CHALLENGES (UNCHANGED) =====
              const Text(
                "Challenges",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  _challengeImage(
                    "Squats",
                    "assets/images/Squat.jpg",
                    () => openWorkout(context, "Squats"),
                  ),
                  const SizedBox(width: 12),
                  _challengeImage(
                    "Push Up",
                    "assets/images/push up.jpg",
                    () => openWorkout(context, "Push Up"),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _challengeTile(
                cardDark,
                "Plank",
                "15 min",
                "1 exercise",
                () => openWorkout(context, "Plank"),
              ),
              const SizedBox(height: 10),
              _challengeTile(
                cardDark,
                "Lunges",
                "20 min",
                "1 exercise",
                () => openWorkout(context, "Lunges"),
              ),

              const SizedBox(height: 30),

              // 🔥 CATEGORY REPLACED (ONLY THIS PART)
              Text(
                "$userGoal Exercises",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: exercises.map((e) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => openWorkout(context, e["title"]!),
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.only(right: 10),
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                            image: AssetImage(e["img"]!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.3),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Text(
                          e["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _challengeImage(
    String title,
    String img,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: AssetImage(img),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _challengeTile(
    Color bg,
    String title,
    String time,
    String ex,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$time • $ex",
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
