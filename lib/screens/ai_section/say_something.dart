import 'dart:math';

import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/extensions/e_formated_to_datetime.dart';
import 'package:aivi/core/extensions/e_formatted_dates.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/model/user_model.dart';
import 'package:aivi/screens/ai_section/edit_ai_notes.dart';
import 'package:aivi/screens/ai_section/edit_ai_task.dart';
import 'package:aivi/utils/services/firebase_messaging_handler.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SaySomething extends StatefulWidget {
  final String? recordedText;
  const SaySomething({super.key, this.recordedText});
  @override
  _SaySomethingState createState() => _SaySomethingState();
}

class _SaySomethingState extends State<SaySomething> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textController = TextEditingController();

  UserModel? currentUser;

  getData() async {
    currentUser = await getUserData();
  }

  @override
  void initState() {
    if ((widget.recordedText ?? "").isNotEmpty) {
      textController.text = widget.recordedText!;
      setState(() {});
    }
    super.initState();
    getData();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    print('_TabsPageState._onSpeechResult: ${textController.text}');
    setState(() {
      isListening = true;
      textController.text = '';
    });
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 30),
      localeId: "en_En",
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.confirmation,
    );
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  ///
  void _stopListening() async {
    isListening = false;
    await _speechToText.stop();

    setState(() {});
  }

  bool isListening = false;

  bool _speechEnabled = false;
  String _lastWords = "";

  final SpeechToText _speechToText = SpeechToText();

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = '';
      _lastWords = "$_lastWords${result.recognizedWords} ";
      print('_TabsPageState._onSpeechResult: $_lastWords}');

      textController.clear();

      textController.text = _lastWords;
    });
    // print('_TabsPageState._onSpeechResult: ${textController.text}');
  }

  List<Widget> messages = [
    // ChatMessage(
    //   isMediaIncluded: false,
    //   message: 'Create a reminder to send files to Jegan tomorrow',
    //   isSentByMe: true,
    // ),
    // ChatMessage(
    //   isMediaIncluded: true,
    //   message: 'Sure, Here is reminder preview',
    //   isSentByMe: false,
    // ),
    // ChatMessage(
    //   isMediaIncluded: false,
    //   message: 'Also add a description that the files should be in pdf format',
    //   isSentByMe: true,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithDrawer(
        backgroundColor: Colors.white,
        isIconBack: true,
        centerTitle: true,
        title: "Say Something",
        scaffoldKey: _scaffoldKey,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "You can ask me to add notes, input habit time, add food intake",
                textAlign: TextAlign.center,
                style: context.titleSmall?.copyWith(color: context.primary),
              ),
            ),
            const Gap(10),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: messages.map((message) {
                  return message;
                }).toList(),
              ),
            ),

            // AppImage.assets(
            //   assetName: Assets.gif.loading.path,
            //   color: context.secondary,
            //   height: 50,
            //   width: 50,
            // ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: isListening ? _stopListening : _startListening,
                    child: AppImage.assets(
                      assetName: Assets.images.logoBar.path,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(10),
                  if (!isListening) ...{
                    Expanded(
                      child: Stack(
                        children: [
                          TextField(
                            controller: textController,

                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(right: 40, left: 10),
                              hintText: 'Type message',
                              border:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                              enabledBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
                            ),
                            // Add controller and onChanged for message input handling
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            top: 10,
                            child: InkWell(
                              onTap: sendMessage,
                              child: AppImage.assets(
                                assetName: Assets.images.send.path,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                  } else ...{
                    AppImage.assets(
                      assetName: Assets.gif.audio.path,
                      color: context.secondary,
                    ),
                  }
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isFetchingData = false;
  void fetchData() async {
    ApiResponse? task = await callApi(textController.text.trim());
    if (task != null) {
      textController.clear();
      _lastWords = '';
      print('Action: ${task.action}');
      print('Task Title: ${task.entities['task_title']}');
      print('Task Content: ${task.entities['task_content']}');
      print('Task Due Date: ${task.entities['task_due_date']}');
      // Handle task data as needed
      String formattedDate = '';
      if (task.entities['task_due_date'] != null) {
        formattedDate = task.entities['task_due_date']!.toString().formatDateString();
      } else {
        // Format the DateTime object using DateFormat from intl package
        formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
      }

      setState(() {
        messages.add(ChatMessage(
            ownProfile: currentUser?.profile ?? AppStrings.dummyImage,
            actionTitle: task.entities['task_title'] ?? '',
            actionDate: formattedDate,
            actionDescription: task.entities['task_content'] ?? '',
            message: "Sure! Here ${task!.action == 'create_note' ? 'Notes' : 'Task'} is the preview",
            isMediaIncluded: true,
            action: task!.action == 'create_note' ? 'Notes' : 'Tasks',
            isSentByMe: false));
      });
    } else {
      print('Failed to fetch task data.');
      context.showSnackBar(text: "Please try again with correct command!");
      // Handle error scenario
    }
  }

  void sendMessage() {
    setState(() {
      messages.add(
        ChatMessage(
          ownProfile: currentUser?.profile ?? AppStrings.dummyImage,
          isMediaIncluded: false,
          message: textController.text,
          isSentByMe: true,
        ),
      );
    });
    fetchData();
  }
}

class ChatMessage extends StatelessWidget {
  final DateTime? dateTime;
  final String? actionDescription;
  final String? actionTitle;
  final String? action;
  final String? actionDate;
  final String message;
  final bool isSentByMe;
  final bool isMediaIncluded;
  final String ownProfile;

  const ChatMessage({
    Key? key,
    this.action,
    this.dateTime,
    required this.ownProfile,
    this.actionDate,
    this.actionDescription,
    this.actionTitle,
    required this.message,
    required this.isMediaIncluded,
    required this.isSentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? date = actionDate?.toDate();
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSentByMe) // Show user avatar only for messages not sent by the current user
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(Assets.images.logo.path),
                radius: 16,
              ),
            ),
          Container(
            constraints: const BoxConstraints(maxWidth: 300),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isSentByMe ? const Color(0xffEAF0FF) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: isMediaIncluded
                ? Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const Gap(10),
                        Container(
                          width: 220,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200), color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Gap(16),
                              Container(
                                padding: const EdgeInsets.all(2),
                                width: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: Colors.grey.shade200),
                                    color: const Color(0xffE4E1FC)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppImage.svg(
                                      assetName: Assets.svgs.notificatons,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    Text(
                                      action ?? "",
                                      style: context.displaySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  actionTitle ?? "Send files to Jegan",
                                  style: context.titleSmall?.copyWith(color: context.primary),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Gap(10),
                              Text(
                                actionDescription ?? "No Description",
                                style: context.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 16,
                                    color: context.secondary,
                                  ),
                                  const Gap(10),
                                  if (!(action!.trim().toLowerCase() == "notes"))
                                    Text(
                                      actionDate ?? "30, April 2024",
                                      style: context.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton.outlineShrink(
                                onPressed: () {
                                  if (action!.trim().toLowerCase() == "notes") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => EditAINotes(
                                          title: actionTitle ?? "",
                                          description: actionDescription ?? '',
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => EditAIAppointment(
                                          title: actionTitle ?? "",
                                          date: date ?? DateTime.now(),
                                          description: actionDescription ?? '',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                borderColor: context.secondary,
                                height: 30,
                                width: 100,
                                child: Text(
                                  "Edit",
                                  style: context.displaySmall?.copyWith(fontSize: 12, color: context.secondary, fontWeight: FontWeight.w600),
                                )),
                            const Gap(10.0),
                            AppButton.primary(
                                onPressed: () async {
                                  if (action!.trim().toLowerCase() == "notes") {
                                    try {
                                      String userId = getCurrentUserId();
                                      var data = {
                                        "title": actionTitle,
                                        "type": "Tasks",
                                        "labels": tagsList,
                                        "description": actionDescription,
                                        "date": date.toString(),
                                        "userId": userId,
                                      };
                                      await uploadDataToFirestore("notes", data).then((value) {
                                        Fluttertoast.showToast(
                                          msg: "Uploaded!",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.SNACKBAR,
                                          backgroundColor: Colors.black54,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );

                                        FirebaseMessagingHandler().scheduleNotification(
                                          id: Random().nextInt(1000),
                                          title: actionTitle,
                                          body: actionDescription,
                                          scheduledNotificationDateTime: date ?? DateTime.now().add(const Duration(hours: 5)),
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
                                      context.pop();
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
                                  } else {
                                    try {
                                      String userId = getCurrentUserId();
                                      var data = {
                                        "type_desc": actionTitle,
                                        "type": action,
                                        "labels": tagsList,
                                        "description": actionDescription,
                                        "location": "",
                                        "date": date.toString(),
                                        "userId": userId,
                                        "isCompleted": false
                                      };
                                      await uploadDataToFirestore(
                                        "tasks",
                                        data,
                                      ).then((value) {
                                        Fluttertoast.showToast(
                                          msg: "Updated Successfully!",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.SNACKBAR,
                                          backgroundColor: Colors.black54,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );

                                        FirebaseMessagingHandler().scheduleNotification(
                                          id: Random().nextInt(100),
                                          title: actionTitle,
                                          body: actionDescription,
                                          scheduledNotificationDateTime: date ?? DateTime.now().add(const Duration(hours: 5)),
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
                                      context.pop();
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
                                height: 30,
                                width: 100,
                                background: context.secondary,
                                child: Text(
                                  "Confirm",
                                  style: context.displaySmall?.copyWith(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                      ],
                    ),
                  )
                : Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
          ),
          if (isSentByMe) // Show user avatar only for messages not sent by the current user
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(14.0),
                  child: AppImage.network(
                    imageUrl: ownProfile,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(20.0),
                    placeholder: (_, __) => CircleAvatar(backgroundColor: context.primary.withOpacity(.2)),
                    errorWidget: (_, __, ___) => CircleAvatar(backgroundColor: context.primary.withOpacity(.2)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
