import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:mall/model/product_model.dart';
import 'package:mall/screens/customer/shopping/orders.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';

class CartBill extends StatefulWidget {
  final List<double> grandTotal;

  CartBill({super.key, required this.grandTotal});

  @override
  State<CartBill> createState() => _CartBillState();
}

class _CartBillState extends State<CartBill> {
  double finalSum = 0;
  var a, b;
  final List<String> id = [];
  List productIds = [];
  Map<String, List<String>> map = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalSum = widget.grandTotal.sum;
  }

  List<ProductModel> productList = [];
  ProductModel? productModel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.customerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('carts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (id.length == 0) {
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                a = snapshot.data!.docs[i]['sellerId'];
                b = snapshot.data!.docs[i]['productId'];
                id.add(a.toString());
                map[b.toString()] = [a.toString()];
                print('map=============== ${map}');
                Map<String, dynamic>? data = snapshot.data?.docs[i].data();
                if (data != null) {
                  String jsonString = jsonEncode(data);
                  productModel = productModelFromJson(jsonString);
                  productList.add(productModel!);
                } else {
                  print("Document is null or doesn't contain data.");
                }
                print('Prooooooooo ${productList[i].productId}');
              }
            }
            return Scaffold(
              appBar: AppBar(
                title: Text("Bill"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.grey,
                            child: ListTile(
                              visualDensity: VisualDensity(vertical: 4),
                              title: Text(
                                snapshot.data!.docs[index]['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data!.docs[index]['image'])),
                              subtitle: Text(
                                '${snapshot.data!.docs[index]['quantity']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Rs. ${snapshot.data!.docs[index]['price'].toString()}\n  per item',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  Column(
                    children: [
                      ListTile(
                        title: Text('Total Price'),
                        trailing: Text('Rs.${finalSum.toStringAsFixed(2)}'),
                      ),
                      ListTile(
                        title: Text('GST'),
                        trailing:
                            Text('Rs.${(finalSum * 0.1).toStringAsFixed(2)}'),
                      ),
                      ListTile(
                        title: Text('Total'),
                        trailing: Text(
                            'Rs.${(finalSum + finalSum * .1).toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                ]),
              ),
              bottomNavigationBar: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Orders(
                          id: id,
                          total: finalSum + finalSum * .1,
                          productIds: [productIds],
                          map: map,
                          productList: productList,
                        ),
                      ));
                },
                child: Container(
                  height: mq.height * .1,
                  width: mq.width,
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
