import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/app_manager/noti_detail.dart';

import '../../controller/auth.dart';

class AppManagerNotificationHistory extends StatefulWidget {
  const AppManagerNotificationHistory({super.key});

  @override
  State<AppManagerNotificationHistory> createState() =>
      _AppManagerNotificationHistoryState();
}

class _AppManagerNotificationHistoryState
    extends State<AppManagerNotificationHistory> {
  String? phno, email, uid, orderId, date;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shop),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.book_outlined),
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
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final name = snapshot.data!.docs[index]['name'];
                        final msg = snapshot.data!.docs[index]['msg'];
                        final productId =
                            snapshot.data!.docs[index]['productId'];
                        final mode = snapshot.data!.docs[index]['mode'];
                        if (productId != "") {
                          uid = snapshot.data!.docs[index]['customerId'];
                          email = snapshot.data!.docs[index]['email'];
                          phno = snapshot.data!.docs[index]['phone'];
                          orderId = snapshot.data!.docs[index]['date'];
                        } else {
                          orderId = snapshot.data!.docs[index]['orderId'];
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            visualDensity: VisualDensity(vertical: 3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey)),
                            title: Text(name),
                            subtitle: mode == "homeDelivery"
                                ? Text('${msg}\nHome Delivery')
                                : Text('${msg}\nPick from mall'),
                            onTap: () {
                              if (productId != "") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationDetail(
                                              uid: uid,
                                              name: name,
                                              email: email,
                                              phno: phno,
                                              productId: productId,
                                              orderId: snapshot
                                                  .data!.docs[index]['date'],
                                              mode: mode,
                                            )));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationDetail(
                                              uid: uid,
                                              name: name,
                                              email: email,
                                              phno: phno,
                                              productId: productId,
                                              orderId: snapshot
                                                  .data!.docs[index]['orderId'],
                                              mode: mode
                                            )));
                              }
                            },
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    print('hellppppppppppppo');
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data == null) {
                    print('hello');
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey)),
                            title: Text(name),
                            subtitle: snapshot.data?.docs[index]['cancelled']
                                ? Text(
                                    'Cancelled',
                                    style:
                                        TextStyle(color: Colors.red.shade800),
                                  )
                                : Text('${snapshot.data?.docs[index]['msg']}',
                                    style: TextStyle(
                                        color: Colors.green.shade800)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotificationDetail(
                                            uid: uid,
                                            name: name,
                                            email: email,
                                            phno: phno,
                                            shopId: shopId,
                                            bookingId: bookingId,
                                            cancelled: snapshot
                                                .data?.docs[index]['cancelled'],
                                          )));
                            },
                          ),
                        );
                      },
                    );
                  } else if (snapshot.connectionState ==
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
              )
            ],
          ),
        ));
  }
}
