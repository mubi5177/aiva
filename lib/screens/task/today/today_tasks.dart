import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/task/today/today_appointments.dart';
import 'package:aivi/screens/task/today/today_task_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TodaySTaskBar extends StatefulWidget {
  @override
  _TodaySTaskBarState createState() => _TodaySTaskBarState();
}

class _TodaySTaskBarState extends State<TodaySTaskBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    super.initState();
  }

  int currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _handleTabChange() {
    // This function will be called whenever the current index of the tab controller changes
    print("Current tab index: ${_tabController.index}");
    setState(() {
      currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]

            const Gap(10),
            Container(
              height: 42,
              decoration: BoxDecoration(
                color: Color(0xFFE4EAF9),
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: context.secondary,
                ),
                labelColor: Colors.white,
                labelStyle: context.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelColor: context.secondary,
                unselectedLabelStyle: context.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: context.secondary),
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    child: Row(
                      children: [
                        AppImage.svg(
                          assetName: Assets.svgs.notificatons,
                          color: currentIndex == 0 ? Colors.white : context.secondary,
                        ),
                        const Gap(10),
                        const Text('Appointments (41)'),
                      ],
                    ),
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    child: Row(
                      children: [
                        AppImage.assets(
                          assetName: Assets.images.taskWithoutBg.path,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                          color: currentIndex == 1 ? Colors.white : context.secondary,
                        ),
                        const Gap(10),
                        const Text('Tasks (20)'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  // first tab bar view widget
                  TodayAppointments(),
                  TodayTaskSection()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
