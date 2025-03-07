import 'package:flutter/material.dart';

class HomeNavigation extends StatelessWidget {
  final bool isExtended;

  const HomeNavigation({
    super.key,
    this.isExtended = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: isExtended,
      selectedIndex: 0,
      onDestinationSelected: (index) {
        // Handle navigation
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.security),
          label: Text('Security'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.password),
          label: Text('Passwords'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
} 