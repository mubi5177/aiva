import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/model/user_model.dart';
import 'package:aivi/widgets/custom_social_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserModel? currentUser;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    currentUser = await getUserData();

    setState(() {});
    print('_WelcomeScreenState.initState: ${currentUser?.name}');
  }

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
                child: Text(
                  "Hi ${currentUser?.name ?? ''}, I'm your personal AI that help get things done",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
              boxShadow: const [],
              text: AppStrings.letGetStarted,
              onPressed: () async {
                bool emailExists = await checkEmailExistence(currentUser?.email ?? "");
                if (emailExists) {
                  context.go(AppRoute.tabs);
                } else {
                  // Add your onPressed logic here
                  context.go(AppRoute.createProfileScreenOne);
                }
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
