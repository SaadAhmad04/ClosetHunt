// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/screens/shop_manager/view_notification.dart';
// import '../../controller/auth.dart';
//
// class OrderProduct extends StatefulWidget {
//   const OrderProduct({super.key});
//
//   @override
//   State<OrderProduct> createState() => _OrderProductState();
// }
//
// class _OrderProductState extends State<OrderProduct> {
//   var exists;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("All notifications"),
//           centerTitle: true,
//         ),
//         body: FutureBuilder(
//             future: checkSubcollectionExistence(Auth.auth.currentUser!.uid),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.connectionState == ConnectionState.done) {
//                 bool subcollectionExists = snapshot.data as bool;
//                 if (subcollectionExists) {
//                   return StreamBuilder(
//                       stream: Auth.shopManagerRef
//                           .doc(Auth.auth.currentUser!.uid)
//                           .collection('notifications')
//                           .snapshots(),
//                       builder: (context, sp) {
//                         if (sp.connectionState == ConnectionState.waiting) {
//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         } else if (sp.data != null && sp.hasData) {
//                           return ListView.builder(
//                               shrinkWrap: true,
//                               reverse: true,
//                               itemCount: sp.data!.docs.length,
//                               itemBuilder: (context, index) {
//                                 final name = sp.data!.docs[index]['name'];
//                                 String dateString =
//                                     sp.data!.docs[index]['date'];
//                                 DocumentSnapshot documentSnapshot =
//                                     sp.data!.docs[index];
//                                 Map<String, dynamic>? data = documentSnapshot
//                                     .data() as Map<String, dynamic>?;
//                                 if (data!.containsKey('bookingId') &&
//                                     data.containsKey('serviceId')) {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ListTile(
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           side: BorderSide(color: Colors.grey)),
//                                       leading: CircleAvatar(
//                                           child: Text(
//                                               '${sp.data!.docs[index]['serviceId']}')),
//                                       title: Text(name),
//                                       onTap: () {
//                                         print(
//                                             sp.data!.docs[index]['bookingId']);
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ViewNotification(
//                                                       bookingId:
//                                                           sp.data!.docs[index]
//                                                               ['bookingId'],
//                                                       customerName: name,
//                                                       customerEmail: sp.data!
//                                                           .docs[index]['email'],
//                                                       serviceId:
//                                                           sp.data!.docs[index]
//                                                               ['serviceId'],
//                                                       serviceName:
//                                                           sp.data!.docs[index]
//                                                               ['serviceName'],
//                                                       amount: double.parse(
//                                                           sp.data!.docs[index]
//                                                               ['servicePrice']),
//                                                       time: sp.data!.docs[index]
//                                                           ['time'],
//                                                       bookingDate: sp.data!
//                                                           .docs[index]['date'],
//                                                       cancelled:
//                                                           sp.data!.docs[index]
//                                                               ['cancelled'],
//                                                     )));
//                                       },
//                                       subtitle: sp.data?.docs[index]
//                                               ['cancelled']
//                                           ? Text(
//                                               'Cancelled',
//                                               style: TextStyle(
//                                                   color: Colors.red.shade800,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold),
//                                             )
//                                           : Text(
//                                               '${sp.data?.docs[index]['msg']}',
//                                               style: TextStyle(
//                                                   color: Colors.green.shade800,
//                                                   fontWeight: FontWeight.bold)),
//                                       trailing: Text(
//                                           '${sp.data!.docs[index]['servicePrice']}'),
//                                     ),
//                                   );
//                                 } else if (data.containsKey('bookingId')) {
//                                   DateTime dateTime =
//                                       DateTime.parse(dateString);
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ListTile(
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           side: BorderSide(color: Colors.grey)),
//                                       leading: CircleAvatar(
//                                           child: Text(
//                                               '${sp.data!.docs[index]['guests']}')),
//                                       title: Text(name),
//                                       onTap: () {
//                                         print(
//                                             sp.data!.docs[index]['bookingId']);
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ViewNotification(
//                                                       bookingId:
//                                                           sp.data!.docs[index]
//                                                               ['bookingId'],
//                                                       customerName: name,
//                                                       customerEmail: sp.data!
//                                                           .docs[index]['email'],
//                                                       time: sp.data!.docs[index]
//                                                           ['time'],
//                                                       bookingDate: sp.data!
//                                                           .docs[index]['date'],
//                                                       cancelled:
//                                                           sp.data!.docs[index]
//                                                               ['cancelled'],
//                                                       slotType:sp.data!.docs[index]
//                                                       ['slotType'],
//                                                       guests: sp.data!.docs[index]
//                                                       ['guests'],
//                                                       restro: true,
//                                                     )));
//                                       },
//                                       subtitle: sp.data?.docs[index]
//                                               ['cancelled']
//                                           ? Text(
//                                               'Cancelled',
//                                               style: TextStyle(
//                                                   color: Colors.red.shade800,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold),
//                                             )
//                                           : Text(
//                                               '${sp.data?.docs[index]['msg']}',
//                                               style: TextStyle(
//                                                   color: Colors.green.shade800,
//                                                   fontWeight: FontWeight.bold)),
//                                       trailing: Text(
//                                           '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
//                                     ),
//                                   );
//                                 } else {
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ListTile(
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                           side: BorderSide(color: Colors.grey)),
//                                       leading: Image.network(
//                                           '${sp.data!.docs[index]['productImage']}'),
//                                       title: Text(name),
//                                       onTap: () {
//                                         print(sp.data!.docs[index]['quantity']
//                                             .runtimeType);
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ViewNotification(
//                                                       orderId: dateString,
//                                                       amount:
//                                                           sp.data!.docs[index]
//                                                               ['perprice'],
//                                                       dateTime: dateString,
//                                                       qty: sp.data!.docs[index]
//                                                           ['quantity'],
//                                                       productId:
//                                                           sp.data!.docs[index]
//                                                               ['productId'],
//                                                       customerEmail: sp.data!
//                                                           .docs[index]['email'],
//                                                       customerName: sp.data!
//                                                           .docs[index]['name'],
//                                                       productName:
//                                                           sp.data!.docs[index]
//                                                               ['productName'],
//                                                       cancelled:
//                                                           sp.data!.docs[index]
//                                                               ['cancelled'],
//                                                     )));
//                                       },
//                                       subtitle: sp.data?.docs[index]
//                                               ['cancelled']
//                                           ? Text(
//                                               'Cancelled',
//                                               style: TextStyle(
//                                                   color: Colors.red.shade800,
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold),
//                                             )
//                                           : Text(
//                                               '${sp.data?.docs[index]['msg']}',
//                                               style: TextStyle(
//                                                   color: Colors.green.shade800,
//                                                   fontWeight: FontWeight.bold)),
//                                       trailing: Text(
//                                           '${sp.data!.docs[index]['quantity']}'),
//                                     ),
//                                   );
//                                 }
//                               });
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       });
//                 } else {
//                   return SizedBox();
//                 }
//               } else {
//                 return Text("No Orders Yet");
//               }
//             }));
//   }
//
//   Future<bool> checkSubcollectionExistence(String shopManagerId) async {
//     final CollectionReference mainCollection = Auth.shopManagerRef;
//     final DocumentReference document = mainCollection.doc(shopManagerId);
//     final CollectionReference subCollection =
//         document.collection('notifications');
//
//     try {
//       final QuerySnapshot querySnapshot = await subCollection.get();
//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       print('Error checking subcollection existence: $e');
//       return false;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/shop_manager/view_notification.dart';
import '../../controller/auth.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({super.key});

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  var exists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[50],
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "All notifications",
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: checkSubcollectionExistence(Auth.auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                bool subcollectionExists = snapshot.data as bool;
                if (subcollectionExists) {
                  return StreamBuilder(
                      stream: Auth.shopManagerRef
                          .doc(Auth.auth.currentUser!.uid)
                          .collection('notifications')
                          .snapshots(),
                      builder: (context, sp) {
                        if (sp.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (sp.data != null && sp.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: sp.data!.docs.length,
                              itemBuilder: (context, index) {
                                final name = sp.data!.docs[index]['name'];
                                String dateString =
                                sp.data!.docs[index]['date'];
                                DocumentSnapshot documentSnapshot =
                                sp.data!.docs[index];
                                Map<String, dynamic>? data = documentSnapshot
                                    .data() as Map<String, dynamic>?;
                                if (data!.containsKey('bookingId') &&
                                    data.containsKey('serviceId')) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      //color: Colors.transparent,
                                      elevation: 10,
                                      shadowColor: Colors.purple[50],
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            side: BorderSide(
                                                color: Colors.purple)),
                                        leading: CircleAvatar(
                                            backgroundColor: Colors.purple[50],
                                            child: Text(
                                                '${sp.data!.docs[index]['serviceId']}')),
                                        title: Text(name),
                                        onTap: () {
                                          print(sp.data!.docs[index]
                                          ['bookingId']);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewNotification(
                                                        bookingId:
                                                        sp.data!.docs[index]
                                                        ['bookingId'],
                                                        customerName: name,
                                                        customerEmail:
                                                        sp.data!.docs[index]
                                                        ['email'],
                                                        serviceId:
                                                        sp.data!.docs[index]
                                                        ['serviceId'],
                                                        serviceName:
                                                        sp.data!.docs[index]
                                                        ['serviceName'],
                                                        amount: double.parse(sp
                                                            .data!
                                                            .docs[index]
                                                        ['servicePrice']),
                                                        time:
                                                        sp.data!.docs[index]
                                                        ['time'],
                                                        bookingDate:
                                                        sp.data!.docs[index]
                                                        ['date'],
                                                        cancelled:
                                                        sp.data!.docs[index]
                                                        ['cancelled'],
                                                      )));
                                        },
                                        subtitle: sp.data?.docs[index]
                                        ['cancelled']
                                            ? Text(
                                          'Cancelled',
                                          style: TextStyle(
                                              color: Colors.red.shade800,
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold),
                                        )
                                            : Text(
                                            '${sp.data?.docs[index]['msg']}',
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight:
                                                FontWeight.bold)),
                                        trailing: Text(
                                            '${sp.data!.docs[index]['servicePrice']}'),
                                      ),
                                    ),
                                  );
                                } else if (data.containsKey('bookingId')) {
                                  DateTime dateTime =
                                  DateTime.parse(dateString);
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 10,
                                      shadowColor: Colors.purple[50],
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            side:
                                            BorderSide(color: Colors.grey)),
                                        leading: CircleAvatar(
                                            child: Text(
                                                '${sp.data!.docs[index]['guests']}')),
                                        title: Text(name),
                                        onTap: () {
                                          print(sp.data!.docs[index]
                                          ['bookingId']);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewNotification(
                                                        bookingId:
                                                        sp.data!.docs[index]
                                                        ['bookingId'],
                                                        customerName: name,
                                                        customerEmail:
                                                        sp.data!.docs[index]
                                                        ['email'],
                                                        time:
                                                        sp.data!.docs[index]
                                                        ['time'],
                                                        bookingDate:
                                                        sp.data!.docs[index]
                                                        ['date'],
                                                        cancelled:
                                                        sp.data!.docs[index]
                                                        ['cancelled'],
                                                        slotType:
                                                        sp.data!.docs[index]
                                                        ['slotType'],
                                                        guests:
                                                        sp.data!.docs[index]
                                                        ['guests'],
                                                        restro: true,
                                                      )));
                                        },
                                        subtitle: sp.data?.docs[index]
                                        ['cancelled']
                                            ? Text(
                                          'Cancelled',
                                          style: TextStyle(
                                              color: Colors.red.shade800,
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold),
                                        )
                                            : Text(
                                            '${sp.data?.docs[index]['msg']}',
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight:
                                                FontWeight.bold)),
                                        trailing: Text(
                                            '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 10,
                                      shadowColor: Colors.purple[50],
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            side:
                                            BorderSide(color: Colors.grey)),
                                        leading: Image.network(
                                            '${sp.data!.docs[index]['productImage']}'),
                                        title: Text(name),
                                        onTap: () {
                                          print(sp.data!.docs[index]['quantity']
                                              .runtimeType);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewNotification(
                                                        orderId: dateString,
                                                        amount:
                                                        sp.data!.docs[index]
                                                        ['perprice'],
                                                        dateTime: dateString,
                                                        qty:
                                                        sp.data!.docs[index]
                                                        ['quantity'],
                                                        productId:
                                                        sp.data!.docs[index]
                                                        ['productId'],
                                                        customerEmail:
                                                        sp.data!.docs[index]
                                                        ['email'],
                                                        customerName:
                                                        sp.data!.docs[index]
                                                        ['name'],
                                                        productName:
                                                        sp.data!.docs[index]
                                                        ['productName'],
                                                        cancelled:
                                                        sp.data!.docs[index]
                                                        ['cancelled'],
                                                      )));
                                        },
                                        subtitle: sp.data?.docs[index]
                                        ['cancelled']
                                            ? Text(
                                          'Cancelled',
                                          style: TextStyle(
                                              color: Colors.red.shade800,
                                              fontSize: 16,
                                              fontWeight:
                                              FontWeight.bold),
                                        )
                                            : Text(
                                            '${sp.data?.docs[index]['msg']}',
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight:
                                                FontWeight.bold)),
                                        trailing: Text(
                                          '${sp.data!.docs[index]['quantity']}',
                                          style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      });
                } else {
                  return SizedBox();
                }
              } else {
                return Text("No Orders Yet");
              }
            }));
  }

  Future<bool> checkSubcollectionExistence(String shopManagerId) async {
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document = mainCollection.doc(shopManagerId);
    final CollectionReference subCollection =
    document.collection('notifications');

    try {
      final QuerySnapshot querySnapshot = await subCollection.get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking subcollection existence: $e');
      return false;
    }
  }
}