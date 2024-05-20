import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:confetti/confetti.dart';
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
  late ConfettiController _confettiController;

  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _listView1Controller = ScrollController();
  final ScrollController _listView2Controller = ScrollController();
  int? selectedIndex;

  @override
  void initState() {
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));

    super.initState();
    _listView1Controller.addListener(_listView1Listener);
    _listView2Controller.addListener(_listView2Listener);
  }

  void _listView1Listener() {
    if (_listView1Controller.position.atEdge) {
      if (_listView1Controller.position.pixels == 0) {
        // At the top of ListView1
        _mainScrollController.animateTo(
          _mainScrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // At the bottom of ListView1
        _mainScrollController.animateTo(
          _mainScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _listView2Listener() {
    if (_listView2Controller.position.atEdge) {
      if (_listView2Controller.position.pixels == 0) {
        // At the top of ListView2
        _mainScrollController.animateTo(
          _mainScrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // At the bottom of ListView2
        _mainScrollController.animateTo(
          _mainScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();

    _mainScrollController.dispose();
    _listView1Controller.dispose();
    _listView2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _mainScrollController,
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
              height: context.height * .4,
              child: ListView.builder(
                controller: _listView1Controller,
                physics: const ClampingScrollPhysics(),
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
                        child: Stack(
                          children: [
                            Row(
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
                                    _confettiController.play();
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
                            ),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: ConfettiWidget(
                                confettiController: _confettiController,
                                blastDirection: 0, // radial value - DOWN
                                particleDrag: 0.05, // apply drag to the confetti
                                emissionFrequency: 0.05, // how often it should emit
                                numberOfParticles: 20, // number of particles to emit
                                gravity: 0.05, // gravity - or fall speed
                                shouldLoop: false, // start again as soon as the animation is finished
                                colors: const [
                                  Colors.green,
                                  Colors.blue,
                                  Colors.pink,
                                  Colors.orange,
                                  Colors.purple,
                                ], // manually specify the colors to be used
                              ),
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
                controller: _listView2Controller,
                physics: const ClampingScrollPhysics(),
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
          const Gap(100),
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
