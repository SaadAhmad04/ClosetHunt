// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/constant/utils/utilities.dart';
// import 'package:mall/screens/shop_manager/shop_display.dart';
//
// import '../../constant/widget/show_error.dart';
// import '../../controller/auth.dart';
// import '../../main.dart';
//
// class CheckDuplicates extends StatefulWidget {
//   final List<Map<String, dynamic>>? excelData;
//
//   CheckDuplicates({Key? key, this.excelData}) : super(key: key);
//
//   @override
//   State<CheckDuplicates> createState() => _CheckDuplicatesState();
// }
//
// class _CheckDuplicatesState extends State<CheckDuplicates> {
//   List duplicates = [];
//   bool set = false;
//   List<String> titles = [];
//   bool dup = false;
//   Stream? stream;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     stream = Auth.productRef.snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Check Duplicates'),
//       ),
//       body: StreamBuilder(
//         stream: stream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return ShowError('No products');
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text('No data available'));
//           }
//           print(widget.excelData?.length);
//           // Clear the list of titles before adding new ones
//           titles.clear();
//           duplicates.clear();
//
//           // Iterate through the documents and extract titles
//           for (var document in snapshot.data!.docs) {
//             String title = document['usItemId'];
//             titles.add(title); // Add the title to the list
//           }
//
//           return Column(children: [
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: titles.length, // Use the length of the titles list
//               itemBuilder: (context, index) {
//                 set = false;
//                 for (int i = 0; i < widget.excelData!.length; i++) {
//                   // print("Excel        ${widget.excelData[i]['productId']}");
//                   // print("Title        ${titles[index]}");
//                   set = widget.excelData![i]['productId'].toString() ==
//                       titles[index].toString();
//                   if (set) {
//                     duplicates.add(widget.excelData![i]['productId']);
//                     break;
//                   }
//                 }
//                 print("Length ${duplicates.length}");
//                 if (duplicates.length > 0) {
//                   dup = true;
//                 } else {
//                   dup = false;
//                   //setState(() {});
//                 }
//                 //setState(() {});
//                 return duplicates.length > 0
//                     ? set
//                         ? ListTile(
//                             title: Text(
//                               titles[index],
//                               style: TextStyle(color: Colors.red),
//                             ),
//                             subtitle: Text("Duplicate Product Id Exist"),
//                           )
//                         : SizedBox()
//                     : SizedBox();
//                 //1009909536
//               },
//             ),
//           ]);
//         },
//       ),
//       bottomNavigationBar: showMyBar(context),
//     );
//   }
//
//   Widget showMyBar(BuildContext context) {
//     return Container(
//       height: mq.height * .09,
//       width: mq.width,
//       decoration: BoxDecoration(
//         color: Colors.blue.shade300,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//       ),
//       child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Stack(
//             children: [
//               Center(
//                 child: Text(
//                   'If duplicate product id(s) exist , kindly\n change, else ignore and proceed!!',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//               Align(
//                   alignment: Alignment.bottomRight,
//                   child: IconButton(
//                       onPressed: () async {
//                         for (int i = 0; i < widget.excelData!.length; i++) {
//                           print(widget.excelData![i]['productId']);
//                           await Auth.shopManagerRef
//                               .doc(Auth.auth.currentUser!.uid)
//                               .collection('shop')
//                               .doc(Auth.auth.currentUser!.uid)
//                               .collection('products')
//                               .doc(widget.excelData![i]['productId'].toString())
//                               .set({
//                             'name':
//                                 widget.excelData![i]['name'].toString() ?? "",
//                             'usItemId':
//                                 widget.excelData![i]['productId'].toString() ??
//                                     "",
//                             'thumbnailUrl':
//                                 widget.excelData![i]['imageUrl'].toString() ??
//                                     "",
//                             'imageId':
//                                 widget.excelData![i]['imageId'].toString() ??
//                                     "",
//                             'categoryPath': widget.excelData![i]['categoryPath']
//                                     .toString() ??
//                                 "",
//                             'price':
//                                 widget.excelData![i]['price'].toString() ?? "",
//                             'size':
//                                 widget.excelData![i]['size'].toString() ?? "",
//                             'sellerName':
//                                 widget.excelData![i]['sellerName'].toString() ??
//                                     "",
//                             'sellerId': Auth.auth.currentUser!.uid,
//                             'deliveryTime': widget.excelData![i]['deliveryTime']
//                                     .toString() ??
//                                 "",
//                             'variantCount':
//                                 widget.excelData![i]['variantCount'] ?? "",
//                             'variantPriceString': widget.excelData![i]
//                                         ['variantPriceString']
//                                     .toString() ??
//                                 "",
//                             'orderLimit':
//                                 widget.excelData![i]['orderLimit'] ?? 0,
//                           });
//                         }
//                         for (int i = 0; i < widget.excelData!.length; i++) {
//                           print(widget.excelData![i]['productId']);
//                           await Auth.productRef
//                               .doc(widget.excelData![i]['productId'].toString())
//                               .set({
//                             'name':
//                                 widget.excelData![i]['name'].toString() ?? "",
//                             'usItemId':
//                                 widget.excelData![i]['productId'].toString() ??
//                                     "",
//                             'thumbnailUrl':
//                                 widget.excelData![i]['imageUrl'].toString() ??
//                                     "",
//                             'imageId':
//                                 widget.excelData![i]['imageId'].toString() ??
//                                     "",
//                             'categoryPath': widget.excelData![i]['categoryPath']
//                                     .toString() ??
//                                 "",
//                             'price':
//                                 widget.excelData![i]['price'].toString() ?? "",
//                             'size':
//                                 widget.excelData![i]['size'].toString() ?? "",
//                             'sellerName':
//                                 widget.excelData![i]['sellerName'].toString() ??
//                                     "",
//                             'sellerId': Auth.auth.currentUser!.uid,
//                             'deliveryTime': widget.excelData![i]['deliveryTime']
//                                     .toString() ??
//                                 "",
//                             'variantCount':
//                                 widget.excelData![i]['variantCount'] ?? "",
//                             'variantPriceString': widget.excelData![i]
//                                         ['variantPriceString']
//                                     .toString() ??
//                                 "",
//                             'orderLimit':
//                                 widget.excelData![i]['orderLimit'] ?? 0,
//                           }).then((value) {
//                             Utilities().showMessage('Products uploaded');
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ShopDisplay()));
//                           }).onError((error, stackTrace) {
//                             Utilities().showMessage(error.toString());
//                           });
//                         }
//                       },
//                       icon: Icon(
//                         Icons.arrow_right,
//                         size: 45,
//                       )))
//             ],
//           )),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/screens/shop_manager/shop_display.dart';

