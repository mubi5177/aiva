import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/model/user_model.dart';
import 'package:aivi/utils/services/social_auth_provider.dart';
import 'package:aivi/widgets/custom_social_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({
    super.key,
  });

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  UserCredential? cred;
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool isGoogleLoading = false;
  bool isAppleLoading = false;

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
              if (isGoogleLoading) ...{
                Center(
                  child: Container(margin: const EdgeInsets.symmetric(vertical: 10), height: 20, width: 20, child: const CircularProgressIndicator()),
                )
              } else ...{
                SocialCustomButton(
                  image: Assets.images.google.path,
                  text: AppStrings.continueWithGoogle,
                  onPressed: () async {
                    try {
                      setState(() {
                        isGoogleLoading = true;
                      });

                      // Add your onPressed logic here
                      cred = await signInWithGoogle();
                      saveUserData(UserModel(
                        email: cred?.user?.email ?? '',
                        phone: cred?.user?.phoneNumber ?? '',
                        profile: cred?.user?.photoURL ?? '',
                        name: cred?.user?.displayName ?? '',
                        loginType: 'google',
                      ));
                      Future.delayed(const Duration(seconds: 1));
                      setState(() {
                        isGoogleLoading = false;
                      });
                      context.go(AppRoute.welcome);
                    } catch (e) {
                      // Handle errors here
                      print('Error occurred: $e');
                      setState(() {
                        isGoogleLoading = false;
                      });
                    }
                  },
                  color: Colors.white,
                  // Change color as needed
                  width: context.width,
                  // Change width as needed
                  height: 60,
                  // Change height as needed
                  borderRadius: 30,
                  // Change border radius as needed
                  textStyle: context.displaySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              },
              if (isAppleLoading) ...{
                Center(
                  child: Container(margin: const EdgeInsets.symmetric(vertical: 10), height: 20, width: 20, child: const CircularProgressIndicator()),
                )
              } else ...{
                SocialCustomButton(
                  image: Assets.images.apple.path,
                  text: AppStrings.continueWithApple,
                  onPressed: () async {
                    setState(() {
                      isAppleLoading = true;
                    });

                    try {
                      // Add your onPressed logic here
                      cred = await signInWithApple();

                      saveUserData(UserModel(
                        email: cred?.user?.email ?? '',
                        phone: cred?.user?.phoneNumber ?? '',
                        profile: cred?.user?.photoURL ?? '',
                        name: cred?.user?.displayName ?? 'Apple User',
                        loginType: 'apple',
                      ));

                      // Simulate a delay for demonstration purposes
                      await Future.delayed(const Duration(seconds: 1));

                      setState(() {
                        isAppleLoading = false;
                      });

                      context.go(AppRoute.welcome);
                    } catch (e) {
                      // Handle errors here
                      print('Error occurred: $e');
                      setState(() {
                        isAppleLoading = false;
                      });
                    }
                  },

                  color: Colors.white,
                  // Change color as needed
                  width: context.width,
                  // Change width as needed
                  height: 60,
                  // Change height as needed
                  borderRadius: 30,
                  // Change border radius as needed
                  textStyle: context.displaySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              },
              SocialCustomButton(
                image: Assets.images.fb.path,
                text: AppStrings.continueWithFb,
                onPressed: () {
                  // Add your onPressed logic here
                  context.push(AppRoute.welcome);
                },
                color: Colors.white,
                // Change color as needed
                width: context.width,
                // Change width as needed
                height: 60,
                // Change height as needed
                borderRadius: 30,
                // Change border radius as needed
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
              InkWell(
                onTap: () {},
                child: Text(
                  AppStrings.continueWithEmail,
                  style: context.displaySmall?.copyWith(color: context.secondary, fontWeight: FontWeight.bold),
                ),
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
