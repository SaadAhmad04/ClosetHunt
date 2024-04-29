// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart' as Flutter;
// import '../../controller/auth.dart';
//
// class ViewDetails extends StatefulWidget {
//   int index;
//   String? shopId;
//   String usItemId;
//
//   ViewDetails(
//       {super.key, this.shopId, required this.index, required this.usItemId});
//
//   @override
//   State<ViewDetails> createState() => _ViewDetailsState();
// }
//
// class _ViewDetailsState extends State<ViewDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Auth.shopManagerRef
//             .doc(widget.shopId == null
//             ? Auth.auth.currentUser!.uid
//             : widget.shopId)
//             .collection('shop')
//             .doc(widget.shopId == null
//             ? Auth.auth.currentUser!.uid
//             : widget.shopId)
//             .collection('products')
//             .where('usItemId', isEqualTo: widget.usItemId)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasData) {
//             return Scaffold(
//                 appBar: AppBar(
//                   title: Text(widget.usItemId.toString()),
//                 ),
//                 body: ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         margin: EdgeInsets.only(top: 150),
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Card(
//                             child: Flutter.Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                     'Name: ${snapshot.data!.docs[index]['name']} '),
//                                 Text(
//                                     'Product Id : ${snapshot.data!.docs[index]['usItemId']}'),
//                                 Text(
//                                     'Price: ${snapshot.data!.docs[index]['price']}'),
//                                 Text(
//                                     'Image Id: ${snapshot.data!.docs[index]['price']}'),
//                                 Text(
//                                     'Order Limit: ${snapshot.data!.docs[index]['orderLimit'].toString()}'),
//                                 Text(
//                                     'ThumbNail Url: ${snapshot.data!.docs[index]['thumbnailUrl']}'),
//                                 Text(
//                                     'Seller Id: ${snapshot.data!.docs[index]['sellerId']}'),
//                                 Text(
//                                     'Seller Name: ${snapshot.data!.docs[index]['sellerName']}'),
//                                 Text(
//                                     'Variant Count: ${snapshot.data!.docs[index]['variantCount'].toString()}'),
//                                 Text(
//                                     'Variant Price String: ${snapshot.data!.docs[index]['variantPriceString']}'),
//                                 Text(
//                                     'Delivery Time: ${snapshot.data!.docs[index]['deliveryTime']}'),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }));
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as Flutter;
import '../../controller/auth.dart';
import '../../main.dart';

class ViewDetails extends StatefulWidget {
  int index;
  String? shopId;
  String usItemId;

  ViewDetails(
      {super.key, this.shopId, required this.index, required this.usItemId});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.shopManagerRef
            .doc(widget.shopId == null
            ? Auth.auth.currentUser!.uid
            : widget.shopId)
            .collection('shop')
            .doc(widget.shopId == null
            ? Auth.auth.currentUser!.uid
            : widget.shopId)
            .collection('products')
            .where('usItemId', isEqualTo: widget.usItemId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.purple[50],
                appBar: AppBar(
                  backgroundColor: Colors.purple,
                  elevation: 0,
                  centerTitle: true,
                  title: Text('Product Id - ${widget.usItemId.toString()}'),
                ),
                body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 150),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            elevation: 10,
                            child: Flutter.Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: mq.height / 6,
                                    child: Image.network(
                                      snapshot.data!.docs[index]
                                      ['thumbnailUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${snapshot.data!.docs[index]['name']} ',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: mq.height / 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Price: ${snapshot.data!.docs[index]['price']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Image Id: ${snapshot.data!.docs[index]['price']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Order Limit: ${snapshot.data!.docs[index]['orderLimit'].toString()}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Seller Id: ${snapshot.data!.docs[index]['sellerId']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Seller Name: ${snapshot.data!.docs[index]['sellerName']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Variant Count: ${snapshot.data!.docs[index]['variantCount'].toString()}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Variant Price String: ${snapshot.data!.docs[index]['variantPriceString']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Delivery Time: ${snapshot.data!.docs[index]['deliveryTime']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}