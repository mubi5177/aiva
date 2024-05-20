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
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class Habits extends StatefulWidget {
  const Habits({super.key});

  @override
  State<Habits> createState() => _HabitsState();
}

class _HabitsState extends State<Habits> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateTimeCubit _endDateTimeCubit = DateTimeCubit();

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
      body: SingleChildScrollView(
        child: Padding(
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
              Container(
                width: context.width,
                height: 295,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200), color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          AppImage.assets(
                            assetName: Assets.images.dumbell.path,
                            height: 50,
                            width: 50,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Text(
                              "Gym Session",
                              style: context.titleSmall?.copyWith(color: context.primary),
                            ),
                          ),
                          AppButton.primary(
                              height: 30,
                              width: 100,
                              background: context.secondary,
                              child: Text(
                                "Unselect",
                                style: context.titleSmall?.copyWith(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
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
                                bloc: _endDateTimeCubit,
                                builder: (context, text) {
                                  return SizedBox(
                                    height: 50,
                                    width: 160,
                                    child: TextFormField(
                                      readOnly: true,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      enableInteractiveSelection: false,
                                      controller: TextEditingController(text: text),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                        hintText: "When it needs to be end",
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            context.closeKeyboard();
                                            context.showBottomSheet(
                                              maxHeight: context.height * .9,
                                              child: EndDateTimeSheet(
                                                  dateName: "Start Date",
                                                  dateTimeCubit: _endDateTimeCubit),
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
                                      controller: TextEditingController(text: text),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(14)),
                                        hintText: "When it needs to be end",
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            context.closeKeyboard();
                                            context.showBottomSheet(
                                              maxHeight: context.height * .9,
                                              child: EndDateTimeSheet(
                                                  dateName: "End Date",
                                                  dateTimeCubit: _endDateTimeCubit),
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
                  ],
                ),
              ),
              SizedBox(
                height: context.height * .35,
                // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey)),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: habitsItemsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        leading: AppImage.assets(assetName: habitsItemsList[index].icon),
                        title: Text(
                          habitsItemsList[index].title,
                          style: context.titleSmall?.copyWith(color: context.primary),
                        ),
                        trailing: AppButton.outlineShrink(
                            borderColor: context.secondary,
                            height: 30,
                            width: 100,
                            child: Text(
                              "Select",
                              maxLines: 1,
                              style: context.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: context.secondary),
                            )),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
