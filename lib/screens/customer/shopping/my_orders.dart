import 'package:flutter/material.dart';
import 'package:mall/screens/customer/customer_home.dart';
import 'package:mall/screens/customer/shopping/order_status.dart';

import '../../../controller/auth.dart';

class MyOrders extends StatefulWidget {
  String? sellerId;
  List? sellerIds;
  MyOrders({super.key, this.sellerId, this.sellerIds});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.customerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('My Orders'),
                centerTitle: true,
                leading: BackButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => CustomerHome()),
                        (route) => false);
                  },
                ),
              ),
              body: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  String productId = snapshot.data?.docs[index]['productId'];
                  int orderId = int.parse(snapshot.data!.docs[index]['orderId']
                      .toString()
                      .substring(
                          0,
                          snapshot.data!.docs[index]['orderId']
                                  .toString()
                                  .length -
                              1));
                  String mode = snapshot.data?.docs[index]['mode'];
                  DateTime dateTime =
                      DateTime.fromMillisecondsSinceEpoch(orderId);
                  return StreamBuilder(
                      stream: Auth.customerRef
                          .doc(Auth.auth.currentUser!.uid)
                          .collection('carts')
                          .doc(productId)
                          .snapshots(),
                      builder: (context, snap) {
                        if (snap.data != null) {
                          String name = snap.data?['name'];
                          String image = snap.data?['image'];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                visualDensity: VisualDensity(vertical: 4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: Colors.grey.shade400)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderStatus(
                                                orderId: snapshot.data!
                                                    .docs[index]['orderId'],
                                                mode: mode,
                                                name: name,
                                                image: image,
                                                price: snap.data?['price'],
                                                perprice:
                                                    snap.data?['perprice'],
                                                qty: snap.data?['quantity'],
                                                dateTime: dateTime,
                                                sellerId:
                                                    snap.data?['sellerId'],
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
                                },
                                title: Text(name),
                                subtitle: snapshot.data?.docs[index]
                                        ['cancelled']
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
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                "Delivered",
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade600,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                        : Text(
                                            "Pick from mall",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                leading: Image.network(image),
                                trailing: Text(
                                  "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      });
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Text('No orders placed'),
          );
        });
  }
}
