class DailyProgress {
  final int steps;
  final int waterMl;
  final int calories;
  final String createdAt;

  DailyProgress({
    required this.steps,
    required this.waterMl,
    required this.calories,
    required this.createdAt,
  });

  factory DailyProgress.fromMap(Map<String, dynamic> map) {
    return DailyProgress(
      steps: map['steps'] ?? 0,
      waterMl: map['water_ml'] ?? 0,
      calories: map['calories'] ?? 0,
      createdAt: map['created_at'] ?? '',
    );
  }
}

