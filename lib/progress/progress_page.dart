import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/daily_progress_service.dart';
import '../models/daily_progress.dart';
import '/progress/water_tracker_page.dart';
import '/progress/step_counter.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  DateTime selectedDate = DateTime.now();
  late Future<DailyProgress?> progressFuture;
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Supabase.instance.client.auth.currentUser!.id;
    progressFuture =
        ProgressService().getProgressForDate(userId, selectedDate);
  }

  void _changeDate(DateTime date) {
    setState(() {
      selectedDate = date;
      progressFuture =
          ProgressService().getProgressForDate(userId, selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2A30),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Progress",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd MMM yyyy').format(selectedDate),
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month,
                        color: Colors.amber),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) _changeDate(picked);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              FutureBuilder<DailyProgress?>(
                future: progressFuture,
                builder: (context, snapshot) {
                  final data = snapshot.data;

                  final steps = data?.steps ?? 0;
                  final water = data?.waterMl ?? 0;
                  final calories = data?.calories ?? 0;

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    children: [

                      /// CALORIES
                      _progressCard(
                        title: "Calories",
                        value: calories.toString(),
                        unit: "Kcal",
                        color: const Color(0xFFDDEED8),
                      ),

                      /// STEPS (CLICKABLE)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StepPage(),
                            ),
                          );
                        },
                        child: _progressCard(
                          title: "Steps",
                          value: steps.toString(),
                          unit: "Steps",
                          color: const Color(0xFFF276F6),
                        ),
                      ),

                      /// WATER (CLICKABLE)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WaterPage(),
                            ),
                          );
                        },
                        child: _progressCard(
                          title: "Water",
                          value: water.toString(),
                          unit: "ml",
                          color: const Color(0xFF7B3FF2),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(unit),
        ],
      ),
    );
  }
}

