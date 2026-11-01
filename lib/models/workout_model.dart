class WorkoutModel {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final DateTime workoutDate;
  final int sets;
  final int reps;
  final String? notes;
  final bool isCompleted;
  final DateTime? createdAt;

  const WorkoutModel({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.workoutDate,
    required this.sets,
    required this.reps,
    this.notes,
    this.isCompleted = false,
    this.createdAt,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id']?.toString() ?? '',
      exerciseId: json['exercise_id'] ?? '',
      exerciseName: json['exercise_name'] ?? '',
      workoutDate: DateTime.parse(json['workout_date']),
      sets: json['sets'] ?? 0,
      reps: json['reps'] ?? 0,
      notes: json['notes'],
      isCompleted: json['is_completed'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'workout_date': workoutDate.toIso8601String().split('T').first,
      'sets': sets,
      'reps': reps,
      'notes': notes,
      'is_completed': isCompleted,
    };
  }
}
