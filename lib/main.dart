import 'package:aivi/bloc_controller.dart';
import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/config/theme/light_theme.dart';
import 'package:aivi/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
  listenForPermissions();

  runApp(const MyApp());
}

void listenForPermissions() async {
  final status = await Permission.microphone.status;
  switch (status) {
    case PermissionStatus.denied:
      requestForPermission();
      break;
    case PermissionStatus.granted:
      break;
    case PermissionStatus.limited:
      break;
    case PermissionStatus.permanentlyDenied:
      break;
    case PermissionStatus.restricted:
      break;
    case PermissionStatus.provisional:
      // TODO: Handle this case.
      break;
  }
}

Future<void> requestForPermission() async {
  await Permission.microphone.request();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlocController(child: AppView());
  }
}
