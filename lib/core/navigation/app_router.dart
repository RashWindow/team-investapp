// lib/core/navigation/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:stocksapp/presentation/pages/auth/auth_screen.dart';
import 'package:stocksapp/presentation/pages/auth/onboarding_screen.dart';
import 'package:stocksapp/presentation/pages/home/home_screen.dart';
import 'package:stocksapp/presentation/pages/auth/splash_screen.dart';

class AppRouter {
  late final GoRouter config = GoRouter(
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    initialLocation: '/splash',
  );
}
