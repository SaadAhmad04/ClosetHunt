import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/app_manager/shopping/assign_shop.dart';
import 'package:mall/screens/shop_manager/view_product.dart';
import '../../../controller/auth.dart';
import '../../customer/shopping/customer_shopping.dart';

class ShopKeeperWithoutShops extends StatefulWidget {
  const ShopKeeperWithoutShops({Key? key}) : super(key: key);

  @override
  State<ShopKeeperWithoutShops> createState() => _ShopKeeperWithoutShopsState();
}

class _ShopKeeperWithoutShopsState extends State<ShopKeeperWithoutShops> {
  late Stream<QuerySnapshot> stream;

  @override
  void initState() {
    super.initState();
    stream = Auth.shopManagerRef.snapshots();
  }

  @override
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
                  'Shop Keeper Without Shops',
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
                      print("EXISTING ${exist}");
                      if (!exist) {
                        print(shopManagerId);
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssignShop(
                                    shopManagerId: shopManagerId,
                                  ),
                                ));
                          },
                          title: Text(shopManagerId),
                          subtitle: Text(shopManagerName),
                        );
                      } else {
                        return SizedBox();
                      }
                    } else {
                      return CircularProgressIndicator();
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
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document = mainCollection.doc(shopManagerId);
    final CollectionReference subCollection1 = document.collection('shop');
    final CollectionReference subCollection2 = document.collection('parlor');
    final CollectionReference subCollection3 = document.collection('theatre');
    try {
      final QuerySnapshot querySnapshot1 = await subCollection1.get();
      final QuerySnapshot querySnapshot2 = await subCollection2.get();
      final QuerySnapshot querySnapshot3 = await subCollection3.get();

      return querySnapshot1.docs.isNotEmpty ||
          querySnapshot2.docs.isNotEmpty ||
          querySnapshot3.docs.isNotEmpty;
    } catch (e) {
      print('Error checking subcollections existence: $e');
      return false;
    }
  }

// Future<bool> checkSubcollectionExistence(String shopManagerId) async {
//   final CollectionReference mainCollection = Auth.shopManagerRef;
//   final DocumentReference document = mainCollection.doc(shopManagerId);
//   final CollectionReference subCollection = document.collection('shop');
//
//   try {
//     final QuerySnapshot querySnapshot = await subCollection.get();
//     return querySnapshot.docs.isNotEmpty;
//   } catch (e) {
//     print('Error checking subcollection existence: $e');
//     return false;
//   }
// }
}