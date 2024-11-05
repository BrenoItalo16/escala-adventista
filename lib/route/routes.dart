import 'package:escala_adventista/app/ui/pages/onboarding/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashPage(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.title),
        ),
      ),
    ),
  ],
);
