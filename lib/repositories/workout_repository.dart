import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/workout_model.dart';
import '../services/user_service.dart';

class WorkoutRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final UserService _userService = UserService();

  // Mengambil jadwal milik pengguna
  Future<List<WorkoutModel>> getWorkouts() async {
    final userId = await _userService.getUserId();

    final response = await _supabase
        .from('workout_schedules')
        .select()
        .eq('user_id', userId)
        .order('workout_date');

    return response
        .map((json) => WorkoutModel.fromJson(json))
        .toList();
  }

  // Menambahkan jadwal latihan
  Future<void> addWorkout(WorkoutModel workout) async {
    final userId = await _userService.getUserId();

    final data = workout.toJson();
    data['user_id'] = userId;

    await _supabase
        .from('workout_schedules')
        .insert(data);
  }

  // Mengubah jadwal latihan
  Future<void> updateWorkout(WorkoutModel workout) async {
    final userId = await _userService.getUserId();

    final data = workout.toJson();
    data.remove('id');
    data['user_id'] = userId;

    await _supabase
        .from('workout_schedules')
        .update(data)
        .eq('id', workout.id)
        .eq('user_id', userId);
  }

  // Menghapus jadwal latihan
  Future<void> deleteWorkout(String id) async {
    final userId = await _userService.getUserId();

    await _supabase
        .from('workout_schedules')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }
}