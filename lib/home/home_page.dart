import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../daily challenge/workout_detail_page.dart';
import '../services/workout_service.dart';
import '../profile/profile_page.dart';

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

  // 🔥 Goal based exercises
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

    return [
      {"title": "Yoga Stretch", "img": "assets/images/yoga stretch.jpg"},
      {"title": "Mobility Flow", "img": "assets/images/mobility flow.jpg"},
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

      // ✅ BOTTOM NAV (HOME + PROFILE ONLY)
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bg,
        currentIndex: 0, // Home active
        selectedItemColor: yellow,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
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

              // ===== DAILY CHALLENGES =====
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
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ===== CHALLENGES =====
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

              // ✅ Plank tile with image
              _challengeTile(
                cardDark,
                "Plank",
                "5 min",
                "1 exercise",
                "assets/images/plank.jpg",
                () => openWorkout(context, "Plank"),
              ),
              const SizedBox(height: 10),

              // ✅ Lunges tile with image
              _challengeTile(
                cardDark,
                "Lunges",
                "20 min",
                "1 exercise",
                "assets/images/lunges.jpg",
                () => openWorkout(context, "Lunges"),
              ),

              const SizedBox(height: 30),

              // ===== GOAL BASED =====
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

  // ✅ UPDATED: tile now supports image background
  static Widget _challengeTile(
    Color bg,
    String title,
    String time,
    String ex,
    String img,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(img),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$time • $ex",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
