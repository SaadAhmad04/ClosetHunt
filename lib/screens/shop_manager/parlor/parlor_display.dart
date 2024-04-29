import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/screens/shop_manager/parlor/service_analysis.dart';
import 'package:mall/screens/shop_manager/parlor/view_summary.dart';
import 'package:mall/screens/shop_manager/product_order.dart';
import 'package:mall/screens/shop_manager/parlor/services.dart';
import 'package:mall/screens/shop_manager/restaurant/view_payments.dart';

import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';
import 'manage_staff.dart';

class ParlorDisplay extends StatefulWidget {
  const ParlorDisplay({super.key});

  @override
  State<ParlorDisplay> createState() => _ParlorDisplayState();
}

class _ParlorDisplayState extends State<ParlorDisplay> {
  final spinkit = SpinKitDancingSquare(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.purple,
        ),
      );
    },
  );
  File? parlorIcon;
  final parlorIconPicker = ImagePicker();
  bool iconPicked = false;

  Future<void> pickIcon() async {
    final pickedFile = await parlorIconPicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      iconPicked = true;
      parlorIcon = File(pickedFile.path);
      setState(() {});
    } else {
      Utilities().showMessage('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.shopManagerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('parlor')
            .doc(Auth.auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  final parlorName = snapshot.data!.data()?['shopName'];
                  final icon = snapshot.data!.data()?['shopIcon'];
                  log(parlorName);
                  return Container(
                      height: mq.height,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: mq.height * .07,
                            child: AlertDialog(
                                backgroundColor: Colors.purple[50],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.purple)),
                                content: StatefulBuilder(
                                    builder: (context, setModalState) {
                                  return Container(
                                    height: mq.height / 1.55,
                                    width: mq.width * .65,
                                    //color: Colors.black,
                                    child: ListView(
                                      children: [
                                        ListTile(
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: Colors.purple,
                                              )),
                                          title: Text('Services'),
                                          trailing: Icon(
                                            Icons.design_services,
                                            color: Colors.purple,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Services(),
                                                ));
                                          },
                                        ),
                                        SizedBox(
                                          height: mq.height * .02,
                                        ),
                                        ListTile(
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: Colors.purple,
                                              )),
                                          title: Text('Notifications'),
                                          trailing: Icon(
                                            Icons.notifications,
                                            color: Colors.purple,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderProduct()));
                                          },
                                        ),
                                        SizedBox(
                                          height: mq.height * .02,
                                        ),
                                        ListTile(
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: Colors.purple,
                                              )),
                                          title: Text('History'),
                                          trailing: Icon(Icons.history,
                                              color: Colors.purple),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewPayments(
                                                    payment: false,
                                                    shop: false,
                                                  ),
                                                ));
                                          },
                                        ),
                                        SizedBox(
                                          height: mq.height * .02,
                                        ),
                                        ListTile(
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: Colors.purple,
                                              )),
                                          title: Text('Manage Staff'),
                                          trailing: Icon(
                                            Icons.work,
                                            color: Colors.purple,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ManageStaff()));
                                          },
                                        ),
                                        SizedBox(
                                          height: mq.height * .02,
                                        ),
                                        ListTile(
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: Colors.purple,
                                              )),
                                          title: Text('Analysis'),
                                          trailing: Icon(
                                            Icons.analytics_outlined,
                                            color: Colors.purple,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ServiceAnalysis()));
                                          },
                                        ),
                                        SizedBox(
                                          height: mq.height * .015,
                                        ),
                                        ListTile(
                                          tileColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              side: BorderSide(
                                                color: Colors.purple,
                                              )),
                                          title: Text('Summary'),
                                          trailing: Icon(
                                            Icons.summarize_outlined,
                                            color: Colors.purple,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewSummary(shopName: parlorName,)));
                                          },
                                        ),
                                        SizedBox(
                                          height: mq.height * .02,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: mq.width * .45,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Auth.logout(context);
                                                },
                                                child: Text(
                                                  'Logout',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                })),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mq.height * .05,
                                horizontal: mq.width * .02),
                            child: Material(
                              child: ListTile(
                                visualDensity:
                                    VisualDensity(vertical: 4, horizontal: 3),
                                shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 2)),
                                leading: parlorIcon != null
                                    ? Image.file(
                                        File(parlorIcon!.path).absolute,
                                        fit: BoxFit.cover,
                                        height: 50,
                                        width: 50,
                                      )
                                    : Image.network(icon,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover),
                                title: Text(parlorName),
                                trailing: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: SingleChildScrollView(
                                      child: Stack(
                                        children: [
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
                                                          title: Text(
                                                              'Change Icon'),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            pickIcon();
                                                          },
                                                        ))
                                                  ]),
                                          Positioned(
                                            top: 18,
                                            right: -5,
                                            child: iconPicked
                                                ? TextButton(
                                                    onPressed: () async {
                                                      print(
                                                          "printing ${parlorIcon}");
                                                      if (parlorIcon != null) {
                                                        String imageUrl = await Auth
                                                            .uploadParlorIcon(
                                                                parlorIcon!,
                                                                Auth
                                                                    .auth
                                                                    .currentUser!
                                                                    .uid);
                                                        await Auth
                                                            .shopManagerRef
                                                            .doc(Auth
                                                                .auth
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                'parlor')
                                                            .doc(Auth
                                                                .auth
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          'shopIcon': imageUrl,
                                                        });
                                                        setState(() {
                                                          iconPicked = false;
                                                        });
                                                        Utilities().showMessage(
                                                            "Icon Updated!");
                                                      }
                                                    },
                                                    child: Text('Save'))
                                                : SizedBox(),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          Positioned(
                            left: mq.width * .2,
                            bottom: mq.height * .06,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              child: Text(
                                'Visit App Manager For any Queries',
                              ),
                            ),
                          )
                        ],
                      ));
                });
          } else {
            return Center(
              child: spinkit,
            );
          }
        });
  }
}
