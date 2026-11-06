import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/workout_model.dart';
import '../providers/workout_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  static const Color navy = Color(0xFF0D1B2A);
  static const Color cardColor = Color(0xFF1B263B);
  static const Color mutedColor = Color(0xFF778DA9);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<WorkoutProvider>().fetchWorkouts();
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HistoryScreen.navy,
      appBar: AppBar(
        backgroundColor: HistoryScreen.navy,
        elevation: 0,
        title: const Text(
          'Workout History',
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

          final completedWorkouts = provider.workouts
              .where((workout) => workout.isCompleted)
              .toList();

          if (completedWorkouts.isEmpty) {
            return _buildEmptyState();
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverview(completedWorkouts.length),
                const SizedBox(height: 24),
                const Text(
                  'Workout History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: completedWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = completedWorkouts[index];

                      return _buildHistoryCard(workout);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverview(int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HistoryScreen.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Completed Workouts',
            style: TextStyle(
              color: HistoryScreen.mutedColor,
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

  Widget _buildHistoryCard(WorkoutModel workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HistoryScreen.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  workout.exerciseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                'Completed',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Date: ${_formatDate(workout.workoutDate)}',
            style: const TextStyle(
              color: HistoryScreen.mutedColor,
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
              'Notes: ${workout.notes}',
              style: const TextStyle(
                color: HistoryScreen.mutedColor,
              ),
            ),
          ],
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
            Icons.history,
            color: HistoryScreen.mutedColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Workout History Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Completed workouts will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: HistoryScreen.mutedColor,
            ),
          ),
        ],
      ),
    );
  }
}
