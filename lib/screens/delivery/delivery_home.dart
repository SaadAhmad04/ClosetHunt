import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/delivery/send_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth.dart';

class DeliveryHome extends StatefulWidget {
  String? id;
  String? email;
  String? password;

  DeliveryHome({super.key, this.id, this.email, this.password});

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.deliveryRef.doc(widget.id).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: getType(),
              builder: (context, snap) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text('${snapshot.data?['email']}'),
                      leading: IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          Auth.logout(context);
                        },
                      ),
                    ),
                    body: snapshot.data?['email'] == widget.email
                        ? StreamBuilder(
                            stream: Auth.appManagerRef.snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
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
                                      .collection('shopping')
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
                                            print('id =================${id}');
                                            return FutureBuilder(
                                              future:
                                                  checkSubcollectionExistence(
                                                      id),
                                              builder: (context, sp) {
                                                if (sp.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (sp.connectionState ==
                                                    ConnectionState.done) {
                                                  bool exist = sp.data as bool;
                                                  if (exist) {
                                                    return StreamBuilder(
                                                      stream: Auth.appManagerRef
                                                          .doc(appManagerId)
                                                          .collection(
                                                              'notifications')
                                                          .doc(appManagerId)
                                                          .collection(
                                                              'shopping')
                                                          .doc(documents[index]
                                                              .id)
                                                          .collection(
                                                              'products')
                                                          .where(
                                                              'deliveryBoyId',
                                                              isEqualTo:
                                                                  widget.id)
                                                          .snapshots(),
                                                      builder: (context, st) {
                                                        if (st.hasData &&
                                                            st.data != null) {
                                                          return ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            itemCount: st.data!
                                                                .docs.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              String name =
                                                                  st.data!.docs[
                                                                          index]
                                                                      ['name'];
                                                              int date = int.parse(st
                                                                  .data!
                                                                  .docs[index]
                                                                      ['date']
                                                                  .toString()
                                                                  .substring(
                                                                      0,
                                                                      st.data!.docs[index]['date']
                                                                              .toString()
                                                                              .length -
                                                                          1));
                                                              DateTime
                                                                  dateTime =
                                                                  DateTime
                                                                      .fromMillisecondsSinceEpoch(
                                                                          date);
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: ListTile(
                                                                  visualDensity:
                                                                      VisualDensity(
                                                                          vertical:
                                                                              4),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      side: BorderSide(
                                                                          color:
                                                                              Colors.black)),
                                                                  title:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                        '${st.data?.docs[index]['name']}'),
                                                                  ),
                                                                  trailing: Text(
                                                                      '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                                                                  subtitle: st.data!.docs[index]
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
                                                                          '${snap.data!.docs[index]['date']}'),
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => SendOtp(
                                                                                  customerId: st.data!.docs[index]['customerId'],
                                                                                  orderId: st.data!.docs[index]['date'],
                                                                                  id: widget.id,
                                                                                  appManagerId: appManagerId,
                                                                                  email: widget.email,
                                                                                  pswd: widget.password,
                                                                                  delivered: st.data!.docs[index]['delivered'],
                                                                                  dateOfDelivery: st.data!.docs[index]['delivered'] ? st.data!.docs[index]['dateOfDelivery'] : null,
                                                                                )));
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                      },
                                                    );
                                                  } else {
                                                    String uid =
                                                        snap.data?.docs[index]
                                                            ['customerId'];
                                                    int date = int.parse(snap
                                                        .data!
                                                        .docs[index]['date']
                                                        .toString()
                                                        .substring(
                                                            0,
                                                            snap
                                                                    .data!
                                                                    .docs[index]
                                                                        ['date']
                                                                    .toString()
                                                                    .length -
                                                                1));
                                                    DateTime dateTime = DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            date);
                                                    return (snap.data?.docs[
                                                                        index][
                                                                    'assigned'] ==
                                                                true &&
                                                            snap.data?.docs[
                                                                        index][
                                                                    'deliveryBoyId'] ==
                                                                widget.id)
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      vertical:
                                                                          3),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                              title: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Text(
                                                                    '${snap.data?.docs[index]['name']}'),
                                                              ),
                                                              subtitle: snap.data!
                                                                              .docs[index]
                                                                          [
                                                                          'delivered'] ==
                                                                      true
                                                                  ? Text(
                                                                      'Delivered')
                                                                  : Text(
                                                                      '${snap.data!.docs[index]['date']}'),
                                                              trailing: Text(
                                                                  '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            SendOtp(
                                                                              customerId: uid,
                                                                              orderId: snap.data!.docs[index]['date'],
                                                                              id: widget.id,
                                                                              appManagerId: appManagerId,
                                                                              stream: 1,
                                                                              email: widget.email,
                                                                              pswd: widget.password,
                                                                              delivered: snap.data!.docs[index]['delivered'],
                                                                              dateOfDelivery: snap.data!.docs[index]['delivered'] ? snap.data!.docs[index]['dateOfDelivery'] : null,
                                                                            )));
                                                              },
                                                            ),
                                                          )
                                                        : SizedBox();
                                                  }
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                        'No products collection'),
                                                  );
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
                        : Text("no"));
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<bool> checkSubcollectionExistence(String orderId) async {
    final CollectionReference mainCollection = Auth.appManagerRef
        .doc(appManagerId)
        .collection('notifications')
        .doc(appManagerId)
        .collection('shopping');
    final DocumentReference document = mainCollection.doc(orderId);
    final CollectionReference subCollection1 = document.collection('products');
    try {
      final QuerySnapshot querySnapshot1 = await subCollection1.get();
      return querySnapshot1.docs.isNotEmpty;
    } catch (e) {
      print('Error checking subcollections existence: $e');
      return false;
    }
  }
}
