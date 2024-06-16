import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/date_time_cubit.dart';
import 'package:aivi/widgets/app_switch.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:aivi/widgets/date_time_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool dailyReview = false;
  bool weeklyReview = false;
  bool habit = false;
  TimeOfDay? pickedTimeMorning;
  TimeOfDay? pickedTimeEvening;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithDrawer(
        backgroundColor: Colors.grey.shade50,
        isIconBack: true,
        centerTitle: true,
        title: AppStrings.notificationSettings,
        scaffoldKey: _scaffoldKey,
        actions: [
          InkWell(onTap: (){
            print('_NotificationSettingsState.build dailyReview: $dailyReview');
            print('_NotificationSettingsState.build weeklyReview: $weeklyReview');
            print('_NotificationSettingsState.build habit: $habit');
            print('_NotificationSettingsState.build pickedTimeMorning:  "${pickedTimeMorning?.hour ?? "12"} : ${pickedTimeMorning?.minute ?? "20"} ${pickedTimeMorning?.period.name ?? "am"}"),');
            print('_NotificationSettingsState.build pickedTimeEvening:  "${pickedTimeEvening?.hour ?? "12"} : ${pickedTimeEvening?.minute ?? "20"} ${pickedTimeEvening?.period.name ?? "am"}"),');
            print('_NotificationSettingsState.build pickedTimeEvening:  "${pickedTimeEvening?.hour ?? "12"} : ${pickedTimeEvening?.minute ?? "20"} ${pickedTimeEvening?.period.name ?? "am"}"),');
            },
            child: Text(
              "Save",
              style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
            ),
          ),
          const Gap(30),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
          child: Column(
            children: [
              const Gap(10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                height: context.height * .37,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily Review",
                          style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                        ),
                        AppSwitch(
                            value: dailyReview,
                            onChanged: (val) {
                              setState(() {
                                dailyReview = !dailyReview;
                              });
                            }),
                      ],
                    ),
                    const Gap(20),
                    Text(
                      "Morning",
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                    ),
                    const Gap(10),
                    Text(
                      "To Plan the day",
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    const Gap(10),
                    BlocBuilder<DateTimeCubit, String>(
                      bloc: _endDateTimeCubit,
                      builder: (context, text) {
                        return TextFormField(
                          readOnly: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: false,
                          controller: TextEditingController(
                              text:
                                  "${pickedTimeMorning?.hour ?? "12"} : ${pickedTimeMorning?.minute ?? "20"} ${pickedTimeMorning?.period.name ?? "am"}"),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            hintText: "",
                            suffixIcon: InkWell(
                              onTap: () async {
                                context.closeKeyboard();
                                TimeOfDay initialTime = TimeOfDay.now();
                                pickedTimeMorning = await showTimePicker(
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
                              },
                              // child: Transform.scale(scale: .5, child: AppImage.svg(size: 10, assetName: Assets.svg.clock)),
                              child: Icon(
                                Icons.watch_later_outlined,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const Gap(20),
                    Text(
                      "Evening",
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                    ),
                    const Gap(10),
                    Text(
                      "To review the day",
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w400),
                    ),
                    const Gap(10),
                    BlocBuilder<DateTimeCubit, String>(
                      bloc: _endDateTimeCubit,
                      builder: (context, text) {
                        return TextFormField(
                          readOnly: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: false,
                          controller: TextEditingController(
                              text:
                                  "${pickedTimeEvening?.hour ?? "12"} : ${pickedTimeEvening?.minute ?? "20"} ${pickedTimeEvening?.period.name ?? "am"}"),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            hintText: "",
                            suffixIcon: InkWell(
                              onTap: () async {
                                context.closeKeyboard();
                                TimeOfDay initialTime = TimeOfDay.now();
                                pickedTimeEvening = await showTimePicker(
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
                              },
                              // child: Transform.scale(scale: .5, child: AppImage.svg(size: 10, assetName: Assets.svg.clock)),
                              child: Icon(
                                Icons.watch_later_outlined,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                height: context.height * .2,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly Review",
                          style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                        ),
                        AppSwitch(
                            value: weeklyReview,
                            onChanged: (val) {
                              setState(() {
                                weeklyReview = !weeklyReview;
                              });
                            }),
                      ],
                    ),
                    const Gap(20),
                    Text(
                      "Day and Time",
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                    ),
                    const Gap(20),
                    BlocBuilder<DateTimeCubit, String>(
                      bloc: _endDateTimeCubit,
                      builder: (context, text) {
                        return TextFormField(
                          readOnly: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: false,
                          controller: TextEditingController(text: text),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            hintText: "",
                            suffixIcon: InkWell(
                              onTap: () {
                                context.closeKeyboard();
                                context.showBottomSheet(
                                  maxHeight: context.height * .9,
                                  child: EndDateTimeSheet(dateName: "End Time", dateTimeCubit: _endDateTimeCubit),
                                );
                              },
                              // child: Transform.scale(scale: .5, child: AppImage.svg(size: 10, assetName: Assets.svg.clock)),
                              child: Icon(
                                Icons.watch_later_outlined,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                height: context.height * .07,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Habit",
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                    ),
                    AppSwitch(
                        value: habit,
                        onChanged: (val) {
                          setState(() {
                            habit = !habit;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final DateTimeCubit _endDateTimeCubit = DateTimeCubit();
}

var data = {
  "dailyReviewEnabled": true, //false,
  "dailyReviewMorningTime": "",
  "dailyReviewEveningTime": "",
  "weeklyReviewEnabled": true, //false,
  "weeKlyDayAndTime": "",
  "habitRemainderEnabled": true, //false,
};
