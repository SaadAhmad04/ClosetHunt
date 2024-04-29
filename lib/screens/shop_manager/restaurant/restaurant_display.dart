// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/screens/shop_manager/parlor/parlor_display.dart';
// import 'package:mall/screens/shop_manager/product_order.dart';
// import 'package:mall/screens/shop_manager/restaurant/manage_slots.dart';
// import 'package:mall/screens/shop_manager/restaurant/view_payments.dart';
// import '../../../controller/auth.dart';
// import 'restro_display.dart';
//
// class RestaurantDisplay extends StatefulWidget {
//   const RestaurantDisplay({Key? key}) : super(key: key);
//
//   @override
//   State<RestaurantDisplay> createState() => _RestaurantDisplayState();
// }
//
// class _RestaurantDisplayState extends State<RestaurantDisplay> {
//   late Stream<DocumentSnapshot> stream;
//
//   @override
//   void initState() {
//     super.initState();
//     stream = Auth.shopManagerRef
//         .doc(Auth.auth.currentUser!.uid)
//         .collection('restaurant')
//         .doc(Auth.auth.currentUser!.uid)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: stream,
//       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasData) {
//           bool? isChecked = snapshot.data?.get('reserveSeat');
//           print("ladfhlkjajf $isChecked");
//           return Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               title: Text(snapshot.data?.get('shopName') ?? ''),
//               leading: IconButton(
//                 icon: Icon(Icons.logout),
//                 onPressed: () {
//                   Auth.logout(context);
//                 },
//               ),
//             ),
//             body: Column(
//               children: [
//                 Card(
//                   child: ListTile(
//                     leading: Image.network(
//                       'https://cdn-icons-png.flaticon.com/512/3428/3428655.png',
//                     ),
//                     title: Text('Menu'),
//                     trailing: IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RestroDisplay(type: "Menu"),
//                           ),
//                         );
//                       },
//                       icon: Icon(Icons.arrow_forward_ios),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   child: ListTile(
//                     trailing: IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RestroDisplay(type: "Offers"),
//                           ),
//                         );
//                       },
//                       icon: Icon(Icons.arrow_forward_ios),
//                     ),
//                     leading: Image.network(
//                       'https://i.pinimg.com/736x/20/2d/6a/202d6aed6af25e2afec26baea4b4cff4.jpg',
//                     ),
//                     title: Text('Offer'),
//                   ),
//                 ),
//                 Card(
//                   child: ListTile(
//                     trailing: IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => RestroDisplay(type: "Images"),
//                           ),
//                         );
//                       },
//                       icon: Icon(Icons.arrow_forward_ios),
//                     ),
//                     leading: Image.network(
//                       'https://purepng.com/public/uploads/large/purepng.com-photos-iconsymbolsiconsapple-iosiosios-8-iconsios-8-721522596102asedt.png',
//                     ),
//                     title: Text('Images'),
//                   ),
//                 ),
//                 Card(
//                   child: ListTile(
//                     leading: Image.network(
//                         "https://cdn0.iconfinder.com/data/icons/hotel-vacation-1/33/reserved-512.png"),
//                     trailing: Checkbox(
//                       checkColor: Colors.white,
//                       value: isChecked,
//                       onChanged: (bool? value) async {
//                         isChecked = value;
//                         if (isChecked == true) {
//                           await Auth.shopManagerRef
//                               .doc(Auth.auth.currentUser!.uid)
//                               .collection('restaurant')
//                               .doc(Auth.auth.currentUser!.uid)
//                               .update({
//                             'reserveSeat': true,
//                           });
//                         }
//                         if (isChecked == false) {
//                           await Auth.shopManagerRef
//                               .doc(Auth.auth.currentUser!.uid)
//                               .collection('restaurant')
//                               .doc(Auth.auth.currentUser!.uid)
//                               .update({
//                             'reserveSeat': false,
//                           });
//                         }
//                         setState(() {});
//                         print(isChecked);
//                       },
//                     ),
//                     title: Text("Allow Reserving Seat"),
//                   ),
//                 ),
//                 isChecked == true
//                     ? TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ManageSlots(),
//                               ));
//                         },
//                         child: Text("Manage Time Slots"))
//                     : SizedBox(),
//                 TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => OrderProduct(),
//                           ));
//                     },
//                     child: Text("Notifications"))
//               ],
//             ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => ViewPayments(
//                       payment: true,
//                     )));
//               },
//               elevation: 0,
//               backgroundColor: Colors.green,
//               child: Icon(Icons.currency_rupee),
//             ),
//           );
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mall/screens/shop_manager/product_order.dart';
import 'package:mall/screens/shop_manager/restaurant/analyse.dart';
import 'package:mall/screens/shop_manager/restaurant/manage_slots.dart';
import 'package:mall/screens/shop_manager/restaurant/view_payments.dart';
import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';
import 'restro_display.dart';
import 'view_summary.dart';

class RestaurantDisplay extends StatefulWidget {
  const RestaurantDisplay({Key? key}) : super(key: key);

