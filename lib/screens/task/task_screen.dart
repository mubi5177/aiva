import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/model/user_model.dart';
import 'package:aivi/screens/task/today/today_tasks.dart';
import 'package:aivi/widgets/app_drawer.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

enum DaysType { today, tomorrow, week, custom }

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _controller;
  late DrawerCubit _drawerCubit;

  @override
  void initState() {
    getData();
    _drawerCubit = BlocProvider.of<DrawerCubit>(context);
    super.initState();
    _controller = TabController(length: 4, vsync: this);
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
              text: "Today",
            ),
            Tab(
              text: "Tomorrow",
            ),
            Tab(
              text: "This Week",
            ),
            Tab(
              text: "Custom",
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> appointmentSnapshot) {
            if (appointmentSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (appointmentSnapshot.hasError) {
              return Center(child: Text('Error: ${appointmentSnapshot.error}'));
            }
            return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> taskSnapshot) {
                  if (taskSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (taskSnapshot.hasError) {
                    return Center(child: Text('Error: ${taskSnapshot.error}'));
                  }
                  return TabBarView(
                    controller: _controller,
                    children: [
                      TodaySTaskBar(
                        type: DaysType.today,
                        appointmentSnapshot: appointmentSnapshot,
                        taskSnapshot: taskSnapshot,
                      ),
                      TodaySTaskBar(
                        type: DaysType.tomorrow,
                        appointmentSnapshot: appointmentSnapshot,
                        taskSnapshot: taskSnapshot,
                      ),
                      TodaySTaskBar(
                        type: DaysType.week,
                        appointmentSnapshot: appointmentSnapshot,
                        taskSnapshot: taskSnapshot,
                      ),
                      TodaySTaskBar(
                        type: DaysType.custom,
                        appointmentSnapshot: appointmentSnapshot,
                        taskSnapshot: taskSnapshot,
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
