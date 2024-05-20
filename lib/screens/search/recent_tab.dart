import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class RecentSearchTab extends StatefulWidget {
  const RecentSearchTab({super.key});

  @override
  State<RecentSearchTab> createState() => _RecentSearchTabState();
}

class _RecentSearchTabState extends State<RecentSearchTab> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            Container(
              height: 70,
              alignment: Alignment.center,
              width: context.width,
              padding: const EdgeInsets.symmetric(
                vertical: 10,

              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                color: Colors.white,
              ),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  child: ListView.builder(
                      itemCount: tagsList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ind, i) {
                        return TagWidget(
                          tagName: tagsList[i].name,
                        );
                      }),
                ),
              ),
            ),
            const Gap(20),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Number of list items
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(right: 20),
                      tileColor: Colors.transparent,
                      leading: Radio(
                        fillColor: MaterialStateColor.resolveWith((states) => context.secondary),
                        activeColor: context.secondary,
                        value: index,
                        groupValue: selectedIndex,
                        onChanged: (int? value) {
                          setState(() {
                            selectedIndex = value;
                          });
                        },
                      ),
                      title: Text('Attend Jay’s School Event'),
                      trailing: AppImage.assets(
                        assetName: Assets.images.bgMenu.path,
                        height: 30,
                        fit: BoxFit.cover,
                        width: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class TagWidget extends StatefulWidget {
  final String tagName;

  const TagWidget({Key? key, required this.tagName}) : super(key: key);

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? context.secondary : const Color(0xffE4EAF9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.tagName,
          style: context.labelLarge?.copyWith(color: isSelected ? Colors.white : Colors.black.withOpacity(.8)),
        ),
      ),
    );
  }
}

class TagsModel {
  String name;
  TagsModel({required this.name});
}

List<TagsModel> tagsList = [
  TagsModel(name: "Memes"),
  TagsModel(name: "Funny"),
  TagsModel(name: "Fun"),
  TagsModel(name: "Memes"),
  TagsModel(name: "Funny"),
  TagsModel(name: "Fun"),
  TagsModel(name: "Memes"),
  TagsModel(name: "Funny"),
  TagsModel(name: "Fun"),
  TagsModel(name: "Memes"),
  TagsModel(name: "Funny"),
];
