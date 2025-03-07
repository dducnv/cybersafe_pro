import 'package:cybersafe_pro/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/app_locale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppLocale(),
      child: Consumer<AppLocale>(
        builder: (context, appLocale, child) {
          return MaterialApp(
            title: 'CyberSafe Pro',
            debugShowCheckedModeBanner: false,
            locale: appLocale.locale,
            supportedLocales: const [
              Locale('vi', 'VN'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

// Ví dụ về cách sử dụng trong một widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocale.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.homeLocale.getText('dashboard')),
        actions: [
          // Nút chuyển đổi ngôn ngữ
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final isVietnamese = locale.locale.languageCode == 'vi';
              locale.setLocale(
                isVietnamese 
                  ? const Locale('en', 'US')
                  : const Locale('vi', 'VN')
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: HomeScreen()
    );
  }
}