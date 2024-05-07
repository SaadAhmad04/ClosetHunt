// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mall/controller/auth.dart';
// import 'package:mall/screens/customer/booking/parlor/view_booking.dart';
//
// import '../../../main.dart';
// import '../rive/NavigationPoint.dart';
//
// class MyBookings extends StatefulWidget {
//   String? shopId;
//
//   MyBookings({super.key, this.shopId});
//
//   @override
//   State<MyBookings> createState() => _MyBookingsState();
// }
//
// class _MyBookingsState extends State<MyBookings> {
//   final spinkit = SpinKitRotatingCircle(
//     itemBuilder: (BuildContext context, int index) {
//       return DecoratedBox(
//         decoration: BoxDecoration(
//           color: Color(0xff974c7c),
//         ),
//       );
//     },
//   );
//   bool? exists;
//   bool? showDateHeader;
//   String? orderId, type;
//   Map<String, String> map = {};
//   Stream<QuerySnapshot>? stream;
//   String? period;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     stream = Auth.customerRef
//         .doc(Auth.auth.currentUser!.uid)
//         .collection('bookings')
//         .snapshots();
//   }
//
//   Future<bool> checkSubcollectionExistence(String shopId) async {
//     final CollectionReference mainCollection = Auth.shopManagerRef;
//     final DocumentReference document = mainCollection.doc(shopId);
//
//     final subCollections = ['parlor', 'restaurant'];
//
//     for (final subCollection in subCollections) {
//       final CollectionReference subCollectionRef =
//       document.collection(subCollection);
//       final QuerySnapshot querySnapshot = await subCollectionRef.get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         exists = await true;
//         type = await subCollection;
//         map[shopId] = type!;
//         return true;
//       }
//     }
//     exists = await false;
//     type = null;
//     map[shopId] = await type!;
//     return false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(Auth.auth.currentUser!.uid);
//     return StreamBuilder<QuerySnapshot>(
//         stream: stream,
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           print(snapshot.data?.docs.length);
//           if (snapshot.hasData && snapshot.data != null) {
//             QuerySnapshot querySnapshot =
//             snapshot.data as QuerySnapshot<Object?>;
//             List<QueryDocumentSnapshot> documents = querySnapshot.docs;
//             print('Docu ${documents}');
//             return Scaffold(
//               extendBodyBehindAppBar: true,
//               appBar: AppBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0.0,
//                 leading: BackButton(
//                   color: Color(0xff974c7c),
//                   onPressed: () {
//                     Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => NavigationPoint()),
//                             (route) => false);
//                   },
//                 ),
//                 title: ShaderMask(
//                     shaderCallback: (Rect bounds) {
//                       return LinearGradient(colors: [Colors.pink, Colors.black])
//                           .createShader(bounds);
//                     },
//                     child: Text(
//                       'My Bookings',
//                       style: TextStyle(
//                         fontSize: 22.0,
//                         color: Colors.white,
//                       ),
//                     )),
//                 centerTitle: true,
//               ),
//               body: Stack(
//                 children: [
//                   Container(
//                     //color: Colors.blue,
//                     height: mq.height,
//                     width: mq.width,
//                     child: Image.network(
//                       "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   ListView.builder(
//                     itemCount: documents.length,
//                     itemBuilder: (context, index) {
//                       String shopManagerId = documents[index].id;
//                       return FutureBuilder(
//                         future: checkSubcollectionExistence(shopManagerId),
//                         builder: (context, snap) {
//                           if (snap.connectionState == ConnectionState.done) {
//                             bool subcollectionExists = snap.data as bool;
//                             if (subcollectionExists) {
//                               if (type == 'parlor') {
//                                 return StreamBuilder(
//                                   stream: Auth.customerRef
//                                       .doc(Auth.auth.currentUser!.uid)
//                                       .collection('bookings')
//                                       .doc(shopManagerId)
//                                       .collection('parlor')
//                                       .snapshots(),
//                                   builder: (context, sp) {
//                                     if (sp.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return Center(
//                                         child: spinkit,
//                                       );
//                                     } else if (sp.data != null && sp.hasData) {
//                                       return ListView.builder(
//                                         reverse: true,
//                                         shrinkWrap: true,
//                                         itemCount: sp.data!.docs.length,
//                                         itemBuilder: (context, index) {
//                                           String dop =
//                                           sp.data!.docs[index]['date'];
//                                           DateTime dateTime =
//                                           DateTime.parse(dop);
//                                           return Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Card(
//                                               elevation: 10,
//                                               shadowColor: Color(0xff974c7c),
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                       10)),
//                                               child: ListTile(
//                                                 leading: CircleAvatar(
//                                                   backgroundColor:
//                                                   Color(0xff8D8E36),
//                                                   child: Icon(
//                                                     Icons.book_outlined,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         10),
//                                                     side: BorderSide(
//                                                         color: Colors.black)),
//                                                 visualDensity:
//                                                 VisualDensity(vertical: 3),
//                                                 title: Text(sp.data!.docs[index]
//                                                 ['shopName']),
//                                                 trailing: Text(
//                                                     "${dateTime.day}-${dateTime.month}-${dateTime.year}"),
//                                                 subtitle: sp.data!.docs[index]
//                                                 ['cancelled'] ==
//                                                     true
//                                                     ? Text(
//                                                   'Cancelled',
//                                                   style: TextStyle(
//                                                       color: Colors
//                                                           .red.shade600,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .bold),
//                                                 )
//                                                     : Text(
//                                                   sp.data!.docs[index]
//                                                   ['time'],
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .bold),
//                                                 ),
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) => ViewBooking(
//                                                               bookingId: sp
//                                                                   .data!
//                                                                   .docs[
//                                                               index]
//                                                               ['bookingId'],
//                                                               cancelled: sp
//                                                                   .data!
//                                                                   .docs[
//                                                               index]
//                                                               ['cancelled'],
//                                                               shopId:
//                                                               shopManagerId)));
//                                                 },
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     } else if (sp.hasError ||
//                                         sp.data == null ||
//                                         !sp.hasData) {
//                                       return SizedBox();
//                                     } else {
//                                       return Text('No shopkeeper');
//                                     }
//                                   },
//                                 );
//                               } else {
//                                 return StreamBuilder(
//                                   stream: Auth.customerRef
//                                       .doc(Auth.auth.currentUser!.uid)
//                                       .collection('bookings')
//                                       .doc(shopManagerId)
//                                       .collection('restaurant')
//                                       .snapshots(),
//                                   builder: (context, sp) {
//                                     if (sp.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return Center(
//                                         child: spinkit,
//                                       );
//                                     } else if (sp.data != null && sp.hasData) {
//                                       return ListView.builder(
//                                         reverse: true,
//                                         shrinkWrap: true,
//                                         itemCount: sp.data!.docs.length,
//                                         itemBuilder: (context, index) {
//                                           String time =
//                                           sp.data!.docs[index]['time'];
//                                           int hr =
//                                           int.parse(time.split(":").first);
//                                           int min =
//                                           int.parse(time.split(":").last);
//                                           if (hr > 12 || hr < 23) {
//                                             hr = hr - 12;
//                                             period = "pm";
//                                           } else {
//                                             period = "am";
//                                           }
//                                           return Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Card(
//                                               elevation: 10,
//                                               shadowColor: Color(0xff974c7c),
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                       10)),
//                                               child: ListTile(
//                                                 leading: CircleAvatar(
//                                                   backgroundColor:
//                                                   Color(0xff8D8E36),
//                                                   child: Icon(
//                                                     Icons.book_outlined,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         10),
//                                                     side: BorderSide(
//                                                         color: Colors.black)),
//                                                 visualDensity:
//                                                 VisualDensity(vertical: 3),
//                                                 title: Text(sp.data!.docs[index]
//                                                 ['shopName']),
//                                                 subtitle: sp.data!.docs[index]
//                                                 ['cancelled'] ==
//                                                     true
//                                                     ? Text(
//                                                   'Cancelled',
//                                                   style: TextStyle(
//                                                       color: Colors
//                                                           .red.shade600,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .bold),
//                                                 )
//                                                     : Text(
//                                                   '${hr}:${min} ${period}',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .bold),
//                                                 ),
//                                                 trailing: Text(
//                                                     "${sp.data!.docs[index]['day']}-${sp.data!.docs[index]['month']}-${sp.data!.docs[index]['year']}"),
//                                                 onTap: () {
//                                                   Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) => ViewBooking(
//                                                               bookingId: sp
//                                                                   .data!
//                                                                   .docs[
//                                                               index]
//                                                               ['bookingId'],
//                                                               restro: true,
//                                                               cancelled: sp
//                                                                   .data!
//                                                                   .docs[
//                                                               index]
//                                                               ['cancelled'],
//                                                               shopId:
//                                                               shopManagerId)));
//                                                 },
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     } else if (sp.hasError ||
//                                         sp.data == null ||
//                                         !sp.hasData) {
//                                       return SizedBox();
//                                     } else {
//                                       return Text('No shopkeeper');
//                                     }
//                                   },
//                                 );
//                               }
//                             } else {
//                               return SizedBox();
//                             }
//                           } else {
//                             return Center(
//                               child: spinkit,
//                             );
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: spinkit);
//           } else {
//             return Center(child: Text('No bookings available'));
//           }
//         });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mall/controller/auth.dart';
import 'package:mall/screens/customer/booking/parlor/view_booking.dart';

