import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/cubit/tab_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/daily_habits/daily_habits.dart';
import 'package:aivi/screens/dashboard/dashboard.dart';
import 'package:aivi/screens/notes/notes_screen.dart';
import 'package:aivi/screens/task/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final List<Widget> _pages = <Widget>[const Dashboard(), const TaskScreen(), const NotesScreen(), const DailyHabits()];

  late TabCubit _tabCubit;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _tabCubit = TabCubit();
    _tabCubit.onItemTap(0);
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, bool>(
      builder: (context, state) {
        return BlocBuilder<TabCubit, int>(
          bloc: _tabCubit,
          builder: (context, selectedIndex) {
            return Scaffold(
                floatingActionButton: state == true
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          context.showBottomSheet(
                              showDragHandle: false,
                              maxHeight: context.height,
                              child: SizedBox(
                                // height: context.height * .7,
                                width: context.width,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Gap(10),
                                      Text(
                                        "Say Something",
                                        style: context.titleLarge,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                                        child: Text(
                                          "You can ask me to add notes, input habit time, add food intake",
                                          textAlign: TextAlign.center,
                                          style: context.titleSmall?.copyWith(color: context.primary, fontSize: 15),
                                        ),
                                      ),
                                      const Gap(30),
                                      Text(
                                        "Create a reminder to send files to Jegan tomorrow",
                                        textAlign: TextAlign.center,
                                        style: context.displayLarge?.copyWith(
                                          height: 1.5,
                                          fontSize: 32,
                                        ),
                                      ),
                                      AppImage.assets(assetName: Assets.images.recordingDemo.path),
                                      const Gap(30),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Expanded(child: SizedBox.shrink()),
                                          const Gap(30),
                                          AppImage.assets(
                                            assetName: Assets.images.logoBar.path,
                                            fit: BoxFit.cover,
                                            height: 70,
                                            width: 70,
                                          ),
                                          const Expanded(child: SizedBox.shrink()),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () {
                                                context.push(AppRoute.saySomething);
                                              },
                                              child: AppImage.assets(
                                                assetName: Assets.images.keyboard.path,
                                                fit: BoxFit.cover,
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                        child: AppImage.assets(
                          assetName: Assets.images.logoBar.path,
                          fit: BoxFit.cover,
                          height: 70,
                          width: 70,
                        ),
                      ),
                extendBodyBehindAppBar: true,
                extendBody: true,
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                body: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: _tabCubit.onItemTap,
                  children: _pages,
                ),
                bottomNavigationBar: state == true
                    ? const SizedBox()
                    : Container(
                        width: context.width,
                        height: 64.0,
                        decoration: BoxDecoration(
                          color: context.scaffoldBackgroundColor,
                        ),
                        // margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
                        // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                _tabCubit.onItemTap(0);
                                _pageController.jumpToPage(0);
                              },
                              icon: AppImage.assets(
                                assetName: selectedIndex == 0 ? Assets.images.dashboardFilled.path : Assets.images.dashboard.path,
                                // color: selectedIndex == 0 ? context.primary : context.tertiary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: IconButton(
                                onPressed: () {
                                  _tabCubit.onItemTap(1);
                                  _pageController.jumpToPage(1);
                                },
                                icon: AppImage.assets(
                                  assetName: selectedIndex == 1 ? Assets.images.taskFilled.path : Assets.images.task.path,
                                  // color: selectedIndex == 1 ? context.primary : context.tertiary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: IconButton(
                                onPressed: () {
                                  _tabCubit.onItemTap(2);
                                  _pageController.jumpToPage(2);
                                },
                                icon: AppImage.assets(
                                  assetName: selectedIndex == 2 ? Assets.images.notesFilled.path : Assets.images.notes.path,
                                  // color: selectedIndex == 2 ? context.primary : context.tertiary,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _tabCubit.onItemTap(3);
                                _pageController.jumpToPage(3);
                              },
                              icon: AppImage.assets(
                                assetName: selectedIndex == 3 ? Assets.images.dailyHabbitFilled.path : Assets.images.dailyHabbit.path,
                                // color: selectedIndex == 3 ? context.primary : context.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ));
          },
        );
      },
    );
  }
}
