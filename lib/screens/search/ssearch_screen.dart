import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/search/recent_tab.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _controller;

  @override
  void initState() {
    super.initState();
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
        children: [
          RecentSearchTab(),
          SizedBox(),
          SizedBox(),
          SizedBox(),
          SizedBox(),
        ],
      ),
    );
  }
}
