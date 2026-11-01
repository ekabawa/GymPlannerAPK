import 'package:flutter/foundation.dart';

import '../models/workout_model.dart';
import '../repositories/workout_repository.dart';

class WorkoutProvider extends ChangeNotifier {
  final WorkoutRepository _repository = WorkoutRepository();

  List<WorkoutModel> _workouts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<WorkoutModel> get workouts => _workouts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWorkouts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _workouts = await _repository.getWorkouts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    try {
      await _repository.addWorkout(workout);
      await fetchWorkouts();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    try {
      await _repository.updateWorkout(workout);
      await fetchWorkouts();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteWorkout(String id) async {
    try {
      await _repository.deleteWorkout(id);
      await fetchWorkouts();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}