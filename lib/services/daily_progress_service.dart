import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../models/daily_progress.dart';

class ProgressService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<DailyProgress?> getProgressForDate(
    String userId,
    DateTime date,
  ) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final data = await _client
        .from('daily_progress')
        .select('steps, water_ml, calories, created_at')
        .eq('user_id', userId)
        .eq('created_at', formattedDate)
        .maybeSingle();

    if (data == null) return null;
    return DailyProgress.fromMap(data);
  }
}
