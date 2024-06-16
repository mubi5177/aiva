import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/model/user_model.dart';
import 'package:aivi/widgets/app_drawer.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DrawerCubit _drawerCubit;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _listView1Controller = ScrollController();
  final ScrollController _listView2Controller = ScrollController();
  int? selectedIndex;
  int? selectedIndexCompleted;
  late ConfettiController _confettiController;

  @override
  void initState() {
    getData();

    _drawerCubit = BlocProvider.of<DrawerCubit>(context);
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
        physics: const ClampingScrollPhysics(),
        controller: _mainScrollController,
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
                    onPressed: () {
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
                height: context.height * .4,
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _listView1Controller,
                  physics: const ClampingScrollPhysics(),

                  itemCount: agendaList.length, // Number of list items
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: agendaList[index].isCompleted ? CupertinoColors.systemGreen : Colors.grey.shade200),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Stack(
                        children: [
                          ListTile(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              if (agendaList[index].isCompleted) {
                              } else {
                                _confettiController.play();
                              }
                            },
                            dense: true,
                            // isThreeLine: agendaList[index].timingText != null ? true : false,
                            contentPadding: const EdgeInsets.only(right: 20),
                            tileColor: Colors.transparent,
                            leading: agendaList[index].isCompleted
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: CupertinoColors.systemGreen,
                                      size: 18,
                                    ),
                                  )
                                : Radio(
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
                    );
                  },
                ),
              ),
              const Gap(20),
              Text(
                "Daily Habits  >",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(10),
              SizedBox(
                height: context.height * .18,
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

                      // Check if the document's user ID matches the current user ID
                      if (userId == currentUserId) {
                        currentUserDocuments.add(document);
                      }
                    }

                    if (currentUserDocuments.isEmpty) {
                      return const Center(child: Text('No documents found for the current user'));
                    }
                    return ListView.builder(
                      controller: _listView2Controller,
                      physics: const ClampingScrollPhysics(),
                      itemCount: currentUserDocuments.length,
                      // Number of list items
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final data = currentUserDocuments[index].data() as Map<String, dynamic>;
                        final docId = currentUserDocuments[index].id;
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
                              AppImage.network(
                                imageUrl: data['image'],
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                              const Gap(14),
                              Text(
                                data['title'],
                                style: context.titleSmall?.copyWith(fontSize: 14, color: context.primary, fontWeight: FontWeight.w700),
                              ),
                              const Gap(14),
                              data['isCompleted']
                                  ? AppButton.primary(
                                      height: 25,
                                      width: 120,
                                      background: const Color(0xFFE1F9E9),
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
                                              color: const Color(0xFF3DB65F),
                                            ),
                                          ),
                                        ],
                                      ))
                                  : AppButton.outlineShrink(
                                      onPressed: () async {
                                        // Vibration.vibrate();
                                        // _confettiController.play();
                                        // await Future.delayed(const Duration(seconds: 1));

                                        try {
                                          // Get reference to the document
                                          DocumentReference documentReference = FirebaseFirestore.instance
                                              .collection('userHabits')
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
  AgendaItems(isCompleted: false, title: "Attend Jay’s School Event", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(isCompleted: false, title: "Remind me to send the files", trailingIcon: Assets.images.bgBell.path, timingText: "12:00 PM - 02:00 PM"),
  AgendaItems(isCompleted: false, title: "Create logo for team", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(isCompleted: false, title: "Drop Jay to school", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(isCompleted: false, title: "Talk to the lawyer about case", trailingIcon: Assets.images.bgBell.path, timingText: "06:00 PM - 08:00 PM"),
  AgendaItems(isCompleted: false, title: "Meeting for new launch", trailingIcon: Assets.images.bgBell.path, timingText: "08:00 PM - 09:00 PM"),
  AgendaItems(isCompleted: true, title: "Attend Jay’s School Event", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(isCompleted: true, title: "Remind me to send the files", trailingIcon: Assets.images.bgBell.path, timingText: "12:00 PM - 02:00 PM"),
  AgendaItems(isCompleted: true, title: "Create logo for team", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(isCompleted: true, title: "Drop Jay to school", trailingIcon: Assets.images.bgMenu.path),
  AgendaItems(isCompleted: true, title: "Talk to the lawyer about case", trailingIcon: Assets.images.bgBell.path, timingText: "06:00 PM - 08:00 PM"),
  AgendaItems(isCompleted: true, title: "Meeting for new launch", trailingIcon: Assets.images.bgBell.path, timingText: "08:00 PM - 09:00 PM"),
];

class AgendaItems {
  final String title;
  final String trailingIcon;
  final String? timingText;
  final bool isCompleted;

  AgendaItems({required this.isCompleted, required this.title, this.timingText, required this.trailingIcon});
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
