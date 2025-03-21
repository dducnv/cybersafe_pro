import 'package:cybersafe_pro/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class HomeAppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  final bool isDesktop;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  final Size preferredSize;

  const HomeAppBarCustom({
    super.key,
    this.isDesktop = false,
    this.scaffoldKey,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<HomeAppBarCustom> createState() => _HomeAppBarCustomState();
}

class _HomeAppBarCustomState extends State<HomeAppBarCustom> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle:true,
      leading: widget.scaffoldKey != null ? IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          widget.scaffoldKey?.currentState?.openDrawer();
        },
      ) : null,
      title: const Text(
        "CyberSafe PRO",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.surface,
        statusBarIconBrightness: Theme.of(context).brightness,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      scrolledUnderElevation: 0,
      actions: [
        // Theme toggle button
        // IconButton(
        //   icon: Icon(
        //     isDark ? Icons.light_mode : Icons.dark_mode,
        //     color: Theme.of(context).colorScheme.primary,
        //   ),
        //   onPressed: () => themeProvider.toggleTheme(),
        // ),
    
        Visibility(
          visible: !widget.isDesktop,
          child: IconButton(
            icon: const Icon(Icons.settings_rounded, size: 24),
            onPressed: () {
              AppRoutes.navigateTo(context, AppRoutes.settings);
            },
          ),
        ),
      ],
    );
  }
}
