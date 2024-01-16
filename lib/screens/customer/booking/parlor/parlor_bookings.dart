import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/controller/auth.dart';
import 'package:mall/screens/customer/booking/parlor/view_booking.dart';
import 'package:mall/screens/customer/customer_home.dart';

import '../../../../main.dart';

class ParlorBookings extends StatefulWidget {
  String? shopId;
  ParlorBookings({super.key, this.shopId});

  @override
  State<ParlorBookings> createState() => _ParlorBookingsState();
}

class _ParlorBookingsState extends State<ParlorBookings> {
  Stream<QuerySnapshot>? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.customerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('bookings')
        .snapshots();
  }

  Future<bool> checkSubcollectionExistence(String shopManagerId) async {
    final CollectionReference mainCollection =
        Auth.customerRef.doc(Auth.auth.currentUser!.uid).collection('bookings');
    final DocumentReference document = mainCollection.doc(shopManagerId);
    final CollectionReference subCollection = document.collection('parlor');

    try {
      final QuerySnapshot querySnapshot = await subCollection.get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking subcollection existence: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(Auth.auth.currentUser!.uid);
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print(snapshot.data?.docs.length);
          if (snapshot.hasData && snapshot.data != null) {
            QuerySnapshot querySnapshot =
                snapshot.data as QuerySnapshot<Object?>;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => CustomerHome()),
                        (route) => false);
                  },
                ),
                title: Text('Parlor Bookings'),
                centerTitle: true,
              ),
              body: Material(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    String shopManagerId = documents[index].id;
                    return FutureBuilder(
                      future: checkSubcollectionExistence(shopManagerId),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          bool subcollectionExists = snap.data as bool;
                          if (subcollectionExists) {
                            return StreamBuilder(
                              stream: Auth.customerRef
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('bookings')
                                  .doc(shopManagerId)
                                  .collection('parlor')
                                  .snapshots(),
                              builder: (context, sp) {
                                if (sp.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (sp.data != null && sp.hasData) {
                                  return ListView.builder(
                                    reverse: true,
                                    shrinkWrap: true,
                                    itemCount: sp.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      String dop = sp.data!.docs[index]['date'];
                                      DateTime dateTime = DateTime.parse(dop);
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            child: Icon(Icons.book_outlined),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          visualDensity:
                                              VisualDensity(vertical: 3),
                                          title: Text(
                                              sp.data!.docs[index]['shopName']),
                                          subtitle: sp.data!.docs[index]
                                                  ['cancelled']
                                              ? Text(
                                                  'Cancelled',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.red.shade800),
                                                )
                                              : Container(),
                                          trailing: Text(
                                              "${dateTime.day}-${dateTime.month}-${dateTime.year}"),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewBooking(
                                                            bookingId: sp.data!
                                                                    .docs[index]
                                                                ['bookingId'],
                                                            shopId:
                                                                shopManagerId)));
                                          },
                                        ),
                                      );
                                    },
                                  );
                                } else if (sp.hasError ||
                                    sp.data == null ||
                                    !sp.hasData) {
                                  return SizedBox();
                                } else {
                                  return Text('No shopkeeper');
                                }
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('No bookings available'));
          }
        });
  }
}
