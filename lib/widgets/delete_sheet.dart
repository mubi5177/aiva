import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteSheet extends StatelessWidget {
  final String docId;
  final String collection;

  const DeleteSheet({super.key, required this.docId, required this.collection});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
          child: ListTile(
            onTap: () async {
              await deleteDocument(docId, collection);
              context.pop();
              context.pop();
            },
            leading: const Icon(Icons.delete),
            title: const Text("Delete"),
          ),
        )
      ],
    );
  }
}
