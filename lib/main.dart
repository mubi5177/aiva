import 'package:aivi/bloc_controller.dart';
import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/config/theme/light_theme.dart';
import 'package:aivi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'utils/services/firebase_messaging_handler.dart';
part 'app_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingHandler().initialize();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlocController(child: AppView());
  }
}
