import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/test_screen.dart';
import 'screens/result_screen.dart';
import 'screens/personality_detail_screen.dart';

/// Entry point of the app.
void main() {
  runApp(const MyApp());
}

/// The root widget of the application.
/// Demonstrates MaterialApp setup, theming, and navigation using named routes.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MBTI Test',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Force RTL text direction for the entire app (Persian)
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      // ── Theme ──
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColor,
        fontFamily: 'Vazirmatn',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColor,
        fontFamily: 'Vazirmatn',
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,

      // ── Navigation: Named Routes ──
      // This is the simplest way to navigate between screens in Flutter.
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/test': (context) => const TestScreen(),
        // For result and detail screens, we need to pass arguments,
        // so we handle them in onGenerateRoute below.
      },
      onGenerateRoute: (settings) {
        // Result screen: receives personality type code as argument
        if (settings.name == '/result') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ResultScreen(
              typeCode: args['typeCode'],
              confidence: args['confidence'],
            ),
          );
        }
        // Personality detail screen: receives type code as argument
        if (settings.name == '/personality') {
          final typeCode = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => PersonalityDetailScreen(typeCode: typeCode),
          );
        }
        return null;
      },
    );
  }
}