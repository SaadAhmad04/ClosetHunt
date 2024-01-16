import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/customer/booking/booking_home.dart';
import 'package:mall/screens/customer/customer_profile.dart';
import 'package:mall/screens/customer/shopping/customer_shopping.dart';
import 'package:mall/screens/customer/shopping/view_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/firebase_api.dart';
import '../../constant/utils/utilities.dart';
import '../../constant/widget/show_error.dart';
import '../../controller/auth.dart';
import '../../main.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int pageIndex = 0;
  String? tok;
  final pages = [
    CustomerShopping(),
    BookingHome(),
    CustomerProfile(),
  ];
  bool showNavigationBar = false;

  Future<String> Found() async {
    final token = await FirebaseApi.initNotifications();
    print("TOKSSSM ${token}");
    return token.toString();
  }

  Future<void> getType() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('type', 'Customer');
    await pref.setString('name', name!);
    await pref.setString('email', email!);
    tok = await Found();
    print("GDFASF${tok}");
  }

  String? name, email, phone;
  Stream? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.customerRef
        .where('uid', isEqualTo: Auth.auth.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List iconList = [Icons.shopping_cart, Icons.book, Icons.person];
            return snapshot.data?.docs.length != 0
                ? Scaffold(
                    appBar: pageIndex == 2
                        ? null
                        : AppBar(
                            backgroundColor: Colors.transparent,
                            title: Text(
                              "ClosetHunt",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
                            ),
                            centerTitle: true,
                            elevation: 0.0,
                            leading: Icon(Icons.home,
                                color: Colors.blueGrey, size: 30),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewCart()));
                                },
                                icon: Icon(Icons.shopping_cart,
                                    color: Colors.blueGrey, size: 30),
                              )
                            ],
                          ),
                    body: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data?.docs[index]['type'] ==
                                  'Customer') {
                                name = snapshot.data?.docs[index]['name'];
                                email = snapshot.data?.docs[index]['email'];
                                phone =
                                    snapshot.data?.docs[index]['phone'] ?? "";
                                return FutureBuilder(
                                    future: getType(),
                                    builder: (context, snapshot) {
                                      print("TOKS ${tok.toString()}");
                                      Auth.customerRef
                                          .doc(Auth.auth.currentUser?.uid)
                                          .update({
                                        'token': tok,
                                      });
                                      return pages[pageIndex];
                                    });
                              }
                              else {
                                log('Type not matched ${Auth.auth.currentUser!.uid}');
                                return ShowError('Type not matched !!');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: CurvedNavigationBar(
                      color: Colors.grey,
                      backgroundColor: Colors.white,
                      items: <Widget>[
                        Icon(
                          Icons.shopping_cart,
                          size: 30,
                          color: Colors.pink,
                        ),
                        Icon(Icons.book_outlined, size: 30, color: Colors.pink),
                        Icon(Icons.person, size: 30, color: Colors.pink),
                      ],
                      onTap: (index) {
                        setState(() => pageIndex = index);
                        //   }
                      },

                      // Additi7onal properties for customization
                      height: 70.0,

                      // Height of the navigation bar
                      animationDuration: Duration(milliseconds: 300),
                      // Duration of the animation
                      animationCurve: Curves.easeInOut,
                      // Animation curve
                      index: pageIndex,
                      // Current active index
                      buttonBackgroundColor:
                          Colors.white, // Background color of the active item
                      // Other properties you might consider:
                      // letIndexChange: (index) => true, // Callback to allow or disallow index change
                      // onTap: (index) => yourFunction(index), // Callback when an item is tapped
                    ),
                  )
                : Scaffold(
                    body: ShowError('No user found !!'),
                  );
          } else if (snapshot.hasError ||
              snapshot.data == null ||
              !snapshot.hasData) {
            log('Data not found ...........${Auth.auth.currentUser!.uid}');
            return ShowError('Data not found !!');
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }
}
