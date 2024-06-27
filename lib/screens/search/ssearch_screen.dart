import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/search/recent_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _controller;
  String searchText = '';
  Map<String, dynamic> searchDataResult = {
    'tasks': [],
    'notes': [],
    'appointments': [],
    'userHabits': [],
  };
  @override
  void initState() {
    super.initState();
    searchDataFromCollections("This is Task");
    _controller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.grey.shade50,
        title: TextFormField(
          onTap: () async {},
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
            // Call function to search Firestore collections
            searchData();
          },
          decoration: InputDecoration(
              prefixIcon: AppImage.svg(
                assetName: Assets.svgs.search,
                color: context.secondary,
              ),
              suffixIcon: const Icon(
                Icons.close,
                size: 20,
              ),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(.2)), borderRadius: BorderRadius.circular(14)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(.2)), borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(.2)), borderRadius: BorderRadius.circular(14)),
              hintText: AppStrings.search),
          keyboardType: TextInputType.name,

          // onSaved: (value) => _auth['email'] = value!,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
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
              text: "Recent",
            ),
            Tab(
              text: "Tasks",
            ),
            Tab(
              text: "Appointments",
            ),
            Tab(
              text: "Notes",
            ),
            Tab(
              text: "Habits",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: const [
          RecentSearchTab(),
          SearchEmptyScreen(
            screen: "Task",
          ),
          SearchEmptyScreen(
            screen: "Appointments",
          ),
          SearchEmptyScreen(
            screen: "Notes",
          ),
          SearchEmptyScreen(
            screen: "Habit",
          ),
        ],
      ),
    );
  }

  Future<void> searchData() async {
    String userId = getCurrentUserId(); // Replace with actual user ID
    String searchData = searchText.trim();

    try {
      // Query tasks collection
      var taskSnapshot =
          await FirebaseFirestore.instance.collection('tasks').where("userId", isEqualTo: userId).where('type_desc', isEqualTo: searchData).get();
      searchDataResult['tasks'] = taskSnapshot.docs.map((doc) => doc.data()).toList();

      // Query notes collection
      var notesSnapshot =
          await FirebaseFirestore.instance.collection('notes').where("userId", isEqualTo: userId).where('title', isEqualTo: searchData).get();
      searchDataResult['notes'] = notesSnapshot.docs.map((doc) => doc.data()).toList();

      // Query appointments collection
      var appointmentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where("userId", isEqualTo: userId)
          .where('type_desc', isEqualTo: searchData)
          .get();
      searchDataResult['appointments'] = appointmentsSnapshot.docs.map((doc) => doc.data()).toList();

      // Query userHabits collection
      var userHabitsSnapshot =
          await FirebaseFirestore.instance.collection('userHabits').where("userId", isEqualTo: userId).where('title', isEqualTo: searchData).get();
      searchDataResult['userHabits'] = userHabitsSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error retrieving data: $e');
      // Handle error as needed
    }

    setState(() {
      // Update UI with search results

      searchDataResult = searchDataResult;

    });
  }
}

class SearchEmptyScreen extends StatelessWidget {
  final String screen;
  const SearchEmptyScreen({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(200),
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
                "No $screen Found",
                style: context.titleSmall?.copyWith(color: context.primary, fontWeight: FontWeight.w500),
              ),
            ),
            const Gap(10),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "It looks like there are no $screen available.",
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

///--------------
