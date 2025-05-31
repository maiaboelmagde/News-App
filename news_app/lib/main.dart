// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/constants/preference_keys.dart';
import 'package:news_app/core/constants/routes.dart';
import 'package:news_app/core/service_locator.dart';
import 'package:news_app/core/theme/light.dart';
import 'package:news_app/features/home/models/news_article_model.dart';
import 'package:news_app/features/splash/splash_screen.dart';
import 'package:news_app/features/main/main_screen.dart';
import 'package:news_app/features/onboarding/onboarding_screen.dart';
import 'package:news_app/features/auth/sign_in_screen.dart';
import 'package:news_app/services/preferences_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  Hive.registerAdapter(NewsArticleAdapter());

  await Hive.openBox('bookmarks');
  await Hive.openBox('settings');

  setupLocator();

  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const SplashScreenWrapper(),
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.main: (_) => const MainScreen(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.signIn: (_) => const SignInScreen(),
      },
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  const SplashScreenWrapper({super.key});

  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = PreferencesManager();
    final onboardingComplete = prefs.getBool(PreferenceKeys.onboardingComplete) ?? false;
    final isLoggedIn = prefs.getBool(PreferenceKeys.isLoggedIn) ?? false;
    if (!mounted) return;
    if (!onboardingComplete) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    } else if (!isLoggedIn) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.signIn);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
