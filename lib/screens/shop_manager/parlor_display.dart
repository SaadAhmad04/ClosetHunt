import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/screens/shop_manager/product_order.dart';
import 'package:mall/screens/shop_manager/services.dart';

import '../../constant/utils/utilities.dart';
import '../../controller/auth.dart';
import '../../main.dart';

class ParlorDisplay extends StatefulWidget {
  const ParlorDisplay({super.key});

  @override
  State<ParlorDisplay> createState() => _ParlorDisplayState();
}

class _ParlorDisplayState extends State<ParlorDisplay> {
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
                itemCount: 1,
                itemBuilder: (context, index) {
                  final parlorName = snapshot.data!.data()?['shopName'];
                  final icon = snapshot.data!.data()?['shopIcon'];
                  return Container(
                      height: mq.height,
                      width: 200,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.blue.shade200,
                        Colors.blue.shade300
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                      child: Stack(
                        children: [
                          AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              content: StatefulBuilder(
                                  builder: (context, setModalState) {
                                return Container(
                                  height: mq.height / 3.2,
                                  width: mq.width - 50,
                                  child: ListView(
                                    children: [
                                      SizedBox(
                                        height: mq.height * .01,
                                      ),
                                      Center(
                                          child: Text(
                                        'Your Dialog',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      SizedBox(
                                        height: mq.height * .02,
                                      ),
                                      ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: Colors.blue.shade800,
                                            )),
                                        title: Text('Services'),
                                        trailing: Icon(
                                          Icons.design_services,
                                          color: Colors.blue.shade800,
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: Colors.blue.shade800,
                                            )),
                                        title: Text('Notifications'),
                                        trailing: Icon(
                                          Icons.notifications,
                                          color: Colors.blue.shade800,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderProduct()));
                                        },
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: mq.height * .15,
                                horizontal: mq.width * .02),
                            child: Material(
                              child: ListTile(
                                visualDensity:
                                    VisualDensity(vertical: 4, horizontal: 3),
                                shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black87, width: 2)),
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
                                                      if (parlorIcon != null) {
                                                        String imageUrl = await Auth
                                                            .uploadParlorIcon(
                                                                parlorIcon!,
                                                                Auth
                                                                    .auth
                                                                    .currentUser!
                                                                    .uid);
                                                        await Auth.bookingRef
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
                                                          'parlorIcon':
                                                              imageUrl,
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
                        ],
                      ));
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
