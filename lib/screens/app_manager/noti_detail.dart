import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/screens/app_manager/verify_product.dart';

import '../../controller/auth.dart';
import '../../main.dart';

class NotificationDetail extends StatefulWidget {
  final uid;
  final name;
  final phno;
  final email;
  final productId;
  final bookingId;
  final shopId;
  final orderId;
  final cancelled;
  final mode;

  NotificationDetail(
      {super.key, this.uid, this.name, this.phno, this.email,
      this.productId,
      this.bookingId,
      this.shopId,
      this.orderId,
      this.cancelled,
      this.mode});

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.bookingId == null) {
      return widget.productId == ""
          ? StreamBuilder(
              stream: Auth.appManagerRef
                  .doc(Auth.auth.currentUser!.uid)
                  .collection('notifications')
                  .doc(Auth.auth.currentUser!.uid)
                  .collection('shopping')
                  .doc(widget.orderId)
                  .collection('products')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Scaffold(
                      appBar: AppBar(
                        title: Text("Order Details"),
                        centerTitle: true,
                      ),
                      body: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String productId =
                                snapshot.data!.docs[index]['productId'];
                            return SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    snapshot.data!.docs[index]['cancelled']
                                        ? Text(
                                            'Cancelled',
                                            style: TextStyle(
                                                color: Colors.red.shade400,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : SizedBox(),
                                    Text("Product : ${index + 1}"),
                                    Text(
                                        "Product id :${snapshot.data!.docs[index]['productId']}"),
                                    Text(
                                        "Customer name :${snapshot.data!.docs[index]['name']}"),
                                    Text(
                                        "Amount paid : ${snapshot.data!.docs[index]['amount']}"),
                                    Text(
                                        "Order Id : ${snapshot.data!.docs[index]['date']}"),
                                    Text(
                                        "Seller Id : ${snapshot.data!.docs[index]['sellerId']}"),
                                    SizedBox(
                                      height: mq.height * .01,
                                    ),
                                    (widget.mode == "homeDelivery" &&
                                            snapshot.data!.docs[index]
                                                    ['cancelled'] ==
                                                false)
                                        ? (snapshot.data!.docs[index]
                                                    ['assigned'] ==
                                                false)
                                            ? InkWell(
                                                onTap: () {
                                                  assignDeliveryBoy(
                                                    context,
                                                    snapshot.data!.docs[index]
                                                        ['date'],
                                                    customerId: snapshot
                                                            .data!.docs[index]
                                                        ['customerId'],
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  height: mq.height * .07,
                                                  width: mq.width * .45,
                                                  child: Center(
                                                    child: Text(
                                                      'Assign delivery boy',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : (snapshot.data!.docs[index]
                                                        ['delivered'] ==
                                                    false)
                                                ? Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          assignDeliveryBoy(
                                                            context,
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['date'],
                                                            customerId: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['customerId'],
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          height:
                                                              mq.height * .07,
                                                          width: mq.width * .45,
                                                          child: Center(
                                                            child: Text(
                                                              'Change delivery boy',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: mq.height * .01,
                                                      ),
                                                      Text(
                                                          'Assigned delivery boy id - ${snapshot.data!.docs[index]['deliveryBoyId']}')
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        'Delivered',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .green.shade400,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        'Delivered on ${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfDelivery'])).day}-${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfDelivery'])).month}-${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfDelivery'])).year}',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .green.shade400,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )
                                        : (widget.mode == "pickFromMall" &&
                                                snapshot.data!.docs[index]
                                                        ['cancelled'] ==
                                                    false)
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VerifyProduct(
                                                                orderId: snapshot
                                                                        .data!
                                                                        .docs[
                                                                    index]['date'],
                                                                customerId: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    [
                                                                    'customerId'],
                                                                delivered: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    [
                                                                    'delivered'],
                                                              )));
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade400,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Center(
                                                    child: loading == true
                                                        ? CircularProgressIndicator()
                                                        : Text(
                                                            'Verify Product',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                    Divider(
                                      height: mq.height * .05,
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
          : StreamBuilder(
              stream: Auth.appManagerRef
                  .doc(Auth.auth.currentUser!.uid)
                  .collection('notifications')
                  .doc(Auth.auth.currentUser!.uid)
                  .collection('shopping')
                  .doc(widget.orderId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey)),
                    margin: EdgeInsets.symmetric(vertical: mq.height * .3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        snapshot.data?['cancelled']
                            ? Text(
                                'Cancelled',
                                style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontWeight: FontWeight.bold),
                              )
                            : SizedBox(),
                        Text("Product id :${snapshot.data?['productId']}"),
                        Text("Customer name :${snapshot.data?['name']}"),
                        Text("Amount paid : ${snapshot.data?['amount']}"),
                        Text("Order Id : ${snapshot.data?['date']}"),
                        Text("Seller Id : ${snapshot.data?['sellerId']}"),
                        SizedBox(
                          height: mq.height * .05,
                        ),
                        (widget.mode == "homeDelivery" &&
                                snapshot.data?['cancelled'] == false)
                            ? (snapshot.data?['assigned'] == false)
                                ? InkWell(
                                    onTap: () {
                                      assignDeliveryBoy(context, widget.orderId,
                                          customerId:
                                              snapshot.data?['customerId'],
                                          stream: 1);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: mq.height * .07,
                                      width: mq.width * .45,
                                      child: Center(
                                        child: Text(
                                          'Assign delivery boy',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                : (snapshot.data?['delivered'] == false)
                                    ? Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              assignDeliveryBoy(
                                                context,
                                                widget.orderId,
                                                stream: 1,
                                                customerId: snapshot
                                                    .data?['customerId'],
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              height: mq.height * .07,
                                              width: mq.width * .45,
                                              child: Center(
                                                child: Text(
                                                  'Change delivery boy',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: mq.height * .01,
                                          ),
                                          Text(
                                              'Assigned delivery boy id - ${snapshot.data?['deliveryBoyId']}')
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text(
                                            'Delivered',
                                            style: TextStyle(
                                                color: Colors.green.shade400,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Delivered on ${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data?['dateOfDelivery'])).day}-${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data?['dateOfDelivery'])).month}-${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data?['dateOfDelivery'])).year}',
                                            style: TextStyle(
                                                color: Colors.green.shade400,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                            : (widget.mode == "pickFromMall" &&
                                    snapshot.data?['cancelled'] == false)
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VerifyProduct(
                                                    orderId:
                                                        snapshot.data?['date'],
                                                    customerId: snapshot
                                                        .data?['customerId'],
                                                    delivered: snapshot
                                                        .data?['delivered'],
                                                    stream: 1,
                                                  )));
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 180,
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade400,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: loading == true
                                            ? CircularProgressIndicator()
                                            : Text(
                                                'Verify Product',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
    } else {
      return StreamBuilder(
          stream: Auth.customerRef
              .doc(widget.uid.toString())
              .collection('bookings')
              .doc(widget.shopId)
              .collection('parlor')
              .doc(widget.bookingId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String dop = snapshot.data?['date'];
              DateTime date = DateTime.parse(dop);
              String time = snapshot.data?['time'];
              String shopName = snapshot.data?['shopName'];
              double amount = snapshot.data?['amount'];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 80),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Booking Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    widget.cancelled
                        ? Text(
                            'Cancelled',
                            style: TextStyle(color: Colors.red.shade800),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: Text('Customer name'),
                      trailing: Text('${widget.name}'),
                    ),
                    ListTile(
                      title: Text('Date of Booking'),
                      trailing: Text('${date.day}-${date.month}-${date.year}'),
                    ),
                    ListTile(
                      title: Text('Time of Booking'),
                      trailing: Text('${time}'),
                    ),
                    ListTile(
                      title: Text('Shop Id'),
                      trailing: Text('${widget.shopId}'),
                    ),
                    ListTile(
                      title: Text('Shop Name'),
                      trailing: Text('${shopName}'),
                    ),
                    ListTile(
                      title: Text('Amount paid'),
                      trailing: Text('${"Rs.${amount}"}'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(
                              color: Colors.orange.shade800, fontSize: 18),
                        ))
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    }
  }

  Future<void> assignDeliveryBoy(BuildContext context, String orderId,
      {String? deliveryBoyId, int? stream, String? customerId}) async {
    String selectedDeliveryBoy = "Select delivery boy";
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: mq.height / 4,
                width: mq.width,
                child: StreamBuilder(
                  stream: Auth.deliveryRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot =
                          snapshot.data as QuerySnapshot;
                      List<String> data = querySnapshot.docs
                          .map((doc) => doc['id'] as String)
                          .toList();
                      if (!data.contains("Select delivery boy")) {
                        // Add the hint only if it's not already present
                        data.insert(0, "Select delivery boy");
                      }
                      return Column(
                        children: [
                          DropdownButton(
                            // Initial Value
                            value: selectedDeliveryBoy,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: data.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDeliveryBoy = newValue!;
                              });
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              if (stream == 1) {
                                await Auth.appManagerRef
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('notifications')
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('shopping')
                                    .doc(orderId)
                                    .update({
                                  'assigned': true,
                                  'deliveryBoyId': selectedDeliveryBoy
                                });
                              } else {
                                await Auth.appManagerRef
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('notifications')
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('shopping')
                                    .doc(orderId.substring(
                                        0, orderId.length - 1))
                                    .collection('products')
                                    .doc(orderId)
                                    .update({
                                  'assigned': true,
                                  'deliveryBoyId': selectedDeliveryBoy
                                });
                              }
                              await Auth.customerRef
                                  .doc(customerId)
                                  .collection('orders')
                                  .doc(orderId)
                                  .update({
                                'assigned': true,
                                'deliveryBoyId': selectedDeliveryBoy
                              }).then((value) {
                                Utilities()
                                    .showMessage('Delivery boy assigned');
                              });
                            },
                            child: Container(
                              height: 35,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  'Okay',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
