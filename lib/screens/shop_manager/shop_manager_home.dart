// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mall/constant/widget/roundButton.dart';
// import 'package:mall/constant/widget/show_error.dart';
// import 'package:mall/screens/shop_manager/parlor/parlor_display.dart';
// import 'package:mall/screens/shop_manager/restaurant/restaurant_display.dart';
// import 'package:mall/screens/shop_manager/shop_display.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controller/firebase_api.dart';
// import '../../constant/utils/utilities.dart';
// import '../../controller/auth.dart';
// import 'add_product.dart';
//
// class ShopManagerHome extends StatefulWidget {
//   const ShopManagerHome({super.key});
//
//   @override
//   State<ShopManagerHome> createState() => _ShopManagerHomeState();
// }
//
// class _ShopManagerHomeState extends State<ShopManagerHome> {
//   String? tok;
//   var exists;
//
//   Future<String> Found() async {
//     final token = await FirebaseApi.initNotifications();
//     print("TOKSSSM ${token}");
//     return token.toString();
//   }
//
//   final shopNameController = TextEditingController();
//   final shopManagerNameController = TextEditingController();
//   final idController = TextEditingController();
//   bool isIconUploaded = false;
//   final _formKey = GlobalKey<FormState>();
//   File? shopIcon;
//   final shopIconPicker = ImagePicker();
//
//   Future<void> getType() async {
//     final pref = await SharedPreferences.getInstance();
//     await pref.setString('type', 'Shop Manager');
//     await pref.setString('name', name);
//     await pref.setString('email', email);
//     tok = await Found();
//     print("GDFASF${tok}");
//   }
//
//   Future<void> checkSubcollectionExistence() async {
//     String check = "";
//     final CollectionReference mainCollection = Auth.shopManagerRef;
//     final DocumentReference document =
//     mainCollection.doc(Auth.auth.currentUser!.uid);
//     final CollectionReference subCollection = document.collection('shop');
//     final CollectionReference subCollection2 = document.collection('parlor');
//     final CollectionReference subCollection3 =
//     document.collection('restaurant');
//     try {
//       final QuerySnapshot querySnapshot = await subCollection.get();
//       final QuerySnapshot querySnapshot2 = await subCollection2.get();
//       final QuerySnapshot querySnapshot3 = await subCollection3.get();
//
//       if (querySnapshot.docs.isNotEmpty ||
//           querySnapshot2.docs.isNotEmpty ||
//           querySnapshot3.docs.isNotEmpty) {
//         exists = 1;
//         if (querySnapshot.docs.isNotEmpty) {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => ShopDisplay()));
//         } else if (querySnapshot2.docs.isNotEmpty) {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (_) => ParlorDisplay()));
//         } else if (querySnapshot3.docs.isNotEmpty) {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => RestaurantDisplay(),
//               ));
//         }
//
//         print('Subcollection exists');
//       } else {
//         exists = 0;
//         print('Subcollection does not exist');
//       }
//     } catch (e) {
//       print('Error checking subcollection existence: $e');
//     }
//   }
//
//   late String name, email;
//   Stream<QuerySnapshot>? stream;
//   List id = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     stream = Auth.shopManagerRef
//         .where('uid', isEqualTo: Auth.auth.currentUser!.uid)
//         .snapshots();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   void _navigateToAnotherScreen() {
//     // Perform navigation logic here (e.g., using Navigator).
//     if (exists == 1) {
//       print('saaaad');
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => ShopDisplay()));
//     }
//   }
//
//   Future<void> pickIcon() async {
//     final pickedFile = await shopIconPicker.pickImage(
//         source: ImageSource.gallery, imageQuality: 80);
//     if (pickedFile != null) {
//       shopIcon = File(pickedFile.path);
//       log(shopIcon!.path);
//       //setState(() {});
//       isIconUploaded = true;
//     } else {
//       Utilities().showMessage('No image selected');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size mq = MediaQuery.of(context).size;
//     return StreamBuilder(
//         stream: stream,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             log('Length = ${snapshot.data!.docs.length}');
//             print('\nData = ${Auth.auth.currentUser!.uid}');
//             return GestureDetector(
//               onTap: () => FocusScope.of(context).unfocus(),
//               child: Scaffold(
//                 body: snapshot.data!.docs.length != 0
//                     ? ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data?.docs.length,
//                     itemBuilder: (context, index) {
//                       log('${snapshot.data!.docs.length}');
//                       if (snapshot.data?.docs[index]['type'] ==
//                           'Shop Manager') {
//                         name = snapshot.data!.docs[index]['name'];
//                         email = snapshot.data!.docs[index]['email'];
//                         return FutureBuilder(
//                           future: getType(),
//                           builder: (context, snapshot) {
//                             print("TOKS ${tok.toString()}");
//                             Auth.shopManagerRef
//                                 .doc(Auth.auth.currentUser!.uid)
//                                 .update({
//                               'token': tok,
//                             });
//                             return FutureBuilder(
//                                 future: checkSubcollectionExistence(),
//                                 builder: (context, sp) {
//                                   if (!sp.hasData && exists == 0) {
//                                     return Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         children: [
//                                           Container(
//                                             margin: EdgeInsets.only(
//                                                 top: mq.height * 0.12),
//                                             child: Image.network(
//                                                 "https://www.sunvoyage.com.ua/wp-content/uploads/2020/02/%D0%92%D0%9D%D0%98%D0%9C%D0%90%D0%9D%D0%98%D0%95.jpg"),
//                                           ),
//                                           Container(
//                                             margin: EdgeInsets.only(
//                                                 top: mq.height * 0.12),
//                                             child: Text(
//                                               "No Shop Present. Wait Till App Manager Adds Your Shop!!",
//                                               style: TextStyle(
//                                                   color: Colors.redAccent),
//                                             ),
//                                           ),
//                                           SizedBox(height: mq.height * .01,),
//                                           InkWell(
//                                             onTap: () {},
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 //color: Colors.black,
//                                                   border: Border.all(
//                                                       color: Colors.red),
//                                                   borderRadius:
//                                                   BorderRadius.circular(
//                                                       25)),
//                                               child: Center(
//                                                 child: OutlinedButton.icon(
//                                                   style: ElevatedButton.styleFrom(
//                                                       side: BorderSide(
//                                                           color: Colors
//                                                               .transparent),
//                                                       backgroundColor:
//                                                       Colors.transparent),
//                                                   onPressed: () {
//                                                     Auth.logout(context);
//                                                   },
//                                                   label: Text(
//                                                     'Logout',
//                                                     style: TextStyle(
//                                                         color: Colors.red),
//                                                   ),
//                                                   icon: Icon(
//                                                     Icons.logout,
//                                                     color: Colors.red,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                   else {
//                                     return Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   }
//                                 });
//                           },
//                         );
//                       } else {
//                         log('Type not matched ${Auth.auth.currentUser!.uid}');
//                         return Center(child: ShowError('Type not matched'));
//                       }
//                     })
//                     : ShowError('No user found !!'),
//               ),
//             );
//           } else if (snapshot.hasError ||
//               snapshot.data == null ||
//               !snapshot.hasData) {
//             log('Data not found ${Auth.auth.currentUser!.uid}');
//             return Scaffold(
//                 body: Center(child: ShowError('Data not found !!')));
//           }
//           return Scaffold(body: Center(child: CircularProgressIndicator()));
//         });
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/constant/widget/roundButton.dart';
import 'package:mall/constant/widget/show_error.dart';
import 'package:mall/screens/shop_manager/parlor/parlor_display.dart';
import 'package:mall/screens/shop_manager/restaurant/restaurant_display.dart';
import 'package:mall/screens/shop_manager/shop_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/firebase_api.dart';
import '../../constant/utils/utilities.dart';
import '../../controller/auth.dart';
import 'add_product.dart';

