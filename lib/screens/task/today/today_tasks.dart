import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/task/task_screen.dart';
import 'package:aivi/screens/task/today/today_appointments.dart';
import 'package:aivi/screens/task/today/today_task_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TodaySTaskBar extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> appointmentSnapshot;
  final AsyncSnapshot<QuerySnapshot<Object?>> taskSnapshot;
  final DaysType type;

  const TodaySTaskBar({super.key, required this.appointmentSnapshot, required this.taskSnapshot, required this.type});

  @override
  _TodaySTaskBarState createState() => _TodaySTaskBarState();
}

class _TodaySTaskBarState extends State<TodaySTaskBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<QueryDocumentSnapshot> currentUserDocumentsTask = [];
  List<QueryDocumentSnapshot> currentUserDocumentsTaskFiltered = [];
  List<QueryDocumentSnapshot> currentUserDocumentsAppointment = [];
  List<QueryDocumentSnapshot> currentUserDocumentsAppointmentFiltered = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this,initialIndex: 1);
    _tabController.addListener(_handleTabChange);
    currentUserDocumentsAppointment = [];
    currentUserDocumentsAppointmentFiltered = [];
    currentUserDocumentsTask = [];
    currentUserDocumentsTaskFiltered = [];
    // Get today's date
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Get tomorrow's date
    DateTime tomorrow = today.add(const Duration(days: 1));

    // Get start and end of the current week
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Formatter to parse and compare dates (assuming date is stored in the document as a string)
    DateFormat dateFormat = DateFormat('MM/dd/yyyy');

    String currentUserId = getCurrentUserId();
    final List<QueryDocumentSnapshot> appointmentDocuments = widget.appointmentSnapshot.data!.docs;
    final List<QueryDocumentSnapshot> taskDocuments = widget.taskSnapshot.data!.docs;
    /*List<QueryDocumentSnapshot> todayAppointments = [];
    List<QueryDocumentSnapshot> tomorrowAppointments = [];
    List<QueryDocumentSnapshot> weekAppointments = [];*/
    if (widget.type == DaysType.today) {
      currentUserDocumentsAppointment = appointmentDocuments.where((doc) {
        DateTime appointmentDate = dateFormat.parse(doc['date']);
        return appointmentDate == today;
      }).toList();

      currentUserDocumentsTask = taskDocuments.where((doc) {
        DateTime taskDate = dateFormat.parse(doc['date']);
        return taskDate == today;
      }).toList();
    } else if (widget.type == DaysType.tomorrow) {
      currentUserDocumentsAppointment = appointmentDocuments.where((doc) {
        DateTime appointmentDate = dateFormat.parse(doc['date']);
        return appointmentDate == tomorrow;
      }).toList();

      currentUserDocumentsTask = taskDocuments.where((doc) {
        DateTime taskDate = dateFormat.parse(doc['date']);
        return taskDate == tomorrow;
      }).toList();
    } else if (widget.type == DaysType.week) {
      currentUserDocumentsAppointment = appointmentDocuments.where((doc) {
        DateTime appointmentDate = dateFormat.parse(doc['date']);
        return appointmentDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            appointmentDate.isBefore(endOfWeek.add(const Duration(days: 1)));
      }).toList();

      currentUserDocumentsTask = taskDocuments.where((doc) {
        DateTime taskDate = dateFormat.parse(doc['date']);
        return taskDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) && taskDate.isBefore(endOfWeek.add(const Duration(days: 1)));
      }).toList();
    } else {}

    for (var document in currentUserDocumentsAppointment) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String userId = data['userId'];
      bool isCompleted = data['isCompleted'] ?? false;
      if (userId == currentUserId && isCompleted == false) {
        currentUserDocumentsAppointmentFiltered.add(document);
      }
    }

    for (var document in currentUserDocumentsTask) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String userId = data['userId'];
      bool isCompleted = data['isCompleted'] ?? false;
      if (userId == currentUserId && isCompleted == false) {
        currentUserDocumentsTaskFiltered.add(document);
      }
    }
    // Now you can use these lists to populate your tabs
    print('${widget.type} Appointments: ${currentUserDocumentsAppointmentFiltered.length}');
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
                        Text('Appointments (${currentUserDocumentsAppointmentFiltered.length})'),
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
                        Text('Tasks (${currentUserDocumentsTaskFiltered.length})'),
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
                    appointmentDocuments: currentUserDocumentsAppointmentFiltered,
                  ),
                  TodayTaskSection(
                    taskDocuments: currentUserDocumentsTaskFiltered,
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
