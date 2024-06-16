import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../notes/notes_details.dart';

class TaskDetails extends StatefulWidget {
  final Map<String, dynamic> task;
  final String id;

  const TaskDetails({super.key, required this.task, required this.id});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    // List<dynamic> labels = widget.task['labels'];
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
                onPressed: () {
                  if (widget.task['type'].toString().toLowerCase() == 'appointments') {
                    context.push(AppRoute.editAppointment, extra: widget.id);
                  } else if (widget.task['type'].toString().toLowerCase() == 'tasks') {
                    context.push(AppRoute.editTask, extra: widget.id);
                  } else {}
                },
                isProcessing: isUploading,
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
            widget.task['isCompleted'] ?? false
                ? const SizedBox()
                : AppButton.primary(
                    isProcessing: isUploading,
                    onPressed: () async {
                      try {
                        setState(() {
                          isUploading = true;
                        });
                        var data = {"isCompleted": true};
                        await updateDataOnFirestore(widget.task['type'].toString().toLowerCase(), data, widget.id).then((value) {
                          setState(() {
                            isUploading = false;
                          });
                          Fluttertoast.showToast(
                            msg: "Mark Completed!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        });
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
                    },
                    height: 50,
                    width: 170,
                    background: context.secondary,
                    child: const Text("Mark Complete")),
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
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection(widget.task['type'].toString().toLowerCase()).doc(widget.id).get(),
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
                      "${data['type']}",
                      style: context.labelLarge?.copyWith(color: const Color(0xff405FBA)),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    "Meeting Agenda",
                    style: context.displayLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Gap(14),
                  Column(
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
                            "${data['date']}",
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
                          SizedBox(
                            width: context.width * .7,
                            child: Text(
                              '${data['location']}',
                              style: context.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(.6)),
                            ),
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
                      itemCount: data['labels'].length,
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
                  Text(
                    "${data['description']}",
                    style: context.titleMedium,
                  )
                ],
              ),
            );
          }),
    );
  }
}
