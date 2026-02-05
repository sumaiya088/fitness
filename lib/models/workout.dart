// This is a "Model" class.
// It is like a folder that stores all the info about a single workout.
class Workout {
  final String title; // Name of the workout (e.g., "Push Ups")
  final int duration; // How many minutes it takes
  final String level; // Difficulty (e.g., "Beginner")
  final int calories; // How many calories you burn
  final String videoFile; // The name of the video file to play

  // This part is the "Constructor"
  // It says: "To make a Workout, you MUST give me all these pieces of info."
  Workout({
    required this.title,
    required this.duration,
    required this.level,
    required this.calories,
    required this.videoFile,
  });

  // This is the "JSON Converter"
  // Viva Tip: "This part takes the data coming from the Database (Supabase)
  // and turns it into a Workout object that Flutter can understand."
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
