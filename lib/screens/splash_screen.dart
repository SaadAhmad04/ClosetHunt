import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:mall/controller/splash_services.dart';
import 'package:mall/screens/app_manager/app_manager_home.dart';
import 'package:mall/screens/app_manager/notification.dart';
import 'package:mall/screens/customer/shopping/customer_shopping.dart';
import 'package:mall/screens/shop_manager/shop_manager_home.dart';
import 'package:mall/screens/shop_manager/view_product.dart';
import '../main.dart';
import 'app_manager/noti_detail.dart';

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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenedApp event was published");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print("TTTTTTTT${sp.type.toString()}");
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

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            Container(
                width: mq.width,
                height: mq.height,
                child: Image.asset(
                  "images/splashwall.jpg",
                  fit: BoxFit.cover,
                )),
            Container(
              width: mq.width,
              height: mq.height,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset("images/rewall.jpg", fit: BoxFit.cover),
                // child: Image.network(
                //   "https://i.gifer.com/ET1a.gif",
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: mq.height * .32, left: mq.width * .35),
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
              margin: EdgeInsets.only(top: mq.height * .71, left: mq.width * .22),
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
        ));
  }
}