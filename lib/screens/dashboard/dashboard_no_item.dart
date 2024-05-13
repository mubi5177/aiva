import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/app_drawer.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DashboardNoItem extends StatefulWidget {
  const DashboardNoItem({super.key});

  @override
  State<DashboardNoItem> createState() => _DashboardNoItemState();
}

class _DashboardNoItemState extends State<DashboardNoItem> {
  late DrawerCubit _drawerCubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _drawerCubit = BlocProvider.of<DrawerCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      onDrawerChanged: (value) => _drawerCubit.onChanged(value),
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithDrawer(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        centerTitle: false,
        isDrawerIcon: true,
        backgroundColor: Colors.grey.shade50,
        isIconBack: false,
        title: "Good Morning, Jegan",
        scaffoldKey: _scaffoldKey,
        actions: [
          AppImage.svg(assetName: Assets.svgs.notificatons),
          const Gap(10),
          InkWell(
              onTap: () {
                context.push(AppRoute.searchScreen);
              },
              child: AppImage.svg(assetName: Assets.svgs.search)),
          const Gap(10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              Text(
                "Today's Agenda >",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(40),
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
                  "No Tasks or Reminder Found",
                  style: context.titleSmall?.copyWith(color: context.primary, fontWeight: FontWeight.w500),
                ),
              ),
              const Gap(10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "It looks like there are no tasks added for today. Try adding some tasks",
                    textAlign: TextAlign.center,
                    style: context.titleSmall,
                  ),
                ),
              ),
              const Gap(20),
              Center(
                child: AppButton.primary(
                  height: 50,
                  width: 250,
                  background: context.secondary,
                  child: const Text("+   Add New"),
                ),
              ),
              const Gap(60),
              Text(
                "Daily Habits  >",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(40),
              Center(
                child: AppImage.assets(
                  assetName: Assets.images.noHabbitIcon.path,
                  height: 80,
                  width: 80,
                ),
              ),
              const Gap(20),
              Center(
                child: Text(
                  "No Habits Added",
                  style: context.titleSmall?.copyWith(color: context.primary, fontWeight: FontWeight.w500),
                ),
              ),
              const Gap(10),
              Center(
                child: AppButton.primary(
                  height: 50,
                  width: 250,
                  background: context.secondary,
                  child: const Text("+   Add Habits"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
