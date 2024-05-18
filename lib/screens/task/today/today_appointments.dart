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

class TodayAppointments extends StatefulWidget {
  const TodayAppointments({super.key});

  @override
  State<TodayAppointments> createState() => _TodayAppointmentsState();
}

class _TodayAppointmentsState extends State<TodayAppointments> {
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
              context.push(AppRoute.addNewAppointment);
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
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: context.height * .5,
              child: ListView.builder(
                itemCount: appointmentList.length, // Number of list items
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      context.push(AppRoute.taskDetails);
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(appointmentList[index].title),
                                const Gap(10),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        AppImage.assets(
                                          assetName: Assets.images.clock.path,
                                          height: 14,
                                          width: 14,
                                          color: context.secondary,
                                          fit: BoxFit.cover,
                                        ),
                                        const Gap(10),
                                        Text(
                                          appointmentList[index].timingText,
                                          style: context.titleSmall?.copyWith(fontSize: 12, color: Colors.black.withOpacity(.7)),
                                        ),
                                      ],
                                    ),
                                    const Gap(10),
                                    Row(
                                      children: [
                                        AppImage.assets(
                                          assetName: Assets.images.location.path,
                                          height: 14,
                                          width: 14,
                                          color: context.secondary,
                                          fit: BoxFit.cover,
                                        ),
                                        const Gap(10),
                                        Text(
                                          appointmentList[index].streetName ?? '',
                                          style: context.titleSmall?.copyWith(fontSize: 12, color: Colors.black.withOpacity(.7)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Gap(14),
                                SizedBox(
                                  width: context.width * .8,
                                  child: Text(
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    appointmentList[index].description ?? '',
                                    style: context.titleSmall?.copyWith(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(.7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                },
              ),
            ),
          ),
          const Gap(20),
          Text(
            "Completed",
            style: context.displayMedium,
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: context.height * .5,
              child: ListView.builder(
                itemCount: appointmentList.length, // Number of list items
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: CupertinoColors.systemGreen,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.check_circle,
                              color: CupertinoColors.systemGreen,
                              size: 18,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(appointmentList[index].title),
                              const Gap(10),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      AppImage.assets(
                                        assetName: Assets.images.clock.path,
                                        height: 14,
                                        width: 14,
                                        color: context.secondary,
                                        fit: BoxFit.cover,
                                      ),
                                      const Gap(10),
                                      Text(
                                        appointmentList[index].timingText,
                                        style: context.titleSmall?.copyWith(fontSize: 12, color: Colors.black.withOpacity(.7)),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  Row(
                                    children: [
                                      AppImage.assets(
                                        assetName: Assets.images.location.path,
                                        height: 14,
                                        width: 14,
                                        color: context.secondary,
                                        fit: BoxFit.cover,
                                      ),
                                      const Gap(10),
                                      Text(
                                        appointmentList[index].streetName ?? '',
                                        style: context.titleSmall?.copyWith(fontSize: 12, color: Colors.black.withOpacity(.7)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(14),
                              SizedBox(
                                width: context.width * .8,
                                child: Text(
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  appointmentList[index].description ?? '',
                                  style: context.titleSmall?.copyWith(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ));
                },
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
