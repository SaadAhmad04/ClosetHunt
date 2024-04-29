import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mall/screens/app_manager/analysis.dart';
import 'package:mall/screens/app_manager/refund.dart';
import 'package:mall/screens/app_manager/shopkeeper_without_shops.dart';
import 'package:mall/screens/app_manager/summary.dart';
import 'package:mall/screens/app_manager/view_shop.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/firebase_api.dart';
import '../../controller/auth.dart';
import '../../main.dart';
import 'add_delivery_boys.dart';
import 'notification.dart';

class AppManagerHome extends StatefulWidget {
  const AppManagerHome({super.key});

  @override
  State<AppManagerHome> createState() => _AppManagerHomeState();
}

class _AppManagerHomeState extends State<AppManagerHome>
    with TickerProviderStateMixin {
  late AnimationController controller;
  String? tok , name , email;

  Future<String> Found() async {
    final token = await FirebaseApi.initNotifications();
    print("TOKSSSM ${token}");
    return token.toString();
  }

  Future<void> getType() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('type', 'App Manager');
    tok = await Found();
    print("GDFASF${pref.getString('name')}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: Auth.appManagerRef
            .where('uid', isEqualTo: Auth.auth.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 35,
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          return Container(
                            height: mq.height * .37,
                            width: mq.width * .37,
                            child: InkWell(
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                child: Lottie.asset('animations/hover.json')),
                          );
                        },
                      )
                    ],
                  )),
              body: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.data!.docs[index]['type'] == 'App Manager') {
                    name = snapshot.data?.docs[index]['name'];
                    email = snapshot.data?.docs[index]['email'];
                    return FutureBuilder(
                        future: getType(),
                        builder: (context, snapshot) {
                          Auth.appManagerRef
                              .doc(Auth.auth.currentUser?.uid)
                              .update({
                            'token': tok,
                          });
                          return Center(
                            child: Lottie.asset('animations/admin.json'),
                          );
                        });
                  } else {
                    return Text('not app manager');
                  }
                },
              ),
              drawer: Drawer(
                backgroundColor: Colors.white,
                child: ListView(
                  children: [
                    DrawerHeader(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff014871),
                                  Colors.blueGrey,
                                  Color(0xffa0ebcf)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.3, 0.5, 0.9])),
                        child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff014871),
                                    Color(0xffa0ebcf)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: const [0.2, 0.9])),
                          accountName: Text('${name}'),
                          accountEmail: Text('${email}'),
                          currentAccountPicture: CircleAvatar(
                            child: Text("A"),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white24,
                          ),
                          currentAccountPictureSize: Size.square(50),
                        )),
                    ListTile(
                      leading: Icon(
                        Icons.shop,
                        color: Colors.black,
                      ),
                      title: Text('View All Shops',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewShop()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.black,
                      ),
                      title: Text('Assign Shops',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShopKeeperWithoutShops()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                      title: Text('Notifications',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AppManagerNotificationHistory()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.currency_rupee, color: Colors.black),
                      title: Text("Refund",
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Refund()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      title: Text('Manage Delivery Boys',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddDeliveryBoys()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.analytics,
                        color: Colors.black,
                      ),
                      title: Text('Analysis',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Analysis()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.summarize_outlined, color: Colors.black),
                      title: Text("Summary",
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Summary()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.black),
                      title: Text("Logout",
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                      onTap: () {
                        Auth.logout(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData ||
              snapshot.hasError ||
              snapshot.data == null) {
            return Scaffold(
              body: Text('U r not a app manager'),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
