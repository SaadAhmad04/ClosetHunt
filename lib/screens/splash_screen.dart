import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mall/controller/splash_services.dart';
import 'package:mall/screens/app_manager/notification.dart';
import 'package:mall/screens/shop_manager/view_product.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController splashcontroller;
  SplashServices sp = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashcontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    splashcontroller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        splashcontroller.reset();
      }
    });
    sp.isLogin(context);
    //for foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@drawable/ic_launcher',
                )));
      }
    });
    //for terminated part
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenedApp event was published");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (sp.type.toString() == "Shop Keeper") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewProduct(shopName: 'Puma'),
              ));
        } else if (sp.type.toString() == "App Manager") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppManagerNotificationHistory(),
              ));
        }
      }
    });
  }

  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   sp.isLogin(context);
  // }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              Container(
                color: Colors.brown,
                height: 1000,
                child: Image.network(
                  "https://media.baamboozle.com/uploads/images/49418/1621176766_73807_gif-url.gif",
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: mq.height * .12, left: mq.width * .35),
                height: mq.height * .1,
                child: ClipOval(
                  child: Image.asset("images/app_icon.jpeg"),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.only(top: mq.height * .12, left: mq.width * .10),
              //   height: mq.height * .8,
              //   child: Image.network(
              //       "https://s3-eu-west-1.amazonaws.com/emap-nibiru-prod/wp-content/uploads/sites/2/2021/04/14095423/Data-animation-April-2021-INDEX1.gif"),
              // ),
              Container(
                margin: EdgeInsets.only(top: mq.height * .81, left: mq.width * .22),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.green, Colors.blue],
                    ).createShader(bounds);
                  },
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'ClosetHunt',
                        textStyle: TextStyle(
                          fontSize: 45,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}