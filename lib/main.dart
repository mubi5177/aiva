import 'package:aivi/bloc_controller.dart';
import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/config/theme/light_theme.dart';
import 'package:flutter/material.dart';
part 'app_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlocController(child: AppView());
  }
}
