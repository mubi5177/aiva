import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/date_time_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/daily_habits/daily_habits.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:aivi/widgets/date_time_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

List<String> repeatDays = [];

class Habits extends StatefulWidget {
  const Habits({super.key});

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton.outlineShrink(
                borderColor: context.secondary,
                height: 50,
                width: 170,
                child: Text(
                  "Cancel",
                  style: context.displaySmall?.copyWith(color: context.secondary),
                )),
            const Gap(10.0),
            AppButton.primary(
                onPressed: () {
                  context.push(AppRoute.tabs);
                },
                height: 50,
                width: 170,
                background: context.secondary,
                child: const Text("Save")),
          ],
        ),
      ),
      appBar: AppBarWithDrawer(
        backgroundColor: Colors.grey.shade50,
        isIconBack: true,
        centerTitle: true,
        title: AppStrings.dailyHabit,
        scaffoldKey: _scaffoldKey,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Habits",
              style: context.displayMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const Gap(10),
            Text(
              "Select habits that you want to follow, we will remind you about them.",
              style: context.titleSmall,
            ),
            const Gap(20),
            InkWell(
              onTap: () {
                context.push(AppRoute.createNewHabits);
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
            const Gap(10),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('habits').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot doc = documents[index];
                        final data = documents[index].data() as Map<String, dynamic>;

                        return ExpandedTile(
                          documents: data,
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class WeekWidget extends StatefulWidget {
  final String tagName;

  const WeekWidget({Key? key, required this.tagName}) : super(key: key);

  @override
  _WeekWidgetState createState() => _WeekWidgetState();
}

class _WeekWidgetState extends State<WeekWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (isSelected) {
          repeatDays.add(widget.tagName);
          print('_WeekWidgetState.build before ${repeatDays.toString()}');
        } else {
          repeatDays.removeWhere((element) => element == widget.tagName);
          print('_WeekWidgetState.build after ${repeatDays.toString()}');
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 46,
        width: 46,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? context.secondary : Colors.transparent
            // borderRadius: BorderRadius.circular(200),
            ),
        child: Text(
          widget.tagName,
          style: context.titleSmall
              ?.copyWith(color: isSelected ? Colors.white : Colors.black.withOpacity(.8), fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}


///-----------------------------------------------------------------------------------------------------------------------------
class ExpandedTile extends StatefulWidget {
  final Map<String, dynamic> documents;

  const ExpandedTile({super.key, required this.documents});

  @override
  State<ExpandedTile> createState() => _ExpandedTileState();
}

class _ExpandedTileState extends State<ExpandedTile> {
  bool _expanded = false;
  double boxHeight = 76;
  final DateTimeCubit _endDateTimeCubit = DateTimeCubit();
  final DateTimeCubit _startDateTimeCubit = DateTimeCubit();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: context.width,
      height: boxHeight,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                AppImage.network(
                  imageUrl: widget.documents['image'] ?? Assets.images.dumbell.path,
                  height: 50,
                  width: 50,
                ),
                const Gap(10),
                Expanded(
                  child: Text(
                    widget.documents['title'] ?? "Gym Session",
                    style: context.titleSmall?.copyWith(color: context.primary),
                  ),
                ),
                AppButton.primary(
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                        if (_expanded) {
                          boxHeight = 295;
                        } else {
                          boxHeight = 76;
                        }
                      });
                    },
                    height: 30,
                    width: 100,
                    background: context.secondary,
                    child: Text(
                      _expanded ? "Unselect" : "Select",
                      style: context.titleSmall?.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          ),
          if (_expanded) ...{
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: context.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.primary,
                        ),
                      ),
                      const Gap(10),
                      BlocBuilder<DateTimeCubit, String>(
                        bloc: _startDateTimeCubit,
                        builder: (context, text) {
                          print('_ExpandedTileState.build: text $text');
                          return SizedBox(
                            height: 50,
                            width: 160,
                            child: TextFormField(
                              readOnly: true,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              enableInteractiveSelection: false,
                              controller: TextEditingController(text: text.split(" ")[0]),
                              decoration: InputDecoration(
                                border:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                focusedBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                hintText: "When it needs to be end",
                                suffixIcon: InkWell(
                                  onTap: () {
                                    context.closeKeyboard();
                                    context.showBottomSheet(
                                      maxHeight: context.height * .9,
                                      child: EndDateTimeSheet(

                                          isTask: false,
                                          dateName: "Start Date", dateTimeCubit: _startDateTimeCubit),
                                    );
                                  },
                                  // child: Transform.scale(scale: .5, child: AppImage.svg(size: 10, assetName: Assets.svg.clock)),
                                  child: const Icon(Icons.calendar_month),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "End Date",
                        style: context.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.primary,
                        ),
                      ),
                      const Gap(10),
                      BlocBuilder<DateTimeCubit, String>(
                        bloc: _endDateTimeCubit,
                        builder: (context, text) {
                          return SizedBox(
                            height: 50,
                            width: 160,
                            child: TextFormField(
                              readOnly: true,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              enableInteractiveSelection: false,
                              controller: TextEditingController(text: text.split(" ")[0]),
                              decoration: InputDecoration(
                                border:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                focusedBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                hintText: "When it needs to be end",
                                suffixIcon: InkWell(
                                  onTap: () {
                                    context.closeKeyboard();
                                    context.showBottomSheet(
                                      maxHeight: context.height * .9,
                                      child: EndDateTimeSheet(
                                          isTask: false,
                                          dateName: "End Date", dateTimeCubit: _endDateTimeCubit),
                                    );
                                  },
                                  // child: Transform.scale(scale: .5, child: AppImage.svg(size: 10, assetName: Assets.svg.clock)),
                                  child: const Icon(Icons.calendar_month),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Text(
                "Repeat",
                style: context.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primary,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  child: ListView.builder(
                      itemCount: weekList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ind, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: WeekWidget(
                            tagName: weekList[i].name,
                          ),
                        );
                      })),
            ),
          }
        ],
      ),
    );
  }
}

List<HabitModel> selectedHabitList = [];

class WeekModel {
  String name;
  WeekModel({required this.name});
}

List<WeekModel> weekList = [
  WeekModel(name: "Mon"),
  WeekModel(name: "Tue"),
  WeekModel(name: "Wed"),
  WeekModel(name: "Thur"),
  WeekModel(name: "Fri"),
  WeekModel(name: "Sat"),
  WeekModel(name: "Sun"),
];

class HabitModel {
  final String title;
  final List<String> repeatDays;
  final String pickedTime;
  final String description;
  final String startDate;
  final String endDate;
  final bool sendReminder;
  final String sendReminderAction;
  final String userId;
  final String image;
  final bool isCompleted;
  HabitModel(
      {required this.title,
      required this.repeatDays,
      required this.pickedTime,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.sendReminder,
      required this.sendReminderAction,
      required this.userId,
      this.image =
          "https://firebasestorage.googleapis.com/v0/b/aiva-e74f3.appspot.com/o/habits%2Fdumbell.png?alt=media&token=f985b21f-5aac-4067-a145-7a5b90be4625",
      this.isCompleted = false});
}
