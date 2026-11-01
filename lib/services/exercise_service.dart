import 'dart:convert';
import 'package:http/http.dart' as http;


import '../models/exercise_model.dart';

class ExerciseService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json';

  Future<List<ExerciseModel>> fetchExercises() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => ExerciseModel.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Gagal mengambil data latihan: ${response.statusCode}',
      );
    }
  }
}
