import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:aivi/widgets/delete_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class NotesDetails extends StatelessWidget {
  final String noteId;
  NotesDetails({super.key, required this.noteId});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
        child: AppButton.outlineShrink(
            onPressed: () {
              context.push(AppRoute.editNotes, extra: noteId);
            },
            borderColor: context.secondary,
            height: 50,
            width: context.width * .9,
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
      ),
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithDrawer(
        backgroundColor: Colors.grey.shade50,
        isIconBack: true,
        centerTitle: true,
        title: AppStrings.notesDetails,
        scaffoldKey: _scaffoldKey,
        actions: [
          InkWell(
            onTap: () {
              context.showBottomSheet(
                  child: DeleteSheet(
                    docId: noteId,
                    collection: "notes",
                  ));
            },
            child: const Icon(
              Icons.more_horiz,
              size: 30,
            ),
          ),
          Gap(12),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('notes').doc(noteId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('An Error Occurred!'));
          }
          final Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          // Now you can use the data from the document as needed
          return Padding(
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
                    data['type'] ?? "Meeting",
                    style: context.labelLarge?.copyWith(color: const Color(0xff405FBA)),
                  ),
                ),
                const Gap(10),
                Text(
                  data['title'] ?? "Meeting Agenda",
                  style: context.displayLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Gap(14),
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
                      data['date'] ?? "6:00 PM",
                      style: context.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.6)),
                    )
                  ],
                ),
                SizedBox(
                  width: context.width,
                  height: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data['labels'].length ?? tagsList.length,
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
                            data['labels'][index],
                            style: context.labelLarge?.copyWith(color: Colors.black.withOpacity(.8)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data['description'].length ?? notesPointList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 0,
                          leading: const Icon(
                            Icons.circle,
                            size: 10,
                          ),
                          title: Text(
                            data['description'] ?? [index],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final List<String> tagsList = ["Urgent", "Finance", "Meeting", "Task"]; // Example list of tags
final List<String> notesPointList = [
  "Lorem ipsum dolor sit amet consectetur.",
  "Tristique egestas hac platea ullamcorper egesta",
  "pellentesque blandit mauris. Er",
  "Tristique donec bibendum egestas blandit nisi tortor at odio",
  "suscipit metus nisl.",
  "Sit vitae ultricies id egestas diam"
]; // Example list of tags
