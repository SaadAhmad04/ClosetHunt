import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/customer/shopping/cart_bill.dart';
import 'package:mall/screens/customer/shopping/single_product_bill.dart';
import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';
import 'package:collection/collection.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key});

  @override
  State<ViewCart> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  Stream? stream;
  List<double> perpriceList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Change();
  }

  void Change() {
    stream = Auth.customerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('carts')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Summary'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data!.docs.length.toString());
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                //id.add(snapshot.data.docs[index]['sellerId']);
                int quantity = snapshot.data!.docs[index]['quantity'];
                double price =
                    double.parse(snapshot.data!.docs[index]['price']);
                double perprice = snapshot.data!.docs[index]['perprice'];
                if (perpriceList.length == snapshot.data!.docs.length) {
                  print('hi');
                } else {
                  perpriceList.add(perprice);
                }
                print('Perprice = ${perprice}');
                total += perprice;
                print('Total = ${total}');
                print('Perprice list = ${perpriceList}');
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleProductBill(
                                    productId: snapshot.data!.docs[index]
                                        ['productId'],
                                  )));
                    },
                    child: Card(
                      elevation: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Image.network(
                                snapshot.data!.docs[index]['image']),
                            title: Text(snapshot.data!.docs[index]['name']
                                .toString()
                                .substring(0, 15)),
                            subtitle: Text(
                                'Quantity: ${snapshot.data!.docs[index]['quantity']}'),
                            trailing: Container(
                              height: 30,
                              width: 140,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  color: Colors.blueGrey),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        if (quantity == 1) {
                                          await Auth.customerRef
                                              .doc(Auth.auth.currentUser!.uid)
                                              .collection('carts')
                                              .doc(snapshot.data!.docs[index]
                                                  ['productId'])
                                              .delete();
                                          perpriceList.clear();
                                        } else {
                                          quantity = quantity - 1;
                                          perprice = 0;
                                          total = 0;
                                          perpriceList.clear();
                                          perprice = price * quantity;
                                          await Auth.customerRef
                                              .doc(Auth.auth.currentUser!.uid)
                                              .collection('carts')
                                              .doc(snapshot.data!.docs[index]
                                                  ['productId'])
                                              .update({
                                            'quantity': quantity,
                                            'perprice': perprice,
                                          });
                                        }
                                        Change();
                                        setState(() {});
                                      },
                                      child: Text(
                                        '-',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  Text('${quantity}',
                                      style: TextStyle(color: Colors.white)),
                                  TextButton(
                                      onPressed: () async {
                                        quantity += 1;
                                        perprice = 0;
                                        total = 0;
                                        perpriceList.clear();
                                        perprice = price * quantity;
                                        await Auth.customerRef
                                            .doc(Auth.auth.currentUser!.uid)
                                            .collection('carts')
                                            .doc(snapshot.data!.docs[index]
                                                ['productId'])
                                            .update(
                                          {
                                            'quantity': quantity,
                                            'perprice': perprice
                                          },
                                        );
                                        Change();
                                        setState(() {});
                                      },
                                      child: Text('+',
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              margin: EdgeInsets.only(left: mq.width * 0.20),
                              child: Text(
                                'Item Price: Rs. ${snapshot.data!.docs[index]['price'].toString()}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              margin: EdgeInsets.only(left: mq.width * 0.20),
                              child: Text(
                                  'Total Price: ${snapshot.data!.docs[index]['perprice'].toString()}',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ),
                          ListTile(
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: TextButton.icon(
                                  onPressed: () {
                                    Auth.customerRef
                                        .doc(Auth.auth.currentUser!.uid)
                                        .collection('carts')
                                        .doc(snapshot.data!.docs[index]
                                            ['productId'])
                                        .delete();
                                    Utilities().showMessage(
                                        "Item Removed from the cart");
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              // children: snapshot.data!.docs.map((DocumentSnapshot document) {
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("No products added"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Container(
              height: 45,
              width: 170,
              decoration: BoxDecoration(
                  color: Colors.orange.shade500,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: perpriceList.sum != 0
                    ? Text(
                        'Rs. ${perpriceList.sum.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Price'),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(Icons.refresh),
                          ],
                        )),
              )),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              print(perpriceList);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartBill(
                            grandTotal: perpriceList,
                          )));
            },
            child: Container(
              height: 45,
              width: 170,
              decoration: BoxDecoration(
                  color: Colors.orange.shade500,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  'Buy Cart',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
