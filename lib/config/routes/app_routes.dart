import 'package:aivi/screens/create_profile/create_profile_screen_1.dart';
import 'package:aivi/screens/dashboard/dashboard.dart';
import 'package:aivi/screens/onboarding_screen.dart';
import 'package:aivi/screens/user/edit_profile.dart';
import 'package:aivi/screens/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const Dashboard()),
    ),
    GoRoute(
      path: AppRoute.welcome,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const WelcomeScreen()),
    ),
    GoRoute(
      path: AppRoute.createProfileScreenOne,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const CreateProfileScreenOne()),
    ),
    GoRoute(
      path: AppRoute.editProfile,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const EditProfile()),
    ),  GoRoute(
      path: AppRoute.dashboard,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const Dashboard()),
    ),
  ],
);

class AppRoute {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String dashboard = '/dashboard';
  static const String editProfile = '/edit-profile';
  static const String createProfileScreenOne = '/create-profile-screen-one';
}
