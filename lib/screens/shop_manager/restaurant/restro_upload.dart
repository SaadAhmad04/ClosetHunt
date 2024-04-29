// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mall/constant/utils/utilities.dart';
// import '../../../controller/auth.dart';
//
// class RestroUpload extends StatefulWidget {
//   final type;
//
//   RestroUpload({Key? key, required this.type}) : super(key: key);
//
//   @override
//   _RestroUploadState createState() => _RestroUploadState();
// }
//
// class _RestroUploadState extends State<RestroUpload> {
//   bool? present;
//   final ImagePicker imagePicker = ImagePicker();
//   List<XFile> imageFileList = [];
//   List<File> restroImages = [];
//
//   Future<bool> selectImages() async {
//     final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
//     if (selectedImages != null && selectedImages.isNotEmpty) {
//       imageFileList.addAll(selectedImages);
//
//       // Convert XFile to File and add to menuImages list
//       restroImages.addAll(selectedImages.map((xfile) => File(xfile.path)));
//
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: widget.type == "Menu"
//             ? Text("Upload Your Menu")
//             : widget.type == "Offers"
//             ? Text("Upload Your Offers")
//             : Text("Upload Your Images"),
//         leading: IconButton(
//           icon: Icon(Icons.logout),
//           onPressed: () {
//             Auth.logout(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                   ),
//                   itemCount: imageFileList.length,
//                   itemBuilder: (context, index) {
//                     return Image.file(
//                       File(imageFileList[index].path),
//                       fit: BoxFit.cover,
//                     );
//                   },
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 bool exists = await selectImages();
//                 setState(() {
//                   present = exists;
//                 });
//                 print("The present is $present");
//               },
//               child: Text('Pick Your Images'),
//             ),
//             present == true
//                 ? TextButton(
//               onPressed: () async {
//                 print(restroImages);
//                 List<String> newMenuUrl = [];
//                 List<String> newOfferUrl = [];
//                 List<String> newImageUrl = [];
//                 widget.type == "Menu"
//                     ? newMenuUrl = await uploadmenuphotos(
//                     restroImages, Auth.auth.currentUser!.uid)
//                     : widget.type == "Offers"
//                     ? newOfferUrl = await uploadofferphotos(
//                     restroImages, Auth.auth.currentUser!.uid)
//                     : newImageUrl = await uploadimagesphotos(
//                     restroImages, Auth.auth.currentUser!.uid);
//                 //print("New Image URLs: $newImageUrls");
//                 // Fetch the existing menuList
//                 List<String> existingImageUrls = [];
//                 var docSnapshot = await Auth.shopManagerRef
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('restaurant')
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('details')
//                     .doc(Auth.auth.currentUser!.uid)
//                     .get();
//
//                 if (docSnapshot.exists) {
//                   var data = docSnapshot.data() as Map<String, dynamic>;
//                   if (data.containsKey('menuList') &&
//                       data['menuList'] is List &&
//                       widget.type == "Menu") {
//                     existingImageUrls =
//                     List<String>.from(data['menuList']);
//                   } else if (data.containsKey('offerList') &&
//                       data['offerList'] is List &&
//                       widget.type == "Offers") {
//                     existingImageUrls =
//                     List<String>.from(data['offerList']);
//                   } else if (data.containsKey('imageList') &&
//                       data['imageList'] is List &&
//                       widget.type == "Images") {
//                     existingImageUrls =
//                     List<String>.from(data['imageList']);
//                   }
//                 }
//                 print("Typee $existingImageUrls");
//                 List<String> updatedImageUrls = [];
//                 // Append the new image URLs to the existing menuList
//                 if (widget.type == "Menu") {
//                   updatedImageUrls = List<String>.from(existingImageUrls)
//                     ..addAll(newMenuUrl);
//                 } else if (widget.type == "Offers") {
//                   updatedImageUrls = List<String>.from(existingImageUrls)
//                     ..addAll(newOfferUrl);
//                 } else {
//                   updatedImageUrls = List<String>.from(existingImageUrls)
//                     ..addAll(newImageUrl);
//                 }
//
//                 // Update the document with the updated menuList
//                 widget.type == "Menu"
//                     ? await Auth.shopManagerRef
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('restaurant')
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('details')
//                     .doc(Auth.auth.currentUser!.uid)
//                     .update({
//                   'menuList': updatedImageUrls,
//                 })
//                     : widget.type == "Offers"
//                     ? await Auth.shopManagerRef
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('restaurant')
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('details')
//                     .doc(Auth.auth.currentUser!.uid)
//                     .update({
//                   'offerList': updatedImageUrls,
//                 })
//                     : await Auth.shopManagerRef
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('restaurant')
//                     .doc(Auth.auth.currentUser!.uid)
//                     .collection('details')
//                     .doc(Auth.auth.currentUser!.uid)
//                     .update({
//                   'imageList': updatedImageUrls,
//                 });
//                 ;
//
//                 Utilities().showMessage("Menu Uploaded");
//                 present = false;
//                 setState(() {});
//               },
//               child: Text('Upload Your Images'),
//             )
//                 : SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<List<String>> uploadmenuphotos(
//       List<File> imageFiles, String restaurantId) async {
//     List<String> imageUrls = [];
//
//     for (int i = 0; i < imageFiles.length; i++) {
//       final File imageFile = imageFiles[i];
//       final ext = imageFile.path.split('.').last;
//       log('Extension : ${ext}');
//
//       final firebaseStorageRef = FirebaseStorage.instance
//           .ref()
//           .child('menuPhotos/${restaurantId}_$i.$ext');
//
//       await firebaseStorageRef.putFile(
//         imageFile,
//         SettableMetadata(
//           contentType: 'image/$ext',
//         ),
//       );
//
//       final imageUrl = await firebaseStorageRef.getDownloadURL();
//       imageUrls.add(imageUrl);
//     }
//
//     return imageUrls;
//   }
//
//   Future<List<String>> uploadofferphotos(
//       List<File> imageFiles, String restaurantId) async {
//     List<String> imageUrls = [];
//
//     for (int i = 0; i < imageFiles.length; i++) {
//       final File imageFile = imageFiles[i];
//       final ext = imageFile.path.split('.').last;
//       log('Extension : ${ext}');
//
//       final firebaseStorageRef = FirebaseStorage.instance
//           .ref()
//           .child('offerPhotos/${restaurantId}_$i.$ext');
//
//       await firebaseStorageRef.putFile(
//         imageFile,
//         SettableMetadata(
//           contentType: 'image/$ext',
//         ),
//       );
//
//       final imageUrl = await firebaseStorageRef.getDownloadURL();
//       imageUrls.add(imageUrl);
//     }
//
//     return imageUrls;
//   }
//
//   Future<List<String>> uploadimagesphotos(
//       List<File> imageFiles, String restaurantId) async {
//     List<String> imageUrls = [];
//
//     for (int i = 0; i < imageFiles.length; i++) {
//       final File imageFile = imageFiles[i];
//       final ext = imageFile.path.split('.').last;
//       log('Extension : ${ext}');
//
//       final firebaseStorageRef = FirebaseStorage.instance
//           .ref()
//           .child('imagePhotos/${restaurantId}_$i.$ext');
//
//       await firebaseStorageRef.putFile(
//         imageFile,
//         SettableMetadata(
//           contentType: 'image/$ext',
//         ),
//       );
//
//       final imageUrl = await firebaseStorageRef.getDownloadURL();
//       imageUrls.add(imageUrl);
//     }
//
//     return imageUrls;
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/constant/utils/utilities.dart';
import '../../../controller/auth.dart';

