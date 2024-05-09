import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:aivi/core/mixins/validations.dart';

class CreateProfileScreenOne extends StatefulWidget {
  const CreateProfileScreenOne({super.key});

  @override
  State<CreateProfileScreenOne> createState() => _CreateProfileScreenOneState();
}

class _CreateProfileScreenOneState extends State<CreateProfileScreenOne> with Validator {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton.outlineShrink(
                height: 50,
                width: 170,
                child: Text(
                  "Skip",
                  style: context.displaySmall,
                )),
            const Gap(10.0),
            AppButton.primary(height: 50, width: 170, background: context.secondary, child: const Text("Next")),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithDrawer(
        backgroundColor: Colors.grey.shade50,
        isIconBack: false,
        title: "${AppStrings.createProfile} (1/2)",
        scaffoldKey: _scaffoldKey,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(20),
            Text(
              "Welcome Onboard,",
              style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Gap(10),
            Text(
              "Let us know a few details about yourself to get started.",
              style: context.titleSmall,
            ),
            const Gap(20),
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    "https://img.freepik.com/free-photo/close-up-shot-hopeful-optimistic-happy-young-redhead-20s-girl-with-freckles-long-hair-smiling-joyfully-with-faith-eyes-prominent-look-posing-against-purple-background_1258-81590.jpg?t=st=1715158163~exp=1715161763~hmac=c338b89f9d47fce4801b160d6d813ab65c53e9c46166595cb4e7f1a0493fbfb8&w=2000"),
              ),
            ),
            const Gap(20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton.primary(
                    height: 30,
                    width: 160,
                    background: context.secondary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage.svg(
                          assetName: Assets.svgs.upload,
                          color: Colors.white,
                        ),
                        const Gap(10),
                        Text(
                          "Upload Photo",
                          style: context.bodySmall?.copyWith(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    )),
                const Gap(10.0),
                AppButton.outlineShrink(
                    height: 30,
                    width: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppImage.svg(
                          assetName: Assets.svgs.delete,
                          color: context.primary,
                        ),
                        const Gap(10),
                        Text(
                          "Remove",
                          style: context.bodySmall?.copyWith(fontSize: 12),
                        ),
                      ],
                    )),
              ],
            ),
            const Gap(30.0),
            Text(
              "Name",
              style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Gap(10.0),
            TextFormField(
              onTap: () async {},
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                  hintText: AppStrings.enterName),
              keyboardType: TextInputType.name,
              validator: validateName,
              // onSaved: (value) => _auth['email'] = value!,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const Gap(30.0),
            Text(
              "Phone Number",
              style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Gap(10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                  width: 100,
                  height: 50,
                  child: const CountryCodePicker(
                    onChanged: print,
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'IT',
                    favorite: ['+39', 'FR'],

                    // optional. aligns the flag and the Text left
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: TextFormField(
                    onTap: () async {},
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                        hintText: AppStrings.enterPhone),
                    keyboardType: TextInputType.phone,

                    // onSaved: (value) => _auth['email'] = value!,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
              ],
            ),
            const Gap(30.0),
            Text(
              "Email",
              style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Gap(10.0),
            TextFormField(
              onTap: () async {},
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                  hintText: AppStrings.enterEmail),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              // onSaved: (value) => _auth['email'] = value!,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ],
        ),
      ),
    );
  }
}
