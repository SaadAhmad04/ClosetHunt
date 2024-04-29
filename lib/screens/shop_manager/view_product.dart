// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/constant/utils/utilities.dart';
// import 'package:mall/constant/widget/show_error.dart';
// import 'package:mall/screens/customer/shopping/product_details.dart';
// import 'package:mall/screens/shop_manager/view_Details.dart';
//
// import '../../controller/auth.dart';
// import '../../main.dart';
//
// class ViewProduct extends StatefulWidget {
//   final String shopName;
//   String? shopId;
//
//   ViewProduct({Key? key, required this.shopName, this.shopId})
//       : super(key: key);
//
//   @override
//   State<ViewProduct> createState() => _ViewProductState();
// }
//
// class _ViewProductState extends State<ViewProduct> {
//   late String product;
//   bool isSearchingOn = false;
//   final searchController = TextEditingController();
//   final editController = TextEditingController();
//   Stream<QuerySnapshot>? stream;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     stream = Auth.shopManagerRef
//         .doc(widget.shopId == null ? Auth.auth.currentUser!.uid : widget.shopId)
//         .collection('shop')
//         .doc(widget.shopId == null ? Auth.auth.currentUser!.uid : widget.shopId)
//         .collection('products')
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size mq = MediaQuery.of(context).size;
//     return StreamBuilder<QuerySnapshot>(
//         stream: stream,
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasData) {
//             return GestureDetector(
//               onTap: () => FocusScope.of(context).unfocus(),
//               child: Scaffold(
//                 //extendBodyBehindAppBar: true,
//                   appBar: AppBar(
//                     bottom: PreferredSize(
//                       preferredSize: Size.fromHeight(50),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 10, left: 1, right: 1),
//                               child: TextField(
//                                 controller: searchController,
//                                 onChanged: (val) {
//                                   if (val.isNotEmpty) {
//                                     setState(() {
//                                       isSearchingOn = true;
//                                     });
//                                   } else {
//                                     setState(() {
//                                       isSearchingOn = false;
//                                     });
//                                   }
//                                 },
//                                 decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.only(
//                                         top: -15, left: 5, right: 1),
//                                     border: OutlineInputBorder(
//                                         borderRadius:
//                                         BorderRadius.circular(10)),
//                                     hintText: 'Search product'),
//                               ),
//                             ),
//                           ),
//                           isSearchingOn && searchController.text.isNotEmpty
//                               ? IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isSearchingOn = false;
//                                   searchController.text = "";
//                                 });
//                               },
//                               icon: Icon(Icons.clear, color: Colors.black))
//                               : SizedBox()
//                         ],
//                       ),
//                     ),
//                     backgroundColor: Colors.transparent,
//                     elevation: 0.0,
//                     title: ShaderMask(
//                       shaderCallback: (Rect bounds) {
//                         return LinearGradient(
//                           colors: [Colors.green, Colors.blue],
//                         ).createShader(bounds);
//                       },
//                       child: Text(
//                         widget.shopName,
//                         style: TextStyle(
//                           fontSize: 30.0,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     centerTitle: true,
//                     leading: IconButton(
//                       icon: Icon(
//                         Icons.arrow_back_outlined,
//                         color: Colors.black,
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     actions: [
//                       Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Icon(Icons.shop, color: Colors.black),
//                       )
//                     ],
//                   ),
//                   body: snapshot.data?.docs.length != 0
//                       ? ListView.builder(
//                     itemCount: snapshot.data?.docs.length,
//                     itemBuilder: (context, index) {
//                       String productId =
//                       snapshot.data!.docs[index]['usItemId'];
//                       String price = snapshot.data!.docs[index]['price'];
//                       product = snapshot.data!.docs[index]['name'];
//                       if (searchController.text.isEmpty) {
//                         return Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Card(
//                               elevation: 10,
//                               shadowColor: Colors.grey,
//                               child: InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => ViewDetails(
//                                           index: index,
//                                           usItemId: productId,
//                                           shopId: widget.shopId,
//                                         ),
//                                       ));
//                                 },
//                                 child: ListTile(
//                                   leading: CircleAvatar(
//                                     backgroundColor: Colors.grey,
//                                     radius: 30,
//                                     backgroundImage: NetworkImage(snapshot
//                                         .data!
//                                         .docs[index]['thumbnailUrl']),
//                                   ),
//                                   trailing: widget.shopId == null
//                                       ? PopupMenuButton(
//                                     icon: Icon(Icons.more_vert),
//                                     itemBuilder: (context) => [
//                                       PopupMenuItem(
//                                           value: 1,
//                                           child: ListTile(
//                                             title: Text(
//                                                 'Update price'),
//                                             leading:
//                                             Icon(Icons.edit),
//                                             onTap: () {
//                                               Navigator.pop(
//                                                   context);
//                                               showEditDialog(
//                                                   productId, price);
//                                             },
//                                           )),
//                                       PopupMenuItem(
//                                           value: 1,
//                                           child: ListTile(
//                                             title: Text('Delete'),
//                                             leading:
//                                             Icon(Icons.delete),
//                                             onTap: () {
//                                               Navigator.pop(
//                                                   context);
//                                               showDeleteDialog(
//                                                   productId);
//                                             },
//                                           ))
//                                     ],
//                                   )
//                                       : SizedBox(),
//                                   title: Text(
//                                       snapshot.data!.docs[index]['name'],
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                   subtitle: Text(
//                                       "Rs. ${snapshot.data!.docs[index]['price']}"),
//                                 ),
//                               )),
//                         );
//                       }
//                       else if (product.toLowerCase().contains(
//                           searchController.text
//                               .toString()
//                               .toLowerCase())) {
//                         return Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Card(
//                               elevation: 10,
//                               shadowColor: Colors.grey,
//                               child: ListTile(
//                                 leading: CircleAvatar(
//                                   backgroundColor: Colors.grey,
//                                   radius: 30,
//                                   backgroundImage: NetworkImage(snapshot
//                                       .data!.docs[index]['thumbnailUrl']),
//                                 ),
//                                 trailing: PopupMenuButton(
//                                   icon: Icon(Icons.more_vert),
//                                   itemBuilder: (context) => [
//                                     PopupMenuItem(
//                                         value: 1,
//                                         child: ListTile(
//                                           title: Text('Update price'),
//                                           leading: Icon(Icons.edit),
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                             showEditDialog(
//                                                 productId, price);
//                                           },
//                                         )),
//                                     PopupMenuItem(
//                                         value: 1,
//                                         child: ListTile(
//                                           title: Text('Delete'),
//                                           leading: Icon(Icons.delete),
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                             showDeleteDialog(productId);
//                                           },
//                                         ))
//                                   ],
//                                 ),
//                                 title: Text(
//                                     snapshot.data!.docs[index]['name'],
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold)),
//                                 subtitle: Text(
//                                     "Rs. ${snapshot.data!.docs[index]['price']}"),
//                               )),
//                         );
//                       }
//                       else {
//                         return Container();
//                       }
//                     },
//                   )
//                       : Center(
//                         child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text('No products!!' , style: TextStyle(fontSize: 25),),
//                             Icon(Icons.error)
//                           ],
//                         ),
//                       )),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         });
//   }
//
//   Future<void> showEditDialog(String productId, String price) {
//     editController.text = price;
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             content: Builder(builder: (context) {
//               return SizedBox(
//                 height: mq.height / 5.5,
//                 width: mq.width / 1.4,
//                 child: Column(
//                   children: [
//                     Text('Product Price'),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     TextField(
//                       controller: editController,
//                       decoration: InputDecoration(
//                         border: UnderlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             height: 30,
//                             width: 60,
//                             foregroundDecoration: BoxDecoration(
//                                 border: Border.all(color: Colors.blue),
//                                 borderRadius: BorderRadius.circular(15)),
//                             child: Center(
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(color: Colors.blue),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         InkWell(
//                           onTap: () async {
//                             await Auth.shopManagerRef
//                                 .doc(Auth.auth.currentUser!.uid)
//                                 .collection('shop')
//                                 .doc(Auth.auth.currentUser!.uid)
//                                 .collection('products')
//                                 .doc(productId.toString())
//                                 .update({
//                               'price': editController.text.toString()
//                             }).then((value) {
//                               Utilities().showMessage('Price updated');
//                               Navigator.pop(context);
//                             }).onError((error, stackTrace) {
//                               Utilities().showMessage(error.toString());
//                             });
//                           },
//                           child: Container(
//                             height: 30,
//                             width: 60,
//                             decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(15)),
//                             child: Center(
//                               child: Text(
//                                 'Save',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }),
//           );
//         });
//   }
//
//   Future<void> showDeleteDialog(String productId) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             content: Builder(builder: (context) {
//               return SizedBox(
//                 height: mq.height / 7,
//                 width: mq.width / 1.4,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 5),
//                     Text(
//                         'Are you sure you want to remove this product from your stock ? '),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             height: 30,
//                             width: 60,
//                             foregroundDecoration: BoxDecoration(
//                                 border:
//                                 Border.all(color: Colors.yellow.shade700),
//                                 borderRadius: BorderRadius.circular(15)),
//                             child: Center(
//                               child: Text(
//                                 'No',
//                                 style: TextStyle(color: Colors.yellow.shade700),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         InkWell(
//                           onTap: () async {
//                             await Auth.shopManagerRef
//                                 .doc(Auth.auth.currentUser!.uid)
//                                 .collection('shop')
//                                 .doc(Auth.auth.currentUser!.uid)
//                                 .collection('products')
//                                 .doc(productId.toString())
//                                 .delete()
//                                 .then((value) {
//                               Utilities()
//                                   .showMessage('Product removed successfully');
//                               Navigator.pop(context);
//                             }).onError((error, stackTrace) {
//                               Utilities().showMessage(error.toString());
//                             });
//                           },
//                           child: Container(
//                             height: 30,
//                             width: 60,
//                             decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(15)),
//                             child: Center(
//                               child: Text(
//                                 'Yes',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }),
//           );
//         });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/screens/shop_manager/view_Details.dart';

import '../../controller/auth.dart';
import '../../main.dart';

class ViewProduct extends StatefulWidget {
  final String shopName;
  String? shopId;

  ViewProduct({Key? key, required this.shopName, this.shopId})
      : super(key: key);

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  bool showSearchField = false;
  late String product;
  bool isSearchingOn = false;
  final searchController = TextEditingController();
  final editController = TextEditingController();
  Stream<QuerySnapshot>? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    stream = Auth.shopManagerRef
        .doc(widget.shopId == null ? Auth.auth.currentUser!.uid : widget.shopId)
        .collection('shop')
        .doc(widget.shopId == null ? Auth.auth.currentUser!.uid : widget.shopId)
        .collection('products')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                //extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    bottom: PreferredSize(
                      preferredSize: showSearchField
                          ? Size.fromHeight(50)
                          : Size.fromHeight(0),
                      child: showSearchField
                          ? Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: TextField(
                                controller: searchController,
                                onChanged: (val) {
                                  if (val.isNotEmpty) {
                                    setState(() {
                                      isSearchingOn = true;
                                    });
                                  } else {
                                    setState(() {
                                      isSearchingOn = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    enabled: true,
                                    hoverColor: Colors.purple,
                                    focusColor: Colors.purple,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purple)),
                                    prefixIconColor: Colors.purple,
                                    contentPadding: EdgeInsets.only(
                                        top: -15, left: 5, right: 1),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    hintText: 'Search product'),
                              ),
                            ),
                          ),
                          isSearchingOn &&
                              searchController.text.isNotEmpty
                              ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearchingOn = false;
                                  searchController.text = "";
                                });
                              },
                              icon: Icon(Icons.clear,
                                  color: Colors.black))
                              : SizedBox()
                        ],
                      )
                          : SizedBox(),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      widget.shopName,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                      ),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: [
                      Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showSearchField = true;
                              });
                            },
                            child: Container(
                                child: Center(
                                    child: Image.asset("images/search.gif"))),
                          )),
                    ],
                  ),
                  body: snapshot.data?.docs.length != 0
                      ? ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      String productId =
                      snapshot.data!.docs[index]['usItemId'];
                      String price = snapshot.data!.docs[index]['price'];
                      product = snapshot.data!.docs[index]['name'];
                      if (searchController.text.isEmpty) {
                        double pricee = double.parse(
                            snapshot.data!.docs[index]['price']);
                        String priceString = pricee.toStringAsFixed(2);
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20)),
                              elevation: 10,
                              shadowColor: Colors.purple[50],
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewDetails(
                                          index: index,
                                          usItemId: productId,
                                          shopId: widget.shopId,
                                        ),
                                      ));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 30,
                                    backgroundImage: NetworkImage(snapshot
                                        .data!
                                        .docs[index]['thumbnailUrl']),
                                  ),
                                  trailing: widget.shopId == null
                                      ? PopupMenuButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.purple,
                                    ),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            title: Text(
                                                'Update price'),
                                            leading: Icon(
                                              Icons.edit,
                                              color: Colors.purple,
                                            ),
                                            onTap: () {
                                              Navigator.pop(
                                                  context);
                                              showEditDialog(
                                                  productId,
                                                  priceString);
                                            },
                                          )),
                                      PopupMenuItem(
                                          value: 1,
                                          child: ListTile(
                                            title: Text('Delete'),
                                            leading: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onTap: () {
                                              Navigator.pop(
                                                  context);
                                              showDeleteDialog(
                                                  productId);
                                            },
                                          ))
                                    ],
                                  )
                                      : SizedBox(),
                                  title: Text(
                                      snapshot.data!.docs[index]['name']
                                          .toString()
                                          .substring(0, 19) +
                                          "...",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text("Rs. ${priceString}"),
                                ),
                              )),
                        );
                      } else if (product.toLowerCase().contains(
                          searchController.text
                              .toString()
                              .toLowerCase())) {
                        double pricee = double.parse(
                            snapshot.data!.docs[index]['price']);
                        String priceString = pricee.toStringAsFixed(2);
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Card(
                              elevation: 10,
                              shadowColor: Colors.purple,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  radius: 30,
                                  backgroundImage: NetworkImage(snapshot
                                      .data!.docs[index]['thumbnailUrl']),
                                ),
                                trailing: PopupMenuButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.purple,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          title: Text('Update price'),
                                          leading: Icon(
                                            Icons.edit,
                                            color: Colors.purple,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            showEditDialog(
                                                productId, price);
                                          },
                                        )),
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          title: Text('Delete'),
                                          leading: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            showDeleteDialog(productId);
                                          },
                                        ))
                                  ],
                                ),
                                title: Text(
                                    snapshot.data!.docs[index]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text('${priceString}'),
                              )),
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                      : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No products!!',
                          style: TextStyle(fontSize: 25),
                        ),
                        Icon(Icons.error)
                      ],
                    ),
                  )),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> showEditDialog(String productId, String price) {
    editController.text = price;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Builder(builder: (context) {
              return SizedBox(
                height: mq.height / 5.5,
                width: mq.width / 1.4,
                child: Column(
                  children: [
                    Text('Product Price'),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: editController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 30,
                            width: 60,
                            foregroundDecoration: BoxDecoration(
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            await Auth.shopManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('shop')
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('products')
                                .doc(productId.toString())
                                .update({
                              'price': editController.text.toString()
                            }).then((value) {
                              Utilities().showMessage('Price updated');
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Utilities().showMessage(error.toString());
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });
  }

  Future<void> showDeleteDialog(String productId) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Builder(builder: (context) {
              return SizedBox(
                height: mq.height / 7,
                width: mq.width / 1.4,
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Text(
                        'Are you sure you want to remove this product from your stock ? '),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 30,
                            width: 60,
                            foregroundDecoration: BoxDecoration(
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            await Auth.shopManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('shop')
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('products')
                                .doc(productId.toString())
                                .delete()
                                .then((value) {
                              Utilities()
                                  .showMessage('Product removed successfully');
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              Utilities().showMessage(error.toString());
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        });
  }
}