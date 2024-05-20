import 'package:aivi/core/components/app_button.dart';
import 'package:aivi/core/components/app_image.dart';
import 'package:aivi/core/constant/app_strings.dart';
import 'package:aivi/core/extensions/e_context_extension.dart';
import 'package:aivi/gen/assets.gen.dart';
import 'package:aivi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SaySomething extends StatefulWidget {
  @override
  _SaySomethingState createState() => _SaySomethingState();
}

class _SaySomethingState extends State<SaySomething> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
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
                children: const [
                  // Chat messages will be listed here

                  ChatMessage(
                    isMediaIncluded: false,
                    message: 'Create a reminder to send files to Jegan tomorrow',
                    isSentByMe: true,
                  ),

                  ChatMessage(
                    isMediaIncluded: true,
                    message: 'Sure, Here is reminder preview',
                    isSentByMe: false,
                  ),
                  ChatMessage(
                    isMediaIncluded: false,
                    message: 'Also add a description that the files should be in pdf format',
                    isSentByMe: true,
                  ),
                  // Add more chat messages as needed
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                children: [
                  AppImage.assets(
                    assetName: Assets.images.logoBar.path,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  const Gap(10),
                  Expanded(
                    child: Stack(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Type message',
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(14)),
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
                          child: AppImage.assets(
                            assetName: Assets.images.send.path,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final bool isMediaIncluded;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.isMediaIncluded,
    required this.isSentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: AssetImage(Assets.images.profile.path),
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
                                      "Appointment",
                                      style: context.displaySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(10),
                              Text(
                                "Send files to Jegan",
                                style: context.titleSmall?.copyWith(color: context.primary),
                              ),
                              const Gap(10),
                              Text(
                                "No Description",
                                style: context.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
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
                                  Text(
                                    "30, April 2024",
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
                                borderColor: context.secondary,
                                height: 30,
                                width: 100,
                                child: Text(
                                  "Edit",
                                  style: context.displaySmall?.copyWith(fontSize: 12, color: context.secondary, fontWeight: FontWeight.w600),
                                )),
                            const Gap(10.0),
                            AppButton.primary(
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(Assets.images.profile.path),
                radius: 16,
              ),
            ),
        ],
      ),
    );
  }
}
