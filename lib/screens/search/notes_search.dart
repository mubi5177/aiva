import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/screens/search/ssearch_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class NotesSearchTasks extends StatelessWidget {
  final List<dynamic> data;

  const NotesSearchTasks({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print('SearchTasks.build: $data');
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: data.isEmpty
              ? const SearchEmptyScreen(screen: "Task/Appointments")
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: data.length,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (context, index) {
                    final dataS = data[index];
                    final docId = data[index]['id'];
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
                              dataS['title'] ?? "",
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
                                dataS['type'] ?? "",
                                style: context.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: Color(0xff405FBA)),
                              ),
                            ),
                            Text(
                              dataS['description'] ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: context.displaySmall?.copyWith(color: Color(0xff6C6B6B)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}
