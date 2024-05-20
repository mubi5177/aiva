import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBarWithDrawer(
        centerTitle: true,
        backgroundColor: Colors.grey.shade50,
        isIconBack: true,
        title: AppStrings.addNewNote,
        scaffoldKey: _scaffoldKey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
              ),
              const Gap(12),
              TextFormField(
                onTap: () async {},
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                    hintText: AppStrings.whatNeedToBeDone),
                keyboardType: TextInputType.name,

                // onSaved: (value) => _auth['email'] = value!,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const Gap(20),
              Text(
                "Label",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
              ),
              const Gap(12),
              Container(
                height: 110,
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
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
                              child: Row(
                                children: [
                                  Text(
                                    tagsList[index],
                                    style: context.labelLarge?.copyWith(color: Colors.black.withOpacity(.8)),
                                  ),
                                  const Gap(5),
                                  Icon(
                                    Icons.close,
                                    size: 14,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    TextField(
                      // Set decoration to null to remove borders
                      decoration: InputDecoration(
                        hintText: "Search for Labels ",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Text(
                "Description",
                style: context.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
              ),
              const Gap(12),
              Container(
                alignment: Alignment.center,
                height: context.height * .5,
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                        child: TextField(
                          maxLines: 15,
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
                    Divider(
                      color: Colors.black.withOpacity(.8),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppImage.assets(
                            assetName: Assets.images.menuList.path,
                            height: 30,
                            width: 30,
                          ),
                          const Gap(30),
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final List<String> tagsList = ["Urgent", "Finance", "Meeting", "Task", "Urgent", "Finance", "Meeting", "Task"]; // Example list of tags
