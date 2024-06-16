import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EmptyScreen extends StatelessWidget {
  final String screen;
  const EmptyScreen({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AppImage.assets(
                assetName: Assets.images.noTaskIcon.path,
                height: 80,
                width: 80,
              ),
            ),
            const Gap(20),
            Center(
              child: Text(
                "No $screen Found",
                style: context.titleSmall?.copyWith(color: context.primary, fontWeight: FontWeight.w500),
              ),
            ),
            const Gap(10),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "It looks like there are no $screen available.",
                  textAlign: TextAlign.center,
                  style: context.titleSmall,
                ),
              ),
            ),
          ],
        ),
        ),
      );
  }
}