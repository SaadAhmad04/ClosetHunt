import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/constant/widget/roundButton.dart';
import 'package:mall/screens/customer/payment.dart';
import 'package:mall/screens/shop_manager/multiple_products.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../controller/firebase_api.dart';
import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';
import '../../../model/product_model.dart';
import 'my_orders.dart';

enum ReceiveOrder { pickFromMall, homeDelivery }

class Orders extends StatefulWidget {
  final List<String>? id;
  final String? singleSellerId;
  String? productId;
  List? productIds;
  int? quantity;
  var map;
  var testing;
  final double total;
  List<ProductModel>? productList;

  Orders(
      {super.key,
      this.id,
      this.singleSellerId,
      this.productIds,
      required this.map,
      this.quantity,
      this.testing,
      required this.total,
      this.productId,
      this.productList});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool loading = false;
  var _razorPay = Razorpay();
  String? rec;
  String? uid;
  final List<String> tokens = [];
  var a;
  String appManagerToken = "";
  String uids = "";
  Stream<QuerySnapshot>? stream;
  final List<String> token = [];
  final List sellerIdsList = [];
  ReceiveOrder? _receiveOrder = ReceiveOrder.homeDelivery;
  String? name, userId, email, phone, msg, tok;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.shopManagerRef
        .where('uid', isEqualTo: widget.singleSellerId.toString())
        .snapshots();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    Utilities().showMessage('Confirming Your Order. Please Wait!!');
    if (widget.productId != null) {
      await Auth.customerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('orders')
          .doc(dateTime + 1.toString())
          .set({
        'orderId': dateTime + 1.toString(),
        'customerId': Auth.auth.currentUser!.uid,
        'sellerId': widget.singleSellerId.toString(),
        'productId': widget.productId.toString(),
        'amount': widget.total,
        'cancelled': false,
        'mode': _receiveOrder.toString().split(".").last,
        'assigned':false,
        'delivered':false
      });
      await FirebaseApi.myNotification(name!, appManagerToken!, msg.toString(),
          userId!, phone!, email!, uids!,
          amount: widget.total,
          mode: _receiveOrder.toString().split(".").last,
          productId: widget.productId,
          orderId: dateTime,
          shopId: widget.singleSellerId);
      await FirebaseApi.shopNotification(name!, token.toList(), msg.toString(),
          userId!, phone!, email!, sellerIdsList,
          productModel: widget.productList,
          mode: _receiveOrder.toString().split(".").last,
          orderId: dateTime);
    } else {
      for (int i = 0; i < widget.productList!.length; i++) {
        await Auth.customerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('orders')
            .doc(dateTime + (i + 1).toString())
            .set({
          'orderId': dateTime + (i + 1).toString(),
          'customerId': Auth.auth.currentUser!.uid,
          'sellerId': widget.productList![i].sellerId,
          'productId': widget.productList![i].productId,
          'amount': widget.productList![i].perprice,
          'mode': _receiveOrder.toString().split(".").last,
          'cancelled': false,
          'assigned':false,
          'delivered':false
        });
      }
      await FirebaseApi.myNotification(
          name!, rec!, msg!, userId!, phone!, email!, uid!,
          productId: "",
          amount: widget.total,
          mode: _receiveOrder.toString().split(".").last,
          orderId: dateTime,
          productModel: widget.productList);
      await FirebaseApi.shopNotification(
          name!, tokens, msg!, userId!, phone!, email!, widget.id!,
          productModel: widget.productList,
          mode: _receiveOrder.toString().split(".").last,
          orderId: dateTime);
    }
    setState(() {
      loading = false;
    });
    Utilities().showMessage('Order placed');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyOrders()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print('Wallet ${response.walletName}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorPay.clear();
  }

