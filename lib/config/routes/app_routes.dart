import 'package:aivi/screens/create_profile/create_profile_screen_1.dart';
import 'package:aivi/screens/daily_habits/create_new_habbit.dart';
import 'package:aivi/screens/daily_habits/habits.dart';
import 'package:aivi/screens/dashboard/dashboard.dart';
import 'package:aivi/screens/dashboard/dashboard_no_item.dart';
import 'package:aivi/screens/notes/add_new_note.dart';
import 'package:aivi/screens/notes/notes_details.dart';
import 'package:aivi/screens/notes/notes_screen.dart';
import 'package:aivi/screens/notification_settings.dart';
import 'package:aivi/screens/onboarding_screen.dart';
import 'package:aivi/screens/say_something.dart';
import 'package:aivi/screens/search/ssearch_screen.dart';
import 'package:aivi/screens/tab_bar/tab_bar.dart';
import 'package:aivi/screens/task/add_new_task.dart';
import 'package:aivi/screens/task/task_details.dart';
import 'package:aivi/screens/task/task_screen.dart';
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
    GoRoute(
      path: AppRoute.searchScreen,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const SearchScreen()),
    ),
    GoRoute(
      path: AppRoute.dashboardNoItem,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const DashboardNoItem()),
    ),
    GoRoute(
      path: AppRoute.taskDetails,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: TaskDetails()),
    ),
    GoRoute(
      path: AppRoute.addNewTask,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const AddNewTask()),
    ),
    GoRoute(
      path: AppRoute.habits,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const Habits()),
    ),
    GoRoute(
      path: AppRoute.createNewHabits,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const CreateNewHabbit()),
    ),
    GoRoute(
      path: AppRoute.notificationSettings,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const NotificationSettings()),
    ),
    GoRoute(
      path: AppRoute.saySomething,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: SaySomething()),
    ),
  ],
);

class AppRoute {
  static const String splash = '/';
  static const String addNewNotes = '/add-new-notes';
  static const String tabs = '/tabs';
  static const String saySomething = '/say-something';
  static const String welcome = '/welcome';
  static const String notificationSettings = '/notification-settings';
  static const String dashboard = '/dashboard';
  static const String habits = '/habits';
  static const String createNewHabits = '/create-new-habits';
  static const String dashboardNoItem = '/dashboard-no-item';
  static const String searchScreen = '/search-screen';
  static const String notes = '/notes';
  static const String notesDetails = '/notes-details';
  static const String editProfile = '/edit-profile';
  static const String addNewTask = '/add-new-task';
  static const String taskDetails = '/task-details';
  static const String createProfileScreenOne = '/create-profile-screen-one';
}
