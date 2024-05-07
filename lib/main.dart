// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_notification_channel/flutter_notification_channel.dart';
// import 'package:flutter_notification_channel/notification_importance.dart';
// import 'package:flutter_notification_channel/notification_visibility.dart';
// import 'package:mall/firebase_options.dart';
// import 'package:mall/screens/splash_screen.dart';
// import 'package:mall/simple.dart';
// import 'package:mall/simple.dart';
//
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', 'High Importance Notifications',
//     description: 'This channel is used for important notifications',
//     importance: Importance.high,
//     playSound: true);
//
// final FlutterLocalNotificationsPlugin flutterLo0calNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _initializeFirebase();
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   runApp(const MyApp());
// }
//
// late Size mq;
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ClosetHunt',
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }
//
// _initializeFirebase() async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   var result = await FlutterNotificationChannel.registerNotificationChannel(
//     description: 'For showing order notification',
//     id: 'mall',
//     importance: NotificationImportance.IMPORTANCE_HIGH,
//     name: 'ClosetHunt',
//   );
//   log('notification channel ${result}');
// }\

import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:mall/firebase_options.dart';
import 'package:mall/screens/splash_screen.dart';
import 'package:mall/simple.dart';
import 'package:mall/simple.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClosetHunt',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing order notification',
    id: 'mall',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'ClosetHunt',
  );
  log('notification channel ${result}');
}