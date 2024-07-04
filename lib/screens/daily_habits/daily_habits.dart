import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/model/user_model.dart';
import 'package:aivi/screens/search/ssearch_screen.dart';
import 'package:aivi/widgets/app_drawer.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:aivi/widgets/empty_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';

class DailyHabits extends StatefulWidget {
  const DailyHabits({super.key});

  @override
  State<DailyHabits> createState() => _DailyHabitsState();
}

class _DailyHabitsState extends State<DailyHabits> {
  late DrawerCubit _drawerCubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _listView1Controller = ScrollController();
  final ScrollController _listView2Controller = ScrollController();
  int? selectedIndex;

  @override
  void initState() {
    _drawerCubit = BlocProvider.of<DrawerCubit>(context);
    getData();
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
    _mainScrollController.dispose();
    _listView1Controller.dispose();

    _listView2Controller.dispose();
    super.dispose();
  }

  UserModel? currentUser;

  getData() async {
    currentUser = await getUserData();

    setState(() {});
  }

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
        title: "Good Morning, ${currentUser?.name ?? '---'}",
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
        controller: _mainScrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                height: 100,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
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
                      context.push(AppRoute.createNewHabits);
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
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('userHabits').snapshots(),
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
                      List<QueryDocumentSnapshot> currentUserDocuments = [];

                      for (var document in documents) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        String userId = data['userId']; // Assuming 'userId' is the field name for user ID in Firestore
                        bool isCompleted = data['isCompleted'];

                        // Check if the document's user ID matches the current user ID
                        if (userId == currentUserId && isCompleted == false) {
                          currentUserDocuments.add(document);
                        }
                      }

                      if (currentUserDocuments.isEmpty) {
                        return const Column(
                          children: [
                            Gap(60),
                            EmptyScreen(
                              screen: 'Habits',
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        controller: _listView1Controller,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: currentUserDocuments.length,
                        // itemCount: habitsItemsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = currentUserDocuments[index].data() as Map<String, dynamic>;
                          final docId = currentUserDocuments[index].id;
                          return YourHabits(
                            data: data,
                            docId: docId,
                          );
                        },
                      );
                    }),
              ),
              Text(
                "Completed",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                height: context.height * .4,
                // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey)),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('userHabits').snapshots(),
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
                            Gap(60),
                            EmptyScreen(
                              screen: 'Completed Habits',
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        controller: _listView2Controller,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: currentUserDocumentsCompleted.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = currentUserDocumentsCompleted[index].data() as Map<String, dynamic>;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                                leading: AppImage.network(
                                    imageUrl: data['image'].toString().isEmpty
                                        ? "https://firebasestorage.googleapis.com/v0/b/aiva-e74f3.appspot.com/o/habits%2Fdumbell.png?alt=media&token=f985b21f-5aac-4067-a145-7a5b90be4625"
                                        : data['image']),
                                title: Text(
                                  data['title'] ?? "",
                                  style: context.titleSmall?.copyWith(color: context.primary),
                                ),
                                subtitle: Text(
                                  data['pickedTime'] ?? "",
                                  style: context.titleSmall?.copyWith(fontSize: 12),
                                ),
                                trailing: AppButton.primary(
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
                                    ))),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YourHabits extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  const YourHabits({super.key, required this.data, required this.docId});

  @override
  State<YourHabits> createState() => _YourHabitsState();
}

class _YourHabitsState extends State<YourHabits> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: AppImage.network(imageUrl: widget.data['image']),
        title: Text(
          widget.data['title'],
          style: context.titleSmall?.copyWith(color: context.primary),
        ),
        subtitle: Text(
          widget.data['pickedTime'],
          style: context.titleSmall?.copyWith(fontSize: 12),
        ),
        trailing: Stack(
          children: [
            AppButton.outlineShrink(
                onPressed: () async {
                  Vibration.vibrate();
                  _confettiController.play();
                  await Future.delayed(const Duration(seconds: 1));

                  try {
                    // Get reference to the document
                    DocumentReference documentReference = FirebaseFirestore.instance
                        .collection('userHabits')
                        .doc(widget.docId.toString()); // Provide the document ID you want to update

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
                borderColor: context.secondary,
                height: 35,
                width: 125,
                child: Text(
                  "Mark Complete",
                  maxLines: 1,
                  style: context.titleSmall?.copyWith(fontSize: 10, color: context.secondary),
                )),
            // Positioned(left: 0, right: 0, top: 0, bottom: 0, child: AppImage.assets(assetName: Assets.gif.success.path,
            // height: 100,
            //   width: 100,
            //
            // )),
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
