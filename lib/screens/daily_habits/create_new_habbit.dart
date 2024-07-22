import 'dart:math';

import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_calculate_dates.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/extensions/e_string_to_dateTime.dart';
import 'package:aivi/core/extensions/e_update_time.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/cubit/action_cubit.dart';
import 'package:aivi/cubit/date_time_cubit.dart';
import 'package:aivi/cubit/expansion_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/daily_habits/habits.dart';
import 'package:aivi/utils/services/firebase_messaging_handler.dart';
import 'package:aivi/widgets/app_switch.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:aivi/widgets/date_time_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final DateTimeCubit _endDateTimeCubit = DateTimeCubit();
  final DateTimeCubit _startDateTimeCubit = DateTimeCubit();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TimeOfDay? pickedTime;
  bool sendReminder = true;
  bool isUploading = false;

  @override
  void dispose() {
    repeatDays = [];
    super.dispose();
  }

  @override
  void initState() {
    repeatDays.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpansionCubit, bool>(
      bloc: _expansionCubit,
      builder: (context, expanded) {
        return BlocBuilder<ActionCubit, String>(
          bloc: _actionCubit,
          builder: (context, action) {
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              (pickedTime != null &&
                                  _endDateTimeCubit.state.isNotEmpty &&
                                  _startDateTimeCubit.state.isNotEmpty &&
                                  repeatDays.isNotEmpty &&
                                  _actionCubit.state != null)) {
                            try {
                              setState(() {
                                isUploading = true;
                              });
                              String userId = getCurrentUserId();

                              var data = {
                                "title": title.text.trim(),
                                "repeatDays": repeatDays,
                                "pickedTime": "${pickedTime?.hour}:${pickedTime?.minute}${pickedTime?.period.name}",
                                "description": description.text.trim(),
                                "startDate": _startDateTimeCubit.state,
                                "endDate": _endDateTimeCubit.state,
                                "sendReminder": sendReminder,
                                "sendReminderAction": action,
                                "userId": userId,
                                "image":
                                    "https://firebasestorage.googleapis.com/v0/b/aiva-e74f3.appspot.com/o/habits%2Fdumbell.png?alt=media&token=f985b21f-5aac-4067-a145-7a5b90be4625",
                                "isCompleted": false
                              };
                              await uploadDataToFirestore("userHabits", data).then((value) {
                                setState(() {
                                  isUploading = false;
                                });
                                Fluttertoast.showToast(
                                  msg: "Uploaded!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.SNACKBAR,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 14.0,
                                );
                                initiateNotifications();
                              }).onError((error, stackTrace) {
                                Fluttertoast.showToast(
                                  msg: error.toString(),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.SNACKBAR,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 14.0,
                                );
                                setState(() {
                                  isUploading = false;
                                });
                              });
                              context.pop();
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: e.toString(),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.SNACKBAR,
                                backgroundColor: Colors.black54,
                                textColor: Colors.white,
                                fontSize: 14.0,
                              );
                              setState(() {
                                isUploading = false;
                              });
                            }
                          }
                        },
                        height: 50,
                        width: 170,
                        background: context.secondary,
                        child: isUploading
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Create")),
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
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                          controller: title,
                          onTap: () async {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Title required!';
                            }
                            return null;
                          },
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
                        SizedBox(
                          height: 80,
                          width: context.width,
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
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                            // change the border color
                                            primary: context.secondary,
                                            secondary: context.secondary,
                                            // change the text color
                                            onSurface: Colors.black,
                                          ),
                                          // button colors
                                          buttonTheme: const ButtonThemeData(
                                            colorScheme: ColorScheme.light(
                                              primary: Colors.white,
                                            ),
                                          ),
                                        ),
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: child!,
                                        ),
                                      );
                                    },
                                  );
                                  setState(() {});
                                  print(
                                      '_CreateNewHabbitState.build pickedTime: ${pickedTime?.hour}:${pickedTime?.minute}${pickedTime?.period.name} ');
                                },
                                height: 40,
                                width: 180,
                                background: context.secondary,
                                child: Text("${pickedTime?.hour ?? "12"} : ${pickedTime?.minute ?? "20"} ${pickedTime?.period.name ?? "am"}")),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
                                      return SizedBox(
                                        height: 50,
                                        width: 160,
                                        child: TextFormField(
                                          readOnly: true,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          enableInteractiveSelection: false,
                                          controller: TextEditingController(text: text.split(" ")[0]),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // const Gap(10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                  child: TextFormField(
                                    controller: description,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Description required!';
                                      }
                                      return null;
                                    },

                                    maxLines: 10,
                                    // Set decoration to null to remove borders
                                    decoration: const InputDecoration(
                                      hintText: "Describe in details",
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black.withOpacity(.8),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                          color: action == "At Habit Time" ? context.primary : context.tertiary,
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    ListTile(
                                      onTap: () {
                                        _actionCubit.onChanged("10 minutes before");
                                        _expansionCubit.reset();
                                      },
                                      title: Text(
                                        "10 minutes before",
                                        style: context.labelLarge?.copyWith(
                                          color: action == "10 minutes before" ? context.primary : context.tertiary,
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  void initiateNotifications() {
    // Create an instance of Random


    DateTime startDate = _startDateTimeCubit.state.toDateTime();
    DateTime endDate = _endDateTimeCubit.state.toDateTime();

    List<DateTime> allDates = startDate.datesUntilWithTime(endDate);
    String time = "${pickedTime?.hour}:${pickedTime?.minute}";
    // Print all dates

    for (DateTime date in allDates) {
      // Parse the original date-time string into a DateTime object
      DateTime originalDateTime = DateTime.parse(date.toString());

      // Update the time part of the original DateTime using the extension method
      DateTime updatedDateTime = originalDateTime.updateTime(time);

      //   // Print or use the updated date-time
      print("updatedDateTime: $updatedDateTime"); // Output:
      // print('_CreateNewHabbitState.initiateNotifications: ${DateTime.now().add(Duration(seconds: 10))}');
      FirebaseMessagingHandler().scheduleNotification(
        id: Random().nextInt(100),
        title: title.text.trim(),
        body: description.text.trim(),
        scheduledNotificationDateTime: updatedDateTime,
      );
    }
  }
}
