import 'package:escala_adventista/features/auth/presentation/pages/signup_page.dart';
import 'package:escala_adventista/features/home/presentation/pages/home_page.dart';
import 'package:escala_adventista/features/splash/presentation/pages/splash_page.dart';
import 'package:escala_adventista/features/auth/presentation/pages/login_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
