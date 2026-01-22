import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StepPage extends StatefulWidget {
  const StepPage({super.key});

  @override
  State<StepPage> createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
  // ===== GUIDELINE (like water target) =====
  static const int dailyGoal = 1000;

  final SupabaseClient _client = Supabase.instance.client;

  late String userId;
  late String today;

  int steps = 0;
  int calories = 0;

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    userId = _client.auth.currentUser!.id;
    today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    _ensureTodayRow().then((_) => _loadTodaySteps());
  }

  // ================= SUPABASE =================

  Future<void> _ensureTodayRow() async {
    final data = await _client
        .from('daily_progress')
        .select()
        .eq('user_id', userId)
        .eq('created_at', today)
        .maybeSingle();

    if (data == null) {
      await _client.from('daily_progress').insert({
        'user_id': userId,
        'steps': 0,
        'water_ml': 0,
        'calories': 0,
        'created_at': today,
      });
    }
  }

  Future<void> _loadTodaySteps() async {
    final data = await _client
        .from('daily_progress')
        .select('steps, calories')
        .eq('user_id', userId)
        .eq('created_at', today)
        .maybeSingle();

    if (data != null) {
      setState(() {
        steps = data['steps'] ?? 0;
        calories = data['calories'] ?? 0;
      });
    }
  }

  // ================= LOGIC =================

  double get progress => (steps / dailyGoal).clamp(0, 1);
  double get distanceKm => steps * 0.00075;
  int get activeMin => (steps / 100).round();
  int get bpm => steps < 400 ? 95 : steps < 1000 ? 120 : 140;

  String get taskMessage {
    if (progress < 0.4) return "Let's Get Started!";
    if (progress < 1) return "Almost Done!";
    return "Goal Achieved 🎉";
  }

  String get activityLevel {
    if (progress < 0.4) return "Low Active";
    if (progress < 1) return "Moderately Active";
    return "Highly Active";
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23282C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // HEADER
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFFF5B233),
                      child: Icon(Icons.arrow_back,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Step Details",
                    style: TextStyle(
                      color: Color(0xFFF5B233),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text("Your Daily Tasks",
                  style:
                      const TextStyle(color: Colors.white70)),
              Text(taskMessage,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),

              const SizedBox(height: 24),

              // CIRCLE
              SizedBox(
                height: 220,
                width: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 18,
                      backgroundColor:
                          const Color(0xFF3A3F44),
                      valueColor:
                          const AlwaysStoppedAnimation(
                        Color(0xFFF5B233),
                      ),
                    ),
                    Column(
                      children: [
                        Text("$steps",
                            style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF5B233))),
                        const Text("steps",
                            style: TextStyle(
                                color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CARDS
              Row(
                children: [
                  _yellowCard(
                      "Cal Burned", "$calories", "cal"),
                  const SizedBox(width: 12),
                  _yellowCard(
                      "Today's Goal", "$dailyGoal", "steps"),
                ],
              ),

              const SizedBox(height: 18),

              // STATS
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _statBox(const Color(0xFF7E3FF2),
                      distanceKm.toStringAsFixed(2), "km"),
                  _statBox(const Color(0xFFF26CF6),
                      "$activeMin", "min"),
                  _statBox(const Color(0xFFD83A56),
                      "$bpm", "bpm"),
                ],
              ),

              const SizedBox(height: 18),

              // ACTIVITY LEVEL
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text("Activity Level",
                              style: TextStyle(
                                  color: Colors.black54)),
                          Text(activityLevel,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold)),
                        ],
                      ),
                    ),
                    Image.asset("assets/images/run.png",
                        width: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _yellowCard(String title, String value, String unit) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5B233),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text("$value $unit",
                style: const TextStyle(
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _statBox(Color color, String value, String unit) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(unit,
              style:
                  const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
