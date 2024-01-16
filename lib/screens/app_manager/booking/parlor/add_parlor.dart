import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/constant/widget/roundButton.dart';
import 'package:mall/screens/app_manager/booking/parlor/parlor_home.dart';

import '../../../../constant/utils/utilities.dart';
import '../../../../controller/auth.dart';
import '../../../../main.dart';

class AddParlor extends StatefulWidget {
  final String shopManagerId;
  const AddParlor({super.key , required this.shopManagerId});

  @override
  State<AddParlor> createState() => _AddParlorState();
}

class _AddParlorState extends State<AddParlor> {
  final _formKey = GlobalKey<FormState>();
  final parlorIdController = TextEditingController();
  final parlorNameController = TextEditingController();
  final parlorManagerNameController = TextEditingController();
  bool isIconUploaded = false;
  File? parlorIcon;
  final parlorIconPicker = ImagePicker();

  Future<void> pickIcon() async {
    final pickedFile = await parlorIconPicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      parlorIcon = File(pickedFile.path);
      log(parlorIcon!.path);
      setState(() {});
      isIconUploaded = true;
    } else {
      Utilities().showMessage('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade900,
          title: Text('Add Parlor'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: mq.height * .15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    initialValue: widget.shopManagerId,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .01,
                ), Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: parlorManagerNameController,
                    decoration: InputDecoration(
                      label: Text('Manager Name'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter parlor manager name';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: mq.height * .01,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: parlorNameController,
                    decoration: InputDecoration(
                      label: Text('Parlor Name'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter parlor name';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            side: BorderSide(width: 1, color: Colors.black)),
                        onPressed: () {
                          pickIcon();
                        },
                        icon: Icon(Icons.upload),
                        label: Text('Upload parlor icon')),
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      child: parlorIcon != null
                          ? Image.file(
                              File(parlorIcon!.path).absolute,
                              fit: BoxFit.cover,
                              width: mq.width,
                              height: mq.height,
                            )
                          : Container(
                              decoration: BoxDecoration(color: Colors.white),
                            ),
                    )
                  ],
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                RoundButton(
                    title: 'Add Parlor',
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (parlorIcon != null) {
                          String imageUrl =
                              await Auth.uploadParlorIcon(parlorIcon! , widget.shopManagerId);
                          await Auth.bookingRef
                              .doc(widget.shopManagerId)
                              .collection('parlor')
                              .doc(widget.shopManagerId)
                              .set({
                            'name':
                            parlorManagerNameController.text.toString(),
                            'parlorName':
                            parlorNameController.text.toString(),
                            'parlorId': widget.shopManagerId.toString(),
                            'parlorIcon': imageUrl,
                            'added_on':
                            '${DateTime.now().millisecondsSinceEpoch.toString()}'
                          }).then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ParlorHome()),
                                (route) => false);
                          });
                        } else {
                          Utilities().showMessage('Upload parlor icon');
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
