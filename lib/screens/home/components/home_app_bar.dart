import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AppBar(
      elevation: 0,
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
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        IconButton(
          icon: Icon(
            Icons.update_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          onPressed: () {},
        ),
        Visibility(
          visible: !widget.isDesktop,
          child: IconButton(
            icon: const Icon(Icons.search_rounded, size: 24),
            onPressed: () {},
          ),
        ),
        Visibility(
          visible: !widget.isDesktop,
          child: IconButton(
            icon: const Icon(Icons.settings_rounded, size: 24),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
