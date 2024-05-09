import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/components/app_image.dart';

class AppBarWithDrawer extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithDrawer({
    super.key,
    required this.title,
    required this.scaffoldKey,
    this.isIconBack = false,
    this.backgroundColor,
    this.isDrawerIcon = false,
    this.actions,
    this.bottom,
  });

  final String title;
  final dynamic scaffoldKey;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool isIconBack;
  final bool isDrawerIcon;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(title,style: context.displaySmall?.copyWith(fontWeight: FontWeight.bold),),
      leading: isIconBack
          ? AppButton.icon(
              onTap: () => context.pop(),
              margin: const EdgeInsets.all(8.0),
              child: AppImage.svg(assetName: Assets.svgs.back),
            )
          : isDrawerIcon
              ? AppButton.icon(
                  decoration: const BoxDecoration(),
                  onTap: () => scaffoldKey.currentState?.openDrawer(),
                  margin: const EdgeInsets.all(8.0),
                  child: AppImage.svg(assetName: Assets.svgs.drawer),
                )
              : const SizedBox.shrink(),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height;
    }
    return Size.fromHeight(height);
  }
}
