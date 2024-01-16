import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/customer/shopping/product_details.dart';
import 'package:mall/screens/customer/shopping/view_cart.dart';

import '../../../../../controller/auth.dart';
import '../../../constant/widget/show_error.dart';

class CustomerProductCollection extends StatefulWidget {
  final String shopManagerId;

  CustomerProductCollection({super.key, required this.shopManagerId});

  @override
  State<CustomerProductCollection> createState() =>
      _CustomerProductCollectionState();
}

class _CustomerProductCollectionState extends State<CustomerProductCollection> {
  var a;
  List product = [];

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    final double itemHeight = (mq.height - kToolbarHeight - 100) / 2;
    final double itemWidth = mq.width / 2;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    // Adjust the radius as needed
                    bottomRight:
                        Radius.circular(50.0), // Adjust the radius as needed
                  ),
                  child: Container(
                    height: mq.height * 0.29,
                    width: mq.width,
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      border: Border.all(color: Colors.white),
                    ),
                    child: Image.network(
                      "https://static.vecteezy.com/system/resources/thumbnails/022/714/667/small_2x/women-s-shoes-with-high-heels-and-paint-splatter-fashion-copyspace-background-ai-generated-photo.jpg",
                      //"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6bwI4DUybeK2CNFzR8vy7Z0lEZfuDjkEofw&usqp=CAU",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "ClosetHunt",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewCart()));
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    margin: EdgeInsets.only(top: mq.height * 0.07),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The FASHION",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 32),
                        ),
                        SizedBox(
                          height: mq.height * 0.01,
                        ),
                        Text("MUTE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 32)),
                        SizedBox(
                          height: mq.height * 0.01,
                        ),
                        Text("At one place!!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 32)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: mq.height * 0.03,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.shopManagerId,
                  //"Style your WARDROBE by our CLOSET",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: mq.height * 0.03,
            ),
            StreamBuilder(
                stream: Auth.productRef.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print("Data is ${snapshot.data}");
                  if (snapshot.hasData || snapshot.data != null) {
                    if (product.length == 0) {
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        a = snapshot.data!.docs[i];
                        if (a
                            .get('sellerId')
                            .toString()
                            .toLowerCase()
                            .contains(widget.shopManagerId.toLowerCase())) {
                          product.add(a);
                        }
                      }
                    }
                    print("Length of the product ${product.length}");
                    return Expanded(
                      child: GridView.builder(
                        itemCount: product.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        primary: false,
                        clipBehavior: Clip.hardEdge,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 300,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          String name = product[index]['name'];
                          return Container(
                            child: Details(
                              image: product[index]['thumbnailUrl'],
                              price:
                                  "Rs. ${double.parse(product[index]['price']).toStringAsFixed(2)}",
                              name: product[index]['name'],
                              index: index,
                              productId: product[index]['usItemId'],
                              deliveryTime: product[index]['deliveryTime'] ??
                                  "".toString(),
                              sellerId:
                                  product[index]['sellerId'] ?? "".toString(),
                              orderLimit: product[index]['orderLimit'],
                            ),
                          );
                        },
                      ),
                    );
                    // if (snapshot.hasData || snapshot.data != null) {
                    //   if (product.length == 0) {
                    //     for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    //       a = snapshot.data!.docs[i];
                    //       if (a
                    //           .get('categoryPath')
                    //           .toString()
                    //           .toLowerCase()
                    //           .contains(widget.shopManagerId)) {
                    //         product.add(a);
                    //       }
                    //     }
                    //   }
                    //   print("Length of the product ${product.length}");
                    //   return Expanded(
                    //     child: GridView.builder(
                    //       itemCount: product.length,
                    //       scrollDirection: Axis.vertical,
                    //       shrinkWrap: true,
                    //       physics: AlwaysScrollableScrollPhysics(),
                    //       primary: false,
                    //       clipBehavior: Clip.hardEdge,
                    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2,
                    //         crossAxisSpacing: 12,
                    //         mainAxisExtent: 300,
                    //         mainAxisSpacing: 20,
                    //       ),
                    //       itemBuilder: (context, index) {
                    //         String name = product[index]['name'];
                    //         return Container(
                    //           child: Details(
                    //             image: product[index]['thumbnailUrl'],
                    //             price:
                    //                 "Rs. ${double.parse(product[index]['price']).toStringAsFixed(2)}",
                    //             name: product[index]['name'],
                    //             index: index,
                    //             productId: product[index]['usItemId'],
                    //             deliveryTime: product[index]['deliveryTime'] ??
                    //                 "".toString(),
                    //             sellerId:
                    //                 product[index]['sellerId'] ?? "".toString(),
                    //             orderLimit: product[index]['orderLimit'],
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   );
                    // } else if (snapshot.hasError) {
                    return ShowError('No products');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ]),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final String image;
  final String price;
  final String name;
  final String productId;
  final String deliveryTime;
  final String sellerId;
  final int orderLimit;
  final int index;

  Details(
      {super.key,
      required this.image,
      required this.price,
      required this.name,
      required this.productId,
      required this.index,
      required this.deliveryTime,
      required this.sellerId,
      required this.orderLimit});

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return SizedBox(
      height: mq.height * .4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetails(info: this)));
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => CarousalProducts(productList: product, index: index,)));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Container(
                  width: mq.width,
                  child: Image.network(
                    image,
                    height: 220,
                    width: 70,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Text(
              '${name.toString().substring(0, 12)}...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              child: Text(
                price,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
