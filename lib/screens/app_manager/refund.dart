import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../controller/auth.dart';
import '../../main.dart';

class Refund extends StatefulWidget {
  const Refund({super.key});

  @override
  State<Refund> createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  var filters = [
    'All',
    'Delivered',
    'Cancelled',
    'Yet to deliver',
    'Yet to pickup'
  ];
  bool showTotal = false;
  String dropDownFilter = 'Cancelled';
  double amount = 0.0;

  @override
  Widget build(BuildContext context) {
    final spinKit = Center(
      child: SpinKitDoubleBounce(
        color: Colors.blue,
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xff1D1F33),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Refund',
          style: TextStyle(color: Colors.grey.shade200),
        ),
        actions: [
          Container(
            width: mq.width * .35,
            child: DropdownButton(
              isExpanded: true,
              borderRadius: BorderRadius.circular(8),
              elevation: 1,
              padding: const EdgeInsets.only(top: 8),
              value: dropDownFilter,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              dropdownColor: Colors.blue.shade600,
              items: filters.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(
                    items,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  amount = 0.0;
                  showTotal = false;
                  dropDownFilter = newValue!;
                });
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Auth.appManagerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('notifications')
            .doc(Auth.auth.currentUser!.uid)
            .collection('shopping')
            .orderBy('orderId', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (context, index) {
                final name = snap.data!.docs[index]['name'];
                String orderId = snap.data!.docs[index]['orderId'];
                amount = 0.0;
                return StreamBuilder(
                    stream: dropDownFilter == 'Delivered'
                        ? Auth.appManagerRef
                            .doc(Auth.auth.currentUser!.uid)
                            .collection('notifications')
                            .doc(Auth.auth.currentUser!.uid)
                            .collection('shopping')
                            .doc(orderId)
                            .collection('products')
                            .where('delivered', isEqualTo: true)
                            .snapshots()
                        : dropDownFilter == 'Cancelled'
                            ? Auth.appManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('notifications')
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('shopping')
                                .doc(orderId)
                                .collection('products')
                                .where('cancelled', isEqualTo: true)
                                .snapshots()
                            : dropDownFilter == 'Yet to deliver'
                                ? Auth.appManagerRef
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('notifications')
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('shopping')
                                    .doc(orderId)
                                    .collection('products')
                                    .where('cancelled', isEqualTo: false)
                                    .where('mode', isEqualTo: 'homeDelivery')
                                    .where('delivered', isEqualTo: false)
                                    .snapshots()
                                : dropDownFilter == 'Yet to pickup'
                                    ? Auth.appManagerRef
                                        .doc(Auth.auth.currentUser!.uid)
                                        .collection('notifications')
                                        .doc(Auth.auth.currentUser!.uid)
                                        .collection('shopping')
                                        .doc(orderId)
                                        .collection('products')
                                        .where('cancelled', isEqualTo: false)
                                        .where('mode',
                                            isEqualTo: 'pickFromMall')
                                        .where('delivered', isEqualTo: false)
                                        .snapshots()
                                    : Auth.appManagerRef
                                        .doc(Auth.auth.currentUser!.uid)
                                        .collection('notifications')
                                        .doc(Auth.auth.currentUser!.uid)
                                        .collection('shopping')
                                        .doc(orderId)
                                        .collection('products')
                                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              amount += (snapshot.data!.docs[index]['amount']);
                              print('amount=====${amount}');
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      tileColor: Colors.grey.shade200,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          side:
                                              BorderSide(color: Colors.black)),
                                      visualDensity: VisualDensity(vertical: 3),
                                      title: Text(
                                        name,
                                        style: TextStyle(
                                            color: Colors.blue.shade600,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Text(
                                          'Rs.${snapshot.data!.docs[index]['amount']}'),
                                      subtitle: Text(
                                          '${snapshot.data!.docs[index]['orderId']}'),
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      } else {
                        return spinKit;
                      }
                    });
              },
            );
          } else if (snap.hasError) {
            print('hellppppppppppppo');
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snap.data == null) {
            return Center(
              child: Text('No notifications'),
            );
          }
          return Center(
            child: Text('No notifications'),
          );
        },
      ),
      floatingActionButton: Container(
        width: mq.width * .3,
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: showTotal == false
              ? RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30))
              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () {
            setState(() {
              showTotal = true;
            });
          },
          child: showTotal == true
              ? Text(
                  'Rs.${amount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.red),
                )
              : Text('Total'),
        ),
      ),
    );
  }
}
