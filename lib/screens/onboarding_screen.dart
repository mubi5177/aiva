import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_social_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AppImage.assets(
                assetName: Assets.images.aviaLogo.path,
                height: 150,
                width: 150,
              ),
              const Gap(22),
              Text(
                AppStrings.welcomeScreenText,
                style: context.displaySmall?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const Gap(20),
              SocialCustomButton(
                image: Assets.images.google.path,
                text: AppStrings.continueWithGoogle,
                onPressed: () {
                  // Add your onPressed logic here
                },
                color: Colors.white, // Change color as needed
                width: context.width, // Change width as needed
                height: 60, // Change height as needed
                borderRadius: 30, // Change border radius as needed
                textStyle: context.displaySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              SocialCustomButton(
                image: Assets.images.apple.path,
                text: AppStrings.continueWithApple,
                onPressed: () {
                  // Add your onPressed logic here
                },
                color: Colors.white, // Change color as needed
                width: context.width, // Change width as needed
                height: 60, // Change height as needed
                borderRadius: 30, // Change border radius as needed
                textStyle: context.displaySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              SocialCustomButton(
                image: Assets.images.fb.path,
                text: AppStrings.continueWithFb,
                onPressed: () {
                  // Add your onPressed logic here
                  context.push(AppRoute.welcome);
                },
                color: Colors.white, // Change color as needed
                width: context.width, // Change width as needed
                height: 60, // Change height as needed
                borderRadius: 30, // Change border radius as needed
                textStyle: context.displaySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: 100,
                      height: 1,
                      color: Colors.grey.withOpacity(.2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.withOpacity(.2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 100,
                      height: 1,
                      color: Colors.grey.withOpacity(.1),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(
                AppStrings.continueWithEmail,
                style: context.displaySmall?.copyWith(color: context.secondary, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Divider(
                color: Colors.grey.withOpacity(.3),
              ),
              const Gap(50),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '${AppStrings.completelySafe}\n',
                      style: context.displaySmall?.copyWith(color: Colors.grey),
                    ),
                    TextSpan(
                      text: AppStrings.termCondition,
                      style: context.displaySmall?.copyWith(color: context.secondary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}
