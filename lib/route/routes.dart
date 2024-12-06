import 'package:escala_adventista/features/auth/presentation/pages/signup_page.dart';
import 'package:escala_adventista/features/church/presentation/pages/create_church_page.dart';
import 'package:escala_adventista/features/home/presentation/pages/home_page.dart';
import 'package:escala_adventista/features/splash/presentation/pages/splash_page.dart';
import 'package:escala_adventista/features/auth/presentation/pages/login_page.dart';
import 'package:escala_adventista/core/presentation/pages/error_404_page.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const Error404Page(),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.createChurch,
      name: 'create-church',
      builder: (context, state) => const CreateChurchPage(),
    ),
  ],
);
