// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/screens/customer/customer_home.dart';
// import 'package:mall/screens/customer/shopping/orders.dart';
// import 'package:mall/screens/customer/shopping/view_cart.dart';
// import '../../../controller/auth.dart';
// import '../../../main.dart';
// import '../../../model/product_model.dart';
//
// class SingleProductBill extends StatefulWidget {
//   final String productId;
//
//   const SingleProductBill({super.key, required this.productId});
//
//   @override
//   State<SingleProductBill> createState() => _SingleProductBillState();
// }
//
// class _SingleProductBillState extends State<SingleProductBill> {
//   Stream<QuerySnapshot>? stream;
//   ProductModel? productModel;
//   List<ProductModel> productList = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     stream = Auth.customerRef
//         .doc(Auth.auth.currentUser!.uid)
//         .collection('carts')
//         .where('productId', isEqualTo: widget.productId)
//         .snapshots();
//   }
//
//   String? sellerId;
//   late double total;
//   int quantity = 0;
//   var testing;
//
//   @override
//   Widget build(BuildContext context) {
//     print('product id = ${widget.productId}');
//     return StreamBuilder<QuerySnapshot>(
//         stream: stream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           return snapshot.data?.docs.length != 0
//               ? Scaffold(
//                   body: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                           colors: [Color(0xFFe8d6e8), Colors.white],
//                           stops: const [0.4, 0.9],
//                           begin: Alignment.topLeft,
//                           end: Alignment.topRight),
//                     ),
//                     child: ListView.builder(
//                       itemCount: snapshot.data?.docs.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         log('Snapshot ${snapshot.data?.docs[index]['productId']}');
//                         if (snapshot.data?.docs[index]['productId'] ==
//                             widget.productId) {
//                           double price =
//                               double.parse(snapshot.data?.docs[index]['price']);
//                           quantity = snapshot.data?.docs[index]['quantity'];
//                           sellerId = snapshot.data?.docs[index]['sellerId'];
//                           testing = snapshot.data?.docs[index];
//                           Map<String, dynamic>? data = testing.data();
//                           if (data != null) {
//                             int c = 0;
//                             String jsonString = jsonEncode(data);
//                             productModel = productModelFromJson(jsonString);
//                             if(productList.isNotEmpty){
//                               for (int i = 0; i < productList.length; i++) {
//                                 if (productModel!.productId ==
//                                     productList[i].productId) {
//                                   break;
//                                 } else {
//                                   c++;
//                                 }
//                               }
//                               if (c == productList.length) {
//                                 productList.add(productModel!);
//                               }
//                             }else{
//                               productList.add(productModel!);
//                             }
//                             print('product list ====${productList.length}');
//                             print('product list ====${productList[0].quantity}');
//                           } else {
//                             print("Document is null or doesn't contain data.");
//                           }
//                           double perprice =
//                               snapshot.data!.docs[index]['perprice'];
//                           total = perprice * .18 + perprice;
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.pop(context);
//                                       },
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                             color: Colors.grey,
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(15))),
//                                         width: 100,
//                                         height: 50,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Icon(
//                                               Icons.chevron_left,
//                                               color: Colors.white,
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Text(
//                                               'Back',
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   color: Colors.white),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Text('Bill',
//                                         style: TextStyle(
//                                             fontSize: 26,
//                                             fontWeight: FontWeight.bold)),
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     ViewCart()));
//                                       },
//                                       child: Container(
//                                         width: 100,
//                                         height: 50,
//                                         decoration: BoxDecoration(
//                                             color: Color(0xff974C7C),
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(15))),
//                                         child: Center(
//                                           child: Text(
//                                             'My Cart',
//                                             style: TextStyle(
//                                                 fontSize: 18,
//                                                 color: Colors.white),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: Card(
//                                   elevation: 10,
//                                   shadowColor: Color(0xff974c7c),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   color: Color(0xff974C7C),
//                                   child: ListTile(
//                                       title: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 12.0, horizontal: 3),
//                                         child: Text(
//                                           snapshot.data?.docs[index]['name'],
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                       leading: CircleAvatar(
//                                         backgroundImage: NetworkImage(snapshot
//                                             .data?.docs[index]['image']),
//                                       ),
//                                       subtitle: Row(
//                                         children: [
//                                           InkWell(
//                                               onTap: () async {
//                                                 if (quantity == 1) {
//                                                   showCartDialog(
//                                                       snapshot.data?.docs[index]
//                                                           ['productId']);
//                                                 } else {
//                                                   quantity = quantity - 1;
//                                                   perprice = 0;
//                                                   total = 0;
//                                                   perprice = price * quantity;
//                                                   await Auth.customerRef
//                                                       .doc(Auth.auth
//                                                           .currentUser!.uid)
//                                                       .collection('carts')
//                                                       .doc(snapshot
//                                                               .data!.docs[index]
//                                                           ['productId'])
//                                                       .update({
//                                                     'quantity': quantity,
//                                                     'perprice': perprice,
//                                                   });
//                                                 }
//                                                 productList.clear();
//                                                 setState(() {});
//                                               },
//                                               child: Container(
//                                                   height: 20,
//                                                   width: 25,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors
//                                                           .yellow.shade600),
//                                                   child: Center(
//                                                       child: Text(
//                                                     '-',
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: 20),
//                                                   )))),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text('${quantity}',
//                                                 style: TextStyle(fontSize: 18)),
//                                           ),
//                                           InkWell(
//                                               onTap: () async {
//                                                 quantity += 1;
//                                                 perprice = 0;
//                                                 perprice = price * quantity;
//                                                 await Auth.customerRef
//                                                     .doc(Auth
//                                                         .auth.currentUser!.uid)
//                                                     .collection('carts')
//                                                     .doc(snapshot
//                                                             .data!.docs[index]
//                                                         ['productId'])
//                                                     .update(
//                                                   {
//                                                     'quantity': quantity,
//                                                     'perprice': perprice
//                                                   },
//                                                 );
//                                                 productList.clear();
//                                                 setState(() {});
//                                               },
//                                               child: Container(
//                                                   height: 20,
//                                                   width: 25,
//                                                   decoration: BoxDecoration(
//                                                       color: Color(0xff8D8E36)),
//                                                   child: Center(
//                                                       child: Text(
//                                                     '+',
//                                                     style: TextStyle(
//                                                         color: Colors.white,
//                                                         fontSize: 20),
//                                                   )))),
//                                           SizedBox(
//                                             width: 80,
//                                           ),
//                                           IconButton(
//                                               onPressed: () {
//                                                 showCartDialog(snapshot.data
//                                                     ?.docs[index]['productId']);
//                                               },
//                                               icon: Icon(Icons.delete,
//                                                   color: Colors.redAccent))
//                                         ],
//                                       )),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Card(
//                                   elevation: 10,
//                                   shadowColor: Color(0xff974c7c),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   color: Color(0xFFe8d6e8),
//                                   child: Column(
//                                     children: [
//                                       ListTile(
//                                         title: Text('Price'),
//                                         trailing: Text(
//                                             'Rs.${price.toStringAsFixed(2)}'),
//                                       ),
//                                       ListTile(
//                                         title: Text('Quantity'),
//                                         trailing: Text(quantity.toString()),
//                                       ),
//                                       ListTile(
//                                         title: Text('Per item price'),
//                                         trailing: Text(
//                                             'Rs.${perprice.toStringAsFixed(2)}'),
//                                       ),
//                                       ListTile(
//                                         title: Text('GST'),
//                                         trailing: Text(
//                                             'Rs.${(perprice * .18).toStringAsFixed(2)}'),
//                                       ),
//                                       ListTile(
//                                         title: Text('Total'),
//                                         trailing: Text(
//                                             'Rs.${total.toStringAsFixed(2)}'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   bottomNavigationBar: placeOrderBar(context),
//                 )
//               : Scaffold();
//         });
//   }
//
//   Widget placeOrderBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: 60,
//         child: InkWell(
//           onTap: () {
//             var map = {
//               'singleSellerId': sellerId.toString(),
//               'productId': widget.productId.toString()
//             };
//             print('listttttttttttttttt${productList}');
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Orders(
//                     singleSellerId: testing['sellerId'],
//                     total: total,
//                     productId: widget.productId,
//                     map: map,
//                     quantity: quantity,
//                     testing: testing,
//                     productList: productList,
//                   ),
//                 ));
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 color: Color(0xff974C7C),
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(15),
//                     topLeft: Radius.circular(15))),
//             child: Center(
//               child: Text(
//                 'Buy',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> showCartDialog(String pId) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               content: StatefulBuilder(builder: (context, setModalState) {
//                 return SizedBox(
//                   height: mq.height / 8,
//                   width: mq.width - 50,
//                   child: Column(
//                     children: [
//                       Text('Remove from cart ? '),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Auth.customerRef
//                                   .doc(Auth.auth.currentUser!.uid)
//                                   .collection('carts')
//                                   .doc(pId)
//                                   .delete();
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => CustomerHome()));
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.yellow.shade700,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(25))),
//                                 width: 100,
//                                 height: 40,
//                                 child: Center(
//                                   child: Text(
//                                     'Remove',
//                                     style: TextStyle(
//                                         fontSize: 18, color: Colors.white),
//                                   ),
//                                 )),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                         colors: [
//                                           Color(0xFFe8d6e8),
//                                           Colors.white
//                                         ],
//                                         stops: const [
//                                           0.5,
//                                           0.9
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.topRight),
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(25))),
//                                 width: 100,
//                                 height: 40,
//                                 child: Center(
//                                   child: Text(
//                                     'Cancel',
//                                     style: TextStyle(
//                                         fontSize: 18, color: Colors.blue),
//                                   ),
//                                 )),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               }));
//         });
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/customer/customer_home.dart';
import 'package:mall/screens/customer/shopping/orders.dart';
import 'package:mall/screens/customer/shopping/view_cart.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';
import '../../../model/product_model.dart';

