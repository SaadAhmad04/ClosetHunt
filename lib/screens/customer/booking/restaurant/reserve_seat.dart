// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_calendar_week/flutter_calendar_week.dart';
// import 'package:intl/intl.dart';
// import 'package:mall/constant/utils/utilities.dart';
// import 'package:mall/controller/firebase_api.dart';
// import 'package:mall/screens/customer/booking/my_bookings.dart';
// import '../../../../controller/auth.dart';
// import '../../../../main.dart';
//
// class ReserveSeat extends StatefulWidget {
//   final lunchTime;
//   final dinnerTime;
//   String? shopId;
//   String? shopName;
//
//   ReserveSeat(
//       {Key? key,
//         required this.lunchTime,
//         required this.dinnerTime,
//         this.shopId,
//         this.shopName})
//       : super(key: key);
//
//   @override
//   _ReserveSeatState createState() => _ReserveSeatState();
// }
//
// class _ReserveSeatState extends State<ReserveSeat> {
//   String? appManagerId, appManagerToken;
//   List shopManagerToken = [];
//   List shopManagerId = [];
//   String? bookingId;
//   int quantity = 1;
//   final CalendarWeekController _controller = CalendarWeekController();
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.brown[200],
//     floatingActionButton: FloatingActionButton(
//       backgroundColor: Color(0xFFC8A2C8),
//       onPressed: () {
//         _controller.jumpToDate(DateTime.now());
//         setState(() {});
//       },
//       child: Icon(Icons.today),
//     ),
//     body: SafeArea(
//       child: Stack(
//         children: [
//           Container(
//             height: mq.height,
//             child: Image.network(
//               "https://mshanken.imgix.net/wso/bolt/2023-12/rs-silvercreekchophouse-interior-122823_1600.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),
//           Column(children: [
//             Container(
//               decoration:
//               BoxDecoration(color: Color(0xFFC8A2C8), boxShadow: [
//                 BoxShadow(
//                   color: Colors.purple,
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                 )
//               ]),
//               child: CalendarWeek(
//                 controller: _controller,
//                 height: 100,
//                 showMonth: true,
//                 minDate: DateTime.now(),
//                 maxDate: DateTime.now().add(
//                   Duration(days: 365),
//                 ),
//                 backgroundColor: Colors.white,
//                 onDatePressed: (DateTime datetime) {
//                   setState(() {});
//                 },
//                 onDateLongPressed: (DateTime datetime) {},
//                 onWeekChanged: () {},
//                 monthViewBuilder: (DateTime time) => Align(
//                   alignment: FractionalOffset.center,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     child: Text(
//                       DateFormat.yMMMM().format(time),
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 decorations: [
//                   DecorationItem(
//                     decorationAlignment: FractionalOffset.bottomRight,
//                     date: DateTime.now(),
//                     decoration: Icon(
//                       Icons.today,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.brown,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Center(
//                   child: Text(
//                     '${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year}',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               color: Colors.pink,
//               height: mq.height / 6,
//               child: Image.network(
//                 "https://media.baamboozle.com/uploads/images/12407/1641300547_396937_gif-url.gif",
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 child: ListTile(
//                   title: Text("No Of Guests"),
//                   trailing: Container(
//                     height: 30,
//                     width: mq.width * 0.375,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                         color: Color(0xFFC8A2C8)),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         TextButton(
//                             onPressed: () async {
//                               if (quantity > 1) {
//                                 quantity--;
//                                 setState(() {});
//                               } else {
//                                 Utilities().showMessage(
//                                     "Can't select for 0 Guests");
//                               }
//                             },
//                             child: Text(
//                               '-',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             )),
//                         Center(
//                             child: Text('$quantity',
//                                 style: TextStyle(color: Colors.white))),
//                         TextButton(
//                             onPressed: () async {
//                               if (quantity < 10) {
//                                 quantity++;
//                                 setState(() {});
//                               } else {
//                                 Utilities().showMessage(
//                                     "Can't select for more than 10 Guests");
//                               }
//                             },
//                             child: Text(
//                               '+',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ))
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 shadowColor: Colors.purple,
//                 elevation: 10,
//                 child: ListTile(
//                   trailing: CircleAvatar(
//                     backgroundColor: Color(0xFFC8A2C8),
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.arrow_drop_down,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         showTimeSlots(context, 'Lunch', widget.lunchTime);
//                       },
//                     ),
//                   ),
//                   title: Text('Lunch'),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 elevation: 10,
//                 shadowColor: Colors.purple,
//                 child: ListTile(
//                   trailing: CircleAvatar(
//                     backgroundColor: Color(0xFFC8A2C8),
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.arrow_drop_down,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         showTimeSlots(context, 'Dinner', widget.dinnerTime);
//                       },
//                     ),
//                   ),
//                   title: Text('Dinner'),
//                 ),
//               ),
//             ),
//           ]),
//         ],
//       ),
//     ),
//   );
//
//   Future<void> showTimeSlots(
//       BuildContext context, String slotType, List listTime) async {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           content: Container(
//             height: 200, // Set a maximum height for the AlertDialog
//             width: double.maxFinite,
//             child: StatefulBuilder(
//               builder: (context, setModalState) {
//                 return SingleChildScrollView(
//                   child: SizedBox(
//                     //height: 500,
//                     child: Column(
//                       children: [
//                         Text(slotType),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         GridView.builder(
//                           shrinkWrap: true,
//                           gridDelegate:
//                           SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: 3 / 1,
//                           ),
//                           itemCount: listTime.length,
//                           itemBuilder: (context, index) {
//                             DateTime dateTime = DateFormat.Hm().parse(
//                                 listTime[index].replaceAll('\u2009', ''));
//                             String time12Hour =
//                             DateFormat.Hm().format(dateTime);
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: InkWell(
//                                 onTap: () {
//                                   print(time12Hour);
//                                   // String time24Hour = DateFormat.Hm()
//                                   //     .format(time12Hour as DateTime);
//                                   // print(time24Hour);
//                                   DateTime nowTime = DateTime.now();
//                                   String nowtime12Hour =
//                                   DateFormat.jm().format(nowTime);
//                                   print(nowtime12Hour);
//                                   DateTime dateTime1 = DateFormat.Hm().parse(
//                                       time12Hour.replaceAll('\u2009', ''));
//                                   DateTime dateTime2 = DateFormat.Hm().parse(
//                                       nowtime12Hour.replaceAll('\u2009', ''));
//                                   print(dateTime1);
//                                   print(dateTime2);
//                                   if (dateTime2.isBefore(dateTime1)) {
//                                     print(
//                                         "$time12Hour is later than $nowtime12Hour");
//                                     bookTimeSlots(
//                                         context, time12Hour, slotType);
//                                   } else if (dateTime1.isBefore(dateTime2)) {
//                                     print(
//                                         "$time12Hour is earlier than $nowtime12Hour");
//                                     Utilities().showMessage(
//                                         "Can't book now! Please try for different slot");
//                                   } else {
//                                     print(
//                                         "$time12Hour and $nowtime12Hour are the same time");
//                                     Utilities().showMessage(
//                                         "Can't book now! Please try for different slot");
//                                   }
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.blue,
//                                       borderRadius: BorderRadius.circular(20)),
//                                   child: Center(child: Text(time12Hour)),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> bookTimeSlots(
//       BuildContext context, String timeSlot, String slotType) async {
//     int counter = 0;
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           content: Container(
//             height: mq.height * .15, // Set a maximum height for the AlertDialog
//             width: double.maxFinite,
//             child: StatefulBuilder(
//               builder: (context, setModalState) {
//                 return SizedBox(
//                   height: 200,
//                   child: Column(
//                     children: [
//                       Text(
//                           "Do you want to book table on ${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year} at $timeSlot for $quantity guests?"),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ElevatedButton(
//                                 onPressed: () async {
//                                   // List<Map<String, dynamic>> documentsData =
//                                   //     [];
//                                   // await Auth.customerRef.get().then(
//                                   //   (QuerySnapshot querySnapshot) {
//                                   //     querySnapshot.docs.forEach(
//                                   //         (QueryDocumentSnapshot
//                                   //             documentSnapshot) {
//                                   //       documentsData.add(documentSnapshot
//                                   //           .data() as Map<String, dynamic>);
//                                   //     });
//                                   //   },
//                                   // );
//                                   // for (int i = 0;
//                                   //     i < documentsData.length;
//                                   //     i++) {
//                                   //   bool exists =
//                                   //       await checkSubcollectionExistence(
//                                   //           documentsData[i]['uid']);
//                                   //   List<Map<String, dynamic>>
//                                   //       documentsData2 = [];
//                                   //   if (exists) {
//                                   //     print(
//                                   //         'rrrrrrrrrrrrrrrrr${documentsData[i]['uid']}');
//                                   //     print('rrrrrrrrrrrrrrrrr${counter}');
//                                   //     counter++;
//                                   //     await Auth.customerRef
//                                   //         .doc(documentsData[i]['uid'])
//                                   //         .collection('bookings')
//                                   //         .doc(widget.shopId)
//                                   //         .collection('restaurant')
//                                   //         .where('day',
//                                   //             isEqualTo: _controller
//                                   //                 .selectedDate.day
//                                   //                 .toString())
//                                   //         .where('month',
//                                   //             isEqualTo: _controller
//                                   //                 .selectedDate.month
//                                   //                 .toString())
//                                   //         .where('year',
//                                   //             isEqualTo: _controller
//                                   //                 .selectedDate.year
//                                   //                 .toString())
//                                   //         .where('slotType',
//                                   //             isEqualTo: "${slotType}")
//                                   //         .where('time',
//                                   //             isEqualTo: "${timeSlot}")
//                                   //         .get()
//                                   //         .then(
//                                   //       (QuerySnapshot querySnapshot) {
//                                   //         querySnapshot.docs.forEach(
//                                   //             (QueryDocumentSnapshot
//                                   //                 documentSnapshot) {
//                                   //           documentsData2.add(
//                                   //               documentSnapshot.data()
//                                   //                   as Map<String, dynamic>);
//                                   //         });
//                                   //       },
//                                   //     );
//                                   //     if (documentsData2.isNotEmpty) {
//                                   //       Utilities().showMessage(
//                                   //           'This slot is already booked,  kindly select another date and time');
//                                   //       Navigator.pop(context);
//                                   //       Navigator.pop(context);
//                                   //       break;
//                                   //     }
//                                   //   } else {
//                                   //     final dateTime = DateTime.now()
//                                   //         .millisecondsSinceEpoch
//                                   //         .toString();
//                                   //     await Auth.customerRef
//                                   //         .doc(Auth.auth.currentUser!.uid)
//                                   //         .collection('bookings')
//                                   //         .doc(widget.shopId)
//                                   //         .collection('restaurant')
//                                   //         .doc(dateTime)
//                                   //         .set({
//                                   //       'bookingId': dateTime,
//                                   //       'guests': quantity,
//                                   //       'day': _controller.selectedDate.day
//                                   //           .toString(),
//                                   //       'month': _controller
//                                   //           .selectedDate.month
//                                   //           .toString(),
//                                   //       'year': _controller.selectedDate.year
//                                   //           .toString(),
//                                   //       'shopId': widget.shopId,
//                                   //       'shopName': widget.shopName,
//                                   //       'time': timeSlot,
//                                   //       'slotType': slotType
//                                   //     }).then((value) {
//                                   //       Utilities()
//                                   //           .showMessage('Slot booked');
//                                   //       Navigator.pushAndRemoveUntil(
//                                   //           context,
//                                   //           MaterialPageRoute(
//                                   //               builder: (context) =>
//                                   //                   ParlorBookings()),
//                                   //           (route) => false);
//                                   //     });
//                                   //   }
//                                   // }
//                                   // if (counter == 0) {
//                                   //   final dateTime = DateTime.now()
//                                   //       .millisecondsSinceEpoch
//                                   //       .toString();
//                                   //   await Auth.customerRef
//                                   //       .doc(Auth.auth.currentUser!.uid)
//                                   //       .collection('bookings')
//                                   //       .doc(widget.shopId)
//                                   //       .collection('restaurant')
//                                   //       .doc(dateTime)
//                                   //       .set({
//                                   //     'bookingId': dateTime,
//                                   //     'guests': quantity,
//                                   //     'day': _controller.selectedDate.day
//                                   //         .toString(),
//                                   //     'month': _controller.selectedDate.month
//                                   //         .toString(),
//                                   //     'year': _controller.selectedDate.year
//                                   //         .toString(),
//                                   //     'shopId': widget.shopId,
//                                   //     'shopName': widget.shopName,
//                                   //     'time': timeSlot,
//                                   //     'slotType': slotType
//                                   //   }).then((value) {
//                                   //     Utilities().showMessage('Slot booked');
//                                   //     Navigator.pushAndRemoveUntil(
//                                   //         context,
//                                   //         MaterialPageRoute(
//                                   //             builder: (context) =>
//                                   //                 ParlorBookings()),
//                                   //         (route) => false);
//                                   //   });
//                                   // }
//                                   final snapshot = await Auth.customerRef
//                                       .doc(Auth.auth.currentUser!.uid)
//                                       .get();
//                                   String name = snapshot.data()?['name'];
//                                   String phone = snapshot.data()?['phone'];
//                                   String email = snapshot.data()?['email'];
//                                   await Auth.appManagerRef.get().then(
//                                         (QuerySnapshot querySnapshot) {
//                                       for (QueryDocumentSnapshot documentSnapshot
//                                       in querySnapshot.docs) {
//                                         Map<String, dynamic> keyValuePairs =
//                                         documentSnapshot.data()
//                                         as Map<String, dynamic>;
//                                         appManagerId = keyValuePairs['uid'];
//                                         appManagerToken =
//                                         keyValuePairs['token'];
//                                       }
//                                     },
//                                   );
//                                   final snap = await Auth.shopManagerRef
//                                       .doc(widget.shopId)
//                                       .get();
//                                   shopManagerToken.add(snap.data()?['token']);
//                                   shopManagerId.add(widget.shopId);
//                                   print(timeSlot);
//                                   final dateTime = DateTime.now()
//                                       .millisecondsSinceEpoch
//                                       .toString();
//                                   await Auth.customerRef
//                                       .doc(Auth.auth.currentUser!.uid)
//                                       .collection('bookings')
//                                       .doc(widget.shopId)
//                                       .set({
//                                     'shopId': widget.shopId,
//                                     'shopName': widget.shopName,
//                                   });
//                                   await Auth.customerRef
//                                       .doc(Auth.auth.currentUser!.uid)
//                                       .collection('bookings')
//                                       .doc(widget.shopId)
//                                       .collection('restaurant')
//                                       .doc(dateTime)
//                                       .set({
//                                     'bookingId': dateTime,
//                                     'guests': quantity,
//                                     'day':
//                                     _controller.selectedDate.day.toString(),
//                                     'month': _controller.selectedDate.month
//                                         .toString(),
//                                     'year': _controller.selectedDate.year
//                                         .toString(),
//                                     'shopId': widget.shopId,
//                                     'shopName': widget.shopName,
//                                     'time': timeSlot,
//                                     'slotType': slotType,
//                                     'cancelled': false
//                                   });
//                                   await FirebaseApi.myNotification(
//                                       name,
//                                       appManagerToken!,
//                                       'Seat Reserved',
//                                       Auth.auth.currentUser!.uid,
//                                       phone,
//                                       email,
//                                       appManagerId!,
//                                       restaurant: true,
//                                       date: _controller.selectedDate.toString(),
//                                       slotType: slotType,
//                                       shopId: widget.shopId,
//                                       reserve: true,
//                                       guests: quantity,
//                                       time: timeSlot,
//                                       bookingId: dateTime);
//                                   await FirebaseApi.shopNotification(
//                                       name,
//                                       shopManagerToken,
//                                       'Seat Reserved',
//                                       Auth.auth.currentUser!.uid,
//                                       phone,
//                                       email,
//                                       shopManagerId,
//                                       shopId: widget.shopId,
//                                       bookingId: dateTime,
//                                       restaurant: true,
//                                       date: _controller.selectedDate
//                                           .toString(),
//                                       time: timeSlot,
//                                       guests: quantity,
//                                       reserve: true,
//                                       slotType: slotType)
//                                       .then((value) {
//                                     Navigator.pushAndRemoveUntil(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => MyBookings()),
//                                             (route) => false);
//                                   });
//                                 },
//                                 child: Text("Yes")),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text("No")),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<bool> checkSubcollectionExistence(String customerId) async {
//     final CollectionReference mainCollection = Auth.customerRef;
//     final DocumentReference document = mainCollection.doc(customerId);
//     final CollectionReference subCollection1 = document.collection('bookings');
//     try {
//       final QuerySnapshot querySnapshot1 = await subCollection1.get();
//       return querySnapshot1.docs.isNotEmpty;
//     } catch (e) {
//       return false;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/controller/firebase_api.dart';
import 'package:mall/screens/customer/booking/my_bookings.dart';
import '../../../../controller/auth.dart';
import '../../../../main.dart';

class ReserveSeat extends StatefulWidget {
  final lunchTime;
  final dinnerTime;
  String? shopId;
  String? shopName;

  ReserveSeat(
      {Key? key,
        required this.lunchTime,
        required this.dinnerTime,
        this.shopId,
        this.shopName})
      : super(key: key);

  @override
  _ReserveSeatState createState() => _ReserveSeatState();
}

class _ReserveSeatState extends State<ReserveSeat> {
  String? appManagerId, appManagerToken;
  List shopManagerToken = [];
  List shopManagerId = [];
  String? bookingId;
  int quantity = 1;
  final CalendarWeekController _controller = CalendarWeekController();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.brown[200],
    floatingActionButton: FloatingActionButton(
      backgroundColor: Color(0xFFC8A2C8),
      onPressed: () {
        _controller.jumpToDate(DateTime.now());
        setState(() {});
      },
      child: Icon(Icons.today),
    ),
    body: SafeArea(
      child: Stack(
        children: [
          Container(
            height: mq.height,
            child: Image.network(
              "https://mshanken.imgix.net/wso/bolt/2023-12/rs-silvercreekchophouse-interior-122823_1600.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Column(children: [
            Container(
              decoration:
              BoxDecoration(color: Color(0xFFC8A2C8), boxShadow: [
                BoxShadow(
                  color: Colors.purple,
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]),
              child: CalendarWeek(
                controller: _controller,
                height: 100,
                showMonth: true,
                minDate: DateTime.now(),
                maxDate: DateTime.now().add(
                  Duration(days: 365),
                ),
                backgroundColor: Colors.white,
                onDatePressed: (DateTime datetime) {
                  setState(() {});
                },
                onDateLongPressed: (DateTime datetime) {},
                onWeekChanged: () {},
                monthViewBuilder: (DateTime time) => Align(
                  alignment: FractionalOffset.center,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMM().format(time),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFC8A2C8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                decorations: [
                  DecorationItem(
                    decorationAlignment: FractionalOffset.bottomRight,
                    date: DateTime.now(),
                    decoration: Icon(
                      Icons.today,
                      color: Color(0xFFC8A2C8),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    '${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year}',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.pink,
              height: mq.height / 6,
              child: Image.network(
                "https://media.baamboozle.com/uploads/images/12407/1641300547_396937_gif-url.gif",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text("No Of Guests"),
                  trailing: Container(
                    height: 30,
                    width: mq.width * 0.375,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xFFC8A2C8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () async {
                              if (quantity > 1) {
                                quantity--;
                                setState(() {});
                              } else {
                                Utilities().showMessage(
                                    "Can't select for 0 Guests");
                              }
                            },
                            child: Text(
                              '-',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                        Center(
                            child: Text('$quantity',
                                style: TextStyle(color: Colors.white))),
                        TextButton(
                            onPressed: () async {
                              if (quantity < 10) {
                                quantity++;
                                setState(() {});
                              } else {
                                Utilities().showMessage(
                                    "Can't select for more than 10 Guests");
                              }
                            },
                            child: Text(
                              '+',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shadowColor: Colors.purple,
                elevation: 10,
                child: ListTile(
                  trailing: CircleAvatar(
                    backgroundColor: Color(0xFFC8A2C8),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showTimeSlots(context, 'Lunch', widget.lunchTime);
                      },
                    ),
                  ),
                  title: Text('Lunch'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                shadowColor: Colors.purple,
                child: ListTile(
                  trailing: CircleAvatar(
                    backgroundColor: Color(0xFFC8A2C8),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showTimeSlots(context, 'Dinner', widget.dinnerTime);
                      },
                    ),
                  ),
                  title: Text('Dinner'),
                ),
              ),
            ),
          ]),
        ],
      ),
    ),
  );

  Future<void> showTimeSlots(
      BuildContext context, String slotType, List listTime) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            height: 200, // Set a maximum height for the AlertDialog
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: SizedBox(
                    //height: 500,
                    child: Column(
                      children: [
                        Text(slotType),
                        SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 1,
                          ),
                          itemCount: listTime.length,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateFormat.Hm().parse(
                                listTime[index].replaceAll('\u2009', ''));
                            String time12Hour =
                            DateFormat.Hm().format(dateTime);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  print(time12Hour);
                                  // String time24Hour = DateFormat.Hm()
                                  //     .format(time12Hour as DateTime);
                                  // print(time24Hour);
                                  DateTime nowTime = DateTime.now();
                                  String nowtime12Hour =
                                  DateFormat.jm().format(nowTime);
                                  print(nowtime12Hour);
                                  DateTime dateTime1 = DateFormat.Hm().parse(
                                      time12Hour.replaceAll('\u2009', ''));
                                  DateTime dateTime2 = DateFormat.Hm().parse(
                                      nowtime12Hour.replaceAll('\u2009', ''));
                                  print(dateTime1);
                                  print(dateTime2);
                                  if (dateTime2.isBefore(dateTime1)) {
                                    print(
                                        "$time12Hour is later than $nowtime12Hour");
                                    bookTimeSlots(
                                        context, time12Hour, slotType);
                                  } else if (dateTime1.isBefore(dateTime2)) {
                                    print(
                                        "$time12Hour is earlier than $nowtime12Hour");
                                    Utilities().showMessage(
                                        "Can't book now! Please try for different slot");
                                  } else {
                                    print(
                                        "$time12Hour and $nowtime12Hour are the same time");
                                    Utilities().showMessage(
                                        "Can't book now! Please try for different slot");
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFFC8A2C8),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(child: Text(time12Hour)),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> bookTimeSlots(
      BuildContext context, String timeSlot, String slotType) async {
    int counter = 0;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            height: mq.height * .15, // Set a maximum height for the AlertDialog
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      Text(
                          "Do you want to book table on ${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year} at $timeSlot for $quantity guests?"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(

                                backgroundColor: Color(0xFFC8A2C8),
                              ),
                                onPressed: () async {
                                  // List<Map<String, dynamic>> documentsData =
                                  //     [];
                                  // await Auth.customerRef.get().then(
                                  //   (QuerySnapshot querySnapshot) {
                                  //     querySnapshot.docs.forEach(
                                  //         (QueryDocumentSnapshot
                                  //             documentSnapshot) {
                                  //       documentsData.add(documentSnapshot
                                  //           .data() as Map<String, dynamic>);
                                  //     });
                                  //   },
                                  // );
                                  // for (int i = 0;
                                  //     i < documentsData.length;
                                  //     i++) {
                                  //   bool exists =
                                  //       await checkSubcollectionExistence(
                                  //           documentsData[i]['uid']);
                                  //   List<Map<String, dynamic>>
                                  //       documentsData2 = [];
                                  //   if (exists) {
                                  //     print(
                                  //         'rrrrrrrrrrrrrrrrr${documentsData[i]['uid']}');
                                  //     print('rrrrrrrrrrrrrrrrr${counter}');
                                  //     counter++;
                                  //     await Auth.customerRef
                                  //         .doc(documentsData[i]['uid'])
                                  //         .collection('bookings')
                                  //         .doc(widget.shopId)
                                  //         .collection('restaurant')
                                  //         .where('day',
                                  //             isEqualTo: _controller
                                  //                 .selectedDate.day
                                  //                 .toString())
                                  //         .where('month',
                                  //             isEqualTo: _controller
                                  //                 .selectedDate.month
                                  //                 .toString())
                                  //         .where('year',
                                  //             isEqualTo: _controller
                                  //                 .selectedDate.year
                                  //                 .toString())
                                  //         .where('slotType',
                                  //             isEqualTo: "${slotType}")
                                  //         .where('time',
                                  //             isEqualTo: "${timeSlot}")
                                  //         .get()
                                  //         .then(
                                  //       (QuerySnapshot querySnapshot) {
                                  //         querySnapshot.docs.forEach(
                                  //             (QueryDocumentSnapshot
                                  //                 documentSnapshot) {
                                  //           documentsData2.add(
                                  //               documentSnapshot.data()
                                  //                   as Map<String, dynamic>);
                                  //         });
                                  //       },
                                  //     );
                                  //     if (documentsData2.isNotEmpty) {
                                  //       Utilities().showMessage(
                                  //           'This slot is already booked,  kindly select another date and time');
                                  //       Navigator.pop(context);
                                  //       Navigator.pop(context);
                                  //       break;
                                  //     }
                                  //   } else {
                                  //     final dateTime = DateTime.now()
                                  //         .millisecondsSinceEpoch
                                  //         .toString();
                                  //     await Auth.customerRef
                                  //         .doc(Auth.auth.currentUser!.uid)
                                  //         .collection('bookings')
                                  //         .doc(widget.shopId)
                                  //         .collection('restaurant')
                                  //         .doc(dateTime)
                                  //         .set({
                                  //       'bookingId': dateTime,
                                  //       'guests': quantity,
                                  //       'day': _controller.selectedDate.day
                                  //           .toString(),
                                  //       'month': _controller
                                  //           .selectedDate.month
                                  //           .toString(),
                                  //       'year': _controller.selectedDate.year
                                  //           .toString(),
                                  //       'shopId': widget.shopId,
                                  //       'shopName': widget.shopName,
                                  //       'time': timeSlot,
                                  //       'slotType': slotType
                                  //     }).then((value) {
                                  //       Utilities()
                                  //           .showMessage('Slot booked');
                                  //       Navigator.pushAndRemoveUntil(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   ParlorBookings()),
                                  //           (route) => false);
                                  //     });
                                  //   }
                                  // }
                                  // if (counter == 0) {
                                  //   final dateTime = DateTime.now()
                                  //       .millisecondsSinceEpoch
                                  //       .toString();
                                  //   await Auth.customerRef
                                  //       .doc(Auth.auth.currentUser!.uid)
                                  //       .collection('bookings')
                                  //       .doc(widget.shopId)
                                  //       .collection('restaurant')
                                  //       .doc(dateTime)
                                  //       .set({
                                  //     'bookingId': dateTime,
                                  //     'guests': quantity,
                                  //     'day': _controller.selectedDate.day
                                  //         .toString(),
                                  //     'month': _controller.selectedDate.month
                                  //         .toString(),
                                  //     'year': _controller.selectedDate.year
                                  //         .toString(),
                                  //     'shopId': widget.shopId,
                                  //     'shopName': widget.shopName,
                                  //     'time': timeSlot,
                                  //     'slotType': slotType
                                  //   }).then((value) {
                                  //     Utilities().showMessage('Slot booked');
                                  //     Navigator.pushAndRemoveUntil(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 ParlorBookings()),
                                  //         (route) => false);
                                  //   });
                                  // }
                                  final snapshot = await Auth.customerRef
                                      .doc(Auth.auth.currentUser!.uid)
                                      .get();
                                  String name = snapshot.data()?['name'];
                                  String phone = snapshot.data()?['phone'];
                                  String email = snapshot.data()?['email'];
                                  await Auth.appManagerRef.get().then(
                                        (QuerySnapshot querySnapshot) {
                                      for (QueryDocumentSnapshot documentSnapshot
                                      in querySnapshot.docs) {
                                        Map<String, dynamic> keyValuePairs =
                                        documentSnapshot.data()
                                        as Map<String, dynamic>;
                                        appManagerId = keyValuePairs['uid'];
                                        appManagerToken =
                                        keyValuePairs['token'];
                                      }
                                    },
                                  );
                                  final snap = await Auth.shopManagerRef
                                      .doc(widget.shopId)
                                      .get();
                                  shopManagerToken.add(snap.data()?['token']);
                                  shopManagerId.add(widget.shopId);
                                  print(timeSlot);
                                  final dateTime = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  await Auth.customerRef
                                      .doc(Auth.auth.currentUser!.uid)
                                      .collection('bookings')
                                      .doc(widget.shopId)
                                      .set({
                                    'shopId': widget.shopId,
                                    'shopName': widget.shopName,
                                  });
                                  await Auth.customerRef
                                      .doc(Auth.auth.currentUser!.uid)
                                      .collection('bookings')
                                      .doc(widget.shopId)
                                      .collection('restaurant')
                                      .doc(dateTime)
                                      .set({
                                    'bookingId': dateTime,
                                    'guests': quantity,
                                    'day':
                                    _controller.selectedDate.day.toString(),
                                    'month': _controller.selectedDate.month
                                        .toString(),
                                    'year': _controller.selectedDate.year
                                        .toString(),
                                    'shopId': widget.shopId,
                                    'shopName': widget.shopName,
                                    'time': timeSlot,
                                    'slotType': slotType,
                                    'cancelled': false
                                  });
                                  await FirebaseApi.myNotification(
                                      name,
                                      appManagerToken!,
                                      'Seat Reserved',
                                      Auth.auth.currentUser!.uid,
                                      phone,
                                      email,
                                      appManagerId!,
                                      restaurant: true,
                                      date: _controller.selectedDate.toString(),
                                      slotType: slotType,
                                      shopId: widget.shopId,
                                      reserve: true,
                                      guests: quantity,
                                      time: timeSlot,
                                      bookingId: dateTime);
                                  await FirebaseApi.shopNotification(
                                      name,
                                      shopManagerToken,
                                      'Seat Reserved',
                                      Auth.auth.currentUser!.uid,
                                      phone,
                                      email,
                                      shopManagerId,
                                      shopId: widget.shopId,
                                      bookingId: dateTime,
                                      restaurant: true,
                                      date: _controller.selectedDate
                                          .toString(),
                                      time: timeSlot,
                                      guests: quantity,
                                      reserve: true,
                                      slotType: slotType)
                                      .then((value) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyBookings()),
                                            (route) => false);
                                  });
                                },
                                child: Text("Yes")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(

                                  backgroundColor: Color(0xFFC8A2C8),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> checkSubcollectionExistence(String customerId) async {
    final CollectionReference mainCollection = Auth.customerRef;
    final DocumentReference document = mainCollection.doc(customerId);
    final CollectionReference subCollection1 = document.collection('bookings');
    try {
      final QuerySnapshot querySnapshot1 = await subCollection1.get();
      return querySnapshot1.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}