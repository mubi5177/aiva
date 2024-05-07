import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [AppImage.svg(assetName: Assets.svg.aivaMic)],
        ),
      ),
    );
  }
}
