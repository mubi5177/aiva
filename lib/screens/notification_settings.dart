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
                                  child: EndDateTimeSheet(
                                      dateName: "End Time",
                                      dateTimeCubit: _endDateTimeCubit),
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
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.grey.shade700,
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
