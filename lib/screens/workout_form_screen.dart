import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/exercise_model.dart';
import '../models/workout_model.dart';
import '../providers/workout_provider.dart';
import '../services/exercise_service.dart';
import '../services/user_service.dart';

class WorkoutFormScreen extends StatefulWidget {
  final WorkoutModel? workout;

  const WorkoutFormScreen({
    super.key,
    this.workout,
  });

  @override
  State<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  static const Color navy = Color(0xFF111827);
  static const Color blue = Color(0xFF2563EB);
  static const Color cardColor = Color(0xFF1F2937);
  static const Color mutedColor = Color(0xFF9CA3AF);

  final ExerciseService _exerciseService = ExerciseService();
  final UserService _userService = UserService();

  final _formKey = GlobalKey<FormState>();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _notesController = TextEditingController();

  List<ExerciseModel> _exercises = [];
  ExerciseModel? _selectedExercise;
  DateTime _selectedDate = DateTime.now();

  bool _isLoadingExercises = true;
  bool _isSaving = false;
  String? _exerciseError;

  bool get _isEditing => widget.workout != null;

  @override
  void initState() {
    super.initState();

    final workout = widget.workout;

    if (workout != null) {
      _setsController.text = workout.sets.toString();
      _repsController.text = workout.reps.toString();
      _notesController.text = workout.notes ?? '';
      _selectedDate = workout.workoutDate;
    }

    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final exercises = await _exerciseService.fetchExercises();

      if (!mounted) return;

      final seenIds = <String>{};
      final uniqueExercises = <ExerciseModel>[];
      for (final exercise in exercises) {
        if (seenIds.add(exercise.id)) {
          uniqueExercises.add(exercise);
        }
      }

      setState(() {
        _exercises = uniqueExercises;

        if (_isEditing) {
          final workout = widget.workout!;

          _selectedExercise = _exercises.where(
            (exercise) => exercise.id == workout.exerciseId,
          ).firstOrNull ?? _exercises.where(
            (exercise) =>
                exercise.name.toLowerCase() ==
                workout.exerciseName.toLowerCase(),
          ).firstOrNull;

          if (_selectedExercise == null && workout.exerciseName.isNotEmpty) {
            _selectedExercise = ExerciseModel(
              id: workout.exerciseId.isNotEmpty
                  ? workout.exerciseId
                  : workout.exerciseName,
              name: workout.exerciseName,
              primaryMuscles: const [],
              secondaryMuscles: const [],
              instructions: const [],
              images: const [],
            );
            _exercises.insert(0, _selectedExercise!);
          }
        }

        _isLoadingExercises = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        if (_isEditing && widget.workout != null) {
          final workout = widget.workout!;
          _selectedExercise = ExerciseModel(
            id: workout.exerciseId.isNotEmpty
                ? workout.exerciseId
                : workout.exerciseName,
            name: workout.exerciseName,
            primaryMuscles: const [],
            secondaryMuscles: const [],
            instructions: const [],
            images: const [],
          );
          _exercises = [_selectedExercise!];
          _isLoadingExercises = false;
        } else {
          _exerciseError = e.toString();
          _isLoadingExercises = false;
        }
      });
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: blue,
              surface: cardColor,
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedExercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih latihan terlebih dahulu.'),
        ),
      );
      return;
    }

    final provider = context.read<WorkoutProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      _isSaving = true;
    });

    try {
      final userId = await _userService.getUserId();

      final workout = WorkoutModel(
        id: widget.workout?.id ?? const Uuid().v4(),
        userId: userId,
        exerciseId: _selectedExercise!.id,
        exerciseName: _selectedExercise!.name,
        workoutDate: _selectedDate,
        sets: int.parse(_setsController.text.trim()),
        reps: int.parse(_repsController.text.trim()),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        isCompleted: widget.workout?.isCompleted ?? false,
        createdAt: widget.workout?.createdAt,
      );

      if (_isEditing) {
        await provider.updateWorkout(workout);
      } else {
        await provider.addWorkout(workout);
      }

      if (!mounted) return;

      if (provider.errorMessage != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Workout Schedule Updated Successfully.'
                : 'Workout Schedule Added Successfully.',
          ),
          backgroundColor: blue,
        ),
      );

      navigator.pop();
    } catch (e) {
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          content: Text('ailed to Save Workout Schedule: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        title: Text(
          _isEditing ? 'Edit Workout Schedule' : 'Add Workout Schedule',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoadingExercises
            ? const Center(
                child: CircularProgressIndicator(color: blue),
              )
            : _exerciseError != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal memuat Exercise Library.',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoadingExercises = true;
                                _exerciseError = null;
                              });
                              _loadExercises();
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Plan Your Workout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '“Fill in the details of your workout session',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 28),

                          _buildLabel('Exercise'),
                          DropdownButtonFormField<ExerciseModel>(
                            key: ValueKey(_selectedExercise?.id),
                            initialValue: _exercises.contains(_selectedExercise)
                                ? _selectedExercise
                                : null,
                            isExpanded: true,
                            dropdownColor: cardColor,
                            decoration: _inputDecoration(
                              hint: 'Select an Exercise',
                            ),
                            items: _exercises.map((exercise) {
                              return DropdownMenuItem<ExerciseModel>(
                                value: exercise,
                                child: Text(
                                  exercise.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (exercise) {
                              setState(() {
                                _selectedExercise = exercise;
                              });
                            },
                            validator: (value) {
                              if (value == null && _selectedExercise == null) {
                                return 'Pilih latihan terlebih dahulu.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('Workout Date'),
                          InkWell(
                            onTap: _selectDate,
                            child: InputDecorator(
                              decoration: _inputDecoration(
                                hint: 'Select Workout Date',
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: Color(0xFF60A5FA),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${_selectedDate.day.toString().padLeft(2, '0')}/'
                                    '${_selectedDate.month.toString().padLeft(2, '0')}/'
                                    '${_selectedDate.year}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('Sets'),
                          TextFormField(
                            controller: _setsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: 'Number',
                            ),
                            validator: (value) {
                              final number = int.tryParse(value ?? '');

                              if (number == null || number <= 0) {
                                return 'Sets harus lebih dari 0.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('Reps'),
                          TextFormField(
                            controller: _repsController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: 'Number',
                            ),
                            validator: (value) {
                              final number = int.tryParse(value ?? '');

                              if (number == null || number <= 0) {
                                return 'Reps harus lebih dari 0.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildLabel('Notes (Optional)'),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 3,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              hint: 'Add a Note',
                            ),
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isSaving ? null : _saveWorkout,
                              icon: _isSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.save),
                              label: Text(
                                _isSaving
                                    ? 'Saving...'
                                    : _isEditing
                                        ? 'Update Workout schedule'
                                        : 'Save Workout schedule',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: mutedColor),
      filled: true,
      fillColor: cardColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: blue),
      ),
    );
  }
}
