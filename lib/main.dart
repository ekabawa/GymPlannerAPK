import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/responsive_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GYMPLANNER',
      theme: AppTheme.darkTheme,
      home: const ResponsiveNavigation(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GYMPLANNER'),
      ),
      body: const Center(
        child: Text(
          'Welcome to GYMPLANNER',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}