  @override
  Widget build(BuildContext context) {
    print('map = ==============${widget.singleSellerId}');
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: widget.singleSellerId != null
          ? Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            token.add(data['token']);
                            return Image.asset(
                              'images/oderr.jpg',
                              height: mq.height * .3,
                            );
                          }).toList(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return Text("sorry");
                      }
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Auth.appManagerRef.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data!.docs.length);
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            // Access data from the document using document.data() method
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            appManagerToken = data['token'];
                            uids = data['uid'];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: mq.height * .1,
                                ),
                                Text(
                                  'How do you want to receive your order ?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height: mq.height * .01,
                                ),
                                RadioListTile(
                                    secondary: Icon(Icons.delivery_dining),
                                    title: Text('Home Delivery'),
                                    value: ReceiveOrder.homeDelivery,
                                    groupValue: _receiveOrder,
                                    onChanged: (val) {
                                      setState(() {
                                        _receiveOrder = val;
                                        print(_receiveOrder
                                            .toString()
                                            .split(".")
                                            .last);
                                      });
                                    }),
                                RadioListTile(
                                    secondary: Icon(Icons.shop),
                                    title: Text('Pick from mall'),
                                    value: ReceiveOrder.pickFromMall,
                                    groupValue: _receiveOrder,
                                    onChanged: (val) {
                                      setState(() {
                                        _receiveOrder = val;
                                        print(_receiveOrder
                                            .toString()
                                            .split(".")
                                            .last);
                                      });
                                    })
                              ],
                            );
                          }).toList(),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Auth.customerRef
                        .where('uid', isEqualTo: Auth.auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            name = snapshot.data!.docs[index]['name'];
                            userId = snapshot.data!.docs[index]['uid'];
                            phone =
                                snapshot.data!.docs[index]['phone'].toString();
                            email = snapshot.data!.docs[index]['email'];
                            msg = "New Order Request!!!";
                            tok = snapshot.data!.docs[index]['token'];
                            sellerIdsList.add(widget.singleSellerId.toString());
                            print('wdfjkajcx${sellerIdsList}');
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RoundButton(
                                  loading: loading,
                                  title:
                                      'Pay Rs.${widget.total.toStringAsFixed(2)}',
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    var options = {
                                      'key': 'rzp_test_hsfoAtMk3TFoZA',
                                      'amount': (widget.total * 100).round(),
                                      'name': 'ClosetHunt',
                                      'description': 'Fine T-Shirt',
                                      'timeout': 120,
                                    };
                                    try {
                                      _razorPay.open(options);
                                    } on Exception catch (e) {
                                      Utilities().showMessage(e.toString());
                                    }
                                  }),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.id!.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: Auth.shopManagerRef
                                .doc(widget.id![index])
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                tokens.add(snapshot.data!['token']);
                                return Image.asset(
                                  'images/oderr.jpg',
                                  height: mq.height * .3,
                                );
                              } else {
                                return Text("sorry");
                              }
                            });
                      }),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Auth.appManagerRef.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data!.docs.length);
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            rec = data['token'];
                            uid = data['uid'];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: mq.height * .1,
                                ),
                                Text(
                                  'How do you want to receive your order ?',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height: mq.height * .01,
                                ),
                                RadioListTile(
                                    secondary: Icon(Icons.delivery_dining),
                                    title: Text('Home Delivery'),
                                    value: ReceiveOrder.homeDelivery,
                                    groupValue: _receiveOrder,
                                    onChanged: (val) {
                                      setState(() {
                                        _receiveOrder = val;
                                      });
                                    }),
                                RadioListTile(
                                    secondary: Icon(Icons.shop),
                                    title: Text('Pick from mall'),
                                    value: ReceiveOrder.pickFromMall,
                                    groupValue: _receiveOrder,
                                    onChanged: (val) {
                                      setState(() {
                                        _receiveOrder = val;
                                      });
                                    })
                              ],
                            );
                          }).toList(),
                        );
                      } else {
                        print("sorry");
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Auth.customerRef
                        .where('uid', isEqualTo: Auth.auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            name = snapshot.data!.docs[index]['name'];
                            userId = snapshot.data!.docs[index]['uid'];
                            phone =
                                snapshot.data!.docs[index]['phone'].toString();
                            email = snapshot.data!.docs[index]['email'];
                            msg = "New Order Request!!!";
                            tok = snapshot.data!.docs[index]['token'];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RoundButton(
                                loading: loading,
                                title:
                                    'Pay Rs.${widget.total.toStringAsFixed(2)}',
                                onTap: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  var options = {
                                    'key': 'rzp_test_hsfoAtMk3TFoZA',
                                    'amount': (widget.total * 100).round(),
                                    'name': 'ClosetHunt',
                                    'description': 'Fine T-Shirt',
                                    'timeout': 120,
                                  };
                                  try {
                                    _razorPay.open(options);
                                  } on Exception catch (e) {
                                    Utilities().showMessage(e.toString());
                                  }
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
