import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/action_cubit.dart';
import 'package:aivi/cubit/expansion_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/daily_habits/habits.dart';
import 'package:aivi/widgets/app_switch.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateNewHabbit extends StatefulWidget {
  const CreateNewHabbit({super.key});

  @override
  State<CreateNewHabbit> createState() => _CreateNewHabbitState();
}

class _CreateNewHabbitState extends State<CreateNewHabbit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ExpansionCubit _expansionCubit = ExpansionCubit();
  final ActionCubit _actionCubit = ActionCubit("At Habit Time");
  TimeOfDay? pickedTime;
  bool sendReminder = false;
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
                child: const Text("Create")),
          ],
        ),
      ),
      appBar: AppBarWithDrawer(
        backgroundColor: Colors.grey.shade50,
        isIconBack: true,
        centerTitle: true,
        title: AppStrings.addNewHabit,
        scaffoldKey: _scaffoldKey,
      ),
      body: BlocBuilder<ExpansionCubit, bool>(
        bloc: _expansionCubit,
        builder: (context, expanded) {
          return BlocBuilder<ActionCubit, String>(
            bloc: _actionCubit,
            builder: (context, action) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      const Gap(12),
                      TextFormField(
                        onTap: () async {},
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                            enabledBorder:
                                OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                            focusedBorder:
                                OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                            hintText: AppStrings.whatNeedToBeDone),
                        keyboardType: TextInputType.name,

                        // onSaved: (value) => _auth['email'] = value!,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const Gap(20),
                      Text(
                        "Repeat",
                        style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Wrap(
                          spacing: 5.0, // horizontal space between the tags
                          runSpacing: 10.0, // vertical space between the lines
                          children: List<Widget>.generate(weekList.length, (int index) {
                            return WeekWidget(
                              tagName: weekList[index].name,
                            );
                          }),
                        ),
                      ),
                      const Gap(20),
                      Text(
                        "Habit Time",
                        style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      const Gap(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppButton.primary(
                              onPressed: () async {
                                TimeOfDay initialTime = TimeOfDay.now();
                                pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: initialTime,
                                  builder: (BuildContext context, Widget? child) {
                                    return Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: child!,
                                    );
                                  },
                                );
                              },
                              height: 40,
                              width: 180,
                              background: context.secondary,
                              child: Text(pickedTime?.period.name ?? "12 : 30 PM")),
                          // InkWell(
                          //   onTap: () {
                          //     context.push(AppRoute.createNewHabits);
                          //   },
                          //   child: Container(
                          //     alignment: Alignment.center,
                          //     margin: const EdgeInsets.symmetric(horizontal: 10),
                          //     height: 40,
                          //     width: 180,
                          //     decoration: DottedDecoration(
                          //       shape: Shape.box,
                          //       color: Colors.black,
                          //       borderRadius: BorderRadius.circular(100), //remove this to get plane rectange
                          //     ),
                          //     child: Text(
                          //       "+   Add",
                          //       style: context.titleSmall?.copyWith(fontSize: 16, color: Colors.grey),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const Gap(20),
                      Text(
                        "Description",
                        style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      const Gap(12),
                      Container(
                        alignment: Alignment.center,
                        height: context.height * .36,
                        decoration:
                            BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // const Gap(10),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                child: TextField(
                                  maxLines: 10,
                                  // Set decoration to null to remove borders
                                  decoration: InputDecoration(
                                    hintText: "Describe in details",
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AppImage.assets(
                                    assetName: Assets.images.magicBrush.path,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const Gap(30),
                                  AppImage.assets(
                                    assetName: Assets.images.gallery.path,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const Gap(30),
                                  AppImage.assets(
                                    assetName: Assets.images.mic.path,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const Gap(30),
                                ],
                              ),
                            ),
                            // Container(
                            //   height: 60,
                            //   decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.end,
                            //     children: [
                            //       AppImage.assets(
                            //         assetName: Assets.images.magicBrush.path,
                            //         height: 30,
                            //         width: 30,
                            //       ),
                            //       const Gap(30),
                            //       AppImage.assets(
                            //         assetName: Assets.images.gallery.path,
                            //         height: 30,
                            //         width: 30,
                            //       ),
                            //       const Gap(30),
                            //       AppImage.assets(
                            //         assetName: Assets.images.mic.path,
                            //         height: 30,
                            //         width: 30,
                            //       ),
                            //       const Gap(30),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Send Reminder",
                            style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                          ),
                          AppSwitch(
                              value: sendReminder,
                              onChanged: (val) {
                                setState(() {
                                  sendReminder = !sendReminder;
                                });
                              }),
                        ],
                      ),
                      const Gap(12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ExpansionTile(
                          onExpansionChanged: (value) => _expansionCubit.onChanged(),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          trailing: Icon(
                            expanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                            size: 15,
                          ),
                          title: Text(action, style: context.titleSmall?.copyWith(fontSize: 15, color: context.primary)),
                        ),
                      ),
                      if (expanded)
                        Container(
                          decoration: ShapeDecoration(
                            color: context.onPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            shadows: [
                              BoxShadow(
                                color: context.primary.withOpacity(.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: BlocBuilder<ActionCubit, String>(
                            bloc: _actionCubit,
                            builder: (context, action) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      _actionCubit.onChanged("At Habit Time");
                                      _expansionCubit.reset();
                                    },
                                    title: Text(
                                      "At Habit Time",
                                      style: context.labelLarge?.copyWith(
                                        color: action == "Tasks" ? context.primary : context.tertiary,
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  ListTile(
                                    onTap: () {
                                      _actionCubit.onChanged("Appointments");
                                      _expansionCubit.reset();
                                    },
                                    title: Text(
                                      "Appointments",
                                      style: context.labelLarge?.copyWith(
                                        color: action == "Appointments" ? context.primary : context.tertiary,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