import '../../constant/widget/show_error.dart';
import '../../controller/auth.dart';
import '../../main.dart';

class CheckDuplicates extends StatefulWidget {
  final List<Map<String, dynamic>>? excelData;

  CheckDuplicates({Key? key, this.excelData}) : super(key: key);

  @override
  State<CheckDuplicates> createState() => _CheckDuplicatesState();
}

class _CheckDuplicatesState extends State<CheckDuplicates> {
  List duplicates = [];
  bool set = false;
  List<String> titles = [];
  bool dup = false;
  Stream? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.productRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Duplicates'),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ShowError('No products');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }
          print(widget.excelData?.length);
          // Clear the list of titles before adding new ones
          titles.clear();
          duplicates.clear();

          // Iterate through the documents and extract titles
          for (var document in snapshot.data!.docs) {
            String title = document['usItemId'];
            titles.add(title); // Add the title to the list
          }

          return Column(children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: titles.length, // Use the length of the titles list
              itemBuilder: (context, index) {
                set = false;
                for (int i = 0; i < widget.excelData!.length; i++) {
                  // print("Excel        ${widget.excelData[i]['productId']}");
                  // print("Title        ${titles[index]}");
                  set = widget.excelData![i]['productId'].toString() ==
                      titles[index].toString();
                  if (set) {
                    duplicates.add(widget.excelData![i]['productId']);
                    break;
                  }
                }
                print("Length ${duplicates.length}");
                if (duplicates.length > 0) {
                  dup = true;
                } else {
                  dup = false;
                  //setState(() {});
                }
                //setState(() {});
                return duplicates.length > 0
                    ? set
                    ? ListTile(
                  title: Text(
                    titles[index],
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: Text("Duplicate Product Id Exist"),
                )
                    : SizedBox()
                    : SizedBox();
                //1009909536
              },
            ),
          ]);
        },
      ),
      bottomNavigationBar: showMyBar(context),
    );
  }

  Widget showMyBar(BuildContext context) {
    return Container(
      height: mq.height * .09,
      width: mq.width,
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Center(
                child: Text(
                  'If duplicate product id(s) exist , kindly\n change, else ignore and proceed!!',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () async {
                        for (int i = 0; i < widget.excelData!.length; i++) {
                          print(widget.excelData![i]['productId']);
                          await Auth.shopManagerRef
                              .doc(Auth.auth.currentUser!.uid)
                              .collection('shop')
                              .doc(Auth.auth.currentUser!.uid)
                              .collection('products')
                              .doc(widget.excelData![i]['productId'].toString())
                              .set({
                            'name':
                            widget.excelData![i]['name'].toString() ?? "",
                            'usItemId':
                            widget.excelData![i]['productId'].toString() ??
                                "",
                            'thumbnailUrl':
                            widget.excelData![i]['imageUrl'].toString() ??
                                "",
                            'imageId':
                            widget.excelData![i]['imageId'].toString() ??
                                "",
                            'categoryPath': widget.excelData![i]['categoryPath']
                                .toString() ??
                                "",
                            'price':
                            widget.excelData![i]['price'].toString() ?? "",
                            'size':
                            widget.excelData![i]['size'].toString() ?? "",
                            'sellerName':
                            widget.excelData![i]['sellerName'].toString() ??
                                "",
                            'sellerId': Auth.auth.currentUser!.uid,
                            'deliveryTime': widget.excelData![i]['deliveryTime']
                                .toString() ??
                                "",
                            'variantCount':
                            widget.excelData![i]['variantCount'] ?? "",
                            'variantPriceString': widget.excelData![i]
                            ['variantPriceString']
                                .toString() ??
                                "",
                            'orderLimit':
                            widget.excelData![i]['orderLimit'] ?? 0,
                          });
                        }
                        for (int i = 0; i < widget.excelData!.length; i++) {
                          print(widget.excelData![i]['productId']);
                          await Auth.productRef
                              .doc(widget.excelData![i]['productId'].toString())
                              .set({
                            'name':
                            widget.excelData![i]['name'].toString() ?? "",
                            'usItemId':
                            widget.excelData![i]['productId'].toString() ??
                                "",
                            'thumbnailUrl':
                            widget.excelData![i]['imageUrl'].toString() ??
                                "",
                            'imageId':
                            widget.excelData![i]['imageId'].toString() ??
                                "",
                            'categoryPath': widget.excelData![i]['categoryPath']
                                .toString() ??
                                "",
                            'price':
                            widget.excelData![i]['price'].toString() ?? "",
                            'size':
                            widget.excelData![i]['size'].toString() ?? "",
                            'sellerName':
                            widget.excelData![i]['sellerName'].toString() ??
                                "",
                            'sellerId': Auth.auth.currentUser!.uid,
                            'deliveryTime': widget.excelData![i]['deliveryTime']
                                .toString() ??
                                "",
                            'variantCount':
                            widget.excelData![i]['variantCount'] ?? "",
                            'variantPriceString': widget.excelData![i]
                            ['variantPriceString']
                                .toString() ??
                                "",
                            'orderLimit':
                            widget.excelData![i]['orderLimit'] ?? 0,
                          }).then((value) {
                            Utilities().showMessage('Products uploaded');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopDisplay()));
                          }).onError((error, stackTrace) {
                            Utilities().showMessage(error.toString());
                          });
                        }
                      },
                      icon: Icon(
                        Icons.arrow_right,
                        size: 45,
                      )))
            ],
          )),
    );
  }
}