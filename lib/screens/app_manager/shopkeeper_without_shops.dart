import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mall/screens/app_manager/app_manager_home.dart';
import 'package:mall/screens/app_manager/assign_shop.dart';
import 'package:mall/screens/shop_manager/view_product.dart';
import '../../controller/auth.dart';
import '../customer/shopping/customer_shopping.dart';

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
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: Color(0xff1D1F33),
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppManagerHome()));
                  },
                  color: Colors.grey.shade200,
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
                      fontSize:20.0,
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.black)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssignShop(
                                        shopManagerId: shopManagerId,
                                      ),
                                    ));
                              },
                              title: Text('Shop Name : ${shopManagerName}'),
                              subtitle: Text(shopManagerId),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      } else {
                        return Center(child: spinKit);
                      }
                    },
                  );
                },
              ),
            ),
          );
        } else {
          return Center(
            child: spinKit,
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
    final CollectionReference subCollection3 =
        document.collection('restaurant');
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

}