class RestroUpload extends StatefulWidget {
  final type;

  RestroUpload({Key? key, required this.type}) : super(key: key);

  @override
  _RestroUploadState createState() => _RestroUploadState();
}

class _RestroUploadState extends State<RestroUpload> {
  bool? present;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  List<File> restroImages = [];

  Future<bool> selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);

      // Convert XFile to File and add to menuImages list
      restroImages.addAll(selectedImages.map((xfile) => File(xfile.path)));

      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        elevation: 0,
        centerTitle: true,
        title: widget.type == "Menu"
            ? Text("Upload Your Menu")
            : widget.type == "Offers"
            ? Text("Upload Your Offers")
            : Text("Upload Your Images"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: imageFileList.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(imageFileList[index].path),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            MaterialButton(
              color: Colors.purple,
              onPressed: () async {
                bool exists = await selectImages();
                setState(() {
                  present = exists;
                });
                print("The present is $present");
              },
              child: Text(
                'Pick Your Images',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            present == true
                ? MaterialButton(
              color: Colors.purple,
              onPressed: () async {
                print(restroImages);
                List<String> newMenuUrl = [];
                List<String> newOfferUrl = [];
                List<String> newImageUrl = [];
                widget.type == "Menu"
                    ? newMenuUrl = await uploadmenuphotos(
                    restroImages, Auth.auth.currentUser!.uid)
                    : widget.type == "Offers"
                    ? newOfferUrl = await uploadofferphotos(
                    restroImages, Auth.auth.currentUser!.uid)
                    : newImageUrl = await uploadimagesphotos(
                    restroImages, Auth.auth.currentUser!.uid);
                //print("New Image URLs: $newImageUrls");
                // Fetch the existing menuList
                List<String> existingImageUrls = [];
                var docSnapshot = await Auth.shopManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('restaurant')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('details')
                    .doc(Auth.auth.currentUser!.uid)
                    .get();

                if (docSnapshot.exists) {
                  var data = docSnapshot.data() as Map<String, dynamic>;
                  if (data.containsKey('menuList') &&
                      data['menuList'] is List &&
                      widget.type == "Menu") {
                    existingImageUrls =
                    List<String>.from(data['menuList']);
                  } else if (data.containsKey('offerList') &&
                      data['offerList'] is List &&
                      widget.type == "Offers") {
                    existingImageUrls =
                    List<String>.from(data['offerList']);
                  } else if (data.containsKey('imageList') &&
                      data['imageList'] is List &&
                      widget.type == "Images") {
                    existingImageUrls =
                    List<String>.from(data['imageList']);
                  }
                }
                print("Typee $existingImageUrls");
                List<String> updatedImageUrls = [];
                // Append the new image URLs to the existing menuList
                if (widget.type == "Menu") {
                  updatedImageUrls = List<String>.from(existingImageUrls)
                    ..addAll(newMenuUrl);
                } else if (widget.type == "Offers") {
                  updatedImageUrls = List<String>.from(existingImageUrls)
                    ..addAll(newOfferUrl);
                } else {
                  updatedImageUrls = List<String>.from(existingImageUrls)
                    ..addAll(newImageUrl);
                }

                // Update the document with the updated menuList
                widget.type == "Menu"
                    ? await Auth.shopManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('restaurant')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('details')
                    .doc(Auth.auth.currentUser!.uid)
                    .update({
                  'menuList': updatedImageUrls,
                })
                    : widget.type == "Offers"
                    ? await Auth.shopManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('restaurant')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('details')
                    .doc(Auth.auth.currentUser!.uid)
                    .update({
                  'offerList': updatedImageUrls,
                })
                    : await Auth.shopManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('restaurant')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('details')
                    .doc(Auth.auth.currentUser!.uid)
                    .update({
                  'imageList': updatedImageUrls,
                });
                ;

                Utilities().showMessage("Menu Uploaded");
                present = false;
                setState(() {});
              },
              child: Text(
                'Upload Your Images',
                style: TextStyle(color: Colors.white70),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<List<String>> uploadmenuphotos(
      List<File> imageFiles, String restaurantId) async {
    List<String> imageUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final File imageFile = imageFiles[i];
      final ext = imageFile.path.split('.').last;
      log('Extension : ${ext}');

      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('menuPhotos/${restaurantId}_$i.$ext');

      await firebaseStorageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/$ext',
        ),
      );

      final imageUrl = await firebaseStorageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  Future<List<String>> uploadofferphotos(
      List<File> imageFiles, String restaurantId) async {
    List<String> imageUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final File imageFile = imageFiles[i];
      final ext = imageFile.path.split('.').last;
      log('Extension : ${ext}');

      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('offerPhotos/${restaurantId}_$i.$ext');

      await firebaseStorageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/$ext',
        ),
      );

      final imageUrl = await firebaseStorageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  Future<List<String>> uploadimagesphotos(
      List<File> imageFiles, String restaurantId) async {
    List<String> imageUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final File imageFile = imageFiles[i];
      final ext = imageFile.path.split('.').last;
      log('Extension : ${ext}');

      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('imagePhotos/${restaurantId}_$i.$ext');

      await firebaseStorageRef.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/$ext',
        ),
      );

      final imageUrl = await firebaseStorageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }
}