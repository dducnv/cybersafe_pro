import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('CyberSafe Pro'),
      actions: [
        // Notification button
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notifications
          },
        ),
        // Profile button
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            // Handle profile
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 