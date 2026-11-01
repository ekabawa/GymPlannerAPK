import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl =
      'https://ipbfewlkyfwfwvnvrsat.supabase.co';

  static const String supabaseKey =
      'sb_publishable_3BieQYAnENfebu2rNDTnzA_3_nbLrYx';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseKey,
    );
  }
}