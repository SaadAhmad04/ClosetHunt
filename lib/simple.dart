import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller/auth.dart';

class Simple extends StatefulWidget {
  const Simple({super.key});

  @override
  State<Simple> createState() => _SimpleState();
}

class _SimpleState extends State<Simple> {
  List items = [];
  // List<dynamic> badges = [];

// Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/skincare.json');
    final data = await json.decode(response);
    setState(() {
      items = data["products"];
      // badges = data['priceInfo'];
    });
    print('sucess');
    // print(items);
  }

  List promises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          ElevatedButton(
            child: const Text('Load Data'),
            onPressed: () {
              readJson();
            },
          ),

          // Display the data loaded from sample.json
          items.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      if (items.isNotEmpty) {
                        print(items[index]['usItemId']);
                        Auth.productRef
                            .doc(items[index]['usItemId'] ?? "ID1")
                            .set({
                          'name': items[index]['name'],
                          'usItemId': items[index]['usItemId'],
                          'price':
                              "${items[index]['priceInfo']['currentPrice']['price'] * 83}",
                          'variantPriceString': items[index]['priceInfo']
                                      ['currentPrice']['variantPriceString'] !=
                                  null
                              ? "${double.parse(items[index]['priceInfo']['currentPrice']['variantPriceString'].toString().substring(1)) * 83}"
                              : "",
                          "categoryPath": items[index]['category']
                              ['categoryPath'],
                          "thumbnailUrl": items[index]['imageInfo']
                              ['thumbnailUrl'],
                          "imageId": items[index]['imageInfo']['id'],
                          "sellerId": 'zx7of5rXf5Nh9EZtbNytomgB9HC2',
                          "sellerName": 'krunal',
                          "variantCount": items[index]['variantCount'] ?? "",
                          "orderLimit": items[index]['orderLimit'],
                          "deliveryTime": items[index]['shippingOption']
                              ['slaTier'],
                        });

                        Auth.shopManagerRef
                            .doc('zx7of5rXf5Nh9EZtbNytomgB9HC2')
                            .collection('shop')
                            .doc('zx7of5rXf5Nh9EZtbNytomgB9HC2').collection('products')
                            .doc(items[index]['usItemId'] ?? "ID1")
                            .set({
                          'name': items[index]['name'],
                          'usItemId': items[index]['usItemId'],
                          'price':
                              "${items[index]['priceInfo']['currentPrice']['price'] * 83}",
                          'variantPriceString': items[index]['priceInfo']
                                      ['currentPrice']['variantPriceString'] !=
                                  null
                              ? "${double.parse(items[index]['priceInfo']['currentPrice']['variantPriceString'].toString().substring(1)) * 83}"
                              : "",
                          "categoryPath": items[index]['category']
                              ['categoryPath'],
                          "thumbnailUrl": items[index]['imageInfo']
                              ['thumbnailUrl'],
                          "imageId": items[index]['imageInfo']['id'],
                          "sellerId": 'zx7of5rXf5Nh9EZtbNytomgB9HC2',
                          "sellerName": 'krunal',
                          "variantCount": items[index]['variantCount'] ?? "",
                          "orderLimit": items[index]['orderLimit'],
                          "deliveryTime": items[index]['shippingOption']
                              ['slaTier'],
                        });
                      }
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(items[index]["name"] ?? 'No Data'),
                          subtitle: Text(items[index]['usItemId'] ?? 'NO Data'),
                        ),
                      );
                    },
                  ),
                )
              : Container()
        ],
      ),
    ));
  }
}

// import 'package:flutter/material.dart';
//
// import 'controller/auth.dart';
//
// class UploadProducts extends StatefulWidget {
//   const UploadProducts({super.key});
//
//   @override
//   State<UploadProducts> createState() => _UploadProductsState();
// }
//
// class _UploadProductsState extends State<UploadProducts> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Auth.shopManagerRef
//             .doc('Oe7SjsoqWFMCamEymTV685C0Evh1')
//             .collection('shop')
//             .doc('Oe7SjsoqWFMCamEymTV685C0Evh1')
//             .collection('products')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('Upload'),
//               ),
//               body: ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final proId = snapshot.data!.docs[index]['usItemId'];
//                     print(proId);
//                     return ListTile(
//                       title: Text('Upload'),
//                       onTap: () async{
//                         await  Auth.productRef.doc(proId.toString()).set({
//                           'name': snapshot.data!.docs[index]['name'],
//                           'usItemId': snapshot.data!.docs[index]['usItemId'],
//                           'price': snapshot.data!.docs[index]['price'],
//                           'variantPriceString': snapshot.data?.docs[index]['price'] ?? "",
//                           "categoryPath": snapshot.data!.docs[index]['categoryPath'],
//                           "categoryPathId": "",
//                           "availabilityStatus": "IN_STOCK",
//                           "thumbnailUrl": snapshot.data!.docs[index]['thumbnailUrl'],
//                           "imageId": snapshot.data?.docs[index]['imageId'] ?? "",
//                           "imageName": "",
//                           "sellerId": snapshot.data!.docs[index]['sellerId'],
//                           "sellerName": snapshot.data?.docs[index]['sellerName'] ?? "",
//                           "variantCount": snapshot.data!.docs[index]['variantCount'] ?? 0,
//                           "orderLimit": snapshot.data!.docs[index]['orderLimit'] ?? 0,
//                           "deliveryTime": snapshot.data!.docs[index]['deliveryTime'] ?? "",
//                           "uploadedBy" : 'Shop Manager'
//                         });
//                       },
//                     );
//                   },),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         });
//   }
// }
