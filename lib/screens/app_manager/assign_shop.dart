import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/constant/widget/roundButton.dart';
import 'package:mall/screens/app_manager/shopkeeper_without_shops.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/firebase_api.dart';
import '../../constant/utils/utilities.dart';
import '../../controller/auth.dart';

class AssignShop extends StatefulWidget {
  final shopManagerId;

  AssignShop({super.key, required this.shopManagerId});

  @override
  State<AssignShop> createState() => _AssignShopState();
}

class _AssignShopState extends State<AssignShop> {
  String dropdownvalue = 'Brands';

  // List of items in our dropdown menu
  var items = [
    'Brands',
    'Parlor',
    'Restaurant',
  ];
  final shopNameController = TextEditingController();
  final shopManagerNameController = TextEditingController();
  final idController = TextEditingController();
  bool isIconUploaded = false;
  final _formKey = GlobalKey<FormState>();
  File? shopIcon;
  final shopIconPicker = ImagePicker();

  late String name, email;
  Stream<QuerySnapshot>? stream;
  List id = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.shopManagerRef
        .where('uid', isEqualTo: Auth.auth.currentUser!.uid)
        .snapshots();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> pickIcon() async {
    final pickedFile = await shopIconPicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      shopIcon = File(pickedFile.path);
      log(shopIcon!.path);
      setState(() {});
      isIconUploaded = true;
    } else {
      Utilities().showMessage('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff1D1F33),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: mq.height * .4,
                  width: mq.width * 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                    ),
                    child: Image.asset(
                      "images/mall.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(
                //       top: mq.height * 0.2, left: mq.width * 0.10),
                //   child: ShaderMask(
                //     shaderCallback: (Rect bounds) {
                //       return LinearGradient(
                //           colors: [Color(0xff014871), Color(0xffa0ebcf)],
                //           begin: Alignment.topLeft,
                //           end: Alignment.bottomRight,
                //           stops: const [0.3, 0.9]).createShader(bounds);
                //     },
                //     child: Text(
                //       'Welcome to the World of \n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tMAGIC',
                //       style: TextStyle(
                //           fontSize: 30.0,
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Focus.of(context).unfocus();
              },
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: mq.height * 0.04,
                      ),
                      TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[A-Za-z]"))
                        ],
                        controller: shopManagerNameController,
                        cursorColor: Colors.grey.shade200,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200)),
                          hintText: "Enter Shopkeeper's Name",
                          hintStyle: TextStyle(color: Colors.grey.shade200),
                          prefixIcon: Icon(Icons.drive_file_rename_outline),
                          prefixIconColor: Colors.grey.shade200,
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Empty name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.04,
                      ),
                      TextFormField(
                        controller: shopNameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[A-Za-z]"))
                        ],
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200)),
                          hintText: "Enter Shop Name",
                          hintStyle: TextStyle(color: Colors.grey.shade200),
                          prefixIcon: Icon(Icons.shop),
                          prefixIconColor: Colors.grey.shade200,
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Empty shop name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.04,
                      ),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200)),
                          hintText: widget.shopManagerId,
                          hintStyle: TextStyle(color: Colors.grey.shade200),
                          prefixIcon: Icon(Icons.check),
                          prefixIconColor: Colors.grey.shade200,
                        ),
                      ),
                      SizedBox(
                        height: mq.height * 0.04,
                      ),
                      DropdownButton(
                        // Initial Value
                        value: dropdownvalue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Color(0xffeeeeee)),

                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items,
                                style: TextStyle(color: Colors.grey.shade200)),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                          print("${dropdownvalue}");
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  side: BorderSide(
                                      width: 1, color: Colors.black)),
                              onPressed: () {
                                pickIcon();
                              },
                              icon: Icon(Icons.upload),
                              label: Text('Upload shop icon')),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            child: shopIcon != null
                                ? Image.file(
                                    File(shopIcon!.path).absolute,
                                    fit: BoxFit.cover,
                                    width: mq.width,
                                    height: mq.height,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff1D1F33),
                                    ),
                                  ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.grey.shade200,
                                  )
                                )
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Back')),
                        ],
                      ),
                      SizedBox(
                        height: mq.height * 0.04,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: RoundButton(
                            title: "Submit",
                            bgColor: Colors.transparent,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (shopIcon != null) {
                                  print("Printing $dropdownvalue");
                                  String imageUrl = await Auth.uploadShopIcon(
                                      shopIcon!, widget.shopManagerId);
                                  dropdownvalue == 'Brands'
                                      ? await Auth.shopManagerRef
                                          .doc(widget.shopManagerId)
                                          .collection('shop')
                                          .doc(widget.shopManagerId)
                                          .set({
                                          'shopManagerName':
                                              shopManagerNameController.text
                                                  .toString(),
                                          'shopName': shopNameController.text
                                              .toString(),
                                          'shopId':
                                              widget.shopManagerId.toString(),
                                          'shopIcon': imageUrl,
                                          'added_on':
                                              '${DateTime.now().millisecondsSinceEpoch.toString()}'
                                        })
                                      : dropdownvalue == 'Parlor'
                                          ? await Auth.shopManagerRef
                                              .doc(widget.shopManagerId)
                                              .collection('parlor')
                                              .doc(widget.shopManagerId)
                                              .set({
                                              'shopManagerName':
                                                  shopManagerNameController.text
                                                      .toString(),
                                              'shopName': shopNameController
                                                  .text
                                                  .toString(),
                                              'shopId': widget.shopManagerId
                                                  .toString(),
                                              'shopIcon': imageUrl,
                                              'added_on':
                                                  '${DateTime.now().millisecondsSinceEpoch.toString()}'
                                            })
                                          : await Auth.shopManagerRef
                                              .doc(widget.shopManagerId)
                                              .collection('restaurant')
                                              .doc(widget.shopManagerId)
                                              .set({
                                              'shopManagerName':
                                                  shopManagerNameController.text
                                                      .toString(),
                                              'shopName': shopNameController
                                                  .text
                                                  .toString(),
                                              'shopId': widget.shopManagerId
                                                  .toString(),
                                              'shopIcon': imageUrl,
                                              'reserveSeat': false,
                                              'added_on':
                                                  '${DateTime.now().millisecondsSinceEpoch.toString()}'
                                            });
                                  if (dropdownvalue == "Restaurant") {
                                    await Auth.shopManagerRef
                                        .doc(widget.shopManagerId)
                                        .collection('restaurant')
                                        .doc(widget.shopManagerId)
                                        .collection('details')
                                        .doc(widget.shopManagerId)
                                        .set({
                                      'menuList': [],
                                      'offerList': [],
                                      'imageList': [],
                                      'dinnerTime': [],
                                      'lunchTime': [],
                                    });
                                  }
                                }
                                Utilities()
                                    .showMessage('Shop added successfully');
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShopKeeperWithoutShops(),
                                    ));
                              }
                            }),
                      ),
                    ],
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
