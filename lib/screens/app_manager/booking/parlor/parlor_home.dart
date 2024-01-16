import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/app_manager/app_manager_home.dart';
import 'package:mall/screens/app_manager/booking/parlor/add_parlor.dart';

import '../../../../controller/auth.dart';

class ParlorHome extends StatefulWidget {
  const ParlorHome({super.key});

  @override
  State<ParlorHome> createState() => _ParlorHomeState();
}

class _ParlorHomeState extends State<ParlorHome> {
  bool exist = false;
  late Stream<QuerySnapshot> stream;

  @override
  void initState() {
    super.initState();
    stream = Auth.bookingRef.snapshots();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              title: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Colors.blue, Colors.green],
                  ).createShader(bounds);
                },
                child: Text(
                  'Assign Parlor',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                String shopManagerId = snapshot.data?.docs[index]['uid'];
                String shopManagerName = snapshot.data?.docs[index]['name'];
                return FutureBuilder(
                  future: checkSubcollectionExistence(shopManagerId),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      bool exist = snap.data as bool;
                      if (!exist) {
                        print(shopManagerId);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    width: 1,
                                    color: Colors.black
                                )
                            ),
                            title: Text(shopManagerId),
                            subtitle: Text(shopManagerName),
                            trailing: TextButton(child: Text('Assign') , onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddParlor(
                                      shopManagerId: shopManagerId,
                                    ),
                                  ));
                            }),
                          ),
                        );
                      }
                      else {
                        return SizedBox();
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<bool> checkSubcollectionExistence(String shopManagerId) async {
    final CollectionReference mainCollection = Auth.bookingRef;
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
}
