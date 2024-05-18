import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/app_drawer.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DailyHabits extends StatefulWidget {
  const DailyHabits({super.key});

  @override
  State<DailyHabits> createState() => _DailyHabitsState();
}

class _DailyHabitsState extends State<DailyHabits> {
  late DrawerCubit _drawerCubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _drawerCubit = BlocProvider.of<DrawerCubit>(context);
    super.initState();
  }

  int? selectedIndex;
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
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                height: 100,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weekList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 50,
                      child: Column(
                        children: [
                          const Gap(8),
                          Text(weekList[index].day, style: context.titleSmall),
                          const Gap(8),
                          Text(weekList[index].date, style: context.displayMedium),
                          const Gap(8),
                          const Icon(
                            Icons.check_circle_outline,
                            color: CupertinoColors.systemGreen,
                            size: 20,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Habits",
                    style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  AppButton.primary(
                    onPressed: () {
                      context.push(AppRoute.habits);
                    },
                    height: 35,
                    width: 130,
                    background: context.secondary,
                    child: Text(
                      "+ Add New",
                      style: context.titleSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(6),
                height: context.height * .35,
                // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey)),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: habitsItemsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: AppImage.assets(assetName: habitsItemsList[index].icon),
                        title: Text(
                          habitsItemsList[index].title,
                          style: context.titleSmall?.copyWith(color: context.primary),
                        ),
                        subtitle: Text(
                          habitsItemsList[index].time,
                          style: context.titleSmall?.copyWith(fontSize: 12),
                        ),
                        trailing: habitsItemsList[index].isCompleted
                            ? AppButton.primary(
                                height: 35,
                                width: 120,
                                background: Color(0xFFE1F9E9),
                                child: Row(
                                  children: [
                                    AppImage.assets(
                                      assetName: Assets.images.doneCheck.path,
                                      fit: BoxFit.cover,
                                      height: 12,
                                      width: 12,
                                    ),
                                    const Gap(8),
                                    Text(
                                      "Completed",
                                      style: context.titleSmall?.copyWith(
                                        fontSize: 9,
                                        color: Color(0xFF3DB65F),
                                      ),
                                    ),
                                  ],
                                ))
                            : AppButton.outlineShrink(
                                borderColor: context.secondary,
                                height: 35,
                                width: 125,
                                child: Text(
                                  "Mark Complete",
                                  maxLines: 1,
                                  style: context.titleSmall?.copyWith(fontSize: 10, color: context.secondary),
                                )),
                      ),
                    );
                  },
                ),
              ),

              Text(
                "Completed",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                height: context.height * .4,
                // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey)),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: habitsItemsListCompleted.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: AppImage.assets(assetName: habitsItemsListCompleted[index].icon),
                        title: Text(
                          habitsItemsListCompleted[index].title,
                          style: context.titleSmall?.copyWith(color: context.primary),
                        ),
                        subtitle: Text(
                          habitsItemsListCompleted[index].time,
                          style: context.titleSmall?.copyWith(fontSize: 12),
                        ),
                        trailing: habitsItemsListCompleted[index].isCompleted
                            ? AppButton.primary(
                            height: 35,
                            width: 120,
                            background: Color(0xFFE1F9E9),
                            child: Row(
                              children: [
                                AppImage.assets(
                                  assetName: Assets.images.doneCheck.path,
                                  fit: BoxFit.cover,
                                  height: 12,
                                  width: 12,
                                ),
                                const Gap(8),
                                Text(
                                  "Completed",
                                  style: context.titleSmall?.copyWith(
                                    fontSize: 9,
                                    color: Color(0xFF3DB65F),
                                  ),
                                ),
                              ],
                            ))
                            : AppButton.outlineShrink(
                            borderColor: context.secondary,
                            height: 35,
                            width: 125,
                            child: Text(
                              "Mark Complete",
                              maxLines: 1,
                              style: context.titleSmall?.copyWith(fontSize: 10, color: context.secondary),
                            )),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeekDays {
  final String day;
  final String date;
  final String icon;
  WeekDays({required this.icon, required this.date, required this.day});
}

final List<WeekDays> weekList = [
  WeekDays(icon: "icon", date: "23", day: "Tue"),
  WeekDays(icon: "icon", date: "24", day: "Wed"),
  WeekDays(icon: "icon", date: "25", day: "Thu"),
  WeekDays(icon: "icon", date: "26", day: "Fri"),
  WeekDays(icon: "icon", date: "27", day: "Sat"),
  WeekDays(icon: "icon", date: "28", day: "Sun"),
  WeekDays(icon: "icon", date: "29", day: "Mon"),
];

class HabitsItems {
  final String title;
  final String time;
  final String icon;
  final bool isCompleted;
  HabitsItems({required this.icon, required this.isCompleted, required this.title, required this.time});
}

final List<HabitsItems> habitsItemsList = [
  HabitsItems(icon: Assets.images.dumbell.path, isCompleted: false, title: "Gym Session", time: "08 : 00 Pm"),
  HabitsItems(icon: Assets.images.book.path, isCompleted: false, title: "Read Book", time: "08 : 00 Pm"),
  HabitsItems(icon: Assets.images.running.path, isCompleted: false, title: "Running", time: "08 : 00 Pm")
];
final List<HabitsItems> habitsItemsListCompleted = [
  HabitsItems(icon: Assets.images.dumbell.path, isCompleted: true, title: "Gym Session", time: "08 : 00 Pm"),
  HabitsItems(icon: Assets.images.book.path, isCompleted: true, title: "Read Book", time: "08 : 00 Pm"),
  HabitsItems(icon: Assets.images.running.path, isCompleted: true, title: "Running", time: "08 : 00 Pm")
];
