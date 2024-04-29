// import 'dart:convert';
// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'controller/auth.dart';
//
// class Simple extends StatefulWidget {
//   const Simple({super.key});
//
//   @override
//   State<Simple> createState() => _SimpleState();
// }
//
// class _SimpleState extends State<Simple> {
//   List items = [];
//   // List<dynamic> badges = [];
//
// // Fetch content from the json file
//   Future<void> readJson() async {
//     final String response = await rootBundle.loadString('assets/skincare.json');
//     final data = await json.decode(response);
//     setState(() {
//       items = data["products"];
//       // badges = data['priceInfo'];
//     });
//     print('sucess');
//     // print(items);
//   }
//
//   List promises = [];
//   List size = ['S', 'M', 'L', 'XL', 'XXL'];
//   List shoe = ['5', '6', '7', '8', '9', '10'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Padding(
//       padding: const EdgeInsets.all(25),
//       child: Column(
//         children: [
//           ElevatedButton(
//             child: const Text('Load Data'),
//             onPressed: () {
//               readJson();
//             },
//           ),
//
//           // Display the data loaded from sample.json
//           items.isNotEmpty
//               ? Expanded(
//                   child: ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       if (items.isNotEmpty) {
//                         print(items[index]['usItemId']);
//                         // Auth.productRef
//                         //     .doc(items[index]['usItemId'] ?? "ID1")
//                         //     .set({
//                         //   'name': items[index]['name'],
//                         //   'usItemId': items[index]['usItemId'],
//                         //   'price':
//                         //       "${items[index]['priceInfo']['currentPrice']['price'] * 83}",
//                         //   'variantPriceString': items[index]['priceInfo']
//                         //               ['currentPrice']['variantPriceString'] !=
//                         //           null
//                         //       ? "${double.parse(items[index]['priceInfo']['currentPrice']['variantPriceString'].toString().substring(1)) * 83}"
//                         //       : "",
//                         //   "categoryPath": items[index]['category']
//                         //       ['categoryPath'],
//                         //   "thumbnailUrl": items[index]['imageInfo']
//                         //       ['thumbnailUrl'],
//                         //   "imageId": items[index]['imageInfo']['id'],
//                         //   "sellerId": 'zx7of5rXf5Nh9EZtbNytomgB9HC2',
//                         //   "sellerName": 'krunal',
//                         //   "variantCount": items[index]['variantCount'] ?? "",
//                         //   "orderLimit": items[index]['orderLimit'],
//                         //   "deliveryTime": items[index]['shippingOption']
//                         //       ['slaTier'],
//                         // });
//                         int min = 0;
//                         int max = 5;
//
//                         // Create an instance of the Random class
//                         Random random = Random();
//
//                         // Generate a random number within the specified range
//                         int randomNumber = min + random.nextInt(max - min + 1);
//
//                         // Print the generated random number
//                         print(
//                             "Random number between $min and $max: $randomNumber");
//                         Auth.shopManagerRef
//                             .doc('zx7of5rXf5Nh9EZtbNytomgB9HC2')
//                             .collection('shop')
//                             .doc('zx7of5rXf5Nh9EZtbNytomgB9HC2')
//                             .collection('products')
//                             .doc(items[index]['usItemId'])
//                             .set({
//                           'name': items[index]['name'],
//                           'usItemId': items[index]['usItemId'],
//                           'price':
//                               "${items[index]['priceInfo']['currentPrice']['price'] * 83}",
//                           'variantPriceString': items[index]['priceInfo']
//                                       ['currentPrice']['variantPriceString'] !=
//                                   null
//                               ? "${double.parse(items[index]['priceInfo']['currentPrice']['variantPriceString'].toString().substring(1)) * 83}"
//                               : "",
//                           "categoryPath": items[index]['category']
//                               ['categoryPath'],
//                           "thumbnailUrl": items[index]['imageInfo']
//                               ['thumbnailUrl'],
//                           "imageId": items[index]['imageInfo']['id'],
//                           "sellerId": 'zx7of5rXf5Nh9EZtbNytomgB9HC2',
//                           "sellerName": 'krunal',
//                           "variantCount": items[index]['variantCount'] ?? "",
//                           "orderLimit": items[index]['orderLimit'],
//                           "deliveryTime": items[index]['shippingOption']
//                               ['slaTier'],
//                           'size': ""
//                         });
//                         Auth.productRef
//                             .doc(items[index]['usItemId'])
//                             .update({'size': ""});
//                       }
//                       return Card(
//                         margin: const EdgeInsets.all(10),
//                         child: ListTile(
//                           title: Text(items[index]["name"] ?? 'No Data'),
//                           subtitle: Text(items[index]['usItemId'] ?? 'NO Data'),
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               : Container()
//         ],
//       ),
//     ));
//   }
// }
//
// // import 'package:flutter/material.dart';
// //
// // import 'controller/auth.dart';
// //
// // class UploadProducts extends StatefulWidget {
// //   const UploadProducts({super.key});
// //
// //   @override
// //   State<UploadProducts> createState() => _UploadProductsState();
// // }
// //
// // class _UploadProductsState extends State<UploadProducts> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder(
// //         stream: Auth.shopManagerRef
// //             .doc('Oe7SjsoqWFMCamEymTV685C0Evh1')
// //             .collection('shop')
// //             .doc('Oe7SjsoqWFMCamEymTV685C0Evh1')
// //             .collection('products')
// //             .snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.hasData) {
// //             return Scaffold(
// //               appBar: AppBar(
// //                 title: Text('Upload'),
// //               ),
// //               body: ListView.builder(
// //                 itemCount: snapshot.data!.docs.length,
// //                   itemBuilder: (context, index) {
// //                     final proId = snapshot.data!.docs[index]['usItemId'];
// //                     print(proId);
// //                     return ListTile(
// //                       title: Text('Upload'),
// //                       onTap: () async{
// //                         await  Auth.productRef.doc(proId.toString()).set({
// //                           'name': snapshot.data!.docs[index]['name'],
// //                           'usItemId': snapshot.data!.docs[index]['usItemId'],
// //                           'price': snapshot.data!.docs[index]['price'],
// //                           'variantPriceString': snapshot.data?.docs[index]['price'] ?? "",
// //                           "categoryPath": snapshot.data!.docs[index]['categoryPath'],
// //                           "categoryPathId": "",
// //                           "availabilityStatus": "IN_STOCK",
// //                           "thumbnailUrl": snapshot.data!.docs[index]['thumbnailUrl'],
// //                           "imageId": snapshot.data?.docs[index]['imageId'] ?? "",
// //                           "imageName": "",
// //                           "sellerId": snapshot.data!.docs[index]['sellerId'],
// //                           "sellerName": snapshot.data?.docs[index]['sellerName'] ?? "",
// //                           "variantCount": snapshot.data!.docs[index]['variantCount'] ?? 0,
// //                           "orderLimit": snapshot.data!.docs[index]['orderLimit'] ?? 0,
// //                           "deliveryTime": snapshot.data!.docs[index]['deliveryTime'] ?? "",
// //                           "uploadedBy" : 'Shop Manager'
// //                         });
// //                       },
// //                     );
// //                   },),
// //             );
// //           } else {
// //             return Center(child: CircularProgressIndicator());
// //           }
// //         });
// //   }
// // }
//
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// //
// // import 'controller/auth.dart';
// // import 'dart:math';
// //
// // class Simple extends StatefulWidget {
// //   const Simple({super.key});
// //
// //   @override
// //   State<Simple> createState() => _SimpleState();
// // }
// //
// // class _SimpleState extends State<Simple> {
// //   String? shopManagerId, productId;
// //   List size = ['S', 'M', 'L', 'XL', 'XXL'];
// //   List shoe = ['5', '6', '7', '8', '9', '10'];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: TextButton(
// //           child: Text("hello"),
// //           onPressed: () async {
// //             List<Map<String, dynamic>> documentsData = [];
// //             await Auth.shopManagerRef.get().then(
// //               (QuerySnapshot querySnapshot) async {
// //                 for (QueryDocumentSnapshot documentSnapshot
// //                     in querySnapshot.docs) {
// //                   Map<String, dynamic> keyValuePairs =
// //                       documentSnapshot.data() as Map<String, dynamic>;
// //                   shopManagerId = keyValuePairs['uid'];
// //                   bool exist =
// //                       await checkSubcollectionExistence(shopManagerId!);
// //                   print('ddddddd${exist}-----------${shopManagerId}');
// //                   if (exist) {
// //                     await Auth.shopManagerRef
// //                         .doc(shopManagerId)
// //                         .collection('shop')
// //                         .doc(shopManagerId)
// //                         .collection('products')
// //                         .get()
// //                         .then((QuerySnapshot querySnapshot) async {
// //                       for (QueryDocumentSnapshot documentSnapshot
// //                           in querySnapshot.docs) {
// //                         Map<String, dynamic> keyValuePairs =
// //                             documentSnapshot.data() as Map<String, dynamic>;
// //                         productId = keyValuePairs['usItemId'];
// //                         if (keyValuePairs['categoryPath']
// //                                 .toString()
// //                                 .toLowerCase()
// //                                 .contains('shoe') ||
// //                             keyValuePairs['categoryPath']
// //                                 .toString()
// //                                 .toLowerCase()
// //                                 .contains('foot')) {
// //                           int min = 0;
// //                           int max = 5;
// //
// //                           // Create an instance of the Random class
// //                           Random random = Random();
// //
// //                           // Generate a random number within the specified range
// //                           int randomNumber =
// //                               min + random.nextInt(max - min + 1);
// //
// //                           // Print the generated random number
// //                           print(
// //                               "Random number between $min and $max: $randomNumber");
// //                           await Auth.shopManagerRef
// //                               .doc(shopManagerId)
// //                               .collection('shop')
// //                               .doc(shopManagerId)
// //                               .collection('products')
// //                               .doc(productId)
// //                               .set({'size': randomNumber});
// //                         } else if (keyValuePairs['categoryPath']
// //                             .toString()
// //                             .toLowerCase()
// //                             .contains('cloth')) {
// //                           int min = 0;
// //                           int max = 4;
// //
// //                           // Create an instance of the Random class
// //                           Random random = Random();
// //
// //                           // Generate a random number within the specified range
// //                           int randomNumber =
// //                               min + random.nextInt(max - min + 1);
// //
// //                           // Print the generated random number
// //                           print(
// //                               "Random number between $min and $max: $randomNumber");
// //                           await Auth.shopManagerRef
// //                               .doc(shopManagerId)
// //                               .collection('shop')
// //                               .doc(shopManagerId)
// //                               .collection('products')
// //                               .doc(productId)
// //                               .set({'size': randomNumber});
// //                         } else {
// //                           await Auth.shopManagerRef
// //                               .doc(shopManagerId)
// //                               .collection('shop')
// //                               .doc(shopManagerId)
// //                               .collection('products')
// //                               .doc(productId)
// //                               .set({'size': ""});
// //                         }
// //                         print(
// //                             'productId=============${productId}---------${shopManagerId}');
// //                       }
// //                     });
// //                   }
// //                 }
// //               },
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<bool> checkSubcollectionExistence(String shopManagerId) async {
// //     final CollectionReference mainCollection = Auth.shopManagerRef;
// //     final DocumentReference document = mainCollection.doc(shopManagerId);
// //     final CollectionReference subCollection1 = document.collection('shop');
// //     try {
// //       final QuerySnapshot querySnapshot1 = await subCollection1.get();
// //       return querySnapshot1.docs.isNotEmpty;
// //     } catch (e) {
// //       return false;
// //     }
// //   }
// // }