class SingleProductBill extends StatefulWidget {
  final String productId;

  const SingleProductBill({super.key, required this.productId});

  @override
  State<SingleProductBill> createState() => _SingleProductBillState();
}

class _SingleProductBillState extends State<SingleProductBill> {
  Stream<QuerySnapshot>? stream;
  ProductModel? productModel;
  List<ProductModel> productList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.customerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('carts')
        .where('productId', isEqualTo: widget.productId)
        .snapshots();
  }

  String? sellerId;
  late double total;
  int quantity = 0;
  var testing;

  @override
  Widget build(BuildContext context) {
    print('product id = ${widget.productId}');
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.data?.docs.length != 0
              ? Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFe8d6e8), Colors.white],
                    stops: const [0.4, 0.9],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight),
              ),
              child: ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  log('Snapshot ${snapshot.data?.docs[index]['productId']}');
                  if (snapshot.data?.docs[index]['productId'] ==
                      widget.productId) {
                    double price =
                    double.parse(snapshot.data?.docs[index]['price']);
                    quantity = snapshot.data?.docs[index]['quantity'];
                    sellerId = snapshot.data?.docs[index]['sellerId'];
                    testing = snapshot.data?.docs[index];
                    Map<String, dynamic>? data = testing.data();
                    if (data != null) {
                      String jsonString = jsonEncode(data);
                      productModel = productModelFromJson(jsonString);
                      productList.add(productModel!);
                    } else {
                      print("Document is null or doesn't contain data.");
                    }
                    double perprice =
                    snapshot.data!.docs[index]['perprice'];
                    total = perprice * .18 + perprice;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  width: 100,
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chevron_left,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Back',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Text('Bill',
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold)),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewCart()));
                                },
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Color(0xff974C7C),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Center(
                                    child: Text(
                                      'My Cart',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Card(
                            elevation: 10,
                            shadowColor: Color(0xff974c7c),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Color(0xff974C7C),
                            child: ListTile(
                                title: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 3),
                                  child: Text(
                                    snapshot.data?.docs[index]['name'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot
                                      .data?.docs[index]['image']),
                                ),
                                subtitle: Row(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          if (quantity == 1) {
                                            showCartDialog(
                                                snapshot.data?.docs[index]
                                                ['productId']);
                                          } else {
                                            quantity = quantity - 1;
                                            perprice = 0;
                                            total = 0;
                                            perprice = price * quantity;
                                            await Auth.customerRef
                                                .doc(Auth.auth
                                                .currentUser!.uid)
                                                .collection('carts')
                                                .doc(snapshot
                                                .data!.docs[index]
                                            ['productId'])
                                                .update({
                                              'quantity': quantity,
                                              'perprice': perprice,
                                            });
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                            height: 20,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                color: Colors
                                                    .yellow.shade600),
                                            child: Center(
                                                child: Text(
                                                  '-',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                )))),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${quantity}',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          quantity += 1;
                                          perprice = 0;
                                          perprice = price * quantity;
                                          await Auth.customerRef
                                              .doc(Auth
                                              .auth.currentUser!.uid)
                                              .collection('carts')
                                              .doc(snapshot
                                              .data!.docs[index]
                                          ['productId'])
                                              .update(
                                            {
                                              'quantity': quantity,
                                              'perprice': perprice
                                            },
                                          );
                                          setState(() {});
                                        },
                                        child: Container(
                                            height: 20,
                                            width: 25,
                                            decoration: BoxDecoration(
                                                color: Color(0xff8D8E36)),
                                            child: Center(
                                                child: Text(
                                                  '+',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                )))),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showCartDialog(snapshot.data
                                              ?.docs[index]['productId']);
                                        },
                                        icon: Icon(Icons.delete,
                                            color: Colors.redAccent))
                                  ],
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            elevation: 10,
                            shadowColor: Color(0xff974c7c),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Color(0xFFe8d6e8),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('Price'),
                                  trailing: Text(
                                      'Rs.${price.toStringAsFixed(2)}'),
                                ),
                                ListTile(
                                  title: Text('Quantity'),
                                  trailing: Text(quantity.toString()),
                                ),
                                ListTile(
                                  title: Text('Per item price'),
                                  trailing: Text(
                                      'Rs.${perprice.toStringAsFixed(2)}'),
                                ),
                                ListTile(
                                  title: Text('GST'),
                                  trailing: Text(
                                      'Rs.${(perprice * .18).toStringAsFixed(2)}'),
                                ),
                                ListTile(
                                  title: Text('Total'),
                                  trailing: Text(
                                      'Rs.${total.toStringAsFixed(2)}'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            bottomNavigationBar: placeOrderBar(context),
          )
              : Scaffold();
        });
  }

  Widget placeOrderBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 60,
        child: InkWell(
          onTap: () {
            var map = {
              'singleSellerId': sellerId.toString(),
              'productId': widget.productId.toString()
            };
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Orders(
                    singleSellerId: testing['sellerId'],
                    total: total,
                    productId: widget.productId,
                    map: map,
                    quantity: quantity,
                    testing: testing,
                    productList: productList,
                  ),
                ));
          },
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xff974C7C),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Center(
              child: Text(
                'Buy',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showCartDialog(String pId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: StatefulBuilder(builder: (context, setModalState) {
                return SizedBox(
                  height: mq.height / 8,
                  width: mq.width - 50,
                  child: Column(
                    children: [
                      Text('Remove from cart ? '),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Auth.customerRef
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('carts')
                                  .doc(pId)
                                  .delete();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomerHome()));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellow.shade700,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                                width: 100,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFe8d6e8),
                                          Colors.white
                                        ],
                                        stops: const [
                                          0.5,
                                          0.9
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                                width: 100,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.blue),
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }));
        });
  }
}
