// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/constant/utils/utilities.dart';
// import 'package:mall/controller/auth.dart';
// import 'package:mall/controller/firebase_api.dart';
// import 'package:mall/screens/customer/booking/my_bookings.dart';
// import '../../../../main.dart';
//
// class ViewBooking extends StatefulWidget {
//   String? bookingId;
//   String? shopId;
//   bool restro;
//   bool? cancelled;
//
//   ViewBooking(
//       {super.key,
//         this.bookingId,
//         this.shopId,
//         this.restro = false,
//         this.cancelled});
//
//   @override
//   State<ViewBooking> createState() => _ViewBookingState();
// }
//
// class _ViewBookingState extends State<ViewBooking> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.restro == false
//         ? StreamBuilder(
//         stream: Auth.customerRef
//             .doc(Auth.auth.currentUser!.uid)
//             .collection('bookings')
//             .doc(widget.shopId)
//             .collection('parlor')
//             .doc(widget.bookingId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             String dop = snapshot.data?['date'];
//             DateTime dateTime = DateTime.parse(dop);
//             String time = snapshot.data?['time'];
//             return Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.transparent,
//                 leading: BackButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   color: Colors.black,
//                 ),
//                 title: Text(
//                   'My Bookings',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 centerTitle: true,
//                 elevation: 0,
//               ),
//               body: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: [Color(0xFFe8d6e8), Colors.white],
//                       stops: const [0.3, 0.9],
//                       begin: Alignment.topLeft,
//                       end: Alignment.topRight),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                         margin: EdgeInsets.only(top: mq.height * .04),
//                         //color: Colors.black,
//                         height: mq.height / 8,
//                         child: snapshot.data?['cancelled']
//                             ? Image.asset("images/cross.png")
//                             : Image.asset("images/check.png")),
//                     Card(
//                       elevation: 10,
//                       shadowColor: Color(0xff974c7c),
//                       color: Colors.white,
//                       margin:
//                       EdgeInsets.symmetric(vertical: mq.height * .05),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           snapshot.data?['cancelled']
//                               ? Text(
//                             'Cancelled',
//                             style:
//                             TextStyle(color: Colors.red.shade800),
//                           )
//                               : SizedBox(),
//                           ListTile(
//                             title: Text('Booking Id'),
//                             trailing:
//                             Text("${snapshot.data?['bookingId']}"),
//                           ),
//                           ListTile(
//                             title: Text('Service Name'),
//                             trailing:
//                             Text("${snapshot.data?['serviceName']}"),
//                           ),
//                           ListTile(
//                             title: Text('Amount paid'),
//                             trailing: Text("${snapshot.data?['amount']}"),
//                           ),
//                           ListTile(
//                             title: Text('Date'),
//                             trailing: Text(
//                                 "${dateTime.day}-${dateTime.month}-${dateTime.year}"),
//                           ),
//                           ListTile(
//                             title: Text('Time'),
//                             trailing: Text("${time}"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               bottomNavigationBar: widget.cancelled == false
//                   ? InkWell(
//                   onTap: () {
//                     showCancelDialog(
//                         context, widget.bookingId!, widget.shopId!);
//                   },
//                   child: Container(
//                     width: mq.width,
//                     height: mq.height * .1,
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade400,
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(
//                             color: Colors.white, fontSize: 18),
//                       ),
//                     ),
//                   ))
//                   : Container(
//                 width: mq.width,
//                 height: mq.height * .1,
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade400,
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Cancelled',
//                     style:
//                     TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         })
//         : StreamBuilder(
//         stream: Auth.customerRef
//             .doc(Auth.auth.currentUser!.uid)
//             .collection('bookings')
//             .doc(widget.shopId)
//             .collection('restaurant')
//             .doc(widget.bookingId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             String time = snapshot.data?['time'];
//             return Scaffold(
//               //backgroundColor: Colors.blue.shade200,
//               appBar: AppBar(
//                 backgroundColor: Colors.transparent,
//                 leading: BackButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   color: Colors.black,
//                 ),
//                 title: Text(
//                   'My Bookings',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 centerTitle: true,
//                 elevation: 0,
//               ),
//               body: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: [Color(0xFFe8d6e8), Colors.white],
//                       stops: const [0.3, 0.9],
//                       begin: Alignment.topLeft,
//                       end: Alignment.topRight),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                         margin: EdgeInsets.only(top: mq.height * .04),
//                         //color: Colors.black,
//                         height: mq.height / 8,
//                         child: snapshot.data?['cancelled']
//                             ? Image.asset("images/cross.png")
//                             : Image.asset("images/check.png")),
//                     Card(
//                       elevation: 10,
//                       shadowColor: Color(0xff974c7c),
//                       color: Colors.white,
//                       margin:
//                       EdgeInsets.symmetric(vertical: mq.height * .05),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           snapshot.data?['cancelled']
//                               ? Text(
//                             'Cancelled',
//                             style:
//                             TextStyle(color: Colors.red.shade800),
//                           )
//                               : SizedBox(),
//                           ListTile(
//                             title: Text('Booking Id'),
//                             trailing:
//                             Text("${snapshot.data?['bookingId']}"),
//                           ),
//                           ListTile(
//                             title: Text('Date'),
//                             trailing: Text(
//                                 "${snapshot.data?['day']}-${snapshot.data?['month']}-${snapshot.data?['year']}"),
//                           ),
//                           ListTile(
//                             title: Text('Slot type'),
//                             trailing: Text("${snapshot.data?['slotType']}"),
//                           ),
//                           ListTile(
//                             title: Text('Time slot'),
//                             trailing: Text("${time} pm"),
//                           ),
//                           ListTile(
//                             title: Text('No.of guests'),
//                             trailing: Text("${snapshot.data?['guests']}"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               bottomNavigationBar: widget.cancelled == false
//                   ? InkWell(
//                   onTap: () {
//                     showCancelDialog(
//                         context, widget.bookingId!, widget.shopId!);
//                   },
//                   child: Container(
//                     width: mq.width,
//                     height: mq.height * .1,
//                     decoration: BoxDecoration(
//                       color: Color(0xff974C7C),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Click Here To Cancel.',
//                         style: TextStyle(
//                             color: Colors.white, fontSize: 18),
//                       ),
//                     ),
//                   ))
//                   : Container(
//                 width: mq.width,
//                 height: mq.height * .1,
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade400,
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Cancelled',
//                     style:
//                     TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         });
//   }
//
//   Future<void> showCancelDialog(
//       BuildContext context, String bookingId, String shopId) async {
//     String? appManagerId, appManagerToken;
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                 height: mq.height / 5,
//                 width: mq.width,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Are you sure you want to cancel your booking ? '),
//                     SizedBox(
//                       height: mq.height * .06,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             height: 40,
//                             width: 80,
//                             child: Center(
//                               child: Text(
//                                 'No',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             decoration: BoxDecoration(
//                                 color: Color(0xff974C7C),
//                                 borderRadius: BorderRadius.circular(20)),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         InkWell(
//                           onTap: () async {
//                             if (widget.restro == false) {
//                               await Auth.customerRef
//                                   .doc(Auth.auth.currentUser!.uid)
//                                   .collection('bookings')
//                                   .doc(widget.shopId)
//                                   .collection('parlor')
//                                   .doc(widget.bookingId)
//                                   .update({'cancelled': true});
//                             } else {
//                               await Auth.customerRef
//                                   .doc(Auth.auth.currentUser!.uid)
//                                   .collection('bookings')
//                                   .doc(widget.shopId)
//                                   .collection('restaurant')
//                                   .doc(widget.bookingId)
//                                   .update({'cancelled': true});
//                             }
//                             final snapshot =
//                             await Auth.shopManagerRef.doc(shopId).get();
//                             print(snapshot.data()?['token']);
//                             String token = snapshot.data()?['token'];
//                             await Auth.appManagerRef.get().then(
//                                   (QuerySnapshot querySnapshot) {
//                                 for (QueryDocumentSnapshot documentSnapshot
//                                 in querySnapshot.docs) {
//                                   Map<String, dynamic> keyValuePairs =
//                                   documentSnapshot.data()
//                                   as Map<String, dynamic>;
//                                   appManagerId = keyValuePairs['uid'];
//                                   appManagerToken = keyValuePairs['token'];
//                                 }
//                               },
//                             );
//                             FirebaseApi.cancelBooking(
//                                 uid: shopId,
//                                 bookingId: widget.bookingId,
//                                 token: token);
//                             FirebaseApi.cancelBooking(
//                                 uid: appManagerId,
//                                 bookingId: widget.bookingId,
//                                 token: appManagerToken,
//                                 forAppManager: true)
//                                 .then((value) {
//                               Utilities().showMessage('Booking Cancelled');
//                             });
//                             Navigator.pushAndRemoveUntil(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => MyBookings()),
//                                     (route) => false);
//                           },
//                           child: Container(
//                             height: 40,
//                             width: 80,
//                             child: Center(
//                               child: Text(
//                                 'Yes',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             decoration: BoxDecoration(
//                                 color: Color(0xff8D8E36),
//                                 borderRadius: BorderRadius.circular(20)),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/controller/auth.dart';
import 'package:mall/controller/firebase_api.dart';
import 'package:mall/screens/customer/booking/my_bookings.dart';
import '../../../../main.dart';

class ViewBooking extends StatefulWidget {
  String? bookingId;
  String? shopId;
  bool restro;
  bool? cancelled;

  ViewBooking(
      {super.key,
        this.bookingId,
        this.shopId,
        this.restro = false,
        this.cancelled});

  @override
  State<ViewBooking> createState() => _ViewBookingState();
}

class _ViewBookingState extends State<ViewBooking> {
  @override
  Widget build(BuildContext context) {
    return widget.restro == false
        ? StreamBuilder(
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
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFe8d6e8), Colors.white],
                      stops: const [0.3, 0.9],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight),
                ),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: mq.height * .04),
                        //color: Colors.black,
                        height: mq.height / 8,
                        child: snapshot.data?['cancelled']
                            ? Image.asset("images/cross.png")
                            : Image.asset("images/check.png")),
                    Card(
                      elevation: 10,
                      shadowColor: Color(0xff974c7c),
                      color: Colors.white,
                      margin:
                      EdgeInsets.symmetric(vertical: mq.height * .05),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          snapshot.data?['cancelled']
                              ? Text(
                            'Cancelled',
                            style:
                            TextStyle(color: Colors.red.shade800),
                          )
                              : SizedBox(),
                          ListTile(
                            title: Text('Booking Id'),
                            trailing:
                            Text("${snapshot.data?['bookingId']}"),
                          ),
                          ListTile(
                            title: Text('Service Name'),
                            trailing:
                            Text("${snapshot.data?['serviceName']}"),
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
                  ],
                ),
              ),
              bottomNavigationBar: widget.cancelled == false
                  ? InkWell(
                  onTap: () {
                    showCancelDialog(
                        context, widget.bookingId!, widget.shopId!);
                  },
                  child: Container(
                    width: mq.width,
                    height: mq.height * .1,
                    decoration: const BoxDecoration(
                      color: Color(0xff974C7C),
                    ),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ))
                  : Container(
                width: mq.width,
                height: mq.height * .1,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                ),
                child: Center(
                  child: Text(
                    'Cancelled',
                    style:
                    TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        })
        : StreamBuilder(
        stream: Auth.customerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('bookings')
            .doc(widget.shopId)
            .collection('restaurant')
            .doc(widget.bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String time = snapshot.data?['time'];
            return Scaffold(
              //backgroundColor: Colors.blue.shade200,
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
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFe8d6e8), Colors.white],
                      stops: const [0.3, 0.9],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight),
                ),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: mq.height * .04),
                        //color: Colors.black,
                        height: mq.height / 8,
                        child: snapshot.data?['cancelled']
                            ? Image.asset("images/cross.png")
                            : Image.asset("images/check.png")),
                    Card(
                      elevation: 10,
                      shadowColor: Color(0xff974c7c),
                      color: Colors.white,
                      margin:
                      EdgeInsets.symmetric(vertical: mq.height * .05),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          snapshot.data?['cancelled']
                              ? Text(
                            'Cancelled',
                            style:
                            TextStyle(color: Colors.red.shade800),
                          )
                              : SizedBox(),
                          ListTile(
                            title: Text('Booking Id'),
                            trailing:
                            Text("${snapshot.data?['bookingId']}"),
                          ),
                          ListTile(
                            title: Text('Date'),
                            trailing: Text(
                                "${snapshot.data?['day']}-${snapshot.data?['month']}-${snapshot.data?['year']}"),
                          ),
                          ListTile(
                            title: Text('Slot type'),
                            trailing: Text("${snapshot.data?['slotType']}"),
                          ),
                          ListTile(
                            title: Text('Time slot'),
                            trailing: Text("${time} pm"),
                          ),
                          ListTile(
                            title: Text('No.of guests'),
                            trailing: Text("${snapshot.data?['guests']}"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: widget.cancelled == false
                  ? InkWell(
                  onTap: () {
                    showCancelDialog(
                        context, widget.bookingId!, widget.shopId!);
                  },
                  child: Container(
                    width: mq.width,
                    height: mq.height * .1,
                    decoration: BoxDecoration(
                      color: Color(0xff974C7C),
                    ),
                    child: Center(
                      child: Text(
                        'Click Here To Cancel.',
                        style: TextStyle(
                            color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ))
                  : Container(
                width: mq.width,
                height: mq.height * .1,
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                ),
                child: Center(
                  child: Text(
                    'Cancelled',
                    style:
                    TextStyle(color: Colors.white, fontSize: 18),
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
                                color: Color(0xff974C7C),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            if (widget.restro == false) {
                              await Auth.customerRef
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('bookings')
                                  .doc(widget.shopId)
                                  .collection('parlor')
                                  .doc(widget.bookingId)
                                  .update({'cancelled': true});
                            } else {
                              await Auth.customerRef
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('bookings')
                                  .doc(widget.shopId)
                                  .collection('restaurant')
                                  .doc(widget.bookingId)
                                  .update({'cancelled': true});
                            }
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
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyBookings()),
                                    (route) => false);
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
                                color: Color(0xff8D8E36),
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