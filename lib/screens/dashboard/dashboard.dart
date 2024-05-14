import 'dart:ffi';

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

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Agenda >",
                    style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  AppButton.primary(
                    onPressed: (){
                      context.push(AppRoute.addNewTask);
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
              const Gap(10),
              SizedBox(
                height: context.height * .5,
                child: ListView.builder(
                  itemCount: agendaList.length, // Number of list items
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        dense: true,
                        // isThreeLine: agendaList[index].timingText != null ? true : false,
                        contentPadding: const EdgeInsets.only(right: 20),
                        tileColor: Colors.transparent,
                        leading: Radio(
                          fillColor: MaterialStateColor.resolveWith((states) => context.secondary),
                          activeColor: context.secondary,
                          value: index,
                          groupValue: selectedIndex,
                          onChanged: (int? value) {
                            setState(() {
                              selectedIndex = value;
                            });
                          },
                        ),
                        subtitle: agendaList[index].timingText != null
                            ? Row(
                                children: [
                                  AppImage.assets(
                                    assetName: Assets.images.clock.path,
                                    height: 14,
                                    width: 14,
                                    color: context.tertiary,
                                    fit: BoxFit.cover,
                                  ),
                                  const Gap(10),
                                  Text(agendaList[index].timingText ?? ""),
                                ],
                              )
                            : const SizedBox.shrink(),
                        title: Text(agendaList[index].title),
                        trailing: AppImage.assets(
                          assetName: agendaList[index].trailingIcon,
                          height: 30,
                          fit: BoxFit.cover,
                          width: 30,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(10),
              Text(
                "Daily Habits  >",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(10),
              SizedBox(
                height: context.height * .18,
                child: ListView.builder(
                  itemCount: habitsList.length,
                  // Number of list items
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: 140,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppImage.assets(
                            assetName: habitsList[index].logo,
                            fit: BoxFit.cover,
                            height: 50,
                            width: 50,
                          ),
                          const Gap(14),
                          Text(
                            habitsList[index].title,
                            style: context.titleSmall?.copyWith(fontSize: 14, color: context.primary, fontWeight: FontWeight.w700),
                          ),
                          const Gap(14),
                          habitsList[index].isCompleted
                              ? AppButton.primary(
                                  height: 25,
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
                                  height: 25,
                                  width: 120,
                                  child: Text(
                                    "Mark Complete",
                                    style: context.titleSmall?.copyWith(fontSize: 9, color: context.secondary),
                                  )),


                        ],
                      ),
                    );
                  },
                ),
              ),
              const Gap(200),
            ],
          ),
        ),
      ),
    );
  }
}

final List<AgendaItems> agendaList = [
  AgendaItems(title: "Attend Jay’s School Event", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(title: "Remind me to send the files", trailingIcon: Assets.images.bgBell.path, timingText: "12:00 PM - 02:00 PM"),
  AgendaItems(title: "Create logo for team", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(title: "Drop Jay to school", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(title: "Talk to the lawyer about case", trailingIcon: Assets.images.bgBell.path, timingText: "06:00 PM - 08:00 PM"),
  AgendaItems(title: "Meeting for new launch", trailingIcon: Assets.images.bgBell.path, timingText: "08:00 PM - 09:00 PM"),
];

class AgendaItems {
  final String title;
  final String trailingIcon;
  final String? timingText;

  AgendaItems({required this.title, this.timingText, required this.trailingIcon});
}

class HabitsItems {
  final String title;
  final String logo;
  final bool isCompleted;
  HabitsItems({required this.title, required this.isCompleted, required this.logo});
}

final List<HabitsItems> habitsList = [
  HabitsItems(title: "Gym Session", logo: Assets.images.dumbell.path, isCompleted: false),
  HabitsItems(title: "Read Books", logo: Assets.images.book.path, isCompleted: false),
  HabitsItems(title: "Running", logo: Assets.images.dumbell.path, isCompleted: true),
];
