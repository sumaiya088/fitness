import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/workout.dart';

class WorkoutService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Workout> getWorkoutByTitle(String title) async {
    final data = await _client
        .from('workouts')
        .select()
        .eq('title', title)
        .single();

    return Workout.fromJson(data);
  }
}
