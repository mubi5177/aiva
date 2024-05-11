import 'package:aivi/screens/create_profile/create_profile_screen_1.dart';
import 'package:aivi/screens/dashboard/dashboard.dart';
import 'package:aivi/screens/notes/add_new_note.dart';
import 'package:aivi/screens/notes/notes_details.dart';
import 'package:aivi/screens/notes/notes_screen.dart';
import 'package:aivi/screens/onboarding_screen.dart';
import 'package:aivi/screens/tab_bar/tab_bar.dart';
import 'package:aivi/screens/user/edit_profile.dart';
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
    GoRoute(
      path: AppRoute.createProfileScreenOne,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const CreateProfileScreenOne()),
    ),
    GoRoute(
      path: AppRoute.editProfile,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const EditProfile()),
    ),
    GoRoute(
      path: AppRoute.dashboard,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const Dashboard()),
    ),
    GoRoute(
      path: AppRoute.notes,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const NotesScreen()),
    ),
    GoRoute(
      path: AppRoute.tabs,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const TabsPage()),
    ),
    GoRoute(
      path: AppRoute.notesDetails,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: NotesDetails()),
    ),
    GoRoute(
      path: AppRoute.addNewNotes,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const AddNotes()),
    ),
  ],
);

class AppRoute {
  static const String splash = '/';
  static const String addNewNotes = '/add-new-notes';
  static const String tabs = '/tabs';
  static const String welcome = '/welcome';
  static const String dashboard = '/dashboard';
  static const String notes = '/notes';
  static const String notesDetails = '/notes-details';
  static const String editProfile = '/edit-profile';
  static const String createProfileScreenOne = '/create-profile-screen-one';
}
