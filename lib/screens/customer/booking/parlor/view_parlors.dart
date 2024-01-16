import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/controller/auth.dart';
import 'package:mall/screens/customer/booking/parlor/parlor_bookings.dart';
import 'package:mall/screens/customer/booking/parlor/view_services.dart';

class ViewParlors extends StatefulWidget {
  const ViewParlors({super.key});

  @override
  State<ViewParlors> createState() => _ViewParlorsState();
}

class _ViewParlorsState extends State<ViewParlors> {
  String? exists;
  Future<bool> checkSubcollectionExistence(String shopManagerId) async {
    final CollectionReference mainCollection = Auth.shopManagerRef;
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
    return StreamBuilder(
        stream: Auth.shopManagerRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('All Parlors'),
                centerTitle: true,
                actions: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: ListTile(
                                  title: Text('My Bookings'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ParlorBookings()));
                                  },
                                ))
                              ]))
                ],
              ),
              body: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    String shopManagerId = snapshot.data?.docs[index]['uid'];
                    return FutureBuilder(
                      future: checkSubcollectionExistence(shopManagerId),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          bool subcollectionExists = snap.data as bool;
                          print(subcollectionExists);
                          if (subcollectionExists) {
                            return StreamBuilder(
                              stream: Auth.shopManagerRef
                                  .doc(shopManagerId)
                                  .collection('parlor')
                                  .doc(shopManagerId)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> sp) {
                                if (sp.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (sp.data != null &&
                                    sp.data!.exists &&
                                    sp.hasData) {
                                  String name = sp.data?['shopName'];
                                  String shopIcon = sp.data?['shopIcon'];
                                  print('${name}-----------------');
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListTile(
                                        visualDensity:
                                            VisualDensity(vertical: 4),
                                        title: Text(name),
                                        leading: Image.network(shopIcon),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewServices(
                                                        shopId: shopManagerId,
                                                        shopName: name,
                                                      )));
                                        },
                                      ),
                                    ),
                                  );
                                } else if (!sp.data!.exists ||
                                    sp.hasError ||
                                    sp.data == null ||
                                    !sp.hasData) {
                                  return SizedBox();
                                } else {
                                  print('saaaaaaaaaaaaad');
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
                  }),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
