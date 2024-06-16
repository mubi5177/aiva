import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/model/user_model.dart';
import 'package:aivi/screens/notes/all_notes_tab.dart';
import 'package:aivi/screens/notes/design_notes_tab.dart';
import 'package:aivi/screens/notes/meeting_notes_tab.dart';
import 'package:aivi/screens/notes/research_notes_tab.dart';
import 'package:aivi/screens/notes/task_notes_tabs.dart';
import 'package:aivi/screens/search/recent_tab.dart';
import 'package:aivi/widgets/app_drawer.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _controller;
  late DrawerCubit _drawerCubit;

  @override
  void initState() {
    getData();
    _drawerCubit = BlocProvider.of<DrawerCubit>(context);
    super.initState();
    _controller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  UserModel? currentUser;

  getData() async {
    currentUser = await getUserData();

    setState(() {});
  }

//A
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      key: _scaffoldKey,
      onDrawerChanged: (value) => _drawerCubit.onChanged(value),
      appBar: AppBarWithDrawer(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        centerTitle: false,
        isDrawerIcon: true,
        backgroundColor: Colors.grey.shade50,
        isIconBack: false,
        title: "Good Morning, ${currentUser?.name ?? '---'}",
        scaffoldKey: _scaffoldKey,
        actions: [
          AppImage.svg(assetName: Assets.svgs.notificatons),
          const Gap(10),
          InkWell(
              onTap: () {
                context.push(AppRoute.searchScreen);
              },
              child: AppImage.svg(assetName: Assets.svgs.search)),
          const Gap(10),
        ],
        bottom: TabBar(
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          isScrollable: true,
          controller: _controller,
          labelColor: context.secondary,
          indicatorColor: context.secondary,
          unselectedLabelColor: context.primary,
          labelStyle: context.titleLarge?.copyWith(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(
              text: "All",
            ),
            Tab(
              text: "Meeting",
            ),
            Tab(
              text: "Research",
            ),
            Tab(
              text: "Task",
            ),
            Tab(
              text: "Design",
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('notes').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return TabBarView(
              controller: _controller,
              children: [
                AllNotesTab(
                  snapshot: snapshot,
                ),
                MeetingNotesTab(
                  snapshot: snapshot,
                ),
                ResearchNotesTab(
                  snapshot: snapshot,
                ),
                TaskNotesTab(
                  snapshot: snapshot,
                ),
                DesignNotesTab(
                  snapshot: snapshot,
                ),
              ],
            );
          }),
    );
  }
}

class EmptyScreen extends StatelessWidget {
  final String screen;

  const EmptyScreen({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            InkWell(
              onTap: () {
                context.push(AppRoute.addNewNotes);
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
            const Gap(40),
            Center(
              child: AppImage.assets(
                assetName: Assets.images.noTaskIcon.path,
                height: 80,
                width: 80,
              ),
            ),
            const Gap(20),
            Center(
              child: Text(
                "No $screen notes Found",
                style: context.titleSmall?.copyWith(color: context.primary, fontWeight: FontWeight.w500),
              ),
            ),
            const Gap(10),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "It looks like there are no notes added for today. Try adding some notes",
                  textAlign: TextAlign.center,
                  style: context.titleSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
