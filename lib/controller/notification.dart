// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart';
// import 'auth.dart';
//
// class Notifications {
//   static Future<void> getToken(String type) async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     await messaging.requestPermission();
//     await messaging.getToken().then((token) async {
//       if (token != null) {
//         Auth.token = token;
//         if (type == 'Customer') {
//           await Auth.customerRef
//               .doc(Auth.auth.currentUser!.uid)
//               .update({'token': token.toString()});
//         } else if (type == 'Shop Manager') {
//           await Auth.shopManagerRef
//               .doc(Auth.auth.currentUser!.uid)
//               .update({'token': token.toString()});
//         } else if (type == 'App Manager') {
//           await Auth.appManagerRef
//               .doc(Auth.auth.currentUser!.uid)
//               .update({'token': token.toString()});
//         }
//         log('Token : ${token}');
//       }
//     });
//   }
//
//   static Future<void> sendPushNotifications(
//       String uid, String token, String msg, String customerId , List product , [String? type]) async {
//     try {
//       final body = {
//         'to': '${token}',
//         'notification': {'title': '${customerId}', 'body': msg}
//       };
//       var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
//       var response = await post(url, body: jsonEncode(body), headers: {
//         HttpHeaders.contentTypeHeader: 'application/json',
//         HttpHeaders.authorizationHeader:
//             'key = AAAAj8GHrEA:APA91bFSuKhymZ5QldzESyvgMY_G3oBCbuCAtVOeWOkPiYjDiQiU3eM6Jiayk0T3jUw5mDhCdatte1lIabdZ0UZtrcng4AliVUXMflAxSxJaGqkrj2TfFf4tj7h2x0vpn-8Fb2fyH8Dv'
//       });
//
//       for(int i = 0; i <product.length; i++){
//         await Auth.appManagerRef
//             .doc(uid)
//             .collection('notifications')
//             .doc(DateTime.now().millisecondsSinceEpoch.toString())
//             .set({
//           'date': DateTime.now().millisecondsSinceEpoch.toString(),
//           'msg': msg.toString(),
//           'from': Auth.auth.currentUser!.uid.toString(),
//           'to': uid.toString(),
//           'productId' : product[i].toString()
//         });
//       }
//
//     } catch (e) {
//       log(e.toString());
//     }
//   }
// }
