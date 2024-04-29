// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/material.dart';
// import 'package:mall/screens/customer/booking/my_bookings.dart';
//
// import 'package:mall/screens/customer/customer_home.dart';
// import 'package:mall/screens/customer/customer_profile.dart';
// import 'package:mall/screens/customer/my_payments.dart';
// import 'package:mall/screens/customer/rive/riveassets.dart';
// import 'package:rive/rive.dart';
//
// import '../../../controller/auth.dart';
// import '../shopping/my_orders.dart';
// import '../shopping/view_cart.dart';
// import 'NavigationPoint.dart';
//
// class SideMenu extends StatefulWidget {
//   const SideMenu({super.key});
//
//   @override
//   State<SideMenu> createState() => _SideMenuState();
// }
//
// class _SideMenuState extends State<SideMenu> {
//   RiveAsset selectedMenu = sideMenus.first;
//
//   @override
//   Widget build(BuildContext context) {
//     Widget file = ViewCart();
//     StateMachineController controller;
//     return Scaffold(
//       body: Container(
//         width: 288,
//         height: double.infinity,
//         color: Color(0xff974C7C),
//         //color: Color(0xff17203a),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               StreamBuilder(
//                 stream: Auth.customerRef
//                     .where('uid', isEqualTo: Auth.auth.currentUser?.uid)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     QuerySnapshot<Map<String, dynamic>> querySnapshot =
//                     snapshot.data as QuerySnapshot<Map<String, dynamic>>;
//                     if (querySnapshot.docs.isNotEmpty) {
//                       Map<String, dynamic> data =
//                       querySnapshot.docs[0].data() as Map<String, dynamic>;
//
//                       return ListTile(
//                         leading: const CircleAvatar(
//                           backgroundColor: Colors.white24,
//                           child: Icon(Icons.person, color: Colors.white),
//                         ),
//                         title: Text(data['name'] ?? '',
//                             style: TextStyle(color: Colors.white)),
//                         subtitle: Text(
//                           data['email'],
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       );
//                     } else {
//                       return Text('No data available');
//                     }
//                   } else {
//                     return CircularProgressIndicator();
//                   }
//                 },
//               ),
//               Padding(
//                 padding: EdgeInsets.only(left: 22, top: 30, bottom: 14),
//                 child: Text(
//                   "ClosetHunt",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               ...sideMenus.map((menu) => Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: 22),
//                     child: Divider(
//                       color: Colors.white24,
//                       height: 1,
//                     ),
//                   ),
//                   Stack(
//                     children: [
//                       AnimatedPositioned(
//                         duration: Duration(milliseconds: 300),
//                         curve: Curves.fastOutSlowIn,
//                         height: 56,
//                         width: selectedMenu == menu ? 288 : 0,
//                         left: 0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Color(0xff8D8E36),
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(10))),
//                         ),
//                       ),
//                       ListTile(
//                           onTap: () {
//                             menu.input?.change(true);
//                             setState(() {
//                               selectedMenu = menu;
//                             });
//                             Future.delayed(const Duration(seconds: 1), () {
//                               menu.input?.change(false);
//                             });
//
//                             menu.index == 1
//                                 ? Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       NavigationPoint(),
//                                 ))
//                                 : menu.index == 2
//                                 ? Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ViewCart(),
//                                 ))
//                                 : menu.index == 3
//                                 ? Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       CustomerProfile(),
//                                 ))
//                                 : menu.index == 4
//                                 ? Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       MyOrders(),
//                                 ))
//                                 : menu.index == 5
//                                 ? Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       MyBookings(),
//                                 ))
//                                 : menu.index == 6
//                                 ? Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       MyPayments(),
//                                 ))
//                                 : Auth.logout(context);
//                           },
//                           leading: SizedBox(
//                             height: 35,
//                             width: 35,
//                             child: Image.asset(menu.image),
//                           ),
//                           title: Text(
//                             menu.title,
//                             style: TextStyle(color: Colors.white),
//                           ))
//                     ],
//                   )
//                 ],
//               ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mall/screens/customer/booking/my_bookings.dart';

import 'package:mall/screens/customer/customer_home.dart';
import 'package:mall/screens/customer/customer_profile.dart';
import 'package:mall/screens/customer/my_payments.dart';
import 'package:mall/screens/customer/rive/riveassets.dart';
import 'package:rive/rive.dart';

import '../../../controller/auth.dart';
import '../shopping/my_orders.dart';
import '../shopping/view_cart.dart';
import 'NavigationPoint.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  RiveAsset selectedMenu = sideMenus.first;

  @override
  Widget build(BuildContext context) {
    Widget file = ViewCart();
    StateMachineController controller;
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: Color(0xff974C7C),
        //color: Color(0xff17203a),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: Auth.customerRef
                    .where('uid', isEqualTo: Auth.auth.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>> querySnapshot =
                    snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                    if (querySnapshot.docs.isNotEmpty) {
                      Map<String, dynamic> data =
                      querySnapshot.docs[0].data() as Map<String, dynamic>;

                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(data['name'] ?? '',
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                          data['email'],
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      return Text('No data available');
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 22, top: 30, bottom: 14),
                child: Text(
                  "ClosetHunt",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ...sideMenus.map((menu) => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 22),
                    child: Divider(
                      color: Colors.white24,
                      height: 1,
                    ),
                  ),
                  Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        height: 56,
                        width: selectedMenu == menu ? 288 : 0,
                        left: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff8D8E36),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      ListTile(
                          onTap: () {
                            menu.input?.change(true);
                            setState(() {
                              selectedMenu = menu;
                            });
                            Future.delayed(const Duration(seconds: 1), () {
                              menu.input?.change(false);
                            });

                            menu.index == 1
                                ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NavigationPoint(),
                                ))
                                : menu.index == 2
                                ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewCart(),
                                ))
                                : menu.index == 3
                                ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerProfile(),
                                ))
                                : menu.index == 4
                                ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyOrders(),
                                ))
                                : menu.index == 5
                                ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyBookings(),
                                ))
                                : menu.index == 6
                                ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyPayments(),
                                ))
                                : Auth.logout(context);
                          },
                          leading: SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset(menu.image),
                          ),
                          title: Text(
                            menu.title,
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}