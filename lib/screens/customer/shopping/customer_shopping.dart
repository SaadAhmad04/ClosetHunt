// import 'dart:async';
//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mall/screens/customer/shopping/customer_product_collection.dart';
//
// import '../../../controller/auth.dart';
//
// class CustomerShopping extends StatefulWidget {
//   const CustomerShopping({super.key});
//
//   @override
//   State<CustomerShopping> createState() => _CustomerShoppingState();
// }
//
// class _CustomerShoppingState extends State<CustomerShopping> {
//   late PageController _pageController;
//
//   //Size mq = MediaQuery.of(context).size;
//   final searchController = TextEditingController();
//   List<Widget> carouselItems = [
//     Image.asset(
//       'images/ck.jpg',
//       fit: BoxFit.cover,
//     ),
//     Image.asset(
//       'images/bata.png',
//       fit: BoxFit.cover,
//     ),
//     Image.asset('images/sugar.jpg', fit: BoxFit.cover),
//     Image.asset(
//       'images/watchicon.jpg',
//       fit: BoxFit.cover,
//     ),
//     Image.asset(
//       'images/lenskart.webp',
//       fit: BoxFit.cover,
//     ),
//     // Add more items as needed
//   ];
//
//   int _currentIndex = 0;
//   final CarouselController _carouselController = CarouselController();
//
//   void _startAutoPlay() {
//     Timer.periodic(Duration(seconds: 3), (timer) {
//       if (_pageController.hasClients) {
//         // Check if the PageController has clients
//         if (_currentIndex < carouselItems.length - 1) {
//           _currentIndex++;
//         } else {
//           _currentIndex = 0;
//         }
//         _pageController.animateToPage(
//           _currentIndex,
//           duration: Duration(milliseconds: 500),
//           // Adjust the duration as needed
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }
//
//   void _stopAutoPlay() {
//     // Cancel the timer when you want to stop auto-play
//     // You can call this method when the user interacts with the carousel
//   }
//
//   late Stream<QuerySnapshot> stream;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     stream = Auth.shopManagerRef.snapshots();
//     _startAutoPlay();
//   }
//
//   @override
//   void dispose() {
//     _stopAutoPlay();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final spinkit = SpinKitPianoWave(
//       itemBuilder: (BuildContext context, int index) {
//         return DecoratedBox(
//           decoration: BoxDecoration(
//             color: index.isEven ? Colors.black : Colors.pink,
//           ),
//         );
//       },
//     );
//     Size mq = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: mq.height * 0.01),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.grey),
//                 child: CarouselSlider(
//                   items: carouselItems,
//                   carouselController: _carouselController,
//                   options: CarouselOptions(
//                     autoPlay: true,
//                     // Disable auto-play in the CarouselOptions
//                     //aspectRatio: 26 / 9,
//                     viewportFraction: 1.0,
//                     height: 255,
//                     enlargeCenterPage: true,
//                     onPageChanged: (index, reason) {
//                       setState(() {
//                         _currentIndex = index;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: mq.height * 0.01,
//             ),
//             Container(
//               child: ShaderMask(
//                 shaderCallback: (Rect bounds) {
//                   return LinearGradient(
//                     colors: [Color(0xff333333), Color(0xff333333)],
//                   ).createShader(bounds);
//                 },
//                 child: Text(
//                   'Discover the Collection here',
//                   style: TextStyle(
//                     fontSize: 26.0,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               //height: 250,
//               child: StreamBuilder(
//                 stream: stream,
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasData) {
//                     // return Text("hello");
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: ClampingScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       itemCount: snapshot.data?.docs.length,
//                       itemBuilder: (context, index) {
//                         String shopManagerId =
//                         snapshot.data?.docs[index]['uid'];
//                         String shopManagerName =
//                         snapshot.data?.docs[index]['name'];
//                         //return Text(shopManagerName.toString());
//                         return FutureBuilder(
//                           future: checkSubcollectionExistence(shopManagerId),
//                           builder: (context, snap) {
//                             if (snap.hasData) {
//                               bool exist = snap.data as bool;
//                               if (exist) {
//                                 return StreamBuilder(
//                                     stream: Auth.shopManagerRef
//                                         .doc(shopManagerId)
//                                         .collection('shop')
//                                         .doc(shopManagerId)
//                                         .snapshots(),
//                                     builder: (context,
//                                         AsyncSnapshot<DocumentSnapshot> snaps) {
//                                       if (snaps.hasData) {
//                                         return FutureBuilder(
//                                             future:
//                                             checkSubcollectionExistence2(
//                                                 shopManagerId),
//                                             builder: (context, shots) {
//                                               if (shots.hasData) {
//                                                 bool existing =
//                                                 shots.data as bool;
//                                                 if (existing) {
//                                                   final shopName = snaps
//                                                       .data!['shopName']
//                                                       .toString();
//                                                   return InkWell(
//                                                     onTap: () {
//                                                       Navigator.of(context)
//                                                           .push(
//                                                           PageRouteBuilder(
//                                                             pageBuilder: (context,
//                                                                 animation,
//                                                                 secondaryAnimation) {
//                                                               return FadeTransition(
//                                                                 opacity: animation,
//                                                                 child:
//                                                                 CustomerProductCollection(
//                                                                   shopManagerId:
//                                                                   shopManagerId,
//                                                                   shopName:
//                                                                   shopName,
//                                                                 ),
//                                                               );
//                                                             },
//                                                             transitionsBuilder:
//                                                                 (context,
//                                                                 animation,
//                                                                 secondaryAnimation,
//                                                                 child) {
//                                                               const begin =
//                                                               Offset(1.0, 0.0);
//                                                               const end =
//                                                                   Offset.zero;
//                                                               const curve = Curves
//                                                                   .easeInOutQuart;
//                                                               var tween = Tween(
//                                                                   begin: begin,
//                                                                   end: end)
//                                                                   .chain(CurveTween(
//                                                                   curve:
//                                                                   curve));
//                                                               var offsetAnimation =
//                                                               animation
//                                                                   .drive(tween);
//
//                                                               // Wrap the child with a Transform widget
//                                                               return Transform(
//                                                                 transform: Matrix4
//                                                                     .translationValues(
//                                                                     offsetAnimation
//                                                                         .value
//                                                                         .dx,
//                                                                     offsetAnimation
//                                                                         .value
//                                                                         .dy,
//                                                                     0.0),
//                                                                 child: child,
//                                                               );
//                                                             },
//                                                           ));
//                                                     },
//                                                     child: Card(
//                                                       // elevation: 10,
//                                                       // shadowColor:
//                                                       //     Color(0x97477C),
//                                                       child: Row(
//                                                         children: [
//                                                           Image.network(
//                                                             snaps.data![
//                                                             'shopIcon'],
//                                                             height: mq.height *
//                                                                 0.14,
//                                                             width: mq.height *
//                                                                 0.12,
//                                                           ),
//                                                           SizedBox(
//                                                             width:
//                                                             mq.width * 0.25,
//                                                           ),
//                                                           Text(snaps
//                                                               .data!['shopName']
//                                                               .toString()),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 } else {
//                                                   return SizedBox();
//                                                 }
//                                               } else {
//                                                 return SizedBox();
//                                               }
//                                             });
//                                       } else {
//                                         return SizedBox();
//                                       }
//                                     });
//                               } else {
//                                 return SizedBox();
//                               }
//                             } else {
//                               return SizedBox();
//                             }
//                           },
//                         );
//                       },
//                     );
//                   } else {
//                     return Center(
//                       child: spinkit,
//                     );
//                   }
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
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
//
// Future<bool> checkSubcollectionExistence2(String shopManagerId) async {
//   final CollectionReference mainCollection = Auth.shopManagerRef;
//   final DocumentReference document = mainCollection.doc(shopManagerId);
//   final CollectionReference subCollection =
//   document.collection('shop').doc(shopManagerId).collection('products');
//
//   try {
//     final QuerySnapshot querySnapshot = await subCollection.get();
//     return querySnapshot.docs.isNotEmpty;
//   } catch (e) {
//     print('Error checking subcollection existence: $e');
//     return false;
//   }
// }

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mall/screens/customer/shopping/customer_product_collection.dart';

import '../../../controller/auth.dart';

class CustomerShopping extends StatefulWidget {
  const CustomerShopping({super.key});

  @override
  State<CustomerShopping> createState() => _CustomerShoppingState();
}

class _CustomerShoppingState extends State<CustomerShopping> {
  late PageController _pageController;

  //Size mq = MediaQuery.of(context).size;
  final searchController = TextEditingController();
  List<Widget> carouselItems = [
    Image.asset(
      'images/ck.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'images/bata.png',
      fit: BoxFit.cover,
    ),
    Image.asset('images/sugar.jpg', fit: BoxFit.cover),
    Image.asset(
      'images/watchicon.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'images/lenskart.webp',
      fit: BoxFit.cover,
    ),
    // Add more items as needed
  ];

  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  void _startAutoPlay() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        // Check if the PageController has clients
        if (_currentIndex < carouselItems.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          // Adjust the duration as needed
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoPlay() {
    // Cancel the timer when you want to stop auto-play
    // You can call this method when the user interacts with the carousel
  }

  late Stream<QuerySnapshot> stream;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    stream = Auth.shopManagerRef.snapshots();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitPianoWave(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Colors.black : Colors.pink,
          ),
        );
      },
    );
    Size mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: mq.height * 0.01),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
                child: CarouselSlider(
                  items: carouselItems,
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                    // Disable auto-play in the CarouselOptions
                    //aspectRatio: 26 / 9,
                    viewportFraction: 1.0,
                    height: 255,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * 0.01,
            ),
            Container(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Color(0xff333333), Color(0xff333333)],
                  ).createShader(bounds);
                },
                child: Text(
                  'Discover the Collection here',
                  style: TextStyle(
                    fontSize: 26.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              //height: 250,
              child: StreamBuilder(
                stream: stream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    // return Text("hello");
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        String shopManagerId =
                        snapshot.data?.docs[index]['uid'];
                        String shopManagerName =
                        snapshot.data?.docs[index]['name'];
                        //return Text(shopManagerName.toString());
                        return FutureBuilder(
                          future: checkSubcollectionExistence(shopManagerId),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              bool exist = snap.data as bool;
                              if (exist) {
                                return StreamBuilder(
                                    stream: Auth.shopManagerRef
                                        .doc(shopManagerId)
                                        .collection('shop')
                                        .doc(shopManagerId)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot> snaps) {
                                      if (snaps.hasData) {
                                        return FutureBuilder(
                                            future:
                                            checkSubcollectionExistence2(
                                                shopManagerId),
                                            builder: (context, shots) {
                                              if (shots.hasData) {
                                                bool existing =
                                                shots.data as bool;
                                                if (existing) {
                                                  final shopName = snaps
                                                      .data!['shopName']
                                                      .toString();
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                          PageRouteBuilder(
                                                            pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) {
                                                              return FadeTransition(
                                                                opacity: animation,
                                                                child:
                                                                CustomerProductCollection(
                                                                  shopManagerId:
                                                                  shopManagerId,
                                                                  shopName:
                                                                  shopName,
                                                                ),
                                                              );
                                                            },
                                                            transitionsBuilder:
                                                                (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                              const begin =
                                                              Offset(1.0, 0.0);
                                                              const end =
                                                                  Offset.zero;
                                                              const curve = Curves
                                                                  .easeInOutQuart;
                                                              var tween = Tween(
                                                                  begin: begin,
                                                                  end: end)
                                                                  .chain(CurveTween(
                                                                  curve:
                                                                  curve));
                                                              var offsetAnimation =
                                                              animation
                                                                  .drive(tween);

                                                              // Wrap the child with a Transform widget
                                                              return Transform(
                                                                transform: Matrix4
                                                                    .translationValues(
                                                                    offsetAnimation
                                                                        .value
                                                                        .dx,
                                                                    offsetAnimation
                                                                        .value
                                                                        .dy,
                                                                    0.0),
                                                                child: child,
                                                              );
                                                            },
                                                          ));
                                                    },
                                                    child: Card(
                                                      // elevation: 10,
                                                      // shadowColor:
                                                      //     Color(0x97477C),
                                                      child: Row(
                                                        children: [
                                                          Image.network(
                                                            snaps.data![
                                                            'shopIcon'],
                                                            height: mq.height *
                                                                0.14,
                                                            width: mq.height *
                                                                0.12,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                            mq.width * 0.25,
                                                          ),
                                                          Text(snaps
                                                              .data!['shopName']
                                                              .toString()),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox();
                                                }
                                              } else {
                                                return SizedBox();
                                              }
                                            });
                                      } else {
                                        return SizedBox();
                                      }
                                    });
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return SizedBox();
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: spinkit,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<bool> checkSubcollectionExistence(String shopManagerId) async {
  final CollectionReference mainCollection = Auth.shopManagerRef;
  final DocumentReference document = mainCollection.doc(shopManagerId);
  final CollectionReference subCollection = document.collection('shop');

  try {
    final QuerySnapshot querySnapshot = await subCollection.get();
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking subcollection existence: $e');
    return false;
  }
}

Future<bool> checkSubcollectionExistence2(String shopManagerId) async {
  final CollectionReference mainCollection = Auth.shopManagerRef;
  final DocumentReference document = mainCollection.doc(shopManagerId);
  final CollectionReference subCollection =
  document.collection('shop').doc(shopManagerId).collection('products');

  try {
    final QuerySnapshot querySnapshot = await subCollection.get();
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking subcollection existence: $e');
    return false;
  }
}