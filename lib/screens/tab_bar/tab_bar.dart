import 'dart:async';
import 'dart:io';

import 'package:aivi/config/routes/app_routes.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/core/helper/helper_funtions.dart';
import 'package:aivi/cubit/drawer_cubit.dart';
import 'package:aivi/cubit/tab_cubit.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/screens/daily_habits/daily_habits.dart';
import 'package:aivi/screens/dashboard/dashboard.dart';
import 'package:aivi/screens/notes/notes_screen.dart';
import 'package:aivi/screens/task/task_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:livespeechtotext/livespeechtotext.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final List<Widget> _pages = <Widget>[const Dashboard(), const TaskScreen(), const NotesScreen(), const DailyHabits()];

  late TabCubit _tabCubit;

  late PageController _pageController;
  @override
  void initState() {
    super.initState();

    _tabCubit = TabCubit();
    _tabCubit.onItemTap(0);
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, bool>(
      builder: (context, state) {
        return BlocBuilder<TabCubit, int>(
          bloc: _tabCubit,
          builder: (context, selectedIndex) {
            return Scaffold(
                floatingActionButton: state == true
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          context.showBottomSheet(showDragHandle: false, maxHeight: context.height, child: const VoiceSheet());
                        },
                        child: AppImage.assets(
                          assetName: Assets.images.logoBar.path,
                          fit: BoxFit.cover,
                          height: 70,
                          width: 70,
                        ),
                      ),
                extendBodyBehindAppBar: true,
                extendBody: true,
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                body: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: _tabCubit.onItemTap,
                  children: _pages,
                ),
                bottomNavigationBar: state == true
                    ? const SizedBox()
                    : Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(bottom: 20),
                        width: context.width,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: context.scaffoldBackgroundColor,
                        ),
                        // margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
                        // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                _tabCubit.onItemTap(0);
                                _pageController.jumpToPage(0);
                              },
                              icon: AppImage.assets(
                                assetName: selectedIndex == 0 ? Assets.images.dashboardFilled.path : Assets.images.dashboard.path,
                                // color: selectedIndex == 0 ? context.primary : context.tertiary,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: IconButton(
                                onPressed: () {
                                  _tabCubit.onItemTap(1);
                                  _pageController.jumpToPage(1);
                                },
                                icon: AppImage.assets(
                                  assetName: selectedIndex == 1 ? Assets.images.taskFilled.path : Assets.images.task.path,
                                  // color: selectedIndex == 1 ? context.primary : context.tertiary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: IconButton(
                                onPressed: () {
                                  _tabCubit.onItemTap(2);
                                  _pageController.jumpToPage(2);
                                },
                                icon: AppImage.assets(
                                  assetName: selectedIndex == 2 ? Assets.images.notesFilled.path : Assets.images.notes.path,
                                  // color: selectedIndex == 2 ? context.primary : context.tertiary,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _tabCubit.onItemTap(3);
                                _pageController.jumpToPage(3);
                              },
                              icon: AppImage.assets(
                                assetName: selectedIndex == 3 ? Assets.images.dailyHabbitFilled.path : Assets.images.dailyHabbit.path,
                                // color: selectedIndex == 3 ? context.primary : context.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ));
          },
        );
      },
    );
  }
}

class VoiceSheet extends StatefulWidget {
  const VoiceSheet({super.key});

  @override
  State<VoiceSheet> createState() => _VoiceSheetState();
}

class _VoiceSheetState extends State<VoiceSheet> {
  late Livespeechtotext _livespeechtotextPlugin;
  late String _recognisedText;
  String? _localeDisplayName = '';
  StreamSubscription<dynamic>? onSuccessEvent;

  bool microphoneGranted = false;
  bool isListening = false;
  @override
  void initState() {
    super.initState();

    _livespeechtotextPlugin = Livespeechtotext();

    _livespeechtotextPlugin.getLocaleDisplayName().then((value) => setState(
          () => _localeDisplayName = value,
        ));

    binding().whenComplete(() => null);

    _recognisedText = '';

    _livespeechtotextPlugin.start();
    setState(() {
      isListening = true;
    });
  }

