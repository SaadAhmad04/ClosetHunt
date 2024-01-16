import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as Flutter;
import '../../controller/auth.dart';

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
                appBar: AppBar(
                  title: Text(widget.usItemId.toString()),
                ),
                body: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 150),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Card(
                            child: Flutter.Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Name: ${snapshot.data!.docs[index]['name']} '),
                                Text(
                                    'Product Id : ${snapshot.data!.docs[index]['usItemId']}'),
                                Text(
                                    'Price: ${snapshot.data!.docs[index]['price']}'),
                                Text(
                                    'Image Id: ${snapshot.data!.docs[index]['price']}'),
                                Text(
                                    'Order Limit: ${snapshot.data!.docs[index]['orderLimit'].toString()}'),
                                Text(
                                    'ThumbNail Url: ${snapshot.data!.docs[index]['thumbnailUrl']}'),
                                Text(
                                    'Seller Id: ${snapshot.data!.docs[index]['sellerId']}'),
                                Text(
                                    'Seller Name: ${snapshot.data!.docs[index]['sellerName']}'),
                                Text(
                                    'Variant Count: ${snapshot.data!.docs[index]['variantCount'].toString()}'),
                                Text(
                                    'Variant Price String: ${snapshot.data!.docs[index]['variantPriceString']}'),
                                Text(
                                    'Delivery Time: ${snapshot.data!.docs[index]['deliveryTime']}'),
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