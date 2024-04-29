import 'dart:async';
import 'dart:convert';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mall/model/serviceModel.dart';
import 'package:mall/screens/customer/booking/parlor/confirm_booking.dart';
import 'package:mall/screens/customer/booking/my_bookings.dart';
import 'package:mall/screens/customer/shopping/my_orders.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../../../constant/utils/utilities.dart';
import '../../../../controller/auth.dart';

class Payment extends StatefulWidget {
  double? amount;
  String? sellerId;
  List? sellerIds;
  String? productId;
  List? productIds;
  Map<String, List<String>>? map;
  String? shopId;
  String? shopName;
  DateTime? date;
  String? time;
  ServiceModel? serviceModel;
  bool isAppointment;
  String? mode;
  String? staff;

  Payment(
      {super.key,
      required this.amount,
      this.sellerIds,
      this.productId,
      this.productIds,
      this.map,
      this.isAppointment = false,
      this.shopId,
      this.shopName,
      this.date,
      this.time,
      this.serviceModel,
      this.sellerId,
      this.mode,
      this.staff});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> with SingleTickerProviderStateMixin {
  var _razorPay = Razorpay();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    widget.amount = widget.amount! + (widget.amount! * .18);

    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 120, end: 150).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCirc,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _razorPay.clear();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (widget.isAppointment) {
      final dateTime = DateTime.now().millisecondsSinceEpoch.toString();
      await Auth.customerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('bookings')
          .doc(widget.shopId)
          .set({'shopId': widget.shopId, 'shopName': widget.shopName});
      await Auth.customerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('bookings')
          .doc(widget.shopId)
          .collection('parlor')
          .doc(dateTime)
          .set({
        'bookingId': dateTime,
        'date': "${widget.date}".toString(),
        'time': "${widget.time}".toString(),
        'customerId': Auth.auth.currentUser!.uid,
        'shopId': widget.shopId,
        'serviceName': widget.serviceModel!.serviceName,
        'serviceId': widget.serviceModel!.serviceId,
        'amount': widget.amount,
        'shopName': widget.shopName,
        'cancelled': false,
        'staff':widget.staff
      }).then((value) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmBooking(
              shopId: widget.shopId,
              bookingId: dateTime,
              serviceModel: widget.serviceModel,
              date: widget.date,
              time: widget.time,
              staff: widget.staff,
            ),
          ),
        );
      });
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Wallet ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: mq.height,
            child: Image.network(
              "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
              fit: BoxFit.cover,
            ),
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "Click here",
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    var url = "https://rzp.io/l/f11lxHx";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }),
          ])),
          Container(
            margin: EdgeInsets.only(top: mq.height * .12, left: mq.width * .40),
            height: mq.height * .1,
            child: ClipOval(
              child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/81/81566.png"),
            ),
          ),
          Container(
              margin:
                  EdgeInsets.only(top: mq.height * .24, left: mq.width * .40),
              height: mq.height * .1,
              child: Text(
                "Pay Securely",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                height: 250,
                width: 550,
                color: Colors.white,
                margin: EdgeInsets.only(
                  top: mq.height * .32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.check, color: Color(0xff8d8e36)),
                      label: Text(
                        "Your Payment is secure.",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.check, color: Color(0xff8d8e36)),
                      label: Text(
                        "We do not send any OTP while doing Online Transaction.",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.check, color: Color(0xff8d8e36)),
                      label: Text(
                        "If you receive any such OTP kindly ignore. ClosetHunt will not be responsible for any loss.",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {},
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.check, color: Color(0xff8d8e36)),
                      label: Text(
                        "On successful completion of your payment, you will receive your bill receipt on your registered e-mail.",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {},
                    )
                  ],
                )),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                margin:
                    EdgeInsets.only(top: mq.height * .70, left: mq.width * 0.3),
                width: _animation.value,
                height: 80,
                child: InkWell(
                  // Inside your onTap callback
                  onTap: () async {
                    var options = {
                      'key': 'rzp_test_hsfoAtMk3TFoZA',
                      'amount': (widget.amount! * 100).round(),
                      'name': 'ClosetHunt',
                      'description': 'From ${widget.shopName}',
                      'timeout': 120,
                    };
                    try {
                      _razorPay.open(options);
                    } on Exception catch (e) {
                      Utilities().showMessage(e.toString());
                    }
                  },
                  child: Center(
                    child: Text(
                      'Pay ${widget.amount!.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff8d8e36),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
