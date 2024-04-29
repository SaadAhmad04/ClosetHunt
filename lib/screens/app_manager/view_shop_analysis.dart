import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controller/auth.dart';
import '../../main.dart';

class ViewShopAnalysis extends StatefulWidget {
  String? shopId;
  String? type;
  bool? restro;
  String? shopName;
  ViewShopAnalysis({super.key, this.shopId, this.type , this.restro , this.shopName});

  @override
  State<ViewShopAnalysis> createState() => _ViewShopAnalysisState();
}

class _ViewShopAnalysisState extends State<ViewShopAnalysis> {
  Stream<QuerySnapshot>? stream;
  String? orderId, formattedDate, bookingId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == "shopping") {
      stream = Auth.appManagerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('notifications')
          .doc(Auth.auth.currentUser!.uid)
          .collection(widget.type!)
          .orderBy('orderId', descending: true)
          .snapshots();
    } else {
      stream = Auth.appManagerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('notifications')
          .doc(Auth.auth.currentUser!.uid)
          .collection(widget.type!)
          .orderBy('bookingId', descending: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Color(0xff1D1F33),
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: Text('${widget.shopName}'),
                elevation: 0,
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  bool? showDateHeader;
                  if (widget.type == "shopping") {
                    orderId = snapshot.data!.docs[index]['orderId'];
                    DateTime orderDate = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(snapshot.data!.docs[index]['orderId']));
                    formattedDate = DateFormat('dd-MM-yyyy').format(orderDate);
                    print('Dateeeeeeeeeeeeeeee:${formattedDate}');
                    if (index != 0 &&
                        orderId != snapshot.data!.docs[index - 1]['orderId']) {
                      DateTime previousOrderDate =
                          DateTime.fromMillisecondsSinceEpoch(int.parse(
                              snapshot.data!.docs[index - 1]['orderId']));
                      if (orderDate.year == previousOrderDate.year &&
                          orderDate.month == previousOrderDate.month &&
                          orderDate.day == previousOrderDate.day) {
                        showDateHeader = false;
                      } else {
                        showDateHeader = true;
                      }
                    } else {
                      showDateHeader = true;
                    }
                  } else {
                    bookingId = snapshot.data!.docs[index]['bookingId'];
                    DateTime bookingDate = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(snapshot.data!.docs[index]['bookingId']));
                    formattedDate =
                        DateFormat('dd-MM-yyyy').format(bookingDate);
                    // Check if the date has changed
                    if (index != 0 &&
                        bookingId !=
                            snapshot.data!.docs[index - 1]['bookingId']) {
                      DateTime previousOrderDate =
                          DateTime.fromMillisecondsSinceEpoch(int.parse(
                              snapshot.data!.docs[index - 1]['bookingId']));
                      if (bookingDate.year == previousOrderDate.year &&
                          bookingDate.month == previousOrderDate.month &&
                          bookingDate.day == previousOrderDate.day) {
                        showDateHeader = false;
                      } else {
                        showDateHeader = true;
                      }
                    } else {
                      showDateHeader = true;
                    }
                  }
                  return widget.type == "shopping"
                      ? StreamBuilder(
                          stream: Auth.appManagerRef
                              .doc(Auth.auth.currentUser!.uid)
                              .collection('notifications')
                              .doc(Auth.auth.currentUser!.uid)
                              .collection(widget.type!)
                              .doc(orderId)
                              .collection('products')
                              .where('sellerId', isEqualTo: widget.shopId)
                              .snapshots(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              print(
                                  'formatted date==========${formattedDate}===========${showDateHeader}---------${orderId}');
                              var items = snap.data!.docs.toSet().toList();
                              print('items==============${items}');
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      if (showDateHeader == true)
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: mq.width * .65,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                formattedDate!,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          tileColor: Colors.grey.shade200,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: BorderSide(
                                                color: Colors.black,
                                              )),
                                          title:
                                              Text('Rs.${items[i]['amount']}'),
                                          subtitle:
                                              Text('${items[i]['orderId']}'),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Center(
                                child: Text('No orders from this shop'),
                              );
                            }
                          },
                        )
                      : widget.restro == false ?
                  StreamBuilder(
                          stream: Auth.appManagerRef
                              .doc(Auth.auth.currentUser!.uid)
                              .collection('notifications')
                              .doc(Auth.auth.currentUser!.uid)
                              .collection(widget.type!)
                              .where('shopId', isEqualTo: widget.shopId)
                              .snapshots(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              print(
                                  'formatted date==========${formattedDate}===========${showDateHeader}---------${orderId}');
                              var items = snap.data!.docs.toSet().toList();
                              print('items==============${items}');
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      if (showDateHeader == true)
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: mq.width * .65,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                formattedDate!,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          tileColor: Colors.grey.shade200,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: BorderSide(
                                                color: Colors.black,
                                              )),
                                          title: Text('${items[i]['bookingId']}'),
                                          subtitle:
                                              Text('Rs.${items[i]['servicePrice']}'),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Center(
                                child: Text('No bookings from this shop'),
                              );
                            }
                          },
                        ) :
                  StreamBuilder(
                    stream: Auth.appManagerRef
                        .doc(Auth.auth.currentUser!.uid)
                        .collection('notifications')
                        .doc(Auth.auth.currentUser!.uid)
                        .collection(widget.type!)
                        .where('shopId', isEqualTo: widget.shopId)
                        .snapshots(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        print(
                            'formatted date==========${formattedDate}===========${showDateHeader}---------${orderId}');
                        var items = snap.data!.docs.toSet().toList();
                        print('items==============${items}');
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                if (showDateHeader == true)
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: mq.width * .65,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Text(
                                          formattedDate!,
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    tileColor: Colors.grey.shade200,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        side: BorderSide(
                                          color: Colors.black,
                                        )),
                                    title: Text('${items[i]['name']}'),
                                    subtitle:
                                    Text('${items[i]['bookingId']}'),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snap.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Center(
                          child: Text('No bookings from this shop'),
                        );
                      }
                    },
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
