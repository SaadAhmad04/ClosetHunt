import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/constant/widget/roundButton.dart';
import 'package:mall/screens/customer/booking/parlor/payment.dart';
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
  bool showAddress = true;
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  bool loading = false;
  var _razorPay = Razorpay();
  String? rec;
  String? uid;
  final List<String> tokens = [];
  var a;
  String appManagerToken = "";
  Stream<QuerySnapshot>? stream;
  final List<String> shopManagerTokens = [];
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
        'productName': widget.productList![i].name,
        'productImage': widget.productList![i].image,
        'productPrice': widget.productList![i].price,
        'quantity': widget.productList![i].quantity,
        'amount': widget.productList![i].perprice,
        'mode': _receiveOrder.toString().split(".").last,
        'address': addressController.text,
        'cancelled': false,
        'assigned': false,
        'delivered': false
      });
      await Auth.productRef.doc(widget.productList![i].productId).update({
        'orderLimit': widget.productList![i].orderLimit! -
            widget.productList![i].quantity!
      });
    }
    await FirebaseApi.myNotification(name!, appManagerToken, msg!, userId!,
        phoneController.text, email!, uid!,
        amount: widget.total,
        mode: _receiveOrder.toString().split(".").last,
        orderId: dateTime,
        productModel: widget.productList,
        address: addressController.text);
    if (widget.id?.length != null) {
      await FirebaseApi.shopNotification(name!, shopManagerTokens, msg!,
          userId!, phoneController.text, email!, widget.id!,
          productModel: widget.productList,
          mode: _receiveOrder.toString().split(".").last,
          orderId: dateTime);
    } else {
      await FirebaseApi.shopNotification(name!, shopManagerTokens,
          msg.toString(), userId!, phone!, email!, sellerIdsList,
          productModel: widget.productList,
          mode: _receiveOrder.toString().split(".").last,
          orderId: dateTime);
    }
    //}
    setState(() {
      loading = false;
    });
    Utilities().showMessage('Order placed');
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyOrders()), (route) => false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
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
    print('map = ==============${widget.productList}');
    print('maps = ==============${widget.singleSellerId}');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: widget.singleSellerId != null
          ? SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                height: mq.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                  ),
                  fit: BoxFit.fill,
                )),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: mq.height * .02, left: mq.width * .035),
                          height: mq.height * .1,
                          child: ClipOval(
                            child: Image.asset("images/app_icon.jpeg"),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: stream,
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  shopManagerTokens.add(data['token']);
                                  return SizedBox();
                                }).toList(),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              print("adfhasfha;klfh");
                              return Text("sorry");
                            }
                          },
                        ),
                        StreamBuilder(
                          stream: Auth.appManagerRef.snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              print(snapshot.data!.docs.length);
                              return ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  // Access data from the document using document.data() method
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  appManagerToken = data['token'];
                                  uid = data['uid'];
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'How do you want to receive your order ?',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: mq.height * .01,
                                        ),
                                        RadioListTile(
                                            secondary:
                                                Icon(Icons.delivery_dining),
                                            title: Text('Home Delivery'),
                                            value: ReceiveOrder.homeDelivery,
                                            groupValue: _receiveOrder,
                                            onChanged: (val) {
                                              setState(() {
                                                showAddress = true;
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
                                                showAddress = false;
                                                _receiveOrder = val;
                                              });
                                            }),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: StreamBuilder(
                                    stream: Auth.customerRef
                                        .where('uid',
                                            isEqualTo:
                                                Auth.auth.currentUser!.uid)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            name = snapshot.data!.docs[index]
                                                ['name'];
                                            userId = snapshot.data!.docs[index]
                                                ['uid'];
                                            phone = snapshot
                                                .data!.docs[index]['phone']
                                                .toString();
                                            email = snapshot.data!.docs[index]
                                                ['email'];
                                            msg = "New Order Request!!!";
                                            tok = snapshot.data!.docs[index]
                                                ['token'];
                                            sellerIdsList.add(widget
                                                .singleSellerId
                                                .toString());
                                            return Column(
                                              children: [
                                                // Image.asset(
                                                //   'images/trolley.gif',
                                                //   height: mq.height * .25,
                                                //   width: mq.width * .5,
                                                // ),
                                                TextField(
                                                  controller: phoneController,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  decoration: InputDecoration(
                                                      enabled: true,
                                                      hoverColor: Colors.purple,
                                                      focusColor: Colors.purple,
                                                      suffixIconColor: Colors
                                                          .purple,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .purple)),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      hintText:
                                                          'Enter phone number',
                                                      suffixIcon:
                                                          Icon(Icons.phone)),
                                                ),
                                                SizedBox(
                                                  height: mq.height * .025,
                                                ),
                                                showAddress
                                                    ? TextField(
                                                        controller:
                                                            addressController,
                                                        minLines: 3,
                                                        maxLines: 3,
                                                        decoration: InputDecoration(
                                                            enabled: true,
                                                            hoverColor:
                                                                Colors.purple,
                                                            focusColor:
                                                                Colors.purple,
                                                            suffixIconColor:
                                                                Colors.purple,
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .purple)),
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            hintText:
                                                                'Enter complete address',
                                                            suffixIcon: Icon(
                                                                Icons.home)),
                                                      )
                                                    : SizedBox(),
                                                SizedBox(
                                                  height: mq.height * .05,
                                                ),
                                                RoundButton(
                                                    loading: loading,
                                                    title:
                                                        'Pay Rs.${widget.total.toStringAsFixed(2)}',
                                                    onTap: () async {
                                                      if (phoneController
                                                              .text ==
                                                          "") {
                                                        Utilities().showMessage(
                                                            'Please enter your phone number');
                                                      } else {
                                                        if (showAddress &&
                                                            addressController
                                                                    .text ==
                                                                "") {
                                                          Utilities().showMessage(
                                                              'Please enter your address');
                                                        } else {
                                                          setState(() {
                                                            loading = true;
                                                          });
                                                          var options = {
                                                            'key':
                                                                'rzp_test_hsfoAtMk3TFoZA',
                                                            'amount':
                                                                (widget.total *
                                                                        100)
                                                                    .round(),
                                                            'name':
                                                                'ClosetHunt',
                                                            'description':
                                                                'Fine T-Shirt',
                                                            'timeout': 120,
                                                          };
                                                          try {
                                                            _razorPay
                                                                .open(options);
                                                          } on Exception catch (e) {
                                                            Utilities()
                                                                .showMessage(e
                                                                    .toString());
                                                          }
                                                        }
                                                      }
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              height: mq.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                  "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                ),
                fit: BoxFit.fill,
              )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.id!.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder(
                              stream: Auth.shopManagerRef
                                  .doc(widget.id![index])
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  shopManagerTokens
                                      .add(snapshot.data!['token']);
                                  return SizedBox();
                                } else {
                                  return Text("sorry");
                                }
                              });
                        }),
                    StreamBuilder(
                      stream: Auth.appManagerRef.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data!.docs.length);
                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              appManagerToken = data['token'];
                              uid = data['uid'];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
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
                                          showAddress = true;
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
                                          showAddress = false;
                                          _receiveOrder = val;
                                        });
                                      }),
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          print("sorry");
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        //color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            StreamBuilder(
                              stream: Auth.customerRef
                                  .where('uid',
                                      isEqualTo: Auth.auth.currentUser!.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      name = snapshot.data!.docs[index]['name'];
                                      userId =
                                          snapshot.data!.docs[index]['uid'];
                                      phone = snapshot
                                          .data!.docs[index]['phone']
                                          .toString();
                                      email =
                                          snapshot.data!.docs[index]['email'];
                                      msg = "New Order Request!!!";
                                      tok = snapshot.data!.docs[index]['token'];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: phoneController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  hintText:
                                                      'Enter phone number',
                                                  suffixIcon:
                                                      Icon(Icons.phone)),
                                            ),
                                            SizedBox(
                                              height: mq.height * .025,
                                            ),
                                            showAddress
                                                ? TextField(
                                                    controller:
                                                        addressController,
                                                    minLines: 3,
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        hintText:
                                                            'Enter complete address',
                                                        suffixIcon:
                                                            Icon(Icons.home)),
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              height: mq.height * .05,
                                            ),
                                            RoundButton(
                                              //colors: Colors.brown,
                                              loading: loading,
                                              title:
                                                  'Pay Rs.${widget.total.toStringAsFixed(2)}',
                                              onTap: () async {
                                                if (phoneController.text ==
                                                    "") {
                                                  Utilities().showMessage(
                                                      'Please enter your phone number');
                                                } else {
                                                  if (showAddress &&
                                                      addressController.text ==
                                                          "") {
                                                    Utilities().showMessage(
                                                        'Please enter your address');
                                                  } else {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    var options = {
                                                      'key':
                                                          'rzp_test_hsfoAtMk3TFoZA',
                                                      'amount':
                                                          (widget.total * 100)
                                                              .round(),
                                                      'name': 'ClosetHunt',
                                                      'description':
                                                          'Fine T-Shirt',
                                                      'timeout': 120,
                                                    };
                                                    try {
                                                      _razorPay.open(options);
                                                    } on Exception catch (e) {
                                                      Utilities().showMessage(
                                                          e.toString());
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
