import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

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
            AppButton.primary(height: 50, width: 170, background: context.secondary, child: const Text("Save")),
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
          padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 10),
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

            ],
          ),
        ),
      ),
    );
  }
}
