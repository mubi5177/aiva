import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
@pragma('vm:entry-point')
Future<void> backgroundNotificationHandler(NotificationResponse notificationResponse) async {
  try {
    if (kDebugMode) {
      print('#####${notificationResponse.payload}');
    }
    // User? user = await getUserData();
    if (notificationResponse.payload != null) {
      String payload = notificationResponse.payload!;
      // await handleNotificationPayload(payload);
    }
  } catch (e, s) {
    print('catch of onDidReceiveNotificationResponse is $e');
  }
}

class FirebaseMessagingHandler {
  static final FirebaseMessagingHandler _firebaseMessagingHandler = FirebaseMessagingHandler._internal();

  factory FirebaseMessagingHandler({BuildContext? c}) {
    return _firebaseMessagingHandler;
  }

  FirebaseMessagingHandler._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print('showFlutterNotification: ${message.data}');
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> initialize() async {
    await setupFlutterNotifications();

    // Request permission for receiving push notifications (optional)
    await _firebaseMessaging.requestPermission();
    // final fCMToken = await FirebaseMessaging.instance.getToken();
    // print('FirebaseMessagingHandler.initialize: token:  $fCMToken');
    // Set up onMessage handler (when app is in the foreground)
    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Handle the message when the app is opened from the notification
      print('Opened app from message: ${message.notification?.body}');
      try {
        print('#####${message.data}');
        String payload = jsonEncode(message.data);
        // await handleNotificationPayload(payload);
      } catch (e, s) {
        print('catch of onDidReceiveNotificationResponse is $e');
      }
    });
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  late AndroidNotificationChannel channel;

  Future<void> setupFlutterNotifications() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.

    // Initialize settings for each platform (Android and iOS)
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        try {
          if (notificationResponse.payload != null) {
            String payload = notificationResponse.payload!;
            // await handleNotificationPayload(payload);
          }
        } catch (e, s) {
          print('catch of onDidReceiveNotificationResponse is $e');
        }
      },
    );
  }

  notificationDetails() {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
        ),
        iOS: const DarwinNotificationDetails());
  }

  Future<void> sendLocalNotification(String? title, String? body, String? payload) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id, // Change this to your channel ID
      channel.name, // Change this to your channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification Title
      body, // Notification Body
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleNotification(
      {int id = 0, String? title, String? body, String? payLoad, required DateTime scheduledNotificationDateTime}) async {
    return flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}

// Future<void> handleNotificationPayload(String payload) async {
//   videoPlayedFromNotification = true;
//   if (jsonDecode(payload)['type'] != null) {
//     NotificationType notificationType = int.parse(jsonDecode(payload)['type']).toNotificationType;
//     if (notificationType == NotificationType.answerUpload) {
//       AnswerWiz answerDatum = AnswerWiz.fromJson(jsonDecode(jsonDecode(payload)['misc']));
//       if (navigatorKey.currentContext == null) {
//         showToast('Something went wrong');
//       } else {
//         Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, CupertinoPageRoute(builder: (context) => Answers(videoId: answerDatum.videoId,isFromNotification: true,)), (route) => route.isFirst);
//       }
//     } else if (notificationType == NotificationType.privateMessage) {
//       PrivateMessageVideo privateMessageVideo = PrivateMessageVideo.fromJson(jsonDecode(jsonDecode(payload)['misc']));
//       if (navigatorKey.currentContext == null) {
//         showToast('Something went wrong');
//       } else {
//         Navigator.pushAndRemoveUntil(
//             navigatorKey.currentContext!, CupertinoPageRoute(builder: (context) => SpecificPrivateMessageView(video: privateMessageVideo)), (route) => route.isFirst);
//       }
//     }
//   }
// }
