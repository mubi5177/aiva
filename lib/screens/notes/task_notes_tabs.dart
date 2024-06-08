import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/notes/notes_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class TaskNotesTab extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  const TaskNotesTab({super.key, required this.snapshot});

  @override
  State<TaskNotesTab> createState() => _TaskNotesTabState();
}

class _TaskNotesTabState extends State<TaskNotesTab> {
  @override
  Widget build(BuildContext context) {
    final List<QueryDocumentSnapshot> documents = widget.snapshot.data!.docs.where((element) => element['type'] == "Tasks").toList();
    if (documents.isNotEmpty) {
      return Container(
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: documents.length + 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  onTap: () {
                    context.push(AppRoute.addNewNotes);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 180,
                    width: 180,
                    decoration: DottedDecoration(
                      shape: Shape.box,
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10), //remove this to get plane rectange
                    ),
                    child: AppImage.assets(
                      assetName: Assets.images.newNote.path,
                      height: 80,
                      width: 80,
                    ),
                  ),
                );
              }
              int assetIndex = index - 1;
              final data = documents[assetIndex].data() as Map<String, dynamic>;
              final docId = documents[assetIndex].id;
              if (data['type'] == "Tasks") {
                return InkWell(
                  onTap: () {
                    context.push(AppRoute.notesDetails, extra: docId);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.0,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset.zero,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data['title'] ?? notesItemsList[assetIndex].title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: context.displaySmall,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xfffe4e1fc),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            data['type'] ?? notesItemsList[assetIndex].tag,
                            style: context.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: Color(0xff405FBA)),
                          ),
                        ),
                        Text(
                          data['description'] ?? notesItemsList[assetIndex].description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: context.displaySmall?.copyWith(color: Color(0xff6C6B6B)),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const EmptyScreen(screen: "Research");
              }
            },
          ),
        ),
      );
    } else {
      return const EmptyScreen(screen: "Task");
    }
  }
}

class NotesItems {
  final String title;
  final String tag;
  final String description;
  NotesItems({required this.title, required this.description, required this.tag});
}

List<NotesItems> notesItemsList = [
  NotesItems(title: "Meeting Agenda", description: 'Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris', tag: "Meeting"),
  NotesItems(
      title: "Research Findings", description: 'Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris', tag: "Research"),
  NotesItems(title: "To-Do List", description: 'Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris', tag: "Task"),
  NotesItems(title: "Design Mockups", description: 'Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris', tag: "Design"),
  NotesItems(title: "Budget Proposal", description: 'Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris', tag: "Finance"),
  NotesItems(title: "Meeting Agenda", description: 'Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris', tag: "Meeting"),
  NotesItems(title: "Meeting Agenda", description: 'Lorem ipsum dolor sit amet consectetur. Habitasse pretium leo tincidunt mauris', tag: "Meeting"),
];
