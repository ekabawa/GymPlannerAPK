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

          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;

          return RefreshIndicator(
            onRefresh: () => provider.fetchWorkouts(),
            color: Colors.blueAccent,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isLandscape ? 12 : 16,
                isLandscape ? 10 : 16,
                isLandscape ? 12 : 16,
                isLandscape ? 24 : 32,
              ),
              itemCount: completedWorkouts.isEmpty
                  ? 2
                  : completedWorkouts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverview(
                        completedWorkouts.length,
                        compact: isLandscape,
                      ),
                      SizedBox(height: isLandscape ? 12 : 24),
                      const Text(
                        'Workout History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isLandscape ? 8 : 16),
                    ],
                  );
                }

                if (completedWorkouts.isEmpty) {
                  return _buildEmptyState();
                }

                final workout = completedWorkouts[index - 1];
                return _buildHistoryCard(workout);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverview(
    int total, {
    bool compact = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 12 : 20),
      decoration: BoxDecoration(
        color: HistoryScreen.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: compact
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Completed Workouts',
                  style: TextStyle(
                    color: HistoryScreen.mutedColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Column(
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Icon(
            Icons.history,
            color: HistoryScreen.mutedColor,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No Workout History Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
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
