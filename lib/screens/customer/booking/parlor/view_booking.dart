import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/controller/auth.dart';
import 'package:mall/controller/firebase_api.dart';
import 'package:mall/screens/customer/booking/parlor/parlor_bookings.dart';

import '../../../../main.dart';

class ViewBooking extends StatefulWidget {
  String? bookingId;
  String? shopId;
  ViewBooking({super.key, this.bookingId, this.shopId});

  @override
  State<ViewBooking> createState() => _ViewBookingState();
}

class _ViewBookingState extends State<ViewBooking> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.customerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('bookings')
            .doc(widget.shopId)
            .collection('parlor')
            .doc(widget.bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String dop = snapshot.data?['date'];
            DateTime dateTime = DateTime.parse(dop);
            String time = snapshot.data?['time'];
            return Scaffold(
              backgroundColor: Colors.blue.shade200,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                ),
                title: Text(
                  'My Bookings',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                elevation: 0,
              ),
              body: Center(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: mq.height * .15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      snapshot.data?['cancelled']
                          ? Text(
                              'Cancelled',
                              style: TextStyle(color: Colors.red.shade800),
                            )
                          : SizedBox(),
                      ListTile(
                        title: Text('Booking Id'),
                        trailing: Text("${snapshot.data?['bookingId']}"),
                      ),
                      ListTile(
                        title: Text('Service Name'),
                        trailing: Text("${snapshot.data?['serviceName']}"),
                      ),
                      ListTile(
                        title: Text('Amount paid'),
                        trailing: Text("${snapshot.data?['amount']}"),
                      ),
                      ListTile(
                        title: Text('Date'),
                        trailing: Text(
                            "${dateTime.day}-${dateTime.month}-${dateTime.year}"),
                      ),
                      ListTile(
                        title: Text('Time'),
                        trailing: Text("${time}"),
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: InkWell(
                onTap: () {
                  showCancelDialog(context, widget.bookingId!, widget.shopId!);
                },
                child: Container(
                  width: mq.width,
                  height: mq.height * .1,
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> showCancelDialog(
      BuildContext context, String bookingId, String shopId) async {
    String? appManagerId, appManagerToken;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: mq.height / 5,
                width: mq.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Are you sure you want to cancel your booking ? '),
                    SizedBox(
                      height: mq.height * .06,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            await Auth.customerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('bookings')
                                .doc(widget.shopId)
                                .collection('parlor')
                                .doc(widget.bookingId)
                                .update({'cancelled': true});
                            final snapshot =
                                await Auth.shopManagerRef.doc(shopId).get();
                            print(snapshot.data()?['token']);
                            String token = snapshot.data()?['token'];
                            await Auth.appManagerRef.get().then(
                              (QuerySnapshot querySnapshot) {
                                for (QueryDocumentSnapshot documentSnapshot
                                    in querySnapshot.docs) {
                                  Map<String, dynamic> keyValuePairs =
                                      documentSnapshot.data()
                                          as Map<String, dynamic>;
                                  appManagerId = keyValuePairs['uid'];
                                  appManagerToken = keyValuePairs['token'];
                                }
                              },
                            );
                            FirebaseApi.cancelBooking(
                                uid: shopId,
                                bookingId: widget.bookingId,
                                token: token);
                            FirebaseApi.cancelBooking(
                                    uid: appManagerId,
                                    bookingId: widget.bookingId,
                                    token: appManagerToken,
                                    forAppManager: true)
                                .then((value) {
                              Utilities().showMessage('Booking Cancelled');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ParlorBookings()),
                                  (route) => false);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            child: Center(
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
