// import 'package:flutter/cupertino.dart';
// import 'package:rive/rive.dart';
//
// import '../customer_home.dart';
// import '../shopping/my_orders.dart';
// import '../shopping/view_cart.dart';
//
// class RiveAsset {
//   final String title;
//   int index;
//   final String image;
//   late SMIBool? input;
//
//   RiveAsset(
//       {required this.title,
//         required this.index,
//         required this.image,
//         this.input});
//
//   set setInput(SMIBool status) {
//     input = status;
//   }
// }
//
// List<RiveAsset> sideMenus = [
//   RiveAsset(
//     title: "Home",
//     index: 1,
//     image: 'images/home.gif',
//   ),
//   RiveAsset(title: "Cart", index: 2, image: 'images/cart.gif'),
//   RiveAsset(title: "My Profile", index: 3, image: 'images/profile.gif'),
//   RiveAsset(title: "My Orders", index: 4, image: 'images/orders.gif'),
//   RiveAsset(title: "My Bookings", index: 5, image: 'images/booking.gif'),
//   RiveAsset(title: "Payments", index: 6, image: 'images/payment.gif'),
//   RiveAsset(title: "Log Out", index: 7, image: 'images/logout.gif'),
// ];

import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

import '../customer_home.dart';
import '../shopping/my_orders.dart';
import '../shopping/view_cart.dart';

class RiveAsset {
  final String title;
  int index;
  final String image;
  late SMIBool? input;

  RiveAsset(
      {required this.title,
        required this.index,
        required this.image,
        this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> sideMenus = [
  RiveAsset(
    title: "Home",
    index: 1,
    image: 'images/home.gif',
  ),
  RiveAsset(title: "Cart", index: 2, image: 'images/cart.gif'),
  RiveAsset(title: "My Profile", index: 3, image: 'images/profile.gif'),
  RiveAsset(title: "My Orders", index: 4, image: 'images/orders.gif'),
  RiveAsset(title: "My Bookings", index: 5, image: 'images/booking.gif'),
  RiveAsset(title: "Payments", index: 6, image: 'images/payment.gif'),
  RiveAsset(title: "Log Out", index: 7, image: 'images/logout.gif'),
];