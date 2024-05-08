import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_social_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            AppImage.assets(
              assetName: Assets.images.aivaMic.path,
              height: 150,
              width: 150,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Color(0xff2764FE), Color(0xffD16FFE), Color(0xffFFA5A5)],
                  ).createShader(bounds);
                },
                child: const Text(
                  "Hi Jegan, I'm your personal AI that help get things done",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // This color will be replaced by the gradient
                  ),
                ),
              ),
            ),
            const Spacer(),
            SocialCustomButton(
              image: '',
              boxShadow: [],
              text: AppStrings.letGetStarted,
              onPressed: () {
                // Add your onPressed logic here
              },
              color: context.secondary, // Change color as needed
              width: context.width * .6, // Change width as needed
              height: 50, // Change height as needed
              borderRadius: 30, // Change border radius as needed
              textStyle: context.displaySmall?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
