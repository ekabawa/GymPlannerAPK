import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../models/workout_model.dart';


class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const HomeScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color navy = Color(0xFF111827);
  static const Color blue = Color(0xFF2563EB);
  static const Color cardColor = Color(0xFF1F2937);
  static const Color mutedColor = Color(0xFF9CA3AF);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WorkoutProvider>().fetchWorkouts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<WorkoutProvider>().fetchWorkouts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('Overview'),
                const SizedBox(height: 12),
                _buildOverview(),
                const SizedBox(height: 28),
                _buildSectionTitle("Workout Today"),
                const SizedBox(height: 12),
                _buildTodayWorkout(),
                const SizedBox(height: 28),
                _buildSectionTitle('Quick access'),
                const SizedBox(height: 12),
                _buildQuickAccess(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              'assets/images/Logo.png',
              width: 35,
              height: 35,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/Logo.png.png',
                width: 35,
                height: 35,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GYMPLANNER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'Your personal workout planner',
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => widget.onNavigate(4),
          child: const CircleAvatar(
            backgroundColor: cardColor,
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageWidth = constraints.maxWidth * 0.62;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.45, 0.35),
              radius: 1.15,
              colors: [
                blue.withValues(alpha: 0.22),
                blue.withValues(alpha: 0.09),
                Colors.transparent,
              ],
              stops: const [0.0, 0.58, 1.0],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.9, 0.2),
                      radius: 0.85,
                      colors: [
                        blue.withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -12,
                top: -12,
                bottom: -12,
                width: imageWidth,
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) {
                    return const RadialGradient(
                      center: Alignment(0.58, 0.48),
                      radius: 0.78,
                      colors: [
                        Colors.black,
                        Colors.black,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.62, 1.0],
                    ).createShader(bounds);
                  },
                  child: Image.asset(
                    'assets/images/athlete_dumbbell.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 62,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const Text(
                            'Build Your\nStrength, Achieve\nYour Goals',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              height: 1.22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Plan your training sessions and stay consistent',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(
                                Icons.bolt,
                                color: Color(0xFF60A5FA),
                                size: 18,
                              ),
                              SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  'Stay Strong and Stay Consistent',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 38,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOverview() {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final schedules = provider.workouts;
        final completed = schedules
            .where((workout) => workout.isCompleted)
            .length;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.calendar_month,
                  title: 'Schedule',
                  value: provider.isLoading ? '...' : '${schedules.length}',
                  description: 'Saved workout plans',
                  color: blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  title: 'Completed',
                  value: provider.isLoading ? '...' : '$completed',
                  description: 'Finished workouts',
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: mutedColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayWorkout() {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.errorMessage != null) {
          return _buildMessageCard(
            icon: Icons.error_outline,
            message: 'Failed to load workout data.',
            onRetry: () => provider.fetchWorkouts(),
          );
        }

        final now = DateTime.now().toLocal();

        final todayWorkouts = provider.workouts.where((workout) {
          final workoutDate = workout.workoutDate.toLocal();
          return workoutDate.year == now.year &&
              workoutDate.month == now.month &&
              workoutDate.day == now.day;
        }).toList();

        if (todayWorkouts.isEmpty) {
          return _buildMessageCard(
            icon: Icons.calendar_today,
            message: 'No workout scheduled for today.',
          );
        }

        return Column(
          children: todayWorkouts
              .map((workout) => _buildTodayWorkoutCard(workout))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageCard({
    required IconData icon,
    required String message,
    VoidCallback? onRetry,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: const Color(0xFF60A5FA)),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mutedColor,
              fontSize: 12,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Try Again'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF60A5FA),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTodayWorkoutCard(WorkoutModel workout) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.fitness_center,
            color: Color(0xFF60A5FA),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.exerciseName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${workout.sets} Sets × ${workout.reps} Reps',
                  style: const TextStyle(
                    color: mutedColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            workout.isCompleted
                ? Icons.check_circle
                : Icons.schedule,
            color: workout.isCompleted
                ? const Color(0xFF10B981)
                : const Color(0xFF60A5FA),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    return Row(
      children: [
        Expanded(
          child: _buildAccessCard(
            icon: Icons.calendar_month,
            title: 'Schedule',
            subtitle: 'Manage your plans',
            onTap: () => widget.onNavigate(1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAccessCard(
            icon: Icons.fitness_center,
            title: 'Exercises',
            subtitle: 'Explore exercises',
            onTap: () => widget.onNavigate(2),
          ),
        ),
      ],
    );
  }

  Widget _buildAccessCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: blue, size: 26),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  color: mutedColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
