import 'package:aivi/screens/onboarding_screen.dart';
import 'package:aivi/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const OnBoardingScreen()),
    ),
    GoRoute(
      path: AppRoute.welcome,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const WelcomeScreen()),
    ),
  ],
);

class AppRoute {
  static const String splash = '/';
  static const String welcome = '/welcome';
}
