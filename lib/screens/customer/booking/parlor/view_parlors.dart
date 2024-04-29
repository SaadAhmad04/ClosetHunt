// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mall/controller/auth.dart';
// import 'package:mall/screens/customer/booking/my_bookings.dart';
// import 'package:mall/screens/customer/booking/parlor/view_services.dart';
//
// class ViewParlors extends StatefulWidget {
//   const ViewParlors({Key? key});
//
//   @override
//   State<ViewParlors> createState() => _ViewParlorsState();
// }
//
// class _ViewParlorsState extends State<ViewParlors> {
//   Future<bool> checkSubcollectionExistence(String shopManagerId) async {
//     final CollectionReference mainCollection = Auth.shopManagerRef;
//     final DocumentReference document = mainCollection.doc(shopManagerId);
//     final CollectionReference subCollection = document.collection('parlor');
//
//     try {
//       final QuerySnapshot querySnapshot = await subCollection.get();
//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       print('Error checking subcollection existence: $e');
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final spinkit = SpinKitRotatingCircle(
//       itemBuilder: (BuildContext context, int index) {
//         return DecoratedBox(
//           decoration: BoxDecoration(
//             color: Color(0xff974c7c),
//           ),
//         );
//       },
//     );
//     Size mq = MediaQuery.of(context).size;
//     return StreamBuilder(
//         stream: Auth.shopManagerRef.snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Scaffold(
//               extendBodyBehindAppBar: true,
//               appBar: AppBar(
//                 leading: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: Color(0xff974c7c),
//                   ),
//                 ),
//                 backgroundColor: Colors.transparent,
//                 elevation: 0.0,
//                 title: ShaderMask(
//                     shaderCallback: (Rect bounds) {
//                       return LinearGradient(colors: [Colors.pink, Colors.black])
//                           .createShader(bounds);
//                     },
//                     child: Text(
//                       'All Parlors',
//                       style: TextStyle(
//                         fontSize: 22.0,
//                         color: Colors.white,
//                       ),
//                     )),
//                 centerTitle: true,
//                 // actions: [
//                 //   Padding(
//                 //     padding: const EdgeInsets.all(8.0),
//                 //     child: PopupMenuButton(
//                 //       icon: Icon(
//                 //         Icons.more_vert,
//                 //         color: Colors.blueGrey,
//                 //       ),
//                 //       itemBuilder: (context) => [
//                 //         PopupMenuItem(
//                 //           child: ListTile(
//                 //             title: Text('My Bookings'),
//                 //             onTap: () {
//                 //               Navigator.pop(context);
//                 //               Navigator.push(
//                 //                 context,
//                 //                 MaterialPageRoute(
//                 //                   builder: (context) => ParlorBookings(),
//                 //                 ),
//                 //               );
//                 //             },
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   )
//                 // ],
//               ),
//               body: Stack(
//                 children: [
//                   Container(
//                     height: mq.height,
//                     child: Image.network(
//                       "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Container(
//                     height: mq.height,
//                     child: ListView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: snapshot.data?.docs.length,
//                       itemBuilder: (context, index) {
//                         String shopManagerId =
//                         snapshot.data?.docs[index]['uid'];
//                         return FutureBuilder(
//                           future: checkSubcollectionExistence(shopManagerId),
//                           builder: (context, snap) {
//                             if (snap.connectionState == ConnectionState.done) {
//                               bool subcollectionExists = snap.data as bool;
//                               print(subcollectionExists);
//                               if (subcollectionExists) {
//                                 return StreamBuilder(
//                                   stream: Auth.shopManagerRef
//                                       .doc(shopManagerId)
//                                       .collection('parlor')
//                                       .doc(shopManagerId)
//                                       .snapshots(),
//                                   builder: (context,
//                                       AsyncSnapshot<DocumentSnapshot> sp) {
//                                     if (sp.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return Center(
//                                         child: CircularProgressIndicator(),
//                                       );
//                                     } else if (sp.data != null &&
//                                         sp.data!.exists &&
//                                         sp.hasData) {
//                                       String name = sp.data?['shopName'];
//                                       String shopIcon = sp.data?['shopIcon'];
//                                       print('${name}-----------------');
//                                       return Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Card(
//                                           elevation: 10,
//                                           shadowColor: Color(0xff974c7c),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                               BorderRadius.circular(10)),
//                                           child: ListTile(
//                                             tileColor: Colors.white,
//                                             visualDensity:
//                                             VisualDensity(vertical: 4),
//                                             title: Align(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: Text(name)),
//                                             leading: Image.network(
//                                               shopIcon,
//                                               height: mq.height / 4,
//                                               width: mq.width / 4,
//                                             ),
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ViewServices(
//                                                         shopId: shopManagerId,
//                                                         shopName: name,
//                                                         shopIcon: shopIcon,
//                                                       ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       );
//                                     } else if (!sp.data!.exists ||
//                                         sp.hasError ||
//                                         sp.data == null ||
//                                         !sp.hasData) {
//                                       return SizedBox();
//                                     } else {
//                                       print('saaaaaaaaaaaaad');
//                                       return Text('No shopkeeper');
//                                     }
//                                   },
//                                 );
//                               } else {
//                                 return SizedBox();
//                               }
//                             } else {
//                               return Center(
//                                 child: spinkit,
//                               );
//                             }
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         "Whoever says money can't buy happiness \n has not found the right beauty salon!",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Colors.pinkAccent,
//               ),
//             );
//           }
//         });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mall/controller/auth.dart';
import 'package:mall/screens/customer/booking/my_bookings.dart';
import 'package:mall/screens/customer/booking/parlor/view_services.dart';

class ViewParlors extends StatefulWidget {
  const ViewParlors({Key? key});

  @override
  State<ViewParlors> createState() => _ViewParlorsState();
}

class _ViewParlorsState extends State<ViewParlors> {
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
    final spinkit = SpinKitRotatingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xff974c7c),
          ),
        );
      },
    );
    Size mq = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: Auth.shopManagerRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff974c7c),
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                title: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(colors: [Colors.pink, Colors.black])
                          .createShader(bounds);
                    },
                    child: Text(
                      'All Parlors',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    )),
                centerTitle: true,

              ),
              body: Stack(
                children: [
                  Container(
                    height: mq.height,
                    child: Image.network(
                      "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: mq.height,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        String shopManagerId =
                        snapshot.data?.docs[index]['uid'];
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
                                          elevation: 10,
                                          shadowColor: Color(0xff974c7c),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: ListTile(
                                            tileColor: Colors.white,
                                            visualDensity:
                                            VisualDensity(vertical: 4),
                                            title: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(name)),
                                            leading: Image.network(
                                              shopIcon,
                                              height: mq.height / 4,
                                              width: mq.width / 4,
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewServices(
                                                        shopId: shopManagerId,
                                                        shopName: name,
                                                        shopIcon: shopIcon,
                                                      ),
                                                ),
                                              );
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
                                child: spinkit,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Whoever says money can't buy happiness \n has not found the right beauty salon!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            );
          }
        });
  }
}