  @override
  State<RestaurantDisplay> createState() => _RestaurantDisplayState();
}

class _RestaurantDisplayState extends State<RestaurantDisplay> {
  final spinkit = SpinKitDancingSquare(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.purple,
        ),
      );
    },
  );
  late Stream<DocumentSnapshot> stream;

  @override
  void initState() {
    super.initState();
    stream = Auth.shopManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('restaurant')
        .doc(Auth.auth.currentUser!.uid)
        .snapshots();
  }

  File? restroIcon;
  final restroIconPicker = ImagePicker();
  bool iconPicked = false;

  Future<void> pickIcon() async {
    final pickedFile = await restroIconPicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      iconPicked = true;
      restroIcon = File(pickedFile.path);
      setState(() {});
    } else {
      Utilities().showMessage('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: stream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          bool? isChecked = snapshot.data?.get('reserveSeat');
          return Scaffold(
            appBar: AppBar(
              actions: [
                PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.purple,
                      size: 20,
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                title: Text('Change Icon'),
                                trailing: Icon(
                                  Icons.photo,
                                  color: Colors.purple.shade200,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  pickIcon();
                                },
                              )),
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                title: Text('Analyse'),
                                trailing: Icon(
                                  Icons.analytics_outlined,
                                  color: Colors.purple.shade200,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Analyse()));
                                },
                              )),
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                title: Text('Summary'),
                                trailing: Icon(
                                  Icons.summarize_outlined,
                                  color: Colors.purple.shade200,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewSummary()));
                                },
                              ))
                        ]),
                iconPicked
                    ? TextButton(
                        onPressed: () async {
                          print("printing ${restroIcon}");
                          if (restroIcon != null) {
                            String imageUrl = await Auth.uploadRestroIcon(
                                restroIcon!, Auth.auth.currentUser!.uid);
                            await Auth.shopManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('restaurant')
                                .doc(Auth.auth.currentUser!.uid)
                                .update({
                              'shopIcon': imageUrl,
                            });
                            setState(() {
                              iconPicked = false;
                            });
                            Utilities().showMessage("Icon Updated!");
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.purple),
                        ))
                    : SizedBox(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderProduct(),
                        ));
                  },
                  icon: Icon(Icons.notification_add),
                )
              ],
              elevation: 0,
              backgroundColor: Colors.purple[100],
              centerTitle: true,
              title: Text(snapshot.data?.get('shopName') ?? ''),
              leading: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onPressed: () {
                  Auth.logout(context);
                },
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: mq.height / 4,
                    width: mq.width * 0.4,
                    //color: Colors.white70,
                    child: CircleAvatar(
                      backgroundColor: Colors.purple[500],
                      maxRadius: 5,
                      // minRadius: 5,
                      backgroundImage: NetworkImage(
                          snapshot.data?.get('shopIcon'),
                          scale: BouncingScrollSimulation
                              .maxSpringTransferVelocity),
                    )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.purple[500],
                    child: ListTile(
                      leading: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/3428/3428655.png',
                      ),
                      title: Text('Menu'),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestroDisplay(type: "Menu"),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.purple[500],
                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RestroDisplay(type: "Offers"),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      leading: Image.network(
                        'https://i.pinimg.com/736x/20/2d/6a/202d6aed6af25e2afec26baea4b4cff4.jpg',
                      ),
                      title: Text('Offer'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.purple[500],
                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RestroDisplay(type: "Images"),
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      leading: Image.network(
                        'https://purepng.com/public/uploads/large/purepng.com-photos-iconsymbolsiconsapple-iosiosios-8-iconsios-8-721522596102asedt.png',
                      ),
                      title: Text('Images'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.purple[500],
                    child: ListTile(
                      leading: Image.network(
                          "https://cdn0.iconfinder.com/data/icons/hotel-vacation-1/33/reserved-512.png"),
                      trailing: Checkbox(
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: (bool? value) async {
                          isChecked = value;
                          if (isChecked == true) {
                            await Auth.shopManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('restaurant')
                                .doc(Auth.auth.currentUser!.uid)
                                .update({
                              'reserveSeat': true,
                            });
                          }
                          if (isChecked == false) {
                            await Auth.shopManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('restaurant')
                                .doc(Auth.auth.currentUser!.uid)
                                .update({
                              'reserveSeat': false,
                            });
                          }
                          setState(() {});
                          print(isChecked);
                        },
                      ),
                      title: Text("Allow Reserving Seat"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                isChecked == true
                    ? TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageSlots(),
                              ));
                        },
                        child: Text(
                          "Manage Time Slots",
                          style: TextStyle(color: Colors.grey, fontSize: 22),
                        ))
                    : SizedBox(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewPayments(
                              payment: true,
                            )));
              },
              elevation: 0,
              backgroundColor: Colors.purple[100],
              child: Icon(Icons.currency_rupee),
            ),
          );
        } else {
          return Center(child: spinkit);
        }
      },
    );
  }
}
