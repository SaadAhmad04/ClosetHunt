import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mall/screens/shop_manager/view_product.dart';
import '../../controller/auth.dart';

class ViewShop extends StatefulWidget {
  const ViewShop({super.key});

  @override
  State<ViewShop> createState() => _ViewShopState();
}

class _ViewShopState extends State<ViewShop> {
  bool? exist;
  bool? found;
  bool? exists;
  bool? showDateHeader;
  String? orderId, type;
  Map<String, String> map = {};

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

  Future<bool> checkSubcollectionExistence2(String shopId) async {
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document = mainCollection.doc(shopId);

    final subCollections = ['parlor', 'restaurant'];

    for (final subCollection in subCollections) {
      final CollectionReference subCollectionRef =
          document.collection(subCollection);
      final QuerySnapshot querySnapshot = await subCollectionRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        exists = true;
        type = subCollection;
        map[shopId] = type!;
        return true;
      }
    }
    exists = false;
    type = null;
    map[shopId] = type!;
    return false;
  }

  Stream<QuerySnapshot>? stream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.shopManagerRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final spinKit = Center(
      child: SpinKitDoubleBounce(
        // itemBuilder: (context, index) {
        //   return DecoratedBox(decoration: BoxDecoration(
        //     color: Colors.blue
        //   ));
        // },
        color: Colors.blue,
      ),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xff1D1F33),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.grey.shade200,
          ),
          backgroundColor: Colors.transparent,
          title: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(colors: [Colors.blue, Colors.green])
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
                  color: Colors.grey.shade200,
                ),
              ),
              Tab(
                  icon: Icon(
                Icons.book_outlined,
                color: Colors.grey.shade200,
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: () {
                return Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ViewShop()),
                        (route) => false);
              },
              child: StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data?.docs.length != 0) {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            String shopManagerId =
                                snapshot.data?.docs[index]['uid'];
                            print(shopManagerId);
                            return FutureBuilder(
                              future:
                                  checkSubcollectionExistence(shopManagerId),
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
                                              child: spinKit,
                                            );
                                          } else if (snapshot.data != null &&
                                              snapshot.data!.exists) {
                                            String data = snapshot
                                                    .data?['shopName']
                                                    .toString() ??
                                                "";
                                            print('data = ${data}');
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                tileColor: Colors.grey.shade200,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25),
                                                    side: BorderSide(
                                                        color: Colors.black
                                                    )
                                                ),
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
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data?['shopIcon'] ??
                                                          "",
                                                     ),
                                                ),
                                                title: Text(data.toString()),
                                                subtitle: Text(snapshot
                                                        .data?['shopManagerName']
                                                        .toString() ??
                                                    ""),
                                              ),
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
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: spinKit,
                      );
                    } else {
                      return Center(
                        child: Text('No shops'),
                      );
                    }
                  }),
            ),
            RefreshIndicator(
              onRefresh: () {
                return Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ViewShop()),
                        (route) => false);
              },
              child: StreamBuilder(
                  stream: Auth.shopManagerRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data?.docs.length != 0) {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            String shopManagerId =
                                snapshot.data?.docs[index]['uid'];
                            return FutureBuilder(
                              future:
                                  checkSubcollectionExistence2(shopManagerId),
                              builder: (context, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: spinKit,
                                  );
                                } else {
                                  print('maaaaaaaaaaaaap${map}');
                                  return exist == true &&
                                          map[shopManagerId] != null
                                      ? StreamBuilder(
                                          stream: Auth.shopManagerRef
                                              .doc(shopManagerId)
                                              .collection(map[shopManagerId]!)
                                              .doc(shopManagerId)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child: spinKit,
                                              );
                                            } else if (snapshot.data != null &&
                                                snapshot.data!.exists) {
                                              String data = snapshot
                                                      .data?['shopName']
                                                      .toString() ??
                                                  "";
                                              print('data = ${data}');
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                  tileColor: Colors.grey.shade200,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25),
                                                    side: BorderSide(
                                                      color: Colors.black
                                                    )
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ViewProduct(
                                                                      shopName: snapshot
                                                                              .data?['shopName']
                                                                              .toString() ??
                                                                          "",
                                                                      shopId:
                                                                          shopManagerId,
                                                                    )));
                                                  },
                                                  leading: CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                      snapshot.data?['shopIcon'] ??
                                                          "",
                                                    ),
                                                  ),
                                                  title: Text(data.toString()),
                                                  subtitle: Text(snapshot.data?[
                                                              'shopManagerName']
                                                          .toString() ??
                                                      ""),
                                                ),
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
                                }
                              },
                            );
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: spinKit,
                      );
                    } else {
                      return Center(
                        child: Text('No shops'),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
