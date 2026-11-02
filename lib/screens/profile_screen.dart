import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color backgroundColor = Color(0xFF131326);
  static const Color cardColor = Color(0xFF1D2B39);
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color successColor = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Foto Profil
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: cardColor,
                child: Icon(
                  Icons.person,
                  size: 65,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Nama Pengguna
            const Text(
              'I Putu Eka Bawa Utama',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

              const Text(
              '2415051008',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 40),

            // Statistik Workout dari Provider
            Consumer<WorkoutProvider>(
              builder: (context, provider, child) {
                final totalWorkout = provider.workouts.length;

                final completedWorkout = provider.workouts
                    .where((workout) => workout.isCompleted)
                    .length;

                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.fitness_center,
                        value: provider.isLoading
                            ? '...'
                            : '$totalWorkout',
                        label: 'Workout',
                        iconColor: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.check_circle,
                        value: provider.isLoading
                            ? '...'
                            : '$completedWorkout',
                        label: 'Completed',
                        iconColor: successColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2D3A48),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30,
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
