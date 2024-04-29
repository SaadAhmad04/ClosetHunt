import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/auth_ui/login_screen.dart';
import 'package:mall/screens/delivery/analysis.dart';
import 'package:mall/screens/delivery/send_otp.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth.dart';
import '../../main.dart';

class DeliveryHome extends StatefulWidget {
  String? id;
  String? email;
  String? password;
  bool refresh;
  DeliveryHome(
      {super.key, this.id, this.email, this.password, this.refresh = false});

  @override
  State<DeliveryHome> createState() => _DeliveryHomeState();
}

class _DeliveryHomeState extends State<DeliveryHome> {
  Future<void> getType() async {
    final pref = await SharedPreferences.getInstance();
    // final pref = await SharedPreferences.getInstance();
    await pref.setString('type', 'Delivery Person');
    await pref.setString('email', widget.email.toString());
    await pref.setString('id', widget.id.toString());
    await pref.setString('password', widget.password.toString());
  }

  Future<String?> getEmail() async {
    final pref = await SharedPreferences.getInstance();
    String? emaill = pref.getString('email');
    return emaill;
  }

  String? appManagerId, orderId;
  String? name;
  Stream<QuerySnapshot>? stream;
  bool refresh = false;
  Set? orderIds = {};
  List<Status> status = [];
  Map<String, String> map = {};
  var filters = ['All', 'Delivered', 'Cancelled', 'Yet to deliver'];
  String dropDownFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.deliveryRef.doc(widget.id).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data!.exists) {
            return FutureBuilder(
              future: getType(),
              builder: (context, snap) {
                return RefreshIndicator(
                  onRefresh: () {
                    return Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliveryHome(
                                  id: widget.id,
                                  email: widget.email,
                                  password: widget.password,
                                  refresh: true,
                                )),
                        (route) => false);
                  },
                  child: Scaffold(
                    backgroundColor: Colors.purple.shade50,
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        '${snapshot.data?['email']}',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Auth.logout(context);
                        },
                      ),
                      actions: [
                        DropdownButton(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 1,
                          padding: const EdgeInsets.only(top: 8),
                          value: dropDownFilter,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: filters.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownFilter = newValue!;
                            });
                          },
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Analysis(
                                            id: widget.id,
                                            orderIds: orderIds?.toList(),
                                            appManagerId: appManagerId,
                                            status: map,
                                          )));
                            },
                            icon: Icon(
                              Icons.analytics_outlined,
                              color: Colors.purple,
                            ))
                      ],
                    ),
                    body: snapshot.data?['email'] == widget.email
                        ? StreamBuilder(
                            stream: Auth.appManagerRef.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                print('hello----------------------');
                                Auth.appManagerRef.get().then(
                                  (QuerySnapshot querySnapshot) {
                                    for (QueryDocumentSnapshot documentSnapshot
                                        in querySnapshot.docs) {
                                      Map<String, dynamic> keyValuePairs =
                                          documentSnapshot.data()
                                              as Map<String, dynamic>;
                                      appManagerId = keyValuePairs['uid'];
                                    }
                                  },
                                );
                                return StreamBuilder(
                                  stream: Auth.appManagerRef
                                      .doc(appManagerId)
                                      .collection('notifications')
                                      .doc(appManagerId)
                                      .collection('shopping').
                                    orderBy('orderId' , descending: true)
                                      .snapshots(),
                                  builder: (context, snap) {
                                    if (snap.hasData) {
                                      QuerySnapshot querySnapshot =
                                          snap.data as QuerySnapshot<Object?>;
                                      List<QueryDocumentSnapshot> documents =
                                          querySnapshot.docs;
                                      return ListView.builder(
                                          itemCount: snap.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            String id = documents[index].id;
                                            return StreamBuilder<QuerySnapshot>(
                                              stream: dropDownFilter ==
                                                      'Delivered'
                                                  ? Auth.appManagerRef
                                                      .doc(appManagerId)
                                                      .collection(
                                                          'notifications')
                                                      .doc(appManagerId)
                                                      .collection('shopping')
                                                      .doc(id)
                                                      .collection('products')
                                                      .where('deliveryBoyId',
                                                          isEqualTo: widget.id)
                                                      .where('delivered',
                                                          isEqualTo: true)
                                                      .snapshots()
                                                  : dropDownFilter ==
                                                          'Cancelled'
                                                      ? Auth.appManagerRef
                                                          .doc(appManagerId)
                                                          .collection(
                                                              'notifications')
                                                          .doc(appManagerId)
                                                          .collection(
                                                              'shopping')
                                                          .doc(id)
                                                          .collection(
                                                              'products')
                                                          .where('deliveryBoyId',
                                                              isEqualTo:
                                                                  widget.id)
                                                          .where('cancelled',
                                                              isEqualTo: true)
                                                          .snapshots()
                                                      : dropDownFilter ==
                                                              'Yet to deliver'
                                                          ? Auth.appManagerRef
                                                              .doc(appManagerId)
                                                              .collection(
                                                                  'notifications')
                                                              .doc(appManagerId)
                                                              .collection(
                                                                  'shopping')
                                                              .doc(id)
                                                              .collection(
                                                                  'products')
                                                              .where(
                                                                  'deliveryBoyId',
                                                                  isEqualTo:
                                                                      widget.id)
                                                              .where('cancelled',
                                                                  isEqualTo:
                                                                      false)
                                                              .where(
                                                                  'delivered',
                                                                  isEqualTo:
                                                                      false)
                                                              .snapshots()
                                                          : Auth.appManagerRef
                                                              .doc(appManagerId)
                                                              .collection(
                                                                  'notifications')
                                                              .doc(appManagerId)
                                                              .collection(
                                                                  'shopping')
                                                              .doc(id)
                                                              .collection(
                                                                  'products')
                                                              .where(
                                                                  'deliveryBoyId',
                                                                  isEqualTo:
                                                                      widget.id)
                                                              .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      st) {
                                                if (st.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (st.hasError) {
                                                  print('skjadj${st.data}');
                                                  return Center(
                                                      child: Text(
                                                          'Error: ${st.error}'));
                                                } else if (st.hasData &&
                                                    st.data?.docs.length != 0 &&
                                                    st.data != null) {
                                                  print('mzxbzbcm${st.data}');
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        ClampingScrollPhysics(),
                                                    itemCount:
                                                        st.data?.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      String name = st.data!
                                                          .docs[index]['name'];
                                                      int date = int.parse(st
                                                          .data!
                                                          .docs[index]
                                                              ['orderId']
                                                          .toString()
                                                          .substring(
                                                              0,
                                                              st
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'orderId']
                                                                      .toString()
                                                                      .length -
                                                                  1));
                                                      DateTime dateTime = DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              date);
                                                      orderIds?.add(
                                                          st.data!.docs[index]
                                                              ['orderId']);
                                                      st.data!.docs[index]['cancelled'] ==
                                                              true
                                                          ? map[st.data!.docs[index]
                                                                  ['orderId']] =
                                                              'Cancelled'
                                                          : st.data!.docs[index]['delivered'] ==
                                                                  true
                                                              ? map[st.data!
                                                                          .docs[index]
                                                                      ['orderId']] =
                                                                  'Delivered'
                                                              : map[st.data!
                                                                          .docs[index]
                                                                      ['orderId']] =
                                                                  'Yet to deliver';
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      vertical:
                                                                          4),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                              title: Text(
                                                                  '${st.data?.docs[index]['name']}'),
                                                              trailing: st.data!
                                                                              .docs[index]
                                                                          [
                                                                          'cancelled'] ==
                                                                      false
                                                                  ? Text(
                                                                      '${dateTime.day}-${dateTime.month}-${dateTime.year}')
                                                                  : Text(
                                                                      'Cancelled',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red
                                                                              .shade600,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                              subtitle:
                                                                  st.data!.docs[index]
                                                                              [
                                                                              'delivered'] ==
                                                                          true
                                                                      ? Text(
                                                                          'Delivered',
                                                                          style: TextStyle(
                                                                              color: Colors.green.shade400,
                                                                              fontWeight: FontWeight.bold),
                                                                        )
                                                                      : Text(
                                                                          '${st.data!.docs[index]['orderId']}',
                                                                          style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            SendOtp(
                                                                              customerId: st.data!.docs[index]['customerId'],
                                                                              customerName: st.data!.docs[index]['name'],
                                                                              orderId: st.data!.docs[index]['orderId'],
                                                                              cancelled: st.data!.docs[index]['cancelled'],
                                                                              id: widget.id,
                                                                              phone: st.data!.docs[index]['phone'],
                                                                              address: st.data!.docs[index]['address'],
                                                                              appManagerId: appManagerId,
                                                                              email: widget.email,
                                                                              pswd: widget.password,
                                                                              delivered: st.data!.docs[index]['delivered'],
                                                                              dateOfDelivery: st.data!.docs[index]['delivered'] ? st.data!.docs[index]['dateOfDelivery'] : null,
                                                                            )));
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              },
                                            );
                                          });
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            })
                        : Text("no"),
                    floatingActionButton: widget.refresh == false
                        ? Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 50,
                              width: mq.width,
                              child: FloatingActionButton(
                                onPressed: () {},
                                elevation: 0,
                                backgroundColor: Colors.purple.shade50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Pull to refresh',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.refresh,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                );
              },
            );
          } else {
            //return Center(child: CircularProgressIndicator(),);
            return Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: mq.height * 0.12),
                    child: Image.network(
                        "https://www.sunvoyage.com.ua/wp-content/uploads/2020/02/%D0%92%D0%9D%D0%98%D0%9C%D0%90%D0%9D%D0%98%D0%95.jpg"),
                  ),
                  Container(
                    height: mq.height * .08,
                    width: mq.width * .75,
                    margin: EdgeInsets.symmetric(
                        horizontal: mq.width * .1, vertical: mq.height * .05),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.red)),
                    child: Center(
                        child: DefaultTextStyle(
                      style: TextStyle(color: Colors.redAccent, fontSize: 15),
                      child: Text(
                        "No delivery boy found!!",
                      ),
                    )),
                  ),
                  TextButton(
                      onPressed: () {
                        Auth.logout(context);
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => LoginScreen()),
                        //         (route) => false);
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            );
          }
        });
  }
}

class Status {
  String? orderId;
  String? status;

  Status({this.orderId, this.status});
}
