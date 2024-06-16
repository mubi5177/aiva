import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/action_cubit.dart';
import 'package:aivi/cubit/date_time_cubit.dart';
import 'package:aivi/cubit/expansion_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:aivi/widgets/date_time_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final ExpansionCubit _expansionCubit = ExpansionCubit();
  final ActionCubit _actionCubit = ActionCubit("Tasks");

  final DateTimeCubit _endDateTimeCubit = DateTimeCubit();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController label = TextEditingController();
TextEditingController title = TextEditingController();
TextEditingController description = TextEditingController();
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
        title: AppStrings.addNewTask,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Type",
                        style: context.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      const Gap(12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ExpansionTile(
                          enabled: false,
                          onExpansionChanged: null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          trailing: const SizedBox.shrink(),
                          // trailing: Icon(
                          //   expanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                          //   size: 15,
                          // ),
                          title: Text(action, style: context.titleLarge),
                          leading: action == "Tasks"
                              ? AppImage.assets(
                                  assetName: Assets.images.taskWithoutBg.path,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.cover,
                                  color: context.primary,
                                )
                              : AppImage.svg(
                                  assetName: Assets.svgs.notificatons,
                                  fit: BoxFit.cover,
                                  color: context.primary,
                                ),
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
                                      _actionCubit.onChanged("Tasks");
                                      _expansionCubit.reset();
                                    },
                                    title: Text(
                                      "Tasks",
                                      style: context.labelLarge?.copyWith(
                                        color: action == "Tasks" ? context.tertiary : context.primary,
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
                                        color: action == "Appointments" ? context.tertiary : context.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      const Gap(20),
                      Text(
                        "Label",
                        style: context.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      const Gap(12),
                      Container(
                        height: 110,
                        decoration:
                            BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
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
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                tagsList.removeWhere((element) => element == tagsList[index]);
                                              });
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              size: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                              Padding(
                              padding:const  EdgeInsets.symmetric(horizontal: 5.0),
                              child: TextField(
                                controller: label,

                                // Set decoration to null to remove borders
                                onSubmitted: (val) {
                                  tagsList.add(val.trim());
                                  setState(() {
                                    label.clear();
                                    // label.text=''
                                  });
                                },
                                decoration:const InputDecoration(
                                  hintText: "Search for Labels ",
                                  errorBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      Text(
                        "Title",
                        style: context.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      const Gap(12),
                      TextFormField(
                        controller: title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title required!';
                          }
                          return null;
                        },
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
                        "Description",
                        style: context.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      const Gap(12),
                      Container(
                        alignment: Alignment.center,
                        height: context.height * .5,
                        decoration:
                            BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(14)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                              Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                child: TextFormField(
                                  controller: description,
                                  maxLines: 15,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Title required!';
                                    }
                                    return null;
                                  },
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
                      ),
                      const Gap(20),
                      Text(
                        "Date",
                        style: context.displayMedium?.copyWith(fontWeight: FontWeight.w600, color: context.primary),
                      ),
                      const Gap(12),
                      BlocBuilder<DateTimeCubit, String>(
                        bloc: _endDateTimeCubit,
                        builder: (context, text) {
                          return TextFormField(
                            readOnly: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            enableInteractiveSelection: false,
                            controller: TextEditingController(text: text),
                            decoration: InputDecoration(
                              hintText: "When it needs to be end",
                              suffixIcon: InkWell(
                                onTap: () {
                                  context.closeKeyboard();
                                  context.showBottomSheet(
                                    maxHeight: context.height * .9,
                                    child: EndDateTimeSheet(dateName: "Due Date", dateTimeCubit: _endDateTimeCubit),
                                  );
                                },
                                // child: Transform.scale(scale: .5, child: AppImage.svg(size: 10, assetName: Assets.svg.clock)),
                                child: const Icon(Icons.calendar_month),
                              ),
                            ),
                          );
                        },
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

final List<String> tagsList = ["Urgent", "Finance", "Meeting", "Task", "Urgent", "Finance", "Meeting", "Task"]; // Example list of tags
