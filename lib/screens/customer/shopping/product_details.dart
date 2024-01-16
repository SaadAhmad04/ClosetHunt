import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/customer/shopping/view_cart.dart';

import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';
import 'customer_product_collection.dart';

class ProductDetails extends StatefulWidget {
  final Details info;

  ProductDetails({super.key, required this.info});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  MaterialColor cartColor = Colors.grey;
  bool addToCart = false;
  int count = 0;
  int currentIndex = 0;

  late Map<String, String> minDelivery;

  void minimumDelivery() async {
    await Auth.customerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('carts')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        if (doc['productId'] == widget.info.productId) {
          cartColor = Colors.orange;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: ListView(children: [
        Container(
          height: mq.height - 50,
          width: mq.width,
          child: Stack(
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
                      height: mq.height / 2.4,
                    ),
                  )),
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
                            color: Colors.orange.shade800,
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              Positioned(
                left: mq.width / 5,
                top: mq.height * .4,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(mq.width * .15)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Product Name',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Company Name',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Ratings : 4.5',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: mq.height * .001,
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
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: mq.height * .08,
                                  width: mq.width * .3,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  child: Center(
                                    child: Text('Wishlist\u2665',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                onTap: () async {
                                  setState(() async {
                                    addToCart = true;
                                    Utilities().showMessage('Added to cart');
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
                                      'productId': widget.info.productId
                                    });

                                    log(widget.info.name);
                                    log(widget.info.price);
                                    log(addToCart.toString());
                                    count = 1;
                                  });
                                },
                                child: Container(
                                  height: mq.height * .08,
                                  width: mq.width * .3,
                                  decoration: BoxDecoration(
                                    color: cartColor,
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
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
              onTap: () {
                print('sorry');
              },
              child: Container(
                height: mq.height * .07,
                width: mq.width * .35,
                decoration: BoxDecoration(
                  color: Colors.orange.shade800,
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
}
