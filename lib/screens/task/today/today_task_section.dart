import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TodayTaskSection extends StatefulWidget {
  const TodayTaskSection({super.key});

  @override
  State<TodayTaskSection> createState() => _TodayTaskSectionState();
}

class _TodayTaskSectionState extends State<TodayTaskSection> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          InkWell(
            onTap: () {
              context.push(AppRoute.addNewTask);
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: context.width,
              decoration: DottedDecoration(
                shape: Shape.box,
                color: Colors.black,
                borderRadius: BorderRadius.circular(10), //remove this to get plane rectange
              ),
              child: Text(
                "+ Add New",
                style: context.titleSmall?.copyWith(fontSize: 16, color: Colors.grey),
              ),
            ),
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

        ],
      ),
    );
  }
}

final List<AppointmentItems> appointmentList = [
  AppointmentItems(
      description: "Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris",
      streetName: "Samson Street",
      title: "Attend Jay’s School Event",
      timingText: "12:00 PM - 02:00 PM"),
  AppointmentItems(
      description: "Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris",
      streetName: "Samson Street",
      title: "Remind me to send the files",
      timingText: "12:00 PM - 02:00 PM"),
  AppointmentItems(
      description: "Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris",
      streetName: "Samson Street",
      title: "Create logo for team",
      timingText: "12:00 PM - 02:00 PM"),
  AppointmentItems(
      description: "Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris",
      streetName: "Samson Street",
      title: "Drop Jay to school",
      timingText: "12:00 PM - 02:00 PM"),
  AppointmentItems(
      description: "Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris",
      streetName: "Samson Street",
      title: "Talk to the lawyer about case",
      timingText: "06:00 PM - 08:00 PM"),
  AppointmentItems(
      description: "Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris",
      streetName: "Samson Street",
      title: "Meeting for new launch",
      timingText: "08:00 PM - 09:00 PM"),
];

class AppointmentItems {
  final String title;
  final String timingText;
  final String description;
  final String streetName;

  AppointmentItems({required this.title, required this.timingText, required this.description, required this.streetName});
}
