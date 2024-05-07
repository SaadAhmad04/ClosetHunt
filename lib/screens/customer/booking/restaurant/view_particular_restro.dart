import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mall/constant/widget/roundButton.dart';
import 'package:mall/screens/customer/booking/restaurant/reserve_seat.dart';
import 'package:mall/screens/customer/my_payments.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/utils/utilities.dart';
import '../../../../controller/auth.dart';
import '../../../../controller/firebase_api.dart';
import '../../../../main.dart';

class ViewParticularRestro extends StatefulWidget {
  final shopName;
  final shopManagerId;
  final reserveStatus;
  final shopIcon;

  ViewParticularRestro({
    super.key,
    required this.shopManagerId,
    required this.shopName,
    required this.reserveStatus,
    this.shopIcon,
  });

  @override
  State<ViewParticularRestro> createState() => _ViewParticularRestroState();
}

class _ViewParticularRestroState extends State<ViewParticularRestro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List shopManagerToken = [];
  List shopManagerId = [];
  String? appManagerId, appManagerToken;
  double? tamount;
  bool loading = false;
  final billController = TextEditingController();
  final phoneController = TextEditingController();
  var _razorPay = Razorpay();
  Stream? stream;
  late PageController _pageController;
  int _currentIndex = 0;
  List<Widget> carousalItems = [];
  final CarouselController _carouselController = CarouselController();

  void _startAutoPlay() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        if (_currentIndex < carousalItems.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0;
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoPlay() {}

  void initState() {
    super.initState();
    _pageController = PageController();
    stream = Auth.shopManagerRef
        .doc(widget.shopManagerId)
        .collection('restaurant')
        .doc(widget.shopManagerId)
        .collection('details')
        .doc(widget.shopManagerId)
        .snapshots();
    _startAutoPlay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _controller = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 20, end: 250).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCirc,
      ),
    );

    _controller.repeat(reverse: true); // Start the animation
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      loading = true;
    });
    final pref = await SharedPreferences.getInstance();
    String? name = await pref.getString('name');
    String? email = await pref.getString('email');
    final dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    await Auth.customerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('payments')
        .doc(dateTime)
        .set({
      'paymentId': dateTime,
      'amount': tamount,
      'customerId': Auth.auth.currentUser!.uid,
      'customerName': name,
      'email': email,
      'phone': phoneController.text,
      'shopId': widget.shopManagerId,
      'shopName': widget.shopName,
      'shopIcon': widget.shopIcon
    });
    final snapshot = await Auth.shopManagerRef.doc(widget.shopManagerId).get();
    shopManagerToken.add(snapshot.data()?['token']);
    shopManagerId.add(widget.shopManagerId);
    await Auth.appManagerRef.get().then(
          (QuerySnapshot querySnapshot) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> keyValuePairs =
          documentSnapshot.data() as Map<String, dynamic>;
          appManagerId = keyValuePairs['uid'];
          appManagerToken = keyValuePairs['token'];
        }
      },
    );
    await FirebaseApi.myNotification(name!, appManagerToken!, 'Paid',
        Auth.auth.currentUser!.uid, phoneController.text, email!, appManagerId!,
        restaurant: true,
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: tamount,
        shopId: widget.shopManagerId,
        reserve: false,
        bookingId: DateTime.now().millisecondsSinceEpoch.toString());
    await FirebaseApi.shopNotification(name, shopManagerToken, 'Paid',
        Auth.auth.currentUser!.uid, phoneController.text, email, shopManagerId,
        shopId: widget.shopManagerId,
        bookingId: DateTime.now().millisecondsSinceEpoch.toString(),
        restaurant: true,
        amount: tamount,
        date: DateTime.now().millisecondsSinceEpoch.toString());
    setState(() {
      loading = false;
    });
    Utilities().showMessage('Completed');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyPayments()),
            (route) => false);
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
    _controller.dispose(); // Stop the animation
    _stopAutoPlay();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          carousalItems.clear();
          for (int i = 0; i < snapshot.data?['imageList'].length; i++) {
            carousalItems.add(Image.network(snapshot.data?['imageList'][i]));
          }
          return Scaffold(
            backgroundColor: Colors.brown[900],
            //backgroundColor: Color(0xffa78787),
            body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: mq.height * 2,
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.network(
                          "https://c4.wallpaperflare.com/wallpaper/407/764/990/restaurant-cafes-urban-city-wallpaper-preview.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20)),
                          child: carousalItems.length > 0
                              ? CarouselSlider(
                            items: carousalItems,
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              autoPlay: true,
                              viewportFraction: 2.0,
                              height: 200,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          )
                              : SizedBox(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10),
                        child: Center(
                            child: Text(
                              widget.shopName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            )),
                      ),
                      SizedBox(
                        height: mq.height / 98,
                      ),
                      Text(
                        "Menu",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Container(
                        height: mq.height / 3.5,
                        decoration: BoxDecoration(
                            color: Color(0xffd4d2d3),
                            borderRadius: BorderRadius.circular(20)),
                        child: snapshot.data!['menuList'].length > 0
                            ? GridView.builder(
                          scrollDirection: Axis.vertical,
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              crossAxisCount: 3),
                          itemCount: snapshot.data?['menuList'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showDisplayImage(context,
                                    snapshot.data?['menuList'][index]);
                              },
                              child: Container(
                                child: Image.network(
                                    snapshot.data?['menuList'][index]),
                              ),
                            );
                          },
                        )
                            : Container(
                            width: 500,
                            child:
                            Center(child: Text("Menu Not Uploaded"))),
                      ),
                      SizedBox(
                        height: mq.height / 88,
                      ),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            height: _animation.value / 2,
                            width: _animation.value * 2,
                            child: Card(
                              color: Colors.transparent,
                              elevation: _animation.value,
                              shadowColor: Colors.purple,
                              child: Center(
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  enabled: widget.reserveStatus == true
                                      ? true
                                      : false,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReserveSeat(
                                            lunchTime:
                                            snapshot.data?['lunchTime'],
                                            dinnerTime:
                                            snapshot.data?['dinnerTime'],
                                            shopId: widget.shopManagerId,
                                            shopName: widget.shopName,
                                          ),
                                        ));
                                  },
                                  tileColor: Color(0xFFC8A2C8),
                                  title: Center(
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return LinearGradient(
                                          colors: [Colors.pink, Colors.black],
                                        ).createShader(bounds);
                                      },
                                      child: Text(
                                        'Reserve Table',
                                        style: TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: mq.height / 98,
                      ),
                      snapshot.data?['offerList'].length > 0
                          ? Text(
                        "Offers",
                        style: TextStyle(color: Colors.white),
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 2,
                      ),
                      Expanded(
                        child: snapshot.data?['offerList'].length > 0
                            ? ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?['offerList'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                color: Colors.grey,
                                height: mq.height / 8,
                                child: Image.network(
                                  snapshot.data?['offerList'][index],
                                  fit: BoxFit.cover,
                                  height: mq.height / 2,
                                ),
                              ),
                            );
                          },
                        )
                            : SizedBox(),
                      ),
                      MaterialButton(
                        onPressed: () {
                          payBill(context);
                        },
                        color: Color(0xFFC8A2C8),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [Colors.pink, Colors.black],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'Pay Your Bill To Get 15% Off',
                            style: TextStyle(
                              //fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> showDisplayImage(
      BuildContext context,
      String imageUrl,
      ) {
    return showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xffd4d2d3),
            shadowColor: Colors.black,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: SizedBox(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.greenAccent,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          );
        });
  }

  Future<void> payBill(
      BuildContext context,
      ) {
    //Size mq = MediaQuery.of(context).size;
    return showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (context, setModalState) {
                return SizedBox(
                    height: mq.height * .4,
                    width: mq.width - 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: billController,
                          maxLines: 2,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$'),
                            ),
                          ],
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.currency_rupee),
                              prefixIconColor: Colors.purple,
                              hintText: "Enter Amount as per your Bill",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        SizedBox(height: mq.height * .05),
                        TextFormField(
                          controller: phoneController,
                          maxLines: 2,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              prefixIconColor: Colors.purple,
                              hintText: "Enter phone number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        //SizedBox(height: mq.height * .05),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: RoundButton(
                            colors: Color(0xff974C7C),
                              loading: loading,
                              title: "Pay",
                              onTap: () async {
                                if (phoneController.text != "" &&
                                    billController.text != "") {
                                  setState(() {
                                    loading=true;
                                  });
                                  double amount = (int.parse(
                                      billController.text.toString()) *
                                      15 /
                                      100);
                                  tamount = int.parse(
                                      billController.text.toString()) -
                                      amount;
                                  var options = {
                                    'key': 'rzp_test_hsfoAtMk3TFoZA',
                                    'amount': (tamount! * 100).round(),
                                    'name': 'ClosetHunt',
                                    'description': 'From ${widget.shopName}',
                                    'timeout': 120,
                                  };
                                  try {
                                    _razorPay.open(options);
                                  } on Exception catch (e) {
                                    Utilities().showMessage(e.toString());
                                  }
                                } else {
                                  Utilities()
                                      .showMessage("Can't have empty field(s)");
                                }
                              }),
                        )
                      ],
                    ));
              },
            ),
          );
        });
  }
}