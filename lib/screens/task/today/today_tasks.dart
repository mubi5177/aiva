import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/task/today/today_appointments.dart';
import 'package:aivi/screens/task/today/today_task_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TodaySTaskBar extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> appointmentSnapshot;
  final AsyncSnapshot<QuerySnapshot<Object?>> taskSnapshot;

  const TodaySTaskBar({super.key, required this.appointmentSnapshot, required this.taskSnapshot});

  @override
  _TodaySTaskBarState createState() => _TodaySTaskBarState();
}

class _TodaySTaskBarState extends State<TodaySTaskBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<QueryDocumentSnapshot> currentUserDocumentsTask = [];
  List<QueryDocumentSnapshot> currentUserDocumentsAppointment = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    String currentUserId = getCurrentUserId();
    final List<QueryDocumentSnapshot> appointmentDocuments = widget.appointmentSnapshot.data!.docs;
    for (var document in appointmentDocuments) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String userId = data['userId'];
      bool isCompleted = data['isCompleted'];
      if (userId == currentUserId && isCompleted==false) {
        currentUserDocumentsAppointment.add(document);
      }
    }
    final List<QueryDocumentSnapshot> taskDocuments = widget.taskSnapshot.data!.docs;
    for (var document in taskDocuments) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String userId = data['userId'];
      bool isCompleted = data['isCompleted'];
      if (userId == currentUserId && isCompleted==false) {
        currentUserDocumentsTask.add(document);
      }
    }

    super.initState();
  }

  int currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _handleTabChange() {
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
            // give the tab bar a height [can change height to preferred height]
            const Gap(10),
            Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE4EAF9),
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
                        const Gap(7),
                        Text('Appointments (${currentUserDocumentsAppointment.length})'),
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
                        Text('Tasks (${currentUserDocumentsTask.length})'),
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
                children: [
                  // first tab bar view widget
                  TodayAppointments(
                    appointmentDocuments: currentUserDocumentsAppointment,
                  ),
                  TodayTaskSection(
                    taskDocuments: currentUserDocumentsTask,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
