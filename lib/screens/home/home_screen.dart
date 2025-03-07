import 'package:flutter/material.dart';
import '../../utils/device_type.dart';
import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';
import 'layouts/desktop_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceType = DeviceInfo.getDeviceType(context);

    switch (deviceType) {
      case DeviceType.desktop:
        return const HomeDesktopLayout();
      case DeviceType.tablet:
        return const HomeTabletLayout();
      case DeviceType.mobile:
        return const HomeMobileLayout();
    }
  }
}

// Các view có thể được tách ra thành các file riêng trong thư mục views/
class MobileHomeView extends StatelessWidget {
  const MobileHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile View')),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // UI cho mobile
          ],
        ),
      ),
    );
  }
}

class TabletHomeView extends StatelessWidget {
  const TabletHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tablet View')),
      body: Row(
        children: [
          // Navigation rail cho tablet
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (index) {},
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // UI cho tablet
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DesktopHomeView extends StatelessWidget {
  const DesktopHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar cho desktop
          NavigationRail(
            extended: true,
            selectedIndex: 0,
            onDestinationSelected: (index) {},
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // UI cho desktop
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 