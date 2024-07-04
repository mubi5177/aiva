import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/search/ssearch_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:vibration/vibration.dart';

class SearchTasks extends StatelessWidget {
  final List<dynamic> data;

  const SearchTasks({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print('SearchTasks.build: $data');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: data.isEmpty
            ? const SearchEmptyScreen(screen: "Task/Appointments")
            : ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),

                itemCount: data.length, // Number of list items
                itemBuilder: (BuildContext context, int index) {
                  final dataS = data[index];

                  final docId = data[index]['id'];

                  return AgendaListItem(
                    index: index,
                    docId: docId,
                    data: dataS,
                  );
                },
              ),
      ),
    );
  }
}

class AgendaListItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  final int index;

  const AgendaListItem({super.key, required this.data, required this.docId, required this.index});

  @override
  State<AgendaListItem> createState() => AgendaListItemState();
}

class AgendaListItemState extends State<AgendaListItem> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();

    super.dispose();
  }

  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: widget.data['isCompleted'] ? CupertinoColors.systemGreen : Colors.grey.shade200),
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          ListTile(
            onTap: () async {
              setState(() {
                selectedIndex = widget.index;
              });
              if (widget.data['isCompleted']) {
              } else {
                Vibration.vibrate();
                _confettiController.play();
                await Future.delayed(const Duration(seconds: 1));

                try {
                  // Get reference to the document
                  DocumentReference documentReference = FirebaseFirestore.instance
                      .collection(widget.data['type'] == "tasks" ? 'tasks' : "appointments")
                      .doc(widget.docId.toString()); // Provide the document ID you want to update

                  // Update the field
                  documentReference.update({
                    'isCompleted': true,
                  }).then((value) {
                    Fluttertoast.showToast(
                      msg: "Completed!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(
                      msg: error.toString(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 14.0,
                    );
                  });

                  // context.pop();
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: e.toString(),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 14.0,
                  );
                }
              }
            },
            dense: true,
            // isThreeLine: agendaList[index].timingText != null ? true : false,
            contentPadding: const EdgeInsets.only(right: 20),
            tileColor: Colors.transparent,
            leading: widget.data['isCompleted']
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.check_circle,
                      color: CupertinoColors.systemGreen,
                      size: 18,
                    ),
                  )
                : Radio(
                    fillColor: MaterialStateColor.resolveWith((states) => context.secondary),
                    activeColor: context.secondary,
                    value: widget.index,
                    groupValue: selectedIndex,
                    onChanged: (int? value) async {
                      setState(() {
                        selectedIndex = value;
                      });
                      Vibration.vibrate();
                      _confettiController.play();
                      await Future.delayed(const Duration(seconds: 1));

                      try {
                        // Get reference to the document
                        DocumentReference documentReference = FirebaseFirestore.instance
                            .collection(widget.data['type'] == "tasks" ? 'tasks' : "appointments")
                            .doc(widget.docId.toString()); // Provide the document ID you want to update

                        // Update the field
                        documentReference.update({
                          'isCompleted': true,
                        }).then((value) {
                          Fluttertoast.showToast(
                            msg: "Completed!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        }).onError((error, stackTrace) {
                          Fluttertoast.showToast(
                            msg: error.toString(),
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 14.0,
                          );
                        });

                        // context.pop();
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: e.toString(),
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.SNACKBAR,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 14.0,
                        );
                      }
                    },
                  ),
            subtitle: widget.data['date'] != null
                ? Row(
                    children: [
                      AppImage.assets(
                        assetName: Assets.images.clock.path,
                        height: 14,
                        width: 14,
                        color: context.tertiary,
                        fit: BoxFit.cover,
                      ),
                      const Gap(10),
                      Text(widget.data['date'] ?? ""),
                    ],
                  )
                : const SizedBox.shrink(),
            title: Text((widget.data['type_desc'] ?? "")),
            trailing: AppImage.assets(
              assetName: Assets.images.bgMenu.path,
              height: 30,
              fit: BoxFit.cover,
              width: 30,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 0, // radial value - DOWN
              particleDrag: 0.05, // apply drag to the confetti
              emissionFrequency: 0.05, // how often it should emit
              numberOfParticles: 20, // number of particles to emit
              gravity: 0.05, // gravity - or fall speed
              shouldLoop: false, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ], // manually specify the colors to be used
            ),
          ),
        ],
      ),
    );
  }
}
