class Workout {
  final String title;
  final int duration; // minutes
  final String level;
  final int calories;
  final String videoFile;

  Workout({
    required this.title,
    required this.duration,
    required this.level,
    required this.calories,
    required this.videoFile,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      title: json['title'],
      duration: (json['duration'] as num).toInt(),
      level: json['level'],
      calories: (json['calories'] as num).toInt(),
      videoFile: json['video_file'],
    );
  }
}