class ShopManagerHome extends StatefulWidget {
  const ShopManagerHome({super.key});

  @override
  State<ShopManagerHome> createState() => _ShopManagerHomeState();
}

class _ShopManagerHomeState extends State<ShopManagerHome> {
  final spinkit = SpinKitDancingSquare(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.purple,
        ),
      );
    },
  );
  String? tok;
  var exists;

  Future<String> Found() async {
    final token = await FirebaseApi.initNotifications();
    print("TOKSSSM ${token}");
    return token.toString();
  }

  final shopNameController = TextEditingController();
  final shopManagerNameController = TextEditingController();
  final idController = TextEditingController();
  bool isIconUploaded = false;
  final _formKey = GlobalKey<FormState>();
  File? shopIcon;
  final shopIconPicker = ImagePicker();

  Future<void> getType() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('type', 'Shop Manager');
    await pref.setString('name', name);
    await pref.setString('email', email);
    tok = await Found();
    print("GDFASF${tok}");
  }

  Future<void> checkSubcollectionExistence() async {
    String check = "";
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document =
    mainCollection.doc(Auth.auth.currentUser!.uid);
    final CollectionReference subCollection = document.collection('shop');
    final CollectionReference subCollection2 = document.collection('parlor');
    final CollectionReference subCollection3 =
    document.collection('restaurant');
    try {
      final QuerySnapshot querySnapshot = await subCollection.get();
      final QuerySnapshot querySnapshot2 = await subCollection2.get();
      final QuerySnapshot querySnapshot3 = await subCollection3.get();

      if (querySnapshot.docs.isNotEmpty ||
          querySnapshot2.docs.isNotEmpty ||
          querySnapshot3.docs.isNotEmpty) {
        exists = 1;
        if (querySnapshot.docs.isNotEmpty) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ShopDisplay()));
        } else if (querySnapshot2.docs.isNotEmpty) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ParlorDisplay()));
        } else if (querySnapshot3.docs.isNotEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantDisplay(),
              ));
        }

        print('Subcollection exists');
      } else {
        exists = 0;
        print('Subcollection does not exist');
      }
    } catch (e) {
      print('Error checking subcollection existence: $e');
    }
  }

  late String name, email;
  Stream<QuerySnapshot>? stream;
  List id = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.shopManagerRef
        .where('uid', isEqualTo: Auth.auth.currentUser!.uid)
        .snapshots();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _navigateToAnotherScreen() {
    // Perform navigation logic here (e.g., using Navigator).
    if (exists == 1) {
      print('saaaad');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ShopDisplay()));
    }
  }

  Future<void> pickIcon() async {
    final pickedFile = await shopIconPicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      shopIcon = File(pickedFile.path);
      log(shopIcon!.path);
      //setState(() {});
      isIconUploaded = true;
    } else {
      Utilities().showMessage('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log('Length = ${snapshot.data!.docs.length}');
            print('\nData = ${Auth.auth.currentUser!.uid}');
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: snapshot.data!.docs.length != 0
                    ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      log('${snapshot.data!.docs.length}');
                      if (snapshot.data?.docs[index]['type'] ==
                          'Shop Manager') {
                        name = snapshot.data!.docs[index]['name'];
                        email = snapshot.data!.docs[index]['email'];
                        return FutureBuilder(
                          future: getType(),
                          builder: (context, snapshot) {
                            print("TOKS ${tok.toString()}");
                            Auth.shopManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .update({
                              'token': tok,
                            });
                            return FutureBuilder(
                                future: checkSubcollectionExistence(),
                                builder: (context, sp) {
                                  if (!sp.hasData && exists == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: mq.height * 0.12),
                                            child: Image.network(
                                                "https://www.sunvoyage.com.ua/wp-content/uploads/2020/02/%D0%92%D0%9D%D0%98%D0%9C%D0%90%D0%9D%D0%98%D0%95.jpg"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: mq.height * 0.12),
                                            child: Text(
                                              "No Shop Present. Wait Till App Manager Adds Your Shop!!",
                                              style: TextStyle(
                                                  color: Colors.redAccent),
                                            ),
                                          ),
                                          SizedBox(
                                            height: mq.height * .01,
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                //color: Colors.black,
                                                  border: Border.all(
                                                      color: Colors.red),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      25)),
                                              child: Center(
                                                child: OutlinedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                      backgroundColor:
                                                      Colors
                                                          .transparent),
                                                  onPressed: () {
                                                    Auth.logout(context);
                                                  },
                                                  label: Text(
                                                    'Logout',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  icon: Icon(
                                                    Icons.logout,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: spinkit,
                                    );
                                  }
                                });
                          },
                        );
                      } else {
                        log('Type not matched ${Auth.auth.currentUser!.uid}');
                        return Center(child: ShowError('Type not matched'));
                      }
                    })
                    : ShowError('No user found !!'),
              ),
            );
          } else if (snapshot.hasError ||
              snapshot.data == null ||
              !snapshot.hasData) {
            log('Data not found ${Auth.auth.currentUser!.uid}');
            return Scaffold(
                body: Center(child: ShowError('Data not found !!')));
          }
          return Scaffold(body: Center(child: spinkit));
        });
  }
}