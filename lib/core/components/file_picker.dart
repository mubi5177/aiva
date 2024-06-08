import 'package:aivi/core/constant/app_strings.dart';
import 'package:flutter/material.dart';

class AppImagePicker extends StatelessWidget {
  final VoidCallback galleryOnTap;
  final VoidCallback cameraOnTap;

  const AppImagePicker({super.key, required this.cameraOnTap, required this.galleryOnTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text(AppStrings.gallery),
            onTap: galleryOnTap,
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text(AppStrings.camera),
            onTap: cameraOnTap,
          ),
        ],
      ),
    );
  }
}