import '../../../main.dart';
import '../rive/NavigationPoint.dart';

class MyBookings extends StatefulWidget {
  String? shopId;

  MyBookings({super.key, this.shopId});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  final spinkit = SpinKitRotatingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xff974c7c),
        ),
      );
    },
  );
  bool? exists;
  bool? showDateHeader;
  String? orderId, type;
  Map<String, String> map = {};
  Stream<QuerySnapshot>? stream;
  String? period;
  bool complete = false;

  @override
  void initState() {
    super.initState();
    stream = Auth.customerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('bookings')
        .snapshots();
  }

  Future<bool> checkSubcollectionExistence(String shopId) async {
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document = mainCollection.doc(shopId);

    final subCollections = ['parlor', 'restaurant'];

    for (final subCollection in subCollections) {
      final CollectionReference subCollectionRef =
          document.collection(subCollection);
      final QuerySnapshot querySnapshot = await subCollectionRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        exists = true;
        type = subCollection;
        map[shopId] = type!;
        return true;
      }
    }
    exists = false;
    type = null;
    map[shopId] = type!;
    return false;
  }

  Set<String> years = {'All'};
  String dropDownValue = 'All';

  Future<void> updateYears(
      List<DocumentSnapshot<Map<String, dynamic>>>? docs) async {
    if (docs != null) {
      for (final doc in docs) {
        int orderId = int.parse(
          doc['bookingId'].toString(),
        );
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(orderId);
        years.add(dateTime.year.toString());
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length!=0) {
          QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot<Object?>;
          List<QueryDocumentSnapshot> documents = querySnapshot.docs;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: BackButton(
                color: Color(0xff974c7c),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationPoint()),
                      (route) => false);
                },
              ),
              title: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(colors: [Colors.pink, Colors.black])
                        .createShader(bounds);
                  },
                  child: Text(
                    'My Bookings',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  )),
              centerTitle: true,
              actions: [
                complete == true
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: mq.height * .01,
                            horizontal: mq.width * .05),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 1,
                          padding: const EdgeInsets.only(top: 8),
                          value: dropDownValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: years
                              .map<DropdownMenuItem<String>>((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownValue = newValue!;
                            });
                          },
                        ),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff8D8E36),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10), // Adjust padding
                          ),
                          onPressed: () {
                            setState(() {
                              complete = true;
                            });
                          },
                          icon: SizedBox(
                            width: 24,
                            height: 24,
                            child: Icon(Icons.filter_alt_rounded),
                          ),
                          label: Text('Filter'),
                        ),
                    )
              ],
            ),
            body: Stack(
              children: [
                Container(
                  height: mq.height,
                  width: mq.width,
                  child: Image.network(
                    "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    String shopManagerId = documents[index].id;
                    return FutureBuilder(
                      future: checkSubcollectionExistence(shopManagerId),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          bool subcollectionExists = snap.data as bool;
                          if (subcollectionExists) {
                            if (type == 'parlor') {
                              return StreamBuilder(
                                stream: Auth.customerRef
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('bookings')
                                    .doc(shopManagerId)
                                    .collection('parlor')
                                    .snapshots(),
                                builder: (context, sp) {
                                  if (sp.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: spinkit,
                                    );
                                  } else if (sp.data != null && sp.hasData) {
                                    return FutureBuilder(
                                      future: updateYears(sp.data?.docs),
                                      builder: (context, snapshot1) {
                                        if (snapshot1.connectionState ==
                                            ConnectionState.waiting) {
                                          return spinkit;
                                        } else if (snapshot1.connectionState ==
                                            ConnectionState.done) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: sp.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              String dop =
                                                  sp.data!.docs[index]['date'];
                                              DateTime dateTime =
                                                  DateTime.parse(dop);
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Card(
                                                  elevation: 10,
                                                  shadowColor:
                                                      Color(0xff974c7c),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Color(0xff8D8E36),
                                                      child: Icon(
                                                        Icons.book_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                    visualDensity:
                                                        VisualDensity(
                                                            vertical: 3),
                                                    title: Text(
                                                        sp.data!.docs[index]
                                                            ['shopName']),
                                                    trailing: Text(
                                                        "${dateTime.day}-${dateTime.month}-${dateTime.year}"),
                                                    subtitle: sp.data!
                                                                    .docs[index]
                                                                ['cancelled'] ==
                                                            true
                                                        ? Text(
                                                            'Cancelled',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red
                                                                    .shade600,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : Text(
                                                            sp.data!.docs[index]
                                                                ['time'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      ViewBooking(
                                                                        bookingId: sp
                                                                            .data!
                                                                            .docs[index]['bookingId'],
                                                                        cancelled: sp
                                                                            .data!
                                                                            .docs[index]['cancelled'],
                                                                        shopId:
                                                                            shopManagerId,
                                                                      )));
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return spinkit;
                                        }
                                      },
                                    );
                                  } else if (sp.hasError ||
                                      sp.data == null ||
                                      !sp.hasData) {
                                    return SizedBox();
                                  } else {
                                    return Text('No shopkeeper');
                                  }
                                },
                              );
                            } else {
                              return StreamBuilder(
                                stream: Auth.customerRef
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('bookings')
                                    .doc(shopManagerId)
                                    .collection('restaurant')
                                    .snapshots(),
                                builder: (context, sp) {
                                  if (sp.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: spinkit,
                                    );
                                  } else if (sp.data != null && sp.hasData) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: sp.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        String time =
                                            sp.data!.docs[index]['time'];
                                        int hr =
                                            int.parse(time.split(":").first);
                                        int min =
                                            int.parse(time.split(":").last);
                                        if (hr > 12 || hr < 23) {
                                          hr = hr - 12;
                                          period = "pm";
                                        } else {
                                          period = "am";
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 10,
                                            shadowColor: Color(0xff974c7c),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Color(0xff8D8E36),
                                                child: Icon(
                                                  Icons.book_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      color: Colors.black)),
                                              visualDensity:
                                                  VisualDensity(vertical: 3),
                                              title: Text(sp.data!.docs[index]
                                                  ['shopName']),
                                              subtitle: sp.data!.docs[index]
                                                          ['cancelled'] ==
                                                      true
                                                  ? Text(
                                                      'Cancelled',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .red.shade600,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      '${hr}:${min} ${period}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                              trailing: Text(
                                                  "${sp.data!.docs[index]['day']}-${sp.data!.docs[index]['month']}-${sp.data!.docs[index]['year']}"),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewBooking(
                                                              bookingId: sp
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['bookingId'],
                                                              restro: true,
                                                              cancelled: sp
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['cancelled'],
                                                              shopId:
                                                                  shopManagerId,
                                                            )));
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else if (sp.hasError ||
                                      sp.data == null ||
                                      !sp.hasData) {
                                    return SizedBox();
                                  } else {
                                    return Text('No shopkeeper');
                                  }
                                },
                              );
                            }
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return Center(
                            child: spinkit,
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData ||
            snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: spinkit);
        } else {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: BackButton(
                  color: Color(0xff974c7c),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavigationPoint()),
                            (route) => false);
                  },
                ),
                title: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(colors: [Colors.pink, Colors.black])
                          .createShader(bounds);
                    },
                    child: Text(
                      'My Bookings',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    )),
                centerTitle: true,
                actions: [
                  complete == true
                      ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mq.height * .01,
                        horizontal: mq.width * .05),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 1,
                      padding: const EdgeInsets.only(top: 8),
                      value: dropDownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: years
                          .map<DropdownMenuItem<String>>((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff8D8E36),
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10), // Adjust padding
                      ),
                      onPressed: () {
                        setState(() {
                          complete = true;
                        });
                      },
                      icon: SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(Icons.filter_alt_rounded),
                      ),
                      label: Text('Filter'),
                    ),
                  )
                ],
              ),
              body: Stack(
            children: [
              Container(
                height: mq.height,
                width: mq.width,
                child: Image.network(
                  "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Center(child: Text('No bookings available')),
            ],
          ));
        }
      },
    );
  }
}
