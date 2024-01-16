import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/controller/firebase_api.dart';
import 'package:mall/screens/delivery/delivery_home.dart';

import '../../controller/auth.dart';
import '../../main.dart';

class SendOtp extends StatefulWidget {
  String? customerId;
  String? orderId;
  String? id;
  String? email;
  String? pswd;
  String? appManagerId;
  int? stream;
  bool? delivered;
  String? dateOfDelivery;
  SendOtp(
      {super.key,
      this.customerId,
      this.orderId,
      this.id,
      this.email,
      this.pswd,
      this.stream,
      this.appManagerId,
      this.delivered,
      this.dateOfDelivery});

  @override
  State<SendOtp> createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  bool loading = false;
  int? otp;
  bool otpSent = false;
  final otpController = TextEditingController();
  int seconds = 0;
  int totalSeconds = 120; // Set the total duration of the timer in seconds
  Timer? _timer;
  bool isTimerRunning = false;
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    // Start the timer only if it's not running
    if (!isTimerRunning) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (seconds < totalSeconds) {
            seconds++;
          } else {
            // Stop the timer when the desired time is reached
            _timer!.cancel();
            isTimerRunning = false;
            otpSent = false;
            setState(() {});
            // You can add additional logic here when the timer is completed
            print('Timer completed!');
          }
        });
      });
      isTimerRunning = true;
    }
  }

  void resetTimer() {
    // Reset the timer
    if (_timer!.isActive) {
      _timer!.cancel();
    } else if (!_timer!.isActive) {}
    setState(() {
      seconds = 0;
      isTimerRunning = false;
    });
  }

  String formatTime(int timeInSeconds) {
    // Format the time as mm:ss
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dateOfDelivery != null) {
      int date = int.parse(widget.dateOfDelivery!);
      dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    }
    return widget.delivered == true
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: mq.height * .15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey, width: 1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Delivery details',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: mq.height * .05,
                    ),
                    ListTile(
                      title: Text('Order Id'),
                      trailing: Text('${widget.orderId}'),
                    ),
                    ListTile(
                      title: Text('Customer Id'),
                      trailing: Text('${widget.customerId}'),
                    ),
                    ListTile(
                      title: Text('Date of delivery'),
                      trailing: Text(
                          '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
                    ),
                    Text(
                      'Delivered',
                      style: TextStyle(
                          color: Colors.green.shade400,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          )
        : StreamBuilder(
            stream: Auth.customerRef.doc(widget.customerId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                String token = snapshot.data?['token'];
                return Scaffold(
                    appBar: AppBar(
                      title: Text('${widget.orderId}'),
                      centerTitle: true,
                    ),
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            otpSent
                                ? TextField(
                                    controller: otpController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.code),
                                        border: OutlineInputBorder()),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Time Remaining: ${formatTime(totalSeconds - seconds)}',
                              style: TextStyle(fontSize: 24),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 50,
                              ),
                            ),
                            otpSent == false
                                ? InkWell(
                                    onTap: () async {
                                      setState(() {
                                        if (otpSent == false) {
                                          otpSent = true;
                                          startTimer();
                                        } else {
                                          otpSent = false;
                                        }
                                      });
                                      otp = await FirebaseApi.otpNotification(
                                          token);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Center(
                                        child: Text('Send OTP'),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                if (otp == int.parse(otpController.text)) {
                                  final date = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  await Auth.customerRef
                                      .doc(widget.customerId)
                                      .collection('orders')
                                      .doc(widget.orderId)
                                      .update({
                                    'delivered': true,
                                    'dateOfDelivery': date
                                  });
                                  await Auth.deliveryRef
                                      .doc(widget.id)
                                      .collection('delivered')
                                      .doc(widget.orderId)
                                      .set({
                                    'customerId': widget.customerId,
                                    'orderId': widget.orderId,
                                    'dateOfDelivery': date
                                  });
                                  if (widget.stream == 1) {
                                    await Auth.appManagerRef
                                        .doc(widget.appManagerId)
                                        .collection('notifications')
                                        .doc(widget.appManagerId)
                                        .collection('shopping')
                                        .doc(widget.orderId)
                                        .update({
                                      'delivered': true,
                                      'dateOfDelivery': date
                                    });
                                  } else {
                                    await Auth.appManagerRef
                                        .doc(widget.appManagerId)
                                        .collection('notifications')
                                        .doc(widget.appManagerId)
                                        .collection('shopping')
                                        .doc(widget.orderId?.substring(
                                            0, widget.orderId!.length - 1))
                                        .collection('products')
                                        .doc(widget.orderId)
                                        .update({
                                      'delivered': true,
                                      'dateOfDelivery': date
                                    });
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DeliveryHome(
                                                email: widget.email,
                                                id: widget.id,
                                                password: widget.pswd,
                                              )),
                                      (route) => false);
                                  Utilities().showMessage('Order delivered');
                                } else {
                                  Utilities().showMessage('Wrong OTP entered');
                                }
                              },
                              child: Container(
                                height: 40,
                                width: 180,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade400,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: loading == true
                                      ? CircularProgressIndicator()
                                      : Text(
                                          'Verify',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
  }
}
