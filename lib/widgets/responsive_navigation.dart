import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/exercise_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';

class ResponsiveNavigation extends StatefulWidget {
  const ResponsiveNavigation({super.key});

  @override
  State<ResponsiveNavigation> createState() =>
      _ResponsiveNavigationState();
}

class _ResponsiveNavigationState extends State<ResponsiveNavigation> {
  int _selectedIndex = 0;

  static const double expandedBreakpoint = 840;

  final List<Widget> _screens = const [
    HomeScreen(),
    ScheduleScreen(),
    ExerciseScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month),
      label: 'Schedule',
    ),
    NavigationDestination(
      icon: Icon(Icons.fitness_center_outlined),
      selectedIcon: Icon(Icons.fitness_center),
      label: 'Exercises',
    ),
    NavigationDestination(
      icon: Icon(Icons.history_outlined),
      selectedIcon: Icon(Icons.history),
      label: 'History',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        final isExpanded =
            screenWidth >= expandedBreakpoint;

        return Scaffold(
          body: Row(
            children: [
              if (isExpanded)
                NavigationDrawer(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 16, 16),
                      child: Text(
                        'GYMPLANNER',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ..._destinations.map(
                      (destination) => NavigationDrawerDestination(
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                        label: Text(destination.label),
                      ),
                    ),
                  ],
                ),

              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _screens,
                ),
              ),
            ],
          ),

          bottomNavigationBar: isExpanded
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  destinations: _destinations,
                ),
        );
      },
    );
  }
}