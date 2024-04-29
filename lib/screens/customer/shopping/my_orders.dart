// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/screens/customer/customer_home.dart';
// import 'package:mall/screens/customer/shopping/order_status.dart';
//
// import '../../../constant/utils/utilities.dart';
// import '../../../controller/auth.dart';
// import '../../../main.dart';
// import '../rive/NavigationPoint.dart';
//
// class MyOrders extends StatefulWidget {
//   String? sellerId;
//   List? sellerIds;
//
//   MyOrders({super.key, this.sellerId, this.sellerIds});
//
//   @override
//   State<MyOrders> createState() => _MyOrdersState();
// }
//
// class _MyOrdersState extends State<MyOrders> {
//   List<Map<String, dynamic>> documentsData = [];
//   DateTime? pickUpDate;
//   String? appManagerId, productId;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Auth.customerRef
//             .doc(Auth.auth.currentUser!.uid)
//             .collection('orders')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Scaffold(
//               extendBodyBehindAppBar: true,
//               appBar: AppBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0.0,
//                 title: ShaderMask(
//                     shaderCallback: (Rect bounds) {
//                       return LinearGradient(colors: [Colors.pink, Colors.black])
//                           .createShader(bounds);
//                     },
//                     child: Text(
//                       'My Orders',
//                       style: TextStyle(
//                         fontSize: 22.0,
//                         color: Colors.white,
//                       ),
//                     )),
//                 actions: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: PopupMenuButton(
//                       child: Container(
//                         height: mq.height * .018,
//                         width: mq.width * .19,
//                         decoration: BoxDecoration(color: Color(0xff8D8E36)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.filter_alt_rounded,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                             Text(
//                               'Filter',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                       itemBuilder: (context) => [
//                         PopupMenuItem(
//                             child: ListTile(
//                           onTap: () {
//                             viewSlots(context);
//                           },
//                           leading: Icon(
//                             Icons.date_range,
//                             color: Color(0xff974c7c),
//                           ),
//                           title: Text(
//                             'Year',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         )),
//                         PopupMenuItem(
//                             child: ListTile(
//                           leading: Icon(Icons.currency_rupee,
//                               color: Color(0xff974c7c)),
//                           title: Text(
//                             'Price',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ))
//                       ],
//                     ),
//                   )
//                 ],
//                 centerTitle: true,
//                 leading: BackButton(
//                   color: Color(0xff974c7c),
//                   onPressed: () {
//                     Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => NavigationPoint()),
//                         (route) => false);
//                   },
//                 ),
//               ),
//               body: SafeArea(
//                 child: Stack(
//                   children: [
//                     Container(
//                       //color: Colors.blue,
//                       height: mq.height,
//                       width: mq.width,
//                       child: Image.network(
//                         "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     ListView.builder(
//                       itemCount: snapshot.data?.docs.length,
//                       reverse: true,
//                       itemBuilder: (context, index) {
//                         String productId =
//                             snapshot.data?.docs[index]['productId'];
//                         int orderId = int.parse(snapshot
//                             .data!.docs[index]['orderId']
//                             .toString()
//                             .substring(
//                                 0,
//                                 snapshot.data!.docs[index]['orderId']
//                                         .toString()
//                                         .length -
//                                     1));
//                         String mode = snapshot.data?.docs[index]['mode'];
//                         String name = snapshot.data?.docs[index]['productName'];
//                         String image =
//                             snapshot.data?.docs[index]['productImage'];
//                         DateTime dateTime =
//                             DateTime.fromMillisecondsSinceEpoch(orderId);
//                         if (snapshot.data!.docs[index]['mode'] ==
//                             'pickFromMall') {
//                           pickUpDate = dateTime.add(Duration(days: 3));
//                           if (DateTime.now().year == pickUpDate!.year &&
//                               DateTime.now().month >= pickUpDate!.month &&
//                               DateTime.now().day >= pickUpDate!.day &&
//                               snapshot.data!.docs[index]['delivered'] ==
//                                   false) {
//                             Auth.customerRef
//                                 .doc(Auth.auth.currentUser!.uid)
//                                 .collection('orders')
//                                 .doc(snapshot.data!.docs[index]['orderId'])
//                                 .update({'cancelled': true});
//                           }
//                         }
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Card(
//                             elevation: 10,
//                             shadowColor: Color(0xff974c7c),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             child: ListTile(
//                                 visualDensity: VisualDensity(vertical: 4),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                     side: BorderSide(
//                                         color: Colors.grey.shade400)),
//                                 onTap: () {
//                                   if (mode == 'homeDelivery') {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => OrderStatus(
//                                                   orderId: snapshot.data!
//                                                       .docs[index]['orderId'],
//                                                   mode: mode,
//                                                   name: name,
//                                                   image: image,
//                                                   price:
//                                                       snapshot.data?.docs[index]
//                                                           ['productPrice'],
//                                                   perprice: double.parse(
//                                                           snapshot.data
//                                                                   ?.docs[index][
//                                                               'productPrice']) *
//                                                       snapshot.data?.docs[index]
//                                                           ['quantity'],
//                                                   qty: snapshot.data
//                                                       ?.docs[index]['quantity'],
//                                                   dateTime: dateTime,
//                                                   sellerId: snapshot.data
//                                                       ?.docs[index]['sellerId'],
//                                                   cancelled:
//                                                       snapshot.data?.docs[index]
//                                                           ['cancelled'],
//                                                   assigned: snapshot.data
//                                                       ?.docs[index]['assigned'],
//                                                   delivered:
//                                                       snapshot.data?.docs[index]
//                                                           ['delivered'],
//                                                   dateOfDelivery:
//                                                       snapshot.data?.docs[index]
//                                                               ['delivered']
//                                                           ? snapshot.data
//                                                                   ?.docs[index]
//                                                               ['dateOfDelivery']
//                                                           : null,
//                                                 )));
//                                   } else {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => OrderStatus(
//                                                   orderId: snapshot.data!
//                                                       .docs[index]['orderId'],
//                                                   mode: mode,
//                                                   name: name,
//                                                   image: image,
//                                                   price:
//                                                       snapshot.data?.docs[index]
//                                                           ['productPrice'],
//                                                   perprice: double.parse(
//                                                           snapshot.data
//                                                                   ?.docs[index][
//                                                               'productPrice']) *
//                                                       snapshot.data?.docs[index]
//                                                           ['quantity'],
//                                                   qty: snapshot.data
//                                                       ?.docs[index]['quantity'],
//                                                   dateTime: dateTime,
//                                                   sellerId: snapshot.data
//                                                       ?.docs[index]['sellerId'],
//                                                   cancelled:
//                                                       snapshot.data?.docs[index]
//                                                           ['cancelled'],
//                                                   assigned: snapshot.data
//                                                       ?.docs[index]['assigned'],
//                                                   delivered:
//                                                       snapshot.data?.docs[index]
//                                                           ['delivered'],
//                                                   dateOfPickup:
//                                                       snapshot.data?.docs[index]
//                                                               ['delivered']
//                                                           ? snapshot.data
//                                                                   ?.docs[index]
//                                                               ['dateOfPickup']
//                                                           : null,
//                                                 )));
//                                   }
//                                 },
//                                 title: Text(name),
//                                 subtitle: snapshot.data?.docs[index]
//                                         ['cancelled']
//                                     ? Text(
//                                         'Cancelled',
//                                         style: TextStyle(
//                                             color: Colors.red,
//                                             fontWeight: FontWeight.bold),
//                                       )
//                                     : mode == "homeDelivery"
//                                         ? (snapshot.data?.docs[index]
//                                                     ['delivered'] ==
//                                                 false)
//                                             ? Text(
//                                                 "Home Delivery",
//                                                 style: TextStyle(
//                                                     color: Color(0xff974c7c),
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             : Text(
//                                                 "Delivered",
//                                                 style: TextStyle(
//                                                     color:
//                                                         Colors.green.shade600,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                         : (snapshot.data?.docs[index]
//                                                     ['delivered'] ==
//                                                 false)
//                                             ? Text(
//                                                 "Pick from mall",
//                                                 style: TextStyle(
//                                                     color: Colors.blue,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               )
//                                             : Text(
//                                                 "Picked up",
//                                                 style: TextStyle(
//                                                     color:
//                                                         Colors.green.shade600,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                 leading: CircleAvatar(
//                                     backgroundImage: NetworkImage(image)),
//                                 trailing: Text(
//                                   "${dateTime.day}-${dateTime.month}-${dateTime.year}",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 )),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return Center(
//               child: Text('No orders yet'),
//             );
//           }
//         });
//   }
//
//   Future<void> viewSlots(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           content: StatefulBuilder(
//             builder: (context, setModalState) {
//               return SizedBox(
//                 height: 300,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       CheckboxListTile(
//                           value: false,
//                           onChanged: (value) {
//                             setState(() {});
//                           },
//                           title: Text('2024')),
//                     ],
//                   ),
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
import 'package:mall/screens/customer/customer_home.dart';
import 'package:mall/screens/customer/shopping/order_status.dart';

import '../../../controller/auth.dart';
import '../../../main.dart';
import '../rive/NavigationPoint.dart';

class MyOrders extends StatefulWidget {
  String? sellerId;
  List? sellerIds;

  MyOrders({super.key, this.sellerId, this.sellerIds});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<Map<String, dynamic>> documentsData = [];
  DateTime? pickUpDate;
  String? appManagerId, productId;
  Set<String> years = {'All'};
  String dropDownValue = 'All';

  Future<void> updateYears(
      List<DocumentSnapshot<Map<String, dynamic>>>? docs) async {
    if (docs != null) {
      docs.forEach((doc) async {
        int orderId = int.parse(doc['orderId']
            .toString()
            .substring(0, doc['orderId'].toString().length - 1));
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(orderId);
        await years.add(dateTime.year.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.customerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('orders')
            .orderBy('orderId', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            updateYears(snapshot.data?.docs);
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                title: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(colors: [Colors.pink, Colors.black])
                          .createShader(bounds);
                    },
                    child: Text(
                      'My Orders',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    )),
                centerTitle: true,
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
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mq.height * .01, horizontal: mq.width * .05),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(8),
                      elevation: 1,
                      padding: const EdgeInsets.only(top: 8),
                      value: dropDownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: years.map<DropdownMenuItem<String>>((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(), // Convert the set to a list before mapping
                      onChanged: (String? newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      },
                    ),
                  )
                ],
              ),
              body: Stack(
                children: [
                  Container(
                    //color: Colors.blue,
                    height: mq.height,
                    width: mq.width,
                    child: Image.network(
                      "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      String productId =
                          snapshot.data?.docs[index]['productId'];
                      int orderId = int.parse(snapshot
                          .data!.docs[index]['orderId']
                          .toString()
                          .substring(
                              0,
                              snapshot.data!.docs[index]['orderId']
                                      .toString()
                                      .length -
                                  1));
                      String mode = snapshot.data?.docs[index]['mode'];
                      String name = snapshot.data?.docs[index]['productName'];
                      String image = snapshot.data?.docs[index]['productImage'];
                      DateTime dateTime =
                          DateTime.fromMillisecondsSinceEpoch(orderId);
                      //years.add(dateTime.year.toString());
                      if (snapshot.data!.docs[index]['mode'] ==
                          'pickFromMall') {
                        pickUpDate = dateTime.add(Duration(days: 3));
                        if (DateTime.now().year == pickUpDate!.year &&
                            DateTime.now().month >= pickUpDate!.month &&
                            DateTime.now().day >= pickUpDate!.day &&
                            snapshot.data!.docs[index]['delivered'] == false) {
                          Auth.customerRef
                              .doc(Auth.auth.currentUser!.uid)
                              .collection('orders')
                              .doc(snapshot.data!.docs[index]['orderId'])
                              .update({'cancelled': true});
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 10,
                          shadowColor: Color(0xff974c7c),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                              visualDensity: VisualDensity(vertical: 4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side:
                                      BorderSide(color: Colors.grey.shade400)),
                              onTap: () {
                                if (mode == 'homeDelivery') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderStatus(
                                                orderId: snapshot.data!
                                                    .docs[index]['orderId'],
                                                mode: mode,
                                                name: name,
                                                image: image,
                                                price:
                                                    snapshot.data?.docs[index]
                                                        ['productPrice'],
                                                perprice: double.parse(snapshot
                                                            .data?.docs[index]
                                                        ['productPrice']) *
                                                    snapshot.data?.docs[index]
                                                        ['quantity'],
                                                qty: snapshot.data?.docs[index]
                                                    ['quantity'],
                                                dateTime: dateTime,
                                                sellerId: snapshot.data
                                                    ?.docs[index]['sellerId'],
                                                cancelled: snapshot.data
                                                    ?.docs[index]['cancelled'],
                                                assigned: snapshot.data
                                                    ?.docs[index]['assigned'],
                                                delivered: snapshot.data
                                                    ?.docs[index]['delivered'],
                                                dateOfDelivery: snapshot
                                                            .data?.docs[index]
                                                        ['delivered']
                                                    ? snapshot.data?.docs[index]
                                                        ['dateOfDelivery']
                                                    : null,
                                              )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderStatus(
                                                orderId: snapshot.data!
                                                    .docs[index]['orderId'],
                                                mode: mode,
                                                name: name,
                                                image: image,
                                                price:
                                                    snapshot.data?.docs[index]
                                                        ['productPrice'],
                                                perprice: double.parse(snapshot
                                                            .data?.docs[index]
                                                        ['productPrice']) *
                                                    snapshot.data?.docs[index]
                                                        ['quantity'],
                                                qty: snapshot.data?.docs[index]
                                                    ['quantity'],
                                                dateTime: dateTime,
                                                sellerId: snapshot.data
                                                    ?.docs[index]['sellerId'],
                                                cancelled: snapshot.data
                                                    ?.docs[index]['cancelled'],
                                                assigned: snapshot.data
                                                    ?.docs[index]['assigned'],
                                                delivered: snapshot.data
                                                    ?.docs[index]['delivered'],
                                                dateOfPickup: snapshot
                                                            .data?.docs[index]
                                                        ['delivered']
                                                    ? snapshot.data?.docs[index]
                                                        ['dateOfPickup']
                                                    : null,
                                              )));
                                }
                              },
                              title: Text(name),
                              subtitle: snapshot.data?.docs[index]['cancelled']
                                  ? Text(
                                      'Cancelled',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : mode == "homeDelivery"
                                      ? (snapshot.data?.docs[index]
                                                  ['delivered'] ==
                                              false)
                                          ? Text(
                                              "Home Delivery",
                                              style: TextStyle(
                                                  color: Color(0xff974c7c),
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "Delivered",
                                              style: TextStyle(
                                                  color: Colors.green.shade600,
                                                  fontWeight: FontWeight.bold),
                                            )
                                      : (snapshot.data?.docs[index]
                                                  ['delivered'] ==
                                              false)
                                          ? Text(
                                              "Pick from mall",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "Picked up",
                                              style: TextStyle(
                                                  color: Colors.green.shade600,
                                                  fontWeight: FontWeight.bold),
                                            ),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(image)),
                              trailing: Text(
                                "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text('No orders yet'),
            );
          }
        });
  }
}
