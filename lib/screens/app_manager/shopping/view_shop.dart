import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/shop_manager/view_product.dart';
import '../../../controller/auth.dart';

class ViewShop extends StatefulWidget {
  const ViewShop({super.key});

  @override
  State<ViewShop> createState() => _ViewShopState();
}

class _ViewShopState extends State<ViewShop> {
  bool? exist;
  bool? found;

  Future<void> checkSubcollectionExistence(String shopManagerId) async {
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document = mainCollection.doc(shopManagerId);
    final CollectionReference subCollection = document.collection('shop');
    try {
      final QuerySnapshot querySnapshot = await subCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        exist = true;
        print('Subcollection exists ${shopManagerId}');
      } else {
        exist = false;
        print('Subcollection does not exist ${shopManagerId}');
      }
    } catch (e) {
      print('Error checking subcollection existence: $e');
    }
  }

  Future<void> checkSubcollectionExistence1(String shopManagerId) async {
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document = mainCollection.doc(shopManagerId);
    final CollectionReference subCollection = document.collection('parlor');
    try {
      final QuerySnapshot querySnapshot = await subCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        found = true;
        print('Subcollection exists ${shopManagerId}');
      } else {
        found = false;
        print('Subcollection does not exist ${shopManagerId}');
      }
    } catch (e) {
      print('Error checking subcollection existence: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.shopManagerRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
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
                            colors: [Colors.blue, Colors.green])
                            .createShader(bounds);
                      },
                      child: Text(
                        'All shops',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      )),
                  centerTitle: true,
                  elevation: 0,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.shop,
                          color: Colors.grey,
                        ),
                      ),
                      Tab(
                          icon: Icon(
                            Icons.book_outlined,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          String shopManagerId =
                          snapshot.data?.docs[index]['uid'];
                          print(shopManagerId);
                          return FutureBuilder(
                            future: checkSubcollectionExistence(shopManagerId),
                            builder: (context, snap) {
                              return exist == true
                                  ? StreamBuilder(
                                  stream: Auth.shopManagerRef
                                      .doc(shopManagerId)
                                      .collection('shop')
                                      .doc(shopManagerId)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                      snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.data != null &&
                                        snapshot.data!.exists) {
                                      String data = snapshot
                                          .data?['shopName']
                                          .toString() ??
                                          "";
                                      print('data = ${data}');
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewProduct(
                                                        shopName: snapshot
                                                            .data?[
                                                        'shopName']
                                                            .toString() ??
                                                            "",
                                                        shopId:
                                                        shopManagerId,
                                                      )));
                                        },
                                        leading: Image.network(
                                            snapshot.data?['shopIcon'] ??
                                                "",
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover),
                                        title: Text(data.toString()),
                                        subtitle: Text(snapshot
                                            .data?['shopManagerName']
                                            .toString() ??
                                            ""),
                                      );
                                    } else if (!snapshot.data!.exists ||
                                        snapshot.hasError ||
                                        snapshot.data == null ||
                                        !snapshot.hasData) {
                                      return SizedBox();
                                    } else {
                                      return Text('No shopkeeper');
                                    }
                                  })
                                  : SizedBox();
                            },
                          );
                        }),
                    ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          String shopManagerId =
                          snapshot.data?.docs[index]['uid'];
                          print(shopManagerId);
                          return FutureBuilder(
                            future: checkSubcollectionExistence1(shopManagerId),
                            builder: (context, snap) {
                              return exist == true
                                  ? StreamBuilder(
                                  stream: Auth.shopManagerRef
                                      .doc(shopManagerId)
                                      .collection('parlor')
                                      .doc(shopManagerId)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                      snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.data != null &&
                                        snapshot.data!.exists) {
                                      String data = snapshot
                                          .data?['shopName']
                                          .toString() ??
                                          "";
                                      print('data = ${data}');
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewProduct(
                                                        shopName: snapshot
                                                            .data?[
                                                        'shopName']
                                                            .toString() ??
                                                            "",
                                                        shopId:
                                                        shopManagerId,
                                                      )));
                                        },
                                        leading: Image.network(
                                            snapshot.data?['shopIcon'] ??
                                                "",
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover),
                                        title: Text(data.toString()),
                                        subtitle: Text(snapshot
                                            .data?['shopManagerName']
                                            .toString() ??
                                            ""),
                                      );
                                    } else if (!snapshot.data!.exists ||
                                        snapshot.hasError ||
                                        snapshot.data == null ||
                                        !snapshot.hasData) {
                                      return SizedBox();
                                    } else {
                                      return Text('No shopkeeper');
                                    }
                                  })
                                  : SizedBox();
                            },
                          );
                        }),
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