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
      {super.key,
      this.uid,
      this.name,
      this.phno,
      this.email,
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
  DateTime? pickUpDate;
  bool loading = false;
  double? amount;

  @override
  Widget build(BuildContext context) {
    if (widget.bookingId == null) {
      return StreamBuilder(
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
                  backgroundColor: Color(0xff1D1F33),
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(
                      "Order Details",
                      style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                    elevation: 0,
                  ),
                  body: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        int dt = int.parse(snapshot.data!.docs[index]['orderId']
                            .toString()
                            .substring(
                                0,
                                snapshot.data!.docs[index]['orderId']
                                        .toString()
                                        .length -
                                    1));
                        DateTime dateTime =
                            DateTime.fromMillisecondsSinceEpoch(dt);
                        if (snapshot.data!.docs[index]['mode'] ==
                            'pickFromMall') {
                          pickUpDate = dateTime.add(Duration(days: 3));
                          if (DateTime.now().year == pickUpDate!.year &&
                              DateTime.now().month >= pickUpDate!.month &&
                              DateTime.now().day >= pickUpDate!.day &&
                              snapshot.data!.docs[index]['delivered'] ==
                                  false) {
                            Auth.appManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('notifications')
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('shopping')
                                .doc(widget.orderId)
                                .collection('products')
                                .doc(snapshot.data!.docs[index]['orderId'])
                                .update({
                              'cancelled': true,
                            });
                            Auth.customerRef
                                .doc(widget.uid)
                                .collection('orders')
                                .doc(snapshot.data!.docs[index]['orderId'])
                                .update({'cancelled': true});
                          }
                        }
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
                                Text(
                                  "Product : ${index + 1}",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Product id :${snapshot.data!.docs[index]['productId']}",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Customer name :${snapshot.data!.docs[index]['name']}",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Amount paid : ${snapshot.data!.docs[index]['amount']}",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Order Id : ${snapshot.data!.docs[index]['orderId']}",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Seller Id : ${snapshot.data!.docs[index]['sellerId']}",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Order date : ${dateTime.day}-${dateTime.month}-${dateTime.year}",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: mq.height * .01,
                                ),
                                (widget.mode == "homeDelivery" &&
                                        snapshot.data!.docs[index]
                                                ['cancelled'] ==
                                            false)
                                    ? (snapshot.data!.docs[index]['assigned'] ==
                                            false)
                                        ? InkWell(
                                            onTap: () {
                                              assignDeliveryBoy(
                                                context,
                                                snapshot.data!.docs[index]
                                                    ['orderId'],
                                                customerId: snapshot.data!
                                                    .docs[index]['customerId'],
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
                                                            ['orderId'],
                                                        customerId: snapshot
                                                                .data!
                                                                .docs[index]
                                                            ['customerId'],
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      height: mq.height * .07,
                                                      width: mq.width * .45,
                                                      child: Center(
                                                        child: Text(
                                                          'Change delivery boy',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: mq.height * .01,
                                                  ),
                                                  Text(
                                                    'Assigned delivery boy id - ${snapshot.data!.docs[index]['deliveryBoyId']}',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue.shade600,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
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
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'Delivered on ${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfDelivery'])).day}-${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfDelivery'])).month}-${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfDelivery'])).year}',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .green.shade400,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )
                                    : (widget.mode == "pickFromMall" &&
                                            snapshot.data!.docs[index]
                                                    ['cancelled'] ==
                                                false)
                                        ? (snapshot.data!.docs[index]
                                                    ['delivered'] ==
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
                                                                        .docs[index]
                                                                    ['orderId'],
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
                                            : Text(
                                                'Picked up on ${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfPickup'])).day}-${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfPickup'])).month}-${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]['dateOfPickup'])).year}',
                                                style: TextStyle(
                                                    color:
                                                        Colors.green.shade600,
                                                    fontWeight:
                                                        FontWeight.bold),
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
          });
    }
    else {
      return StreamBuilder(
          stream: Auth.appManagerRef
              .doc(Auth.auth.currentUser!.uid)
              .collection('notifications')
              .doc(Auth.auth.currentUser!.uid)
              .collection('booking')
              .doc(widget.bookingId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String dop = snapshot.data?['date'];
              DateTime date = DateTime.parse(dop);
              String time = snapshot.data?['time'];
              if(snapshot.data?['msg'] == "New appointment booked"){
                amount = double.parse(snapshot.data?['servicePrice']);
              }
              return Scaffold(
                backgroundColor: Color(0xff1D1F33),
                body: Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 80),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
                      snapshot.data?['msg'] == "New appointment booked" ? ListTile(
                        title: Text('Service Name'),
                        trailing: Text('${snapshot.data?['serviceName']}'),
                      ) : SizedBox(),
                      snapshot.data?['msg'] == "New appointment booked" ? ListTile(
                        title: Text('Amount paid'),
                        trailing: Text('${"Rs.${amount}"}'),
                      ) : ListTile(
                        title: Text('No.of guests'),
                        trailing: Text('${snapshot.data?['guests']}'),
                      ),
                      snapshot.data?['msg'] == "Seat Reserved" ? ListTile(
                        title: Text('Slot type'),
                        trailing: Text('${snapshot.data?['slotType']}'),
                      ) : SizedBox(),
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
