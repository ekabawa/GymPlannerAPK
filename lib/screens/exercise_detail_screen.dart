import 'package:flutter/material.dart';

import '../models/exercise_model.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  static const Color navy = Color(0xFF111827);
  static const Color cardColor = Color(0xFF1F2937);
  static const Color blue = Color(0xFF2563EB);
  static const Color mutedColor = Color(0xFF9CA3AF);

  String get category {
    if (exercise.primaryMuscles.isNotEmpty) {
      return exercise.primaryMuscles.join(', ');
    }

    return exercise.equipment ?? 'Workout';
  }

  String get imageUrl {
    if (exercise.images.isEmpty) {
      return '';
    }

    return 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/${exercise.images.first}';
  }

  String get equipment {
    return exercise.equipment ?? 'Not specified';
  }

  String get level {
    return exercise.level ?? 'Not specified';
  }

  String get mechanic {
    return exercise.mechanic ?? 'Not specified';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        title: const Text(
          'Exercise Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExerciseImage(),
              const SizedBox(height: 24),
              _buildExerciseHeader(),
              const SizedBox(height: 24),
              _buildWorkoutInfo(),
              const SizedBox(height: 28),
              _buildSectionTitle('About Exercise'),
              const SizedBox(height: 12),
              _buildDescription(),
              const SizedBox(height: 28),
              _buildSectionTitle('How to Perform'),
              const SizedBox(height: 16),
              _buildSteps(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseImage() {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder();
              },
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.fitness_center,
        color: Colors.white,
        size: 60,
      ),
    );
  }

  Widget _buildExerciseHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: blue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            category,
            style: const TextStyle(
              color: Color(0xFF60A5FA),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Icons.signal_cellular_alt,
            title: 'Level',
            value: level,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.fitness_center,
            title: 'Equipment',
            value: equipment,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.sync_alt,
            title: 'Mechanic',
            value: mechanic,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF60A5FA),
            size: 26,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mutedColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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

  Widget _buildDescription() {
    final primaryMuscles = exercise.primaryMuscles.isNotEmpty
        ? exercise.primaryMuscles.join(', ')
        : 'Not specified';

    final secondaryMuscles = exercise.secondaryMuscles.isNotEmpty
        ? exercise.secondaryMuscles.join(', ')
        : 'Not specified';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDescriptionItem(
            'Primary Muscles',
            primaryMuscles,
          ),
          const SizedBox(height: 14),
          _buildDescriptionItem(
            'Secondary Muscles',
            secondaryMuscles,
          ),
          const SizedBox(height: 14),
          _buildDescriptionItem(
            'Equipment',
            equipment,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionItem(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF60A5FA),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: mutedColor,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSteps() {
    final steps = exercise.instructions;

    if (steps.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Instructions are not available.',
          style: TextStyle(
            color: mutedColor,
            fontSize: 14,
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        steps.length,
        (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: blue.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFF60A5FA),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    steps[index],
                    style: const TextStyle(
                      color: mutedColor,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}