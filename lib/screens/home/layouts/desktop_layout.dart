import 'package:flutter/material.dart';
import '../components/home_app_bar.dart';
import '../components/home_navigation.dart';

class HomeDesktopLayout extends StatelessWidget {
  const HomeDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar cố định bên trái
          const SizedBox(
            width: 250,
            child: HomeNavigation(isExtended: true),
          ),
          // Content chính
          Expanded(
            child: Column(
              children: [
                const HomeAppBarCustom(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main content area
                        const Expanded(
                          flex: 3,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dashboard',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  // Add your dashboard content here
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Sidebar bên phải
                        SizedBox(
                          width: 300,
                          child: Card(
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(16.0),
                              children: const [
                                Text(
                                  'Quick Actions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                // Add your quick actions here
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 