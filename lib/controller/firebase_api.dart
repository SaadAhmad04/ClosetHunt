import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mall/model/product_model.dart';
import 'auth.dart';
import '../model/serviceModel.dart';

class FirebaseApi {
  static FirebaseMessaging _msg = FirebaseMessaging.instance;

  static Future<String?> initNotifications() async {
    await _msg.requestPermission();
    String? fcmtoken = await _msg.getToken();
    print("TOKEN ${fcmtoken}");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    return fcmtoken;
  }

  static Future<void> myNotification(String name, String recToken, String msg,
      String userId, String phno, String email, String uid,
      {String? productId,
      String? bookingId,
      String? shopId,
      ServiceModel? serviceModel,
      double? amount,
      String? date,
      String? time,
      String? mode,
      List<ProductModel>? productModel,
      String? orderId}) async {
    print("RECEIVER ${recToken}");
    print(phno.toString());
    print(name);
    print(msg);
    try {
      final body = {
        "to": recToken,
        "notification": {
          "title": name,
          "body": msg,
          "android_channel_id": "mall"
        },
        "data": {
          "some_data": "User ID: ${Auth.auth.currentUser!.uid}",
        },
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader:
                    "key = AAAAj8GHrEA:APA91bFSuKhymZ5QldzESyvgMY_G3oBCbuCAtVOeWOkPiYjDiQiU3eM6Jiayk0T3jUw5mDhCdatte1lIabdZ0UZtrcng4AliVUXMflAxSxJaGqkrj2TfFf4tj7h2x0vpn-8Fb2fyH8Dv"
              },
              body: jsonEncode(body));
      //Utilities().showMessage('Confirming Your Order. Please Wait!!');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (bookingId == null) {
        if (productId != "") {
          await Auth.appManagerRef
              .doc(uid)
              .collection('notifications')
              .doc(uid)
              .collection('shopping')
              .doc(orderId! + 1.toString())
              .set({
            'amount': amount,
            'date': orderId + 1.toString(),
            'name': name,
            'msg': msg,
            'customerId': userId,
            'phone': phno,
            'email': email,
            'productId': productId.toString(),
            'sellerId':shopId,
            'mode': mode,
            'assigned': false,
            'cancelled': false,
            'delivered':false
          });
        } else {
          await Auth.appManagerRef
              .doc(uid)
              .collection('notifications')
              .doc(uid)
              .collection('shopping')
              .doc(orderId)
              .set({
            'amount': amount,
            'orderId': orderId,
            'name': name,
            'msg': msg,
            'productId': productId,
            'mode':mode
          });
          for (int i = 0; i < productModel!.length; i++) {
            await Auth.appManagerRef
                .doc(uid)
                .collection('notifications')
                .doc(uid)
                .collection('shopping')
                .doc(orderId)
                .collection('products')
                .doc(orderId! + (i + 1).toString())
                .set({
              'amount': productModel[i].perprice,
              'date': orderId + (i + 1).toString(),
              'name': name,
              'msg': msg,
              'customerId': userId,
              'phone': phno,
              'email': email,
              'productId': productModel[i].productId,
              'sellerId': productModel[i].sellerId,
              'mode': mode,
              'assigned': false,
              'cancelled': false,
              'delivered':false
            });
          }
        }
      } else {
        await Auth.appManagerRef
            .doc(uid)
            .collection('notifications')
            .doc(uid)
            .collection('booking')
            .doc(bookingId)
            .set({
          'date': date,
          'name': name,
          'msg': msg,
          'customerId': userId,
          'phone': phno,
          'email': email,
          'bookingId': bookingId.toString(),
          'shopId': shopId,
          'serviceId': serviceModel!.serviceId,
          'serviceName': serviceModel.serviceName,
          'servicePrice': serviceModel.servicePrice,
          'time': time,
          'cancelled': false
        });
      }
    } catch (e) {
      print("Error $e");
    }
  }

  static Future<void> shopNotification(String name, List id, String msg,
      String userId, String phno, String email, List rev,
      {ServiceModel? serviceModel,
      String? bookingId,
      String? shopId,
      List<ProductModel>? productModel,
      String? time,
      String? date,
      String? mode,
      String? orderId}) async {
    for (int i = 0; i < id.length; i++) {
      print("RECEIVER ${id[i]}");
      try {
        final body = {
          "to": id[i],
          "notification": {"title": name, "body": msg}
        };
        var response =
            await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                  HttpHeaders.authorizationHeader:
                      "key = AAAAj8GHrEA:APA91bFSuKhymZ5QldzESyvgMY_G3oBCbuCAtVOeWOkPiYjDiQiU3eM6Jiayk0T3jUw5mDhCdatte1lIabdZ0UZtrcng4AliVUXMflAxSxJaGqkrj2TfFf4tj7h2x0vpn-8Fb2fyH8Dv"
                },
                body: jsonEncode(body));
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (bookingId == null) {
          await Auth.shopManagerRef
              .doc(productModel![i].sellerId.toString())
              .collection('notifications')
              .doc(orderId! + (i + 1).toString())
              .set({
            'date': orderId + (i + 1).toString(),
            'name': name,
            'msg': msg,
            'customerId': userId,
            'cancelled': false,
            'phone': phno,
            'email': email,
            'quantity': productModel[i].quantity,
            'productId': productModel[i].productId,
            'productName': productModel[i].name,
            'productImage': productModel[i].image,
            'price': productModel[i].price,
            'perprice': productModel[i].perprice,
            'deliveryTime': productModel[i].deliveryTime ?? "",
            'mode': mode,
          });
        } else {
          await Auth.shopManagerRef
              .doc(shopId.toString())
              .collection('notifications')
              .doc(bookingId)
              .set({
            'date': date,
            'name': name,
            'msg': msg,
            'customerId': userId,
            'phone': phno,
            'email': email,
            'bookingId': bookingId.toString(),
            'shopId': shopId,
            'serviceId': serviceModel!.serviceId,
            'serviceName': serviceModel.serviceName,
            'servicePrice': serviceModel.servicePrice,
            'time': time,
            'cancelled': false
          });
        }
      } catch (e) {
        print("Error $e");
      }
    }
  }

  static Future<int> otpNotification(String token) async {
    int min = 1000;
    int max = 9999;

    // Generate a random 4-digit number
    int randomNumber = Random().nextInt(max - min + 1) + min;
    print('Random Number: $randomNumber');
    try {
      final body = {
        "to": token,
        //this will vary
        "notification": {
          "title": "Order-Conformation",
          "body": "Your Otp is ${randomNumber}",
          "android_channel_id": "mall"
        },
        "data": {
          "some_data": "User ID: ${Auth.auth.currentUser!.uid}",
        },
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader:
                    "key = AAAAj8GHrEA:APA91bFSuKhymZ5QldzESyvgMY_G3oBCbuCAtVOeWOkPiYjDiQiU3eM6Jiayk0T3jUw5mDhCdatte1lIabdZ0UZtrcng4AliVUXMflAxSxJaGqkrj2TfFf4tj7h2x0vpn-8Fb2fyH8Dv"
              },
              body: jsonEncode(body));
      //Utilities().showMessage('Confirming Your Order. Please Wait!!');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      final dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    } catch (e) {
      print("Error $e");
    }
    return randomNumber;
  }

  static Future<void> cancelBooking(
      {String? uid,
      String? token,
      String? bookingId,
      String? orderId,
      bool? exists,
      bool forAppManager = false}) async {
    try {
      final body = {
        "to": token,
        //this will vary
        "notification": {
          "title": "Booking-Cancellation",
          "body": "Your booking ${bookingId} is cancelled",
          "android_channel_id": "mall"
        },
        "data": {
          "some_data": "User ID: ${Auth.auth.currentUser!.uid}",
        },
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader:
                    "key = AAAAj8GHrEA:APA91bFSuKhymZ5QldzESyvgMY_G3oBCbuCAtVOeWOkPiYjDiQiU3eM6Jiayk0T3jUw5mDhCdatte1lIabdZ0UZtrcng4AliVUXMflAxSxJaGqkrj2TfFf4tj7h2x0vpn-8Fb2fyH8Dv"
              },
              body: jsonEncode(body));
      if (orderId == null) {
        if (forAppManager) {
          await Auth.appManagerRef
              .doc(uid)
              .collection('notifications')
              .doc(uid)
              .collection('booking')
              .doc(bookingId)
              .update({'cancelled': true});
        } else {
          await Auth.shopManagerRef
              .doc(uid)
              .collection('notifications')
              .doc(bookingId)
              .update({'cancelled': true});
        }
      } else {
        if (forAppManager) {
          if (exists == true) {
            await Auth.appManagerRef
                .doc(uid)
                .collection('notifications')
                .doc(uid)
                .collection('shopping')
                .doc(orderId.substring(0, orderId.length - 1))
                .collection('products')
                .doc(orderId)
                .update({'cancelled': true});
          } else {
            await Auth.appManagerRef
                .doc(uid)
                .collection('notifications')
                .doc(uid)
                .collection('shopping')
                .doc(orderId)
                .update({'cancelled': true});
          }
        } else {
          await Auth.shopManagerRef
              .doc(uid)
              .collection('notifications')
              .doc(orderId)
              .update({'cancelled': true});
        }
      }
    } catch (e) {
      print("Error $e");
    }
  }
}
