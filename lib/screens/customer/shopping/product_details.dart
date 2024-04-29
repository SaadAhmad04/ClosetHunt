// import 'dart:developer';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mall/screens/customer/shopping/single_product_bill.dart';
// import 'package:mall/screens/customer/shopping/view_cart.dart';
// import 'package:flutter/material.dart' hide Badge;
//
// import '../../../constant/utils/utilities.dart';
// import '../../../controller/auth.dart';
// import '../../../main.dart';
// import 'customer_product_collection.dart';
//
// class ProductDetails extends StatefulWidget {
//   final Details info;
//   final List? products;
//
//   ProductDetails({super.key, required this.info, this.products});
//
//   @override
//   State<ProductDetails> createState() => _ProductDetailsState();
// }
//
// class _ProductDetailsState extends State<ProductDetails> {
//   Color cartColor = Colors.grey;
//   bool addToCart = false;
//   int count = 0;
//   int currentIndex = 0;
//   List filteredProducts = [];
//
//   late Map<String, String> minDelivery;
//
//   void minimumDelivery() async {
//     await Auth.customerRef
//         .doc(Auth.auth.currentUser!.uid)
//         .collection('carts')
//         .get()
//         .then((QuerySnapshot qs) {
//       qs.docs.forEach((doc) {
//         if (doc['productId'] == widget.info.productId) {
//           cartColor = Color(0xFFEF6C00);
//           setState(() {});
//         }
//         String name = doc["name"];
//
//         String price = doc["price"];
//         minDelivery = {"amount": name, "charge": price};
//         log(widget.info.productId);
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     minimumDelivery();
//   }
//
//   int _counter = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     for (int i = 0; i < widget.products!.length; i++) {
//       if (widget.products![i]['usItemId'] != widget.info.productId) {
//         filteredProducts.add(widget.products![i]);
//       }
//     }
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: Stack(children: [
//         Container(
//           height: mq.height,
//           width: mq.width * 2,
//           child: Image.network(
//             "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//             fit: BoxFit.cover,
//           ),
//         ),
//         SingleChildScrollView(
//           child: Column(
//             children: [
//               Align(
//                   alignment: Alignment.topCenter,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(mq.width * .12),
//                         bottomRight: Radius.circular(mq.width * .12)),
//                     child: Image.network(
//                       widget.info.image,
//                       fit: BoxFit.cover,
//                       width: mq.width,
//                       height: mq.height / 1.8,
//                     ),
//                   )),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                       top: mq.height * .05,
//                       // bottom: mq.height * .035,
//                       left: mq.width * .03,
//                       right: mq.width * .03),
//                   child: Container(
//                     height: mq.height * .28,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             widget.info.name,
//                             style: TextStyle(
//                                 fontSize: 18, fontFamily: 'Garamond1'),
//                           ),
//                           SizedBox(
//                             height: mq.height * .025,
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               int c = 0;
//                               List<Map<String, dynamic>> documentsData = [];
//                               await Auth.customerRef
//                                   .doc(Auth.auth.currentUser!.uid)
//                                   .collection('carts')
//                                   .get()
//                                   .then(
//                                 (QuerySnapshot querySnapshot) {
//                                   querySnapshot.docs.forEach(
//                                       (QueryDocumentSnapshot documentSnapshot) {
//                                     documentsData.add(documentSnapshot.data()
//                                         as Map<String, dynamic>);
//                                   });
//                                 },
//                               );
//                               for (int i = 0; i < documentsData.length; i++) {
//                                 print(
//                                     '=============${documentsData[i]['productId']}');
//                                 if (documentsData[i]['productId'] ==
//                                     widget.info.productId) {
//                                   c++;
//                                   Utilities()
//                                       .showMessage('Already added to cart');
//                                   break;
//                                 }
//                               }
//                               if (c == 0) {
//                                 minimumDelivery();
//                                 setState(() {
//                                   addToCart = true;
//                                   Auth.customerRef
//                                       .doc(Auth.auth.currentUser!.uid)
//                                       .collection('carts')
//                                       .doc(widget.info.productId)
//                                       .set({
//                                     'name': widget.info.name,
//                                     'price': widget.info.price.substring(4),
//                                     'image': widget.info.image,
//                                     'index': widget.info.index,
//                                     'perprice': double.parse(
//                                         widget.info.price.substring(4)),
//                                     'quantity': 1,
//                                     'deliveryTime': widget.info.deliveryTime,
//                                     'sellerId': widget.info.sellerId,
//                                     'orderLimit': widget.info.orderLimit,
//                                     'productId': widget.info.productId,
//                                     'added_on': DateTime.now()
//                                         .millisecondsSinceEpoch
//                                         .toString()
//                                   }).then((value) {
//                                     Utilities().showMessage('Added to cart');
//                                   });
//                                   log(widget.info.name);
//                                   log(widget.info.price);
//                                   log(addToCart.toString());
//                                   count = 1;
//                                 });
//                               }
//                             },
//                             child: Container(
//                               height: mq.height * .08,
//                               width: mq.width * .6,
//                               decoration: BoxDecoration(
//                                 color: Color(0xff8D8E36),
//                                 borderRadius: BorderRadius.circular(28),
//                               ),
//                               child: Center(
//                                 child: Text('Add to Cart',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold)),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: mq.height * .035,
//                           ),
//                           Text(
//                             'Hurry upp!! Only ${widget.info.orderLimit} left',
//                             style: TextStyle(
//                                 color: Colors.red.shade400,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(4),
//                 height: mq.height * .42,
//                 width: mq.width,
//                 child: GridView.builder(
//                   scrollDirection: Axis.horizontal,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 1,
//                   ),
//                   itemCount: filteredProducts.length,
//                   itemBuilder: (context, index) {
//                     return SizedBox(
//                       height: 300,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Column(
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Details details = detailsFromJson(filteredProducts[index]);
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ProductDetails(
//                                         info: details , products: widget.products,),
//                                   ),
//                                 );
//                               },
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20.0),
//                                 ),
//                                 elevation: 10,
//                                 child: Container(
//                                   width: mq.width,
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(20),
//                                     child: Image.network(
//                                       filteredProducts[index]['thumbnailUrl'],
//                                       height: 220,
//                                       width: 70,
//                                       fit: BoxFit.fill,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${filteredProducts[index]['name'].toString().substring(0, 12)}...',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             Container(
//                               child: Text(
//                                 '${filteredProducts[index]['price']}',
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//         Align(
//             alignment: Alignment.topLeft,
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                   vertical: mq.height * .08, horizontal: mq.width * .04),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   height: mq.height * .07,
//                   width: mq.width * .13,
//                   decoration: BoxDecoration(
//                       color: Colors.grey.shade500,
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Icon(
//                     Icons.chevron_left,
//                     color: Colors.white,
//                     size: 32,
//                   ),
//                 ),
//               ),
//             )),
//         Align(
//             alignment: Alignment.topRight,
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                   vertical: mq.height * .08, horizontal: mq.width * .04),
//               child: InkWell(
//                 onTap: () {
//                   addToCart = false;
//                   setState(() {});
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ViewCart(),
//                       ));
//                 },
//                 child: Container(
//                   height: mq.height * .07,
//                   width: mq.width * .13,
//                   decoration: BoxDecoration(
//                       color: Color(0xff8D8E36),
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Stack(
//                     children: [
//                       Align(
//                         alignment: Alignment.center,
//                         child: Icon(
//                           Icons.shopping_cart_outlined,
//                           color: Colors.white,
//                         ),
//                       ),
//                       addToCart
//                           ? Align(
//                               alignment: Alignment.topRight,
//                               child: Icon(
//                                 Icons.fiber_manual_record,
//                                 size: 20,
//                                 color: Colors.red.shade800,
//                               ),
//                             )
//                           : SizedBox(),
//                     ],
//                   ),
//                 ),
//               ),
//             )),
//       ]),
//       bottomNavigationBar: showMyBar(context),
//     );
//   }
//
//   Widget showMyBar(BuildContext context) {
//     return Container(
//       height: mq.height * .1,
//       width: mq.width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               children: [
//                 Text(
//                   'Price:',
//                   style: TextStyle(color: Colors.grey, fontSize: 20),
//                 ),
//                 Text(
//                   widget.info.price,
//                   style: TextStyle(color: Colors.black, fontSize: 25),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 40,
//             ),
//             InkWell(
//               onTap: () async {
//                 int c = 0;
//                 List<Map<String, dynamic>> documentsData = [];
//                 await Auth.customerRef
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('carts')
//                     .get()
//                     .then(
//                   (QuerySnapshot querySnapshot) {
//                     querySnapshot.docs
//                         .forEach((QueryDocumentSnapshot documentSnapshot) {
//                       documentsData
//                           .add(documentSnapshot.data() as Map<String, dynamic>);
//                     });
//                   },
//                 );
//                 for (int i = 0; i < documentsData.length; i++) {
//                   print('=============${documentsData[i]['productId']}');
//                   if (documentsData[i]['productId'] == widget.info.productId) {
//                     c++;
//                     Navigator.pop(context);
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => SingleProductBill(
//                                 productId: widget.info.productId)));
//                   }
//                 }
//                 if (c == 0) {
//                   showAddToCartDialog(context);
//                 }
//               },
//               child: Container(
//                 height: mq.height * .07,
//                 width: mq.width * .35,
//                 decoration: BoxDecoration(
//                   color: Color(0xff8D8E36),
//                   borderRadius: const BorderRadius.all(
//                     Radius.circular(30),
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Buy Now',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> showAddToCartDialog(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                   height: mq.height / 5,
//                   width: mq.width,
//                   child: Column(children: [
//                     Text(
//                         "You can't buy a product without adding it into cart. Do you want to add this product in your cart ?"),
//                     SizedBox(
//                       height: mq.height * .05,
//                     ),
//                     Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                                 height: mq.height * .07,
//                                 width: mq.width * .25,
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border.all(
//                                         color: Colors.yellow.shade800),
//                                     borderRadius: BorderRadius.circular(25)),
//                                 child: Center(
//                                     child: Text(
//                                   'No',
//                                   style:
//                                       TextStyle(color: Colors.yellow.shade800),
//                                 ))),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               minimumDelivery();
//                               setState(() async {
//                                 addToCart = true;
//                                 await Auth.customerRef
//                                     .doc(Auth.auth.currentUser!.uid)
//                                     .collection('carts')
//                                     .doc(widget.info.productId)
//                                     .set({
//                                   'name': widget.info.name,
//                                   'price': widget.info.price.substring(4),
//                                   'image': widget.info.image,
//                                   'index': widget.info.index,
//                                   'perprice': double.parse(
//                                       widget.info.price.substring(4)),
//                                   'quantity': 1,
//                                   'deliveryTime': widget.info.deliveryTime,
//                                   'sellerId': widget.info.sellerId,
//                                   'orderLimit': widget.info.orderLimit,
//                                   'productId': widget.info.productId,
//                                   'added_on': DateTime.now()
//                                       .millisecondsSinceEpoch
//                                       .toString()
//                                 }).then((value) {
//                                   Navigator.pop(context);
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               SingleProductBill(
//                                                   productId:
//                                                       widget.info.productId)));
//                                 });
//                                 log(addToCart.toString());
//                                 count = 1;
//                               });
//                             },
//                             child: Container(
//                                 height: mq.height * .07,
//                                 width: mq.width * .3,
//                                 decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     borderRadius: BorderRadius.circular(25)),
//                                 child: Center(
//                                     child: Text(
//                                   'Add to cart',
//                                   style: TextStyle(color: Colors.white),
//                                 ))),
//                           )
//                         ]),
//                   ]));
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mall/screens/customer/shopping/single_product_bill.dart';
import 'package:mall/screens/customer/shopping/view_cart.dart';
import 'package:flutter/material.dart' hide Badge;

import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';
import 'customer_product_collection.dart';

class ProductDetails extends StatefulWidget {
  final Details info;
  final List? products;

  ProductDetails({super.key, required this.info, this.products});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Color cartColor = Colors.grey;
  bool addToCart = false;
  int count = 0;
  int currentIndex = 0;
  List filteredProducts = [];

  late Map<String, String> minDelivery;

  void minimumDelivery() async {
    await Auth.customerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('carts')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        if (doc['productId'] == widget.info.productId) {
          cartColor = Color(0xFFEF6C00);
          setState(() {});
        }
        String name = doc["name"];

        String price = doc["price"];
        minDelivery = {"amount": name, "charge": price};
        log(widget.info.productId);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    minimumDelivery();
  }

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.products!.length; i++) {
      if (widget.products![i]['usItemId'] != widget.info.productId) {
        filteredProducts.add(widget.products![i]);
      }
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(children: [
        Container(
          height: mq.height,
          width: mq.width * 2,
          child: Image.network(
            "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
            fit: BoxFit.cover,
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(mq.width * .12),
                        bottomRight: Radius.circular(mq.width * .12)),
                    child: Image.network(
                      widget.info.image,
                      fit: BoxFit.cover,
                      width: mq.width,
                      height: mq.height / 1.8,
                    ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: mq.height * .05,
                      // bottom: mq.height * .035,
                      left: mq.width * .03,
                      right: mq.width * .03),
                  child: Container(
                    height: mq.height * .28,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            widget.info.name,
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Garamond1'),
                          ),
                          SizedBox(
                            height: mq.height * .025,
                          ),
                          InkWell(
                            onTap: () async {
                              int c = 0;
                              List<Map<String, dynamic>> documentsData = [];
                              await Auth.customerRef
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('carts')
                                  .get()
                                  .then(
                                    (QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach(
                                          (QueryDocumentSnapshot documentSnapshot) {
                                        documentsData.add(documentSnapshot.data()
                                        as Map<String, dynamic>);
                                      });
                                },
                              );
                              for (int i = 0; i < documentsData.length; i++) {
                                print(
                                    '=============${documentsData[i]['productId']}');
                                if (documentsData[i]['productId'] ==
                                    widget.info.productId) {
                                  c++;
                                  Utilities()
                                      .showMessage('Already added to cart');
                                  break;
                                }
                              }
                              if (c == 0) {
                                minimumDelivery();
                                setState(() {
                                  addToCart = true;
                                  Auth.customerRef
                                      .doc(Auth.auth.currentUser!.uid)
                                      .collection('carts')
                                      .doc(widget.info.productId)
                                      .set({
                                    'name': widget.info.name,
                                    'price': widget.info.price.substring(4),
                                    'image': widget.info.image,
                                    'index': widget.info.index,
                                    'perprice': double.parse(
                                        widget.info.price.substring(4)),
                                    'quantity': 1,
                                    'deliveryTime': widget.info.deliveryTime,
                                    'sellerId': widget.info.sellerId,
                                    'orderLimit': widget.info.orderLimit,
                                    'productId': widget.info.productId,
                                    'added_on': DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString()
                                  }).then((value) {
                                    Utilities().showMessage('Added to cart');
                                  });
                                  log(widget.info.name);
                                  log(widget.info.price);
                                  log(addToCart.toString());
                                  count = 1;
                                });
                              }
                            },
                            child: Container(
                              height: mq.height * .08,
                              width: mq.width * .6,
                              decoration: BoxDecoration(
                                color: Color(0xff8D8E36),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Center(
                                child: Text('Add to Cart',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: mq.height * .035,
                          ),
                          Text(
                            'Hurry upp!! Only ${widget.info.orderLimit} left',
                            style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                height: mq.height * .42,
                width: mq.width,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Details details =
                                detailsFromJson(filteredProducts[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      info: details,
                                      products: widget.products,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 10,
                                child: Container(
                                  width: mq.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      filteredProducts[index]['thumbnailUrl'],
                                      height: 220,
                                      width: 70,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${filteredProducts[index]['name'].toString().substring(0, 12)}...',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              child: Text(
                                '${filteredProducts[index]['price']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: mq.height * .08, horizontal: mq.width * .04),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: mq.height * .07,
                  width: mq.width * .13,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            )),
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: mq.height * .08, horizontal: mq.width * .04),
              child: InkWell(
                onTap: () {
                  addToCart = false;
                  setState(() {});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewCart(),
                      ));
                },
                child: Container(
                  height: mq.height * .07,
                  width: mq.width * .13,
                  decoration: BoxDecoration(
                      color: Color(0xff8D8E36),
                      borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                      addToCart
                          ? Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.fiber_manual_record,
                          size: 20,
                          color: Colors.red.shade800,
                        ),
                      )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            )),
      ]),
      bottomNavigationBar: showMyBar(context),
    );
  }

  Widget showMyBar(BuildContext context) {
    return Container(
      height: mq.height * .1,
      width: mq.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'Price:',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                Text(
                  widget.info.price,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ],
            ),
            SizedBox(
              width: 40,
            ),
            InkWell(
              onTap: () async {
                int c = 0;
                List<Map<String, dynamic>> documentsData = [];
                await Auth.customerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('carts')
                    .get()
                    .then(
                      (QuerySnapshot querySnapshot) {
                    querySnapshot.docs
                        .forEach((QueryDocumentSnapshot documentSnapshot) {
                      documentsData
                          .add(documentSnapshot.data() as Map<String, dynamic>);
                    });
                  },
                );
                for (int i = 0; i < documentsData.length; i++) {
                  print('=============${documentsData[i]['productId']}');
                  if (documentsData[i]['productId'] == widget.info.productId) {
                    c++;
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleProductBill(
                                productId: widget.info.productId)));
                  }
                }
                if (c == 0) {
                  showAddToCartDialog(context);
                }
              },
              child: Container(
                height: mq.height * .07,
                width: mq.width * .35,
                decoration: BoxDecoration(
                  color: Color(0xff8D8E36),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Buy Now',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showAddToCartDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                  height: mq.height / 5,
                  width: mq.width,
                  child: Column(children: [
                    Text(
                        "You can't buy a product without adding it into cart. Do you want to add this product in your cart ?"),
                    SizedBox(
                      height: mq.height * .05,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: mq.height * .07,
                                width: mq.width * .25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.yellow.shade800),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: Text(
                                      'No',
                                      style:
                                      TextStyle(color: Colors.yellow.shade800),
                                    ))),
                          ),
                          InkWell(
                            onTap: () async {
                              minimumDelivery();
                              setState(() async {
                                addToCart = true;
                                await Auth.customerRef
                                    .doc(Auth.auth.currentUser!.uid)
                                    .collection('carts')
                                    .doc(widget.info.productId)
                                    .set({
                                  'name': widget.info.name,
                                  'price': widget.info.price.substring(4),
                                  'image': widget.info.image,
                                  'index': widget.info.index,
                                  'perprice': double.parse(
                                      widget.info.price.substring(4)),
                                  'quantity': 1,
                                  'deliveryTime': widget.info.deliveryTime,
                                  'sellerId': widget.info.sellerId,
                                  'orderLimit': widget.info.orderLimit,
                                  'productId': widget.info.productId,
                                  'added_on': DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString()
                                }).then((value) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleProductBill(
                                                  productId:
                                                  widget.info.productId)));
                                });
                                log(addToCart.toString());
                                count = 1;
                              });
                            },
                            child: Container(
                                height: mq.height * .07,
                                width: mq.width * .3,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Center(
                                    child: Text(
                                      'Add to cart',
                                      style: TextStyle(color: Colors.white),
                                    ))),
                          )
                        ]),
                  ]));
            },
          ),
        );
      },
    );
  }
}
