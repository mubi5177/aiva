import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    // final SelectedTileCubit selectedTileCubit = SelectedTileCubit();
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Gap(60)),
          SliverToBoxAdapter(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(26.0),
                  child: AppImage.network(
                    imageUrl: AppStrings.dummyImage,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(20.0),
                    placeholder: (_, __) => CircleAvatar(backgroundColor: context.primary.withOpacity(.2)),
                    errorWidget: (_, __, ___) => CircleAvatar(backgroundColor: context.primary.withOpacity(.2)),
                  ),
                ),
              ),
              title: const Text('John Wick'),
              subtitle: const Text('Member Since : Jun 2024'),
            ),
          ),
          SliverList.builder(
            itemCount: drawerList.length,
            itemBuilder: (BuildContext context, int index) {
              SettingsModel drawer = drawerList[index];
              return ListTile(
                title: Text(
                  drawer.title ?? '',
                  style: context.displayMedium?.copyWith(
                    color: context.primary,
                  ),
                ),
                leading: AppImage.svg(
                  assetName: drawer.leadingIcon ?? '',
                  color: context.primary,
                  size: 24.0,
                ),
                dense: true,
                // selected: selectedIndex == index,
                // selectedTileColor: selectedIndex == index ? context.primary : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                // trailing: Icon(CupertinoIcons.chevron_right, color: context.primary),
                onTap: () {
                  switch (index) {
                    case 0:

                      context.push(AppRoute.editProfile);
                      break;
                    // case 1:
                    //   selectedTileCubit.onChanged(index);
                    //   context.push(AppRoute.savedPage);
                    //   break;
                    //
                    // case 2:
                    //   selectedTileCubit.onChanged(index);
                    //   context.push(AppRoute.boostsPage);
                    // case 3:
                    //   selectedTileCubit.onChanged(index);
                    //   context.push(AppRoute.communityMembershipSubscrptions);
                    //   break;
                    default:
                  }
                },
              );
            },
            // separatorBuilder: (_, __) => const Divider(indent: 20.0, endIndent: 20.0),
          ),
          const SliverToBoxAdapter(child: Divider()),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 80.0), // Adjust the padding as needed
            sliver: SliverToBoxAdapter(
              child: SizedBox.shrink(), // Replace YourWidgetHere with the widget you want to add
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: [
              const Text(AppStrings.completelySafe),
              Text(
                AppStrings.readTermConditions,
                style: context.titleSmall?.copyWith(color: context.secondary, fontWeight: FontWeight.bold),
              ),
            ],
          )),
          const SliverToBoxAdapter(child: Divider()),
          SliverToBoxAdapter(
              child: ListTile(
            title: Text(
              AppStrings.logout,
              style: context.displayMedium?.copyWith(
                color: context.primary,
              ),
            ),
            leading: AppImage.svg(
              assetName: Assets.svgs.logout,
              color: context.primary,
              size: 24.0,
            ),
            dense: true,
            // selected: selectedIndex == index,
            // selectedTileColor: selectedIndex == index ? context.primary : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            // trailing: Icon(CupertinoIcons.chevron_right, color: context.primary),
            onTap: () {
              // switch (index) {
              //   case 0:
              //     selectedTileCubit.onChanged(index);
              //     context.push(AppRoute.eventPage);
              //     break;
              //   case 1:
              //     selectedTileCubit.onChanged(index);
              //     context.push(AppRoute.savedPage);
              //     break;
              //
              //   case 2:
              //     selectedTileCubit.onChanged(index);
              //     context.push(AppRoute.boostsPage);
              //   case 3:
              //     selectedTileCubit.onChanged(index);
              //     context.push(AppRoute.communityMembershipSubscrptions);
              //     break;
              //   default:
              // }
            },
          ))
        ],
      ),
    );
  }
}

List<SettingsModel> drawerList = [
  SettingsModel(title: AppStrings.editProfile, leadingIcon: Assets.svgs.profile),
  SettingsModel(title: AppStrings.notes, leadingIcon: Assets.svgs.notes),
  SettingsModel(title: AppStrings.dailyHabits, leadingIcon: Assets.svgs.cycle),
  SettingsModel(title: AppStrings.notificationSetting, leadingIcon: Assets.svgs.notification),
  SettingsModel(title: AppStrings.labels, leadingIcon: Assets.svgs.labels),
  SettingsModel(title: AppStrings.about, leadingIcon: Assets.svgs.about),
];

class SettingsModel {
  final String title;
  final String leadingIcon;
  SettingsModel({required this.title, required this.leadingIcon});
}