  @override
  void dispose() {
    onSuccessEvent?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: context.height * .7,
      width: context.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(10),
            Text(
              "Say Something",
              style: context.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                "You can ask me to add notes, input habit time, add food intake",
                textAlign: TextAlign.center,
                style: context.titleSmall?.copyWith(color: context.primary, fontSize: 15),
              ),
            ),
            const Gap(30),
            Text(
              _recognisedText ?? "Create a reminder to send files to Jegan tomorrow",
              textAlign: TextAlign.center,
              style: context.displayLarge?.copyWith(
                height: 1.5,
                fontSize: 32,
              ),
            ),
            // AppImage.assets(assetName: Assets.images.recordingDemo.path),
            if (isListening) ...{
              AppImage.assets(
                assetName: Assets.gif.audio.path,
                color: context.secondary,
              ),
              const Gap(30),
              InkWell(
                onTap: () {
                  try {
                    _livespeechtotextPlugin.stop();
                    setState(() {
                      isListening = false;
                    });
                    context.pop();
                    context.push(AppRoute.saySomething, extra: _recognisedText);
                  } on PlatformException {
                    setState(() {
                      isListening = false;
                    });
                    print('error');
                  }
                },
                child: Text(
                  "Stop",
                  textAlign: TextAlign.center,
                  style: context.displayLarge?.copyWith(
                    height: 1.5,
                    fontSize: 20,
                  ),
                ),
              ),
            } else ...{
              const Gap(30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox.shrink()),
                    const Gap(30),
                    InkWell(
                      onTap: () {
                        try {
                          _livespeechtotextPlugin.start();
                          setState(() {
                            isListening = true;
                          });
                        } on PlatformException {
                          print('error');
                          setState(() {
                            isListening = true;
                          });
                        }
                      },
                      child: AppImage.assets(
                        assetName: Assets.images.logoBar.path,
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      ),
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          context.push(AppRoute.saySomething, extra: "");
                        },
                        child: AppImage.assets(
                          assetName: Assets.images.keyboard.path,
                          fit: BoxFit.cover,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            }
          ],
        ),
      ),
    );
  }

  Future<dynamic> binding() async {
    onSuccessEvent?.cancel();

    return Future.wait([]).then((_) async {
      // Check if the user has already granted microphone permission.
      var permissionStatus = await Permission.microphone.status;

      // If the user has not granted permission, prompt them for it.
      if (!microphoneGranted) {
        await Permission.microphone.request();

        // Check if the user has already granted the permission.
        permissionStatus = await Permission.microphone.status;

        if (!permissionStatus.isGranted) {
          return Future.error('Microphone access denied');
        }
      }

      // Check if the user has already granted speech permission.
      if (Platform.isIOS) {
        var speechStatus = await Permission.speech.status;

        // If the user has not granted permission, prompt them for it.
        if (!microphoneGranted) {
          await Permission.speech.request();

          // Check if the user has already granted the permission.
          speechStatus = await Permission.speech.status;

          if (!speechStatus.isGranted) {
            return Future.error('Speech access denied');
          }
        }
      }

      return Future.value(true);
    }).then((value) {
      microphoneGranted = true;

      // listen to event "success"
      onSuccessEvent = _livespeechtotextPlugin.addEventListener("success", (value) {
        if (value.runtimeType != String) return;
        if ((value as String).isEmpty) return;

        setState(() {
          _recognisedText = value;
        });
      });

      setState(() {});
    }).onError((error, stackTrace) {
      // toast

      // open app setting
    });
  }
}

///Not Live conversion
// class VoiceSheet extends StatefulWidget {
//   const VoiceSheet({super.key});
//
//   @override
//   State<VoiceSheet> createState() => _VoiceSheetState();
// }
//
// class _VoiceSheetState extends State<VoiceSheet> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (!_speechEnabled) {
//       _initSpeech();
//     }
//   }
//
//   /// This has to happen only once per app
//   void _initSpeech() async {
//     _speechEnabled = await _speechToText.initialize();
//   }
//
//   String recordedText = '';
//
//   /// Each time to start a speech recognition session
//   void _startListening() async {
//     isListening = true;
//     await _speechToText.listen(
//       onResult: _onSpeechResult,
//       listenFor: const Duration(seconds: 30),
//       localeId: "en_En",
//       cancelOnError: false,
//       partialResults: false,
//       listenMode: ListenMode.confirmation,
//     );
//     setState(() {
//       recordedText = '';
//     });
//   }
//
//   /// Manually stop the active speech recognition session
//   /// Note that there are also timeouts that each platform enforces
//   /// and the SpeechToText plugin supports setting timeouts on the
//   /// listen method.
//   ///
//   void _stopListening() async {
//     isListening = false;
//     await _speechToText.stop();
//
//     setState(() {});
//   }
//
//   bool isListening = false;
//
//   bool _speechEnabled = false;
//   String _lastWords = "";
//   // final TextEditingController _textController = TextEditingController();
//
//   final SpeechToText _speechToText = SpeechToText();
//
//   /// This is the callback that the SpeechToText plugin calls when
//   /// the platform returns recognized words.
//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       _lastWords = "$_lastWords${result.recognizedWords} ";
//       recordedText = _lastWords;
//     });
//     context.pop();
//     context.push(AppRoute.saySomething, extra: recordedText);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       // height: context.height * .7,
//       width: context.width,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Gap(10),
//             Text(
//               "Say Something",
//               style: context.titleLarge,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
//               child: Text(
//                 "You can ask me to add notes, input habit time, add food intake",
//                 textAlign: TextAlign.center,
//                 style: context.titleSmall?.copyWith(color: context.primary, fontSize: 15),
//               ),
//             ),
//             const Gap(30),
//             Text(
//               "Create a reminder to send files to Jegan tomorrow",
//               textAlign: TextAlign.center,
//               style: context.displayLarge?.copyWith(
//                 height: 1.5,
//                 fontSize: 32,
//               ),
//             ),
//             // AppImage.assets(assetName: Assets.images.recordingDemo.path),
//             if (isListening) ...{
//               AppImage.assets(
//                 assetName: Assets.gif.audio.path,
//                 color: context.secondary,
//               ),
//               const Gap(30),
//               InkWell(
//                 onTap: _stopListening,
//                 child: Text(
//                   "Stop",
//                   textAlign: TextAlign.center,
//                   style: context.displayLarge?.copyWith(
//                     height: 1.5,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//             } else ...{
//               const Gap(30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Expanded(child: SizedBox.shrink()),
//                     const Gap(30),
//                     InkWell(
//                       onTap: /* _speechToText.isNotListening ?*/ _startListening,
//                       child: AppImage.assets(
//                         assetName: Assets.images.logoBar.path,
//                         fit: BoxFit.cover,
//                         height: 70,
//                         width: 70,
//                       ),
//                     ),
//                     const Expanded(child: SizedBox.shrink()),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: InkWell(
//                         onTap: () {
//                           context.push(AppRoute.saySomething, extra: "");
//                         },
//                         child: AppImage.assets(
//                           assetName: Assets.images.keyboard.path,
//                           fit: BoxFit.cover,
//                           height: 30,
//                           width: 30,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             }
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
