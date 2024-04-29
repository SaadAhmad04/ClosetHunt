// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mall/screens/customer/shopping/cart_bill.dart';
// import 'package:mall/screens/customer/shopping/single_product_bill.dart';
// import '../../../constant/utils/utilities.dart';
// import '../../../controller/auth.dart';
// import 'package:collection/collection.dart';
//
// class ViewCart extends StatefulWidget {
//   const ViewCart({super.key});
//
//   @override
//   State<ViewCart> createState() => _ViewCartState();
// }
//
// class _ViewCartState extends State<ViewCart>
//     with SingleTickerProviderStateMixin {
//   Stream? stream;
//   List<double> perpriceList = [];
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   int animatedIndex = 0;
//   int length = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     Change();
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 1000),
//       vsync: this,
//     );
//
//     _animation = Tween<double>(begin: 10, end: 200).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOutCirc,
//       ),
//     );
//
//     _controller.repeat(reverse: true);
//
//     // Set up a Timer to stop the animation after 10 seconds
//     Timer(Duration(seconds: 2), () {
//       _controller.stop();
//     });
//
//     Timer.periodic(Duration(seconds: 2), (timer) {
//       setState(() {
//         animatedIndex = (animatedIndex + 2) % perpriceList.length - 2;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void Change() {
//     stream = Auth.customerRef
//         .doc(Auth.auth.currentUser!.uid)
//         .collection('carts')
//         .orderBy('added_on', descending: true)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final spinkit = SpinKitRotatingCircle(
//       itemBuilder: (BuildContext context, int index) {
//         return DecoratedBox(
//           decoration: BoxDecoration(
//             color: Colors.pink,
//           ),
//         );
//       },
//     );
//     Size mq = MediaQuery.of(context).size;
//     double total = 0;
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: ShaderMask(
//           shaderCallback: (Rect bounds) {
//             return LinearGradient(colors: [Colors.pink, Colors.black])
//                 .createShader(bounds);
//           },
//           child: Text(
//             'Cart Summary',
//             style: TextStyle(
//               fontSize: 22.0,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//       ),
//       body: SafeArea(
//         child: Stack(children: [
//           Container(
//             height: mq.height,
//             width: mq.width,
//             child: Image.network(
//               "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),
//           StreamBuilder(
//             stream: stream,
//             builder: (BuildContext context, snapshot) {
//               if (snapshot.hasData && snapshot.data!.docs != null) {
//                 length = snapshot.data!.docs.length;
//                 print('llllllllllllllllllllllllllllllllllllll${length}');
//                 log(snapshot.data!.docs.length.toString());
//                 if (snapshot.data!.docs.length > 0) {
//                   return ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       int date = int.tryParse(snapshot
//                                   .data!.docs[index]['added_on']
//                                   ?.toString() ??
//                               '') ??
//                           0;
//
//                       DateTime dateTime =
//                           DateTime.fromMillisecondsSinceEpoch(date);
//
//                       int quantity = snapshot.data!.docs[index]['quantity'];
//                       double price =
//                           double.parse(snapshot.data!.docs[index]['price']);
//                       double perprice = snapshot.data!.docs[index]['perprice'];
//                       if (perpriceList.length == snapshot.data!.docs.length) {
//                         print('hi');
//                       } else {
//                         perpriceList.add(perprice);
//                       }
//                       print('Perprice = ${perprice}');
//                       total += perprice;
//                       print('Total = ${perpriceList.sum}');
//                       print('Perprice list = ${perpriceList}');
//                       bool isAnimated = index == animatedIndex;
//                       SizedBox(
//                         height: 25,
//                       );
//                       return AnimatedBuilder(
//                         animation: _animation,
//                         builder: (context, child) {
//                           return Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => SingleProductBill(
//                                       productId: snapshot.data!.docs[index]
//                                           ['productId'],
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Transform.translate(
//                                 offset: Offset(1, _animation.value - 2),
//                                 child: Card(
//                                   surfaceTintColor: Colors.redAccent,
//                                   color: Colors.white,
//                                   shadowColor: Colors.purple,
//                                   shape: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   elevation: 10,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       ListTile(
//                                         leading: Image.network(snapshot
//                                             .data!.docs[index]['image']),
//                                         title: Text(snapshot
//                                             .data!.docs[index]['name']
//                                             .toString()
//                                             .substring(0, 15)),
//                                         subtitle: Text(
//                                             'Quantity: ${snapshot.data!.docs[index]['quantity']}'),
//                                         trailing: Container(
//                                           height: 30,
//                                           width: 140,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(15)),
//                                             color: Colors.grey[500],
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             children: [
//                                               TextButton(
//                                                 onPressed: () async {
//                                                   if (quantity == 1) {
//                                                     await Auth.customerRef
//                                                         .doc(Auth.auth
//                                                             .currentUser!.uid)
//                                                         .collection('carts')
//                                                         .doc(snapshot.data!
//                                                                 .docs[index]
//                                                             ['productId'])
//                                                         .delete();
//                                                     perpriceList.clear();
//                                                   } else {
//                                                     quantity = quantity - 1;
//                                                     perprice = 0;
//                                                     total = 0;
//                                                     perpriceList.clear();
//                                                     perprice = price * quantity;
//                                                     await Auth.customerRef
//                                                         .doc(Auth.auth
//                                                             .currentUser!.uid)
//                                                         .collection('carts')
//                                                         .doc(snapshot.data!
//                                                                 .docs[index]
//                                                             ['productId'])
//                                                         .update({
//                                                       'quantity': quantity,
//                                                       'perprice': perprice,
//                                                     });
//                                                   }
//                                                   setState(() {
//                                                     Change();
//                                                   });
//                                                 },
//                                                 child: Text(
//                                                   '-',
//                                                   style: TextStyle(
//                                                       color: Colors.white),
//                                                 ),
//                                               ),
//                                               Text('${quantity}',
//                                                   style: TextStyle(
//                                                       color: Colors.white)),
//                                               TextButton(
//                                                 onPressed: () async {
//                                                   quantity += 1;
//                                                   perprice = 0;
//                                                   total = 0;
//                                                   perpriceList.clear();
//                                                   perprice = price * quantity;
//                                                   await Auth.customerRef
//                                                       .doc(Auth.auth
//                                                           .currentUser!.uid)
//                                                       .collection('carts')
//                                                       .doc(snapshot
//                                                               .data!.docs[index]
//                                                           ['productId'])
//                                                       .update(
//                                                     {
//                                                       'quantity': quantity,
//                                                       'perprice': perprice,
//                                                     },
//                                                   );
//                                                   setState(() {
//                                                     Change();
//                                                   });
//                                                 },
//                                                 child: Text(
//                                                   '+',
//                                                   style: TextStyle(
//                                                       color: Colors.white),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(6.0),
//                                         child: Container(
//                                           margin: EdgeInsets.only(
//                                               left: mq.width * 0.20),
//                                           child: Text(
//                                             'Item Price: Rs. ${snapshot.data!.docs[index]['price'].toString()}',
//                                             style: TextStyle(fontSize: 14),
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(6.0),
//                                         child: Container(
//                                           margin: EdgeInsets.only(
//                                               left: mq.width * 0.20),
//                                           child: Text(
//                                             'Total Price: ${snapshot.data!.docs[index]['perprice'].toString()}',
//                                             style: TextStyle(fontSize: 14),
//                                           ),
//                                         ),
//                                       ),
//                                       ListTile(
//                                         title: Text(
//                                           'Added on ${dateTime.day}-${dateTime.month}-${dateTime.year}',
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         trailing: Padding(
//                                           padding: const EdgeInsets.only(
//                                               right: 15.0),
//                                           child: TextButton.icon(
//                                             onPressed: () async {
//                                               total = 0;
//                                               perprice = 0;
//                                               perpriceList.clear();
//                                               print('saaaaad${perpriceList}');
//                                               await Auth.customerRef
//                                                   .doc(Auth
//                                                       .auth.currentUser!.uid)
//                                                   .collection('carts')
//                                                   .doc(snapshot.data!
//                                                       .docs[index]['productId'])
//                                                   .delete()
//                                                   .then((value) {
//                                                 Utilities().showMessage(
//                                                     "Item Removed from the cart");
//                                               });
//                                               setState(() {
//                                                 Change();
//                                               });
//                                             },
//                                             icon: Icon(
//                                               Icons.delete,
//                                               color: Colors.red,
//                                             ),
//                                             label: Text(
//                                               'Delete',
//                                               style:
//                                                   TextStyle(color: Colors.red),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 } else {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         child: Image.network(
//                             "https://media2.giphy.com/media/aWUunfdw42i4S2fDmh/giphy.gif?cid=6c09b952kugcgqby3lmxsh9mmn131yv9dhiif27t088v8ha8&ep=v1_stickers_related&rid=giphy.gif&ct=ts"),
//                       ),
//                       Center(
//                         child: Text(
//                           "No Items in the Cart!",
//                           style: TextStyle(color: Colors.black, fontSize: 16),
//                         ),
//                       ),
//                       Center(
//                         child: Text(
//                           "Don't just dream it, cart it!",
//                           style:
//                               TextStyle(color: Colors.redAccent, fontSize: 26),
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               } else if (snapshot.hasError) {
//                 return Center(child: Text("No products added"));
//               }
//               return Center(child: spinkit);
//             },
//           ),
//           Positioned(
//             top: mq.height * 0.8,
//             child: Container(
//               width: mq.width,
//               height: mq.height,
//               color: Colors.white,
//               child: Stack(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           height: 48,
//                           width: mq.width / 3,
//                           child: length > 0
//                               // ? perpriceList.isNotEmpty
//                               ? Center(
//                                   child: Text(
//                                     'Rs. ${perpriceList.sum.toStringAsFixed(2)}',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 )
//                               : perpriceList.isEmpty
//                                   ? Center(
//                                       child: Text(
//                                         '0.0',
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     )
//                                   : Center(
//                                       child: Text(
//                                         'Loading...',
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                           //                   : Center(
//                           //                   child: Text(
//                           //                     '0.0',
//                           //                     style: TextStyle(
//                           //                         color: Colors.black,
//                           //                         fontWeight: FontWeight.bold),
//                           //                   )
//                           // ),
//                           decoration: BoxDecoration(
//                               color: Color(0xff974C7C),
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: mq.width / 3,
//                           child: MaterialButton(
//                             onPressed: () {
//                               setState(() {});
//                               length > 0
//                                   ? Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => CartBill(
//                                                 grandTotal: perpriceList,
//                                               )))
//                                   : Utilities()
//                                       .showMessage("No Items in the Cart");
//                             },
//                             child: Text('Buy Cart'),
//                           ),
//                           decoration: BoxDecoration(
//                               color: Color(0xff974C7C),
//                               borderRadius: BorderRadius.circular(10)),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mall/screens/customer/shopping/cart_bill.dart';
import 'package:mall/screens/customer/shopping/single_product_bill.dart';
import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import 'package:collection/collection.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key});

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart>
    with SingleTickerProviderStateMixin {
  Stream? stream;
  List<double> perpriceList = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  int animatedIndex = 0;
  int length = 0;

  @override
  void initState() {
    super.initState();
    Change();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 10, end: 200).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCirc,
      ),
    );

    _controller.repeat(reverse: true);

    // Set up a Timer to stop the animation after 10 seconds
    Timer(Duration(seconds: 2), () {
      _controller.stop();
    });

    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        animatedIndex = (animatedIndex + 2) % perpriceList.length - 2;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void Change() {
    stream = Auth.customerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('carts')
        .orderBy('added_on', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitRotatingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.pink,
          ),
        );
      },
    );
    Size mq = MediaQuery.of(context).size;
    double total = 0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(colors: [Colors.pink, Colors.black])
                .createShader(bounds);
          },
          child: Text(
            'Cart Summary',
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: mq.height,
            width: mq.width,
            child: Image.network(
              "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
              fit: BoxFit.cover,
            ),
          ),
          StreamBuilder(
            stream: stream,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs != null) {
                length = snapshot.data!.docs.length;
                log(snapshot.data!.docs.length.toString());
                if (snapshot.data!.docs.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      int date = int.tryParse(snapshot
                          .data!.docs[index]['added_on']
                          ?.toString() ??
                          '') ??
                          0;

                      DateTime dateTime =
                      DateTime.fromMillisecondsSinceEpoch(date);

                      int quantity = snapshot.data!.docs[index]['quantity'];
                      double price =
                      double.parse(snapshot.data!.docs[index]['price']);
                      double perprice = snapshot.data!.docs[index]['perprice'];
                      if (perpriceList.length == snapshot.data!.docs.length) {
                        print('hi');
                      } else {
                        perpriceList.add(perprice);
                      }
                      print('Perprice = ${perprice}');
                      total += perprice;
                      print('Total = ${perpriceList.sum}');
                      print('Perprice list = ${perpriceList}');
                      bool isAnimated = index == animatedIndex;
                      SizedBox(
                        height: 25,
                      );
                      return AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleProductBill(
                                      productId: snapshot.data!.docs[index]
                                      ['productId'],
                                    ),
                                  ),
                                );
                              },
                              child: Transform.translate(
                                offset: Offset(1, _animation.value - 2),
                                child: Card(
                                  surfaceTintColor: Colors.redAccent,
                                  color: Colors.white,
                                  shadowColor: Colors.purple,
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Image.network(snapshot
                                            .data!.docs[index]['image']),
                                        title: Text(snapshot
                                            .data!.docs[index]['name']
                                            .toString()
                                            .substring(0, 15)),
                                        subtitle: Text(
                                            'Quantity: ${snapshot.data!.docs[index]['quantity']}'),
                                        trailing: Container(
                                          height: 30,
                                          width: mq.width * .4,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            color: Colors.grey[500],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  if (quantity == 1) {
                                                    await Auth.customerRef
                                                        .doc(Auth.auth
                                                        .currentUser!.uid)
                                                        .collection('carts')
                                                        .doc(snapshot.data!
                                                        .docs[index]
                                                    ['productId'])
                                                        .delete();
                                                    perpriceList.clear();
                                                  } else {
                                                    quantity = quantity - 1;
                                                    perprice = 0;
                                                    total = 0;
                                                    perpriceList.clear();
                                                    perprice = price * quantity;
                                                    await Auth.customerRef
                                                        .doc(Auth.auth
                                                        .currentUser!.uid)
                                                        .collection('carts')
                                                        .doc(snapshot.data!
                                                        .docs[index]
                                                    ['productId'])
                                                        .update({
                                                      'quantity': quantity,
                                                      'perprice': perprice,
                                                    });
                                                  }
                                                  setState(() {
                                                    Change();
                                                  });
                                                },
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Text('${quantity}',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              TextButton(
                                                onPressed: () async {
                                                  quantity += 1;
                                                  perprice = 0;
                                                  total = 0;
                                                  perpriceList.clear();
                                                  perprice = price * quantity;
                                                  await Auth.customerRef
                                                      .doc(Auth.auth
                                                      .currentUser!.uid)
                                                      .collection('carts')
                                                      .doc(snapshot
                                                      .data!.docs[index]
                                                  ['productId'])
                                                      .update(
                                                    {
                                                      'quantity': quantity,
                                                      'perprice': perprice,
                                                    },
                                                  );
                                                  setState(() {
                                                    Change();
                                                  });
                                                },
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: mq.width * 0.20),
                                          child: Text(
                                            'Item Price: Rs. ${snapshot.data!.docs[index]['price'].toString()}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: mq.width * 0.20),
                                          child: Text(
                                            'Total Price: ${snapshot.data!.docs[index]['perprice'].toString()}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Added on ${dateTime.day}-${dateTime.month}-${dateTime.year}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: TextButton.icon(
                                            onPressed: () async {
                                              total = 0;
                                              perprice = 0;
                                              perpriceList.clear();
                                              await Auth.customerRef
                                                  .doc(Auth
                                                  .auth.currentUser!.uid)
                                                  .collection('carts')
                                                  .doc(snapshot.data!
                                                  .docs[index]['productId'])
                                                  .delete()
                                                  .then((value) {
                                                Utilities().showMessage(
                                                    "Item Removed from the cart");
                                              });
                                              setState(() {
                                                Change();
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            label: Text(
                                              'Delete',
                                              style:
                                              TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.network(
                            "https://media2.giphy.com/media/aWUunfdw42i4S2fDmh/giphy.gif?cid=6c09b952kugcgqby3lmxsh9mmn131yv9dhiif27t088v8ha8&ep=v1_stickers_related&rid=giphy.gif&ct=ts"),
                      ),
                      Center(
                        child: Text(
                          "No Items in the Cart!",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Don't just dream it, cart it!",
                          style:
                          TextStyle(color: Colors.redAccent, fontSize: 26),
                        ),
                      ),
                    ],
                  );
                }
              } else if (snapshot.hasError) {
                return Center(child: Text("No products added"));
              }
              return Center(child: spinkit);
            },
          ),
          Positioned(
            top: mq.height * 0.8,
            child: Container(
              width: mq.width,
              height: mq.height,
              color: Colors.white,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 48,
                          width: mq.width / 3,
                          child: length > 0
                          // ? perpriceList.isNotEmpty
                              ? Center(
                            child: Text(
                              'Rs. ${perpriceList.sum.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                              : perpriceList.isEmpty
                              ? Center(
                            child: Text(
                              '0.0',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                              : Center(
                            child: Text(
                              'Loading...',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          //                   : Center(
                          //                   child: Text(
                          //                     '0.0',
                          //                     style: TextStyle(
                          //                         color: Colors.black,
                          //                         fontWeight: FontWeight.bold),
                          //                   )
                          // ),
                          decoration: BoxDecoration(
                              color: Color(0xff974C7C),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: mq.width / 3,
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {});
                              length > 0
                                  ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CartBill(
                                        grandTotal: perpriceList,
                                      )))
                                  : Utilities()
                                  .showMessage("No Items in the Cart");
                            },
                            child: Text('Buy Cart'),
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xff974C7C),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
