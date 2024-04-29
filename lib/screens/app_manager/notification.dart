import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/app_manager/noti_detail.dart';
import 'package:intl/intl.dart';
import '../../controller/auth.dart';
import '../../main.dart';

class AppManagerNotificationHistory extends StatefulWidget {
  const AppManagerNotificationHistory({super.key});

  @override
  State<AppManagerNotificationHistory> createState() =>
      _AppManagerNotificationHistoryState();
}

class _AppManagerNotificationHistoryState
    extends State<AppManagerNotificationHistory> {

  bool? showDateHeader;
  String? phno, email, uid, orderId, date;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Color(0xff1D1F33),
          appBar: AppBar(
            backgroundColor: Color(0xff1D1F33),
            title: Text('Notifications' , style: TextStyle(color: Colors.blue.shade600),),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shop),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.book_outlined),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.currency_rupee),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StreamBuilder(
                stream: Auth.appManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('notifications')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('shopping')
                    .orderBy('orderId', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final name = snapshot.data!.docs[index]['name'];
                        final msg = snapshot.data!.docs[index]['msg'];
                        final mode = snapshot.data!.docs[index]['mode'];
                        orderId = snapshot.data!.docs[index]['orderId'];
                        // Extract the date and format it
                        DateTime orderDate =
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                                snapshot.data!.docs[index]['orderId']));
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(orderDate);
                        // Check if the date has changed
                        if (index != 0) {
                          if (orderDate.year ==
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                          snapshot.data!.docs[index - 1]
                                              ['orderId']))
                                      .year &&
                              orderDate.month ==
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                          snapshot.data!.docs[index - 1]
                                              ['orderId']))
                                      .month &&
                              orderDate.day ==
                                  DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(snapshot.data!.docs[index - 1]['orderId']))
                                      .day) {
                            showDateHeader = false;
                          } else {
                            showDateHeader = true;
                          }
                        } else {
                          showDateHeader = true;
                        }
                        return Column(
                          children: [
                            if (showDateHeader == true)
                              Row(
                                children: [
                                  SizedBox(
                                    width: mq.width * .67,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
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
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                        color: Colors.black
                                    )
                                ),
                                visualDensity: VisualDensity(vertical: 3),
                                title: Text(name , style: TextStyle(color: Colors.blue.shade600 , fontWeight: FontWeight.bold),),
                                subtitle: mode == "homeDelivery"
                                    ? Text('${msg}\nHome Delivery' , style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold))
                                    : Text('${msg}\nPick from mall', style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold)),
                                onTap: () {
                                  print('ooooooooooooo${orderId}');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationDetail(
                                                orderId: snapshot.data!
                                                    .docs[index]['orderId'],
                                                mode: snapshot.data!.docs[index]
                                                    ['mode'],
                                              )));
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else if (snapshot.hasError) {
                    print('hellppppppppppppo');
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data == null) {
                    return Center(
                      child: Text('No notifications'),
                    );
                  }
                  return Center(
                    child: Text('No notifications'),
                  );
                },
              ),
              StreamBuilder(
                stream: Auth.appManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('notifications')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('booking')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final name = snapshot.data!.docs[index]['name'];
                        final msg = snapshot.data!.docs[index]['msg'];
                        final uid = snapshot.data!.docs[index]['customerId'];
                        final email = snapshot.data!.docs[index]['email'];
                        final phno = snapshot.data!.docs[index]['phone'];
                        final bookingId =
                            snapshot.data!.docs[index]['bookingId'];
                        final shopId = snapshot.data!.docs[index]['shopId'];
                        DateTime bookingDate =
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                                snapshot.data!.docs[index]['bookingId']));
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(bookingDate);
                        // Check if the date has changed
                        if (index != 0) {
                          if (bookingDate.year ==
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                          snapshot.data!.docs[index - 1]
                                              ['bookingId']))
                                      .year &&
                              bookingDate.month ==
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                          snapshot.data!.docs[index - 1]
                                              ['bookingId']))
                                      .month &&
                              bookingDate.day ==
                                  DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(snapshot.data!.docs[index - 1]['bookingId']))
                                      .day) {
                            showDateHeader = false;
                          } else {
                            showDateHeader = true;
                          }
                        } else {
                          showDateHeader = true;
                        }
                        return Column(
                          children: [
                            if (showDateHeader == true)
                              Row(
                                children: [
                                  SizedBox(
                                    width: mq.width * .67,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
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
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                        color: Colors.black
                                    ),),
                                title: Text(name , style: TextStyle(color: Colors.blue.shade600 , fontWeight: FontWeight.bold),),
                                subtitle: snapshot.data?.docs[index]
                                        ['cancelled']
                                    ? Text(
                                        'Cancelled',
                                        style: TextStyle(
                                            color: Colors.red.shade800),
                                      )
                                    : Text(
                                        '${snapshot.data?.docs[index]['msg']}',
                                        style: TextStyle(
                                            color: Colors.green.shade800 , fontWeight: FontWeight.bold)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationDetail(
                                                uid: uid,
                                                name: name,
                                                email: email,
                                                phno: phno,
                                                shopId: shopId,
                                                bookingId: bookingId,
                                                cancelled: snapshot.data
                                                    ?.docs[index]['cancelled'],
                                              )));
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text('No notifications!!'),
                    );
                  }
                },
              ),
              StreamBuilder(
                stream: Auth.appManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('notifications')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('payments')
                    .snapshots(),
                builder: (context, snapshot) {
                  print("length  ${snapshot.data?.docs.length}");
                  if (snapshot.hasData && snapshot.data?.docs.length!=0) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        int date =
                            int.parse(snapshot.data!.docs[index]['date']);
                        DateTime dateTime =
                            DateTime.fromMillisecondsSinceEpoch(date);
                        DateTime bookingDate =
                        DateTime.fromMillisecondsSinceEpoch(int.parse(
                            snapshot.data!.docs[index]['paymentId']));
                        String formattedDate =
                        DateFormat('dd-MM-yyyy').format(bookingDate);
                        // Check if the date has changed
                        if (index != 0) {
                          if (bookingDate.year ==
                              DateTime.fromMillisecondsSinceEpoch(int.parse(
                                  snapshot.data!.docs[index - 1]
                                  ['paymentId']))
                                  .year &&
                              bookingDate.month ==
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                      snapshot.data!.docs[index - 1]
                                      ['paymentId']))
                                      .month &&
                              bookingDate.day ==
                                  DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(snapshot.data!.docs[index - 1]['paymentId']))
                                      .day) {
                            showDateHeader = false;
                          } else {
                            showDateHeader = true;
                          }
                        } else {
                          showDateHeader = true;
                        }
                        return Column(
                          children: [
                            if (showDateHeader == true)
                              Row(
                                children: [
                                  SizedBox(
                                    width: mq.width * .67,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                    '${snapshot.data!.docs[index]['shopName']}'),
                                subtitle: Text(
                                  '${snapshot.data!.docs[index]['msg']}',
                                  style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                    'Rs.${snapshot.data!.docs[index]['amount']}'),
                                onTap: () {
                                  viewPaymentDetails(
                                      snapshot.data!.docs[index]['paymentId'],
                                      snapshot.data!.docs[index]['amount'],
                                      dateTime,
                                      snapshot.data!.docs[index]['name'],
                                      snapshot.data!.docs[index]['phone'],
                                      snapshot.data!.docs[index]['msg'],
                                      snapshot.data!.docs[index]['email'],
                                      snapshot.data!.docs[index]['shopId'],
                                      snapshot.data!.docs[index]['shopName']);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else if (snapshot.connectionState ==
                          ConnectionState.waiting ||
                      snapshot.hasError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text('No payments yet' , style: TextStyle(color: Colors.white),),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }

  Future<void> viewPaymentDetails(
      String paymentId,
      double amount,
      DateTime dateTime,
      String customerName,
      String phone,
      String msg,
      String email,
      String shopId,
      String shopName) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: mq.height * .85,
                width: mq.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.keyboard_backspace),
                        ),
                        SizedBox(
                          width: mq.width * .04,
                        ),
                        Text(
                          'Payment details',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    ListTile(
                      title: Text('Payment Id'),
                      trailing: Text('${paymentId}'),
                    ),
                    ListTile(
                      title: Text('Paid by'),
                      trailing: Text('${customerName}'),
                    ),
                    ListTile(
                      title: Text('Phone'),
                      trailing: Text('${phone}'),
                    ),
                    ListTile(
                      title: Text('Email'),
                      trailing: Text('${email}'),
                    ),
                    ListTile(
                      title: Text('Amount'),
                      trailing: Text('Rs.${amount}'),
                    ),
                    ListTile(
                      title: Text('Date'),
                      trailing: Text(
                          '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                    ),
                    ListTile(
                      title: Text('Time'),
                      trailing: Text(
                          '${dateTime.hour}:${dateTime.minute}:${dateTime.second}'),
                    ),
                    ListTile(
                      title: Text('Shop name'),
                      trailing: Text('Rs.${shopName}'),
                    ),
                    ListTile(
                      title: Text('Shop Id'),
                      trailing: SizedBox(
                        height: 40,
                        width: 125,
                        child: Center(
                          child: Text(
                            shopId
                          ),
                        ),
                      ),
                    ),
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
