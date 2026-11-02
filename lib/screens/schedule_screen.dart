
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/workout_model.dart';
import '../providers/workout_provider.dart';
import 'workout_form_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  static const Color navy = Color(0xFF0D1B2A);
  static const Color blue = Color(0xFF1B263B);
  static const Color cardColor = Color(0xFF1B263B);
  static const Color mutedColor = Color(0xFF778DA9);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<WorkoutProvider>().fetchWorkouts();
    });
  }

  Future<void> _openWorkoutForm({WorkoutModel? workout}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutFormScreen(
          workout: workout,
        ),
      ),
    );
  }

  Future<void> _deleteWorkout(
    WorkoutProvider provider,
    WorkoutModel workout,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ScheduleScreen.cardColor,
        title: const Text(
          'Hapus Jadwal',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus jadwal latihan ini?',
          style: TextStyle(color: ScheduleScreen.mutedColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await provider.deleteWorkout(workout.id);
    }
  }
  
  Future<void> _toggleWorkoutStatus(
    WorkoutProvider provider,
    WorkoutModel workout,
  ) async {
    final updatedWorkout = WorkoutModel(
      id: workout.id,
      userId: workout.userId,
      exerciseId: workout.exerciseId,
      exerciseName: workout.exerciseName,
      workoutDate: workout.workoutDate,
      sets: workout.sets,
      reps: workout.reps,
      notes: workout.notes,
      isCompleted: !workout.isCompleted,
      createdAt: workout.createdAt,
    );

    await provider.updateWorkout(updatedWorkout);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ScheduleScreen.navy,
      appBar: AppBar(
        backgroundColor: ScheduleScreen.navy,
        elevation: 0,
        title: const Text(
          'Jadwal Latihan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 50,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchWorkouts(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverview(provider.workouts.length),
                const SizedBox(height: 24),
                const Text(
                  'Daftar Jadwal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: provider.workouts.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: provider.workouts.length,
                          itemBuilder: (context, index) {
                            final workout = provider.workouts[index];

                            return _buildWorkoutCard(
                              workout,
                              provider,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => _openWorkoutForm(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOverview(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ScheduleScreen.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Jadwal Latihan',
            style: TextStyle(
              color: ScheduleScreen.mutedColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$total',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.fitness_center,
            color: ScheduleScreen.mutedColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Jadwal Latihan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan jadwal latihan pertama Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ScheduleScreen.mutedColor,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _openWorkoutForm(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Jadwal'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(
    WorkoutModel workout,
    WorkoutProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ScheduleScreen.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: workout.isCompleted
            ? Border.all(
                color: Colors.greenAccent.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fitness_center,
                color: workout.isCompleted
                    ? Colors.greenAccent
                    : Colors.blueAccent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  workout.exerciseName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    decoration: workout.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: Colors.greenAccent,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                color: ScheduleScreen.cardColor,
                onSelected: (value) {
                  if (value == 'edit') {
                    _openWorkoutForm(workout: workout);
                  } else if (value == 'delete') {
                    _deleteWorkout(provider, workout);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Hapus',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tanggal: ${workout.workoutDate.day}/'
            '${workout.workoutDate.month}/'
            '${workout.workoutDate.year}',
            style: const TextStyle(
              color: ScheduleScreen.mutedColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sets: ${workout.sets} | Reps: ${workout.reps}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          if (workout.notes != null &&
              workout.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Catatan: ${workout.notes}',
              style: const TextStyle(
                color: ScheduleScreen.mutedColor,
              ),
            ),
          ],
          const Divider(
            color: Colors.white12,
            height: 20,
          ),
          Material(
            color: Colors.transparent,
            child: CheckboxListTile(
              value: workout.isCompleted,
              onChanged: (value) {
                _toggleWorkoutStatus(provider, workout);
              },
              activeColor: Colors.greenAccent,
              checkColor: ScheduleScreen.navy,
              title: Text(
                workout.isCompleted
                    ? 'Latihan Selesai'
                    : 'Tandai Latihan Selesai',
                style: TextStyle(
                  color: workout.isCompleted
                      ? Colors.greenAccent
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
        ],
      ),
    );
  }
}
