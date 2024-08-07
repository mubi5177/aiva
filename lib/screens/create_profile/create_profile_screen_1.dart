import 'dart:io';
import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/components/file_picker.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/model/user_model.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:aivi/core/mixins/validations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfileScreenOne extends StatefulWidget {
  const CreateProfileScreenOne({super.key});

  @override
  State<CreateProfileScreenOne> createState() => _CreateProfileScreenOneState();
}

class _CreateProfileScreenOneState extends State<CreateProfileScreenOne> with Validator {
  UserModel? currentUser;
  File? _profileFile;
  String profile = '';
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    getData();
  }

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController countryCode = TextEditingController();
  getData() async {
    currentUser = await getUserData();
    name.text = currentUser?.name ?? '';
    profile = currentUser?.profile ?? '';

    email.text = currentUser?.email ?? '';
    phone.text = currentUser?.phone ?? '';
    setState(() {});
  }

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
                onPressed: () {
                  saveUserJoinedDate();
                  context.push(AppRoute.tabs);
                },
                height: 50,
                width: 170,
                child: Text(
                  "Skip",
                  style: context.displaySmall,
                )),
            const Gap(10.0),
            AppButton.primary(
                onPressed: () {
                  if (_profileFile != null) {
                    uploadImage(_profileFile!).then((value) {
                      uploadUserData(
                              name: name.text.trim(),
                              profileUrl: value,
                              email: email.text.trim(),
                              phoneNumber: "${countryCode.text.trim()}${phone.text.trim()}",
                              loginType: currentUser?.loginType ?? '')
                          .then((value) {
                        context.push(AppRoute.tabs);
                      });
                    });
                  } else {
                    uploadUserData(
                            name: name.text.trim(),
                            profileUrl: profile,
                            email: email.text.trim(),
                            phoneNumber: "${countryCode.text.trim()}${phone.text.trim()}",
                            loginType: currentUser?.loginType ?? '')
                        .then((value) {
                      context.push(AppRoute.habits);
                    });
                  }
                },
                height: 50,
                width: 170,
                background: context.secondary,
                child: const Text("Next")),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithDrawer(
        backgroundColor: Colors.grey.shade50,
        isIconBack: false,
        centerTitle: true,
        title: AppStrings.createProfile,
        scaffoldKey: _scaffoldKey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(20),
              Text(
                "Welcome ${currentUser?.name ?? ''}, ",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(10),
              Text(
                "Let us know a few details about yourself to get started.",
                style: context.titleSmall,
              ),
              const Gap(20),
              if (_profileFile != null) ...{
                Center(
                  child: CircleAvatar(radius: 60, backgroundImage: FileImage(_profileFile ?? File(currentUser?.profile ?? ''))),
                ),
              } else ...{
                Center(
                  child: CircleAvatar(radius: 60, backgroundImage: NetworkImage(profile)),
                ),
              },
              const Gap(20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton.primary(
                      onPressed: () {
                        _showPicker(context: context);
                      },
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
                      onPressed: () {
                        setState(() {
                          _profileFile = null;
                          profile = "";
                        });
                      },
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
                controller: name,
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
                    child: CountryCodePicker(
                      showFlag: false,
                      onChanged: (code) {
                        countryCode.text = code.dialCode.toString();
                      },
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      initialSelection: 'IT',
                      favorite: ['+39', 'FR'],

                      // optional. aligns the flag and the Text left
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: TextFormField(
                      // keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      controller: phone,
                      onTap: () async {},
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                          enabledBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                          focusedBorder:
                              OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                          hintText: AppStrings.enterPhone),
                      keyboardType: TextInputType.number,

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
                controller: email,
                enabled: false,
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
      ),
    );
  }

  Future<void> _pickProfileFile({
    bool isCamera = false,
  }) async {
    if (isCamera) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        File? compressedFile = await File(photo.path);

        setState(() {
          _profileFile = File(compressedFile!.path);
          profile = '';
        });
      }
    } else {
      // Use file_picker for selecting from gallery
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        File file = File(result.files.single.path!);
        File? compressedFile = file;

        setState(() {
          _profileFile = compressedFile;
          profile = '';
        });
      }
    }
  }

  void _showPicker({
    required BuildContext context,
  }) {
    context.showBottomSheet(
      child: AppImagePicker(
        galleryOnTap: () {
          _pickProfileFile();
          context.pop();
        },
        cameraOnTap: () {
          _pickProfileFile(
            isCamera: true,
          );
          context.pop();
        },
      ),
    );
  }
}
