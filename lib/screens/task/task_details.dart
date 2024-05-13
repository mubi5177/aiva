import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../notes/notes_details.dart';

class TaskDetails extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        alignment: Alignment.center,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton.outlineShrink(
                borderColor: context.secondary,
                height: 50,
                width: 170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage.svg(
                      assetName: Assets.svgs.edit,
                      color: context.secondary,
                    ),
                    const Gap(10),
                    Text(
                      AppStrings.edit,
                      style: context.displaySmall?.copyWith(color: context.secondary),
                    ),
                  ],
                )),
            const Gap(10),
            AppButton.primary(height: 50, width: 170, background: context.secondary, child: const Text("Mark Complete")),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithDrawer(
        backgroundColor: Colors.grey.shade50,
        isIconBack: true,
        centerTitle: true,
        title: AppStrings.taskDetails,
        scaffoldKey: _scaffoldKey,
        actions: const [
          Icon(
            Icons.more_horiz,
            size: 30,
          ),
          Gap(12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xfffe4e1fc),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Meeting",
                style: context.labelLarge?.copyWith(color: const Color(0xff405FBA)),
              ),
            ),
            const Gap(10),
            Text(
              "Meeting Agenda",
              style: context.displayLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Gap(14),
            Row(
              children: [
                Row(
                  children: [
                    AppImage.assets(
                      assetName: Assets.images.clock.path,
                      height: 20,
                      width: 20,
                      fit: BoxFit.cover,
                    ),
                    const Gap(10),
                    Text(
                      "6:00 PM - 8:00 PM",
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.6)),
                    )
                  ],
                ),
                const Gap(20),
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
                      'Samson Street',
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.6)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: context.width,
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tagsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffE4EAF9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tagsList[index],
                        style: context.labelLarge?.copyWith(color: Colors.black.withOpacity(.8)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              "Lorem ipsum dolor sit amet consectetur. Tellus potenti varius vestibulum nibh. Tristique egestas hac platea ullamcorper egestas imperdiet tempus. Aliquet dignissim sem faucibus pellentesque blandit mauris. Erat ullamcorper leo elit tincidunt. Urna est feugiat eu sapien magna. Tristique donec bibendum egestas blandit nisi tortor at odio. Netus pharetra quis sit sed mi at suscipit metus nisl. Sit vitae ultricies id egestas diam. Augue fringilla nisl ac venenatis amet nec dictum. Fringilla non vestibulum quis vitae elit porta. At vitae nunc risus pretium volutpat libero.",
              style: context.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}
