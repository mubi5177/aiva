import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/notes/notes_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';

class TodayTaskSection extends StatefulWidget {
  final List<QueryDocumentSnapshot> taskDocuments;

  const TodayTaskSection({super.key, required this.taskDocuments});

  @override
  State<TodayTaskSection> createState() => _TodayTaskSectionState();
}

class _TodayTaskSectionState extends State<TodayTaskSection> {
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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // At the bottom of ListView1
        _mainScrollController.animateTo(
          _mainScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // At the bottom of ListView2
        _mainScrollController.animateTo(
          _mainScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
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
          const Gap(20),
          if (widget.taskDocuments.isEmpty) ...{
            const Column(
              children: [
                EmptyScreen(
                  isAddButton: false,
                  screen: 'Tasks',
                ),
              ],
            ),
          } else ...{
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: context.height * .4,
                child: ListView.builder(
                  controller: _listView1Controller,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.taskDocuments.length,
                  // Number of list items
                  itemBuilder: (BuildContext context, int index) {
                    final task = widget.taskDocuments[index].data() as Map<String, dynamic>;
                    final docId = widget.taskDocuments[index].id;
                    return InkWell(
                      onTap: () {
                        context.push(AppRoute.taskDetails, extra: {"item": task, "id": docId});
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
                                    onChanged: (int? value) async {
                                      setState(() {
                                        selectedIndex = value;
                                      });
                                      _confettiController.play();
                                      Vibration.vibrate();
                                      _confettiController.play();
                                      await Future.delayed(const Duration(seconds: 1));

                                      try {
                                        // Get reference to the document
                                        DocumentReference documentReference = FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(docId.toString()); // Provide the document ID you want to update

                                        // Update the field
                                        documentReference.update({
                                          'isCompleted': true,
                                        }).then((value) {
                                          Fluttertoast.showToast(
                                            msg: "Completed!",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.SNACKBAR,
                                            backgroundColor: Colors.black54,
                                            textColor: Colors.white,
                                            fontSize: 14.0,
                                          );
                                        }).onError((error, stackTrace) {
                                          Fluttertoast.showToast(
                                            msg: error.toString(),
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.SNACKBAR,
                                            backgroundColor: Colors.black54,
                                            textColor: Colors.white,
                                            fontSize: 14.0,
                                          );
                                        });

                                        // context.pop();
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                          msg: e.toString(),
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.SNACKBAR,
                                          backgroundColor: Colors.black54,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );
                                      }
                                    },
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(width: context.width * 0.7, child: Text(task['type_desc'] ?? appointmentList[index].description)),
                                      const Gap(10),
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
                                            task['date'] ?? appointmentList[index].timingText,
                                            style: context.titleSmall?.copyWith(fontSize: 12, color: Colors.black.withOpacity(.7)),
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      if( task['location'].toString().isNotEmpty)...[
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

                                            SizedBox(
                                              width: context.width * .7,
                                              child: Text(
                                                task['location'] ?? appointmentList[index].streetName ?? '',
                                                style: context.titleSmall?.copyWith(fontSize: 12, color: Colors.black.withOpacity(.7)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(14),
                                      ],

                                      SizedBox(
                                        width: context.width * 0.7,
                                        child: Text(
                                          task['description'] ?? appointmentList[index].description ?? '',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
                                  blastDirection: 0,
                                  // radial value - DOWN
                                  particleDrag: 0.05,
                                  // apply drag to the confetti
                                  emissionFrequency: 0.05,
                                  // how often it should emit
                                  numberOfParticles: 20,
                                  // number of particles to emit
                                  gravity: 0.05,
                                  // gravity - or fall speed
                                  shouldLoop: false,
                                  // start again as soon as the animation is finished
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
          },
          const Gap(20),
          Text(
            "Completed",
            style: context.displayMedium,
          ),
          const Gap(20),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              // Retrieve the current user ID (assuming you have it stored somewhere)

              String currentUserId = getCurrentUserId();

              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              List<QueryDocumentSnapshot> currentUserDocumentsCompleted = [];

              for (var document in documents) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String userId = data['userId']; // Assuming 'userId' is the field name for user ID in Firestore
                bool isCompleted = data['isCompleted'] as bool;

                // Check if the document's user ID matches the current user ID
                if (userId == currentUserId && isCompleted == true) {
                  currentUserDocumentsCompleted.add(document);
                  print('_DailyHabitsState.build document $document');
                }
              }

              if (currentUserDocumentsCompleted.isEmpty) {
                return const Column(
                  children: [
                    EmptyScreen(
                      isAddButton: false,
                      screen: 'Completed Tasks',
                    ),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: context.height * .5,
                  child: ListView.builder(
                    controller: _listView2Controller,
                    physics: const ClampingScrollPhysics(),
                    itemCount: currentUserDocumentsCompleted.length, // Number of list items
                    itemBuilder: (BuildContext context, int index) {
                      final data = currentUserDocumentsCompleted[index].data() as Map<String, dynamic>;
                      final docId = currentUserDocumentsCompleted[index].id;
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
                                  Text(data['type_desc']),
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
                                            data['date'],
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
                                            data['location'],
                                            // appointmentList[index].streetName ?? '',
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
                                      // appointmentList[index].description ?? '',
                                      data['description'],
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
              );
            },
          ),
          const Gap(100),
        ],
      ),
    );
  }
}

// const Gap(40),
// Center(
// child: AppImage.assets(
// assetName: Assets.images.noTaskIcon.path,
// height: 80,
// width: 80,
// ),
// ),

// const Gap(20),
// Center(
// child: Text(
// "No Tasks or Reminder Found",
// style: context.titleSmall?.copyWith(color: context.primary, fontWeight: FontWeight.w500),
// ),
// ),
// const Gap(10),
// Center(
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 20.0),
// child: Text(
// "It looks like there are no tasks added for today. Try adding some tasks",
// textAlign: TextAlign.center,
// style: context.titleSmall,
// ),
// ),
// ),

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
