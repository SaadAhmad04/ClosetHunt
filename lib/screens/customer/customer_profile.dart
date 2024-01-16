import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/screens/customer/booking/parlor/parlor_bookings.dart';
import 'package:mall/screens/customer/customer_home.dart';
import 'package:mall/screens/customer/shopping/my_orders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/auth.dart';
import '../../main.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final profilePicker = ImagePicker();
  File? profilePic;
  late String name1, phone1, email1, gender1, imageUrl1;
  String? name2, phone2, email2, gender2, imageUrl2;
  final _formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  bool showAvatar = true;
  late String image;
  Stream? stream;

  @override
  void initState() {
    super.initState();
    stream = Auth.customerRef
        .where('uid', isEqualTo: Auth.auth.currentUser!.uid)
        .snapshots();
    scrollController.addListener(() {
      if (!scrollController.position.atEdge ||
          scrollController.offset ==
              scrollController.positions.last.maxScrollExtent) {
        if (showAvatar) {
          setState(() {
            showAvatar = false;
          });
        }
      } else {
        if (!showAvatar) {
          setState(() {
            showAvatar = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasData) {
                    name1 = snapshot.data!.docs[index]['name'];
                    phone1 = snapshot.data?.docs[index]['phone'] ?? "";
                    email1 = snapshot.data!.docs[index]['email'];
                    gender1 = snapshot.data?.docs[index]['gender'] ?? "";
                    image = snapshot.data!.docs[index]['profilepic'];
                    return Container(
                      height: mq.height - 50,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.pink.shade100,
                                          Colors.pink.shade50
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: TextButton(
                                      onPressed: () async {
                                        Auth.logout(context);
                                      },
                                      child: Text(
                                        'Logout',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (profilePic != null) {
                                            imageUrl1 =
                                                await Auth.uploadProfilePicture(
                                                    profilePic!);
                                          }
                                          if (phone2?.length == null ||
                                              phone2?.length == 10) {
                                            await Auth.customerRef
                                                .doc(Auth.auth.currentUser!.uid)
                                                .update({
                                              'name':
                                                  name2 != null ? name2 : name1,
                                              'phone': phone2 != null
                                                  ? phone2
                                                  : phone1,
                                              'email': email1,
                                              'gender': gender2 != null
                                                  ? gender2
                                                  : gender1,
                                              'profilepic': profilePic != null
                                                  ? imageUrl1
                                                  : image,
                                            }).then((value) {
                                              Utilities().showMessage(
                                                  'Updated Successfully');
                                            });
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CustomerHome()));
                                          } else {
                                            Utilities().showMessage(
                                                'Invalid phone number');
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.green.shade600,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: mq.height - 100,
                              child: ListView(
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(height: 80),
                                  SizedBox(
                                    height: mq.height - 167,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: mq.width,
                                            height: mq.height - 230,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      mq.width * .1),
                                                  topRight: Radius.circular(
                                                      mq.width * .1)),
                                            ),
                                            child: SingleChildScrollView(
                                              controller: scrollController,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 100),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Form(
                                                        key: _formKey,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    'Name',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .grey),
                                                                  )),
                                                            ),
                                                            TextFormField(
                                                              initialValue:
                                                                  name1,
                                                              decoration: InputDecoration(
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          -10,
                                                                      horizontal:
                                                                          15),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(mq.width *
                                                                              .1))),
                                                              onChanged: (val) {
                                                                name2 = val;
                                                                print(name2);
                                                              },
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    'Phone',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .grey),
                                                                  )),
                                                            ),
                                                            TextFormField(
                                                              initialValue:
                                                                  phone1,
                                                              onChanged: (val) {
                                                                phone2 = val;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            -10,
                                                                        horizontal:
                                                                            15),
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(mq.width *
                                                                            .1)),
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              // validator: (val) {
                                                              //   if (val!.length !=
                                                              //           10) {
                                                              //     return "Invalid";
                                                              //   } else {
                                                              //     return null;
                                                              //   }
                                                              // },
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    'Email',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .grey),
                                                                  )),
                                                            ),
                                                            TextFormField(
                                                              initialValue: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['email'],
                                                              readOnly: true,
                                                              decoration: InputDecoration(
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          -10,
                                                                      horizontal:
                                                                          15),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(mq.width *
                                                                              .1))),
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                            Divider(
                                                              height:
                                                                  mq.height *
                                                                      .07,
                                                              thickness: 1.5,
                                                            ),
                                                            SizedBox(
                                                              height: 80,
                                                              child: ListTile(
                                                                title: Text(
                                                                  'Gender',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                subtitle: Text(
                                                                  snapshot.data?.docs[index]
                                                                              [
                                                                              'gender'] !=
                                                                          ""
                                                                      ? "${gender1}"
                                                                      : "-",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                trailing: Icon(Icons
                                                                    .keyboard_arrow_right),
                                                                onTap: () {
                                                                  showGenderDialog();
                                                                },
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25)),
                                                                child: Center(
                                                                  child:
                                                                      ElevatedButton
                                                                          .icon(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors.transparent),
                                                                    onPressed:
                                                                        () {},
                                                                    label: Text(
                                                                      'Change Password',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    icon: Icon(
                                                                        Icons
                                                                            .lock),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 20),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => MyOrders()));
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        //color: Colors.black,
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .blue),
                                                                        borderRadius:
                                                                            BorderRadius.circular(25)),
                                                                child: Center(
                                                                  child:
                                                                      OutlinedButton
                                                                          .icon(
                                                                    style: ElevatedButton.styleFrom(
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .transparent),
                                                                        backgroundColor:
                                                                            Colors.transparent),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MyOrders()));
                                                                    },
                                                                    label: Text(
                                                                      'My Orders',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .delivery_dining,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 20),
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                  //color: Colors.black,
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .orange.shade900),
                                                                    borderRadius:
                                                                    BorderRadius.circular(25)),
                                                                child: Center(
                                                                  child:
                                                                  OutlinedButton
                                                                      .icon(
                                                                    style: ElevatedButton.styleFrom(
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .transparent),
                                                                        backgroundColor:
                                                                        Colors.transparent),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => ParlorBookings()));
                                                                    },
                                                                    label: Text(
                                                                      'My Bookings',
                                                                      style: TextStyle(
                                                                          color:
                                                                          Colors.orange.shade900),
                                                                    ),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .book_outlined,
                                                                      color: Colors
                                                                          .orange.shade900,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 70,
                                                            )
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 750),
                                            transitionBuilder:
                                                (child, animation) =>
                                                    ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            ),
                                            child: !showAvatar
                                                ? SizedBox()
                                                : SizedBox(
                                                    key: ValueKey("show-state"),
                                                    width: 200,
                                                    height: 200,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                child: profilePic !=
                                                                        null
                                                                    ? Image
                                                                        .file(
                                                                        File(profilePic!.path)
                                                                            .absolute,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width: mq
                                                                            .width,
                                                                        height: mq.height /
                                                                            3.56,
                                                                      )
                                                                    : Image
                                                                        .network(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]['profilepic'],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        width: mq
                                                                            .width,
                                                                        height: mq.height /
                                                                            3.56,
                                                                        // fit: BoxFit
                                                                        //     .cover,
                                                                        // width: mq.width,
                                                                        // height:
                                                                        //     mq.height,
                                                                      ))),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: MaterialButton(
                                                            shape:
                                                                CircleBorder(),
                                                            color: Colors
                                                                .brown.shade900,
                                                            onPressed:
                                                                () async {
                                                              print("hello");
                                                              final pickedFile =
                                                                  await profilePicker
                                                                      .pickImage(
                                                                          source:
                                                                              ImageSource.gallery);

                                                              setState(() {
                                                                if (pickedFile !=
                                                                    null) {
                                                                  profilePic = File(
                                                                      pickedFile
                                                                          .path);
                                                                  log(profilePic
                                                                      .toString());
                                                                } else {
                                                                  print(
                                                                      'No image selected.');
                                                                }
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                });
          }),
    );
  }

  Future<void> showGenderDialog() {
    int? selectedValue;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: StatefulBuilder(builder: (context, setModalState) {
                return SizedBox(
                  height: mq.height * .25,
                  width: mq.width * .6,
                  child: ListView(children: [
                    const Center(child: Text('Select your gender')),
                    RadioListTile<int>(
                        title: Text('Male'),
                        value: 0,
                        groupValue: selectedValue,
                        onChanged: (int? value) {
                          selectedValue = value;
                          gender2 = 'Male';
                          Auth.customerRef
                              .doc(Auth.auth.currentUser!.uid)
                              .update({'gender': gender2});

                          setModalState(() {});
                        }),
                    RadioListTile<int>(
                        title: Text('Female'),
                        value: 1,
                        groupValue: selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            selectedValue = value;
                            gender2 = 'Female';
                            Auth.customerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .update({'gender': gender2});
                          });
                          setModalState(() {});
                        }),
                    RadioListTile<int>(
                        title: Text('Others'),
                        value: 2,
                        groupValue: selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            selectedValue = value;
                            gender2 = 'Others';
                            Auth.customerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .update({'gender': gender2});
                          });
                          setModalState(() {});
                        }),
                  ]),
                );
              }));
        });
  }
}
