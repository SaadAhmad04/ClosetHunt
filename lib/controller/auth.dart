import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/app_manager/app_manager_home.dart';
import 'package:mall/screens/shop_manager/shop_manager_home.dart';
import 'package:path/path.dart';
import '../screens/app_manager/add_delivery_boys.dart';
import '../screens/customer/rive/NavigationPoint.dart';
import '../screens/delivery/delivery_home.dart';
import 'firebase_api.dart';
import '../constant/utils/utilities.dart';
import '../screens/auth_ui/login_screen.dart';
import '../screens/customer/customer_home.dart';
import 'package:image_picker/image_picker.dart';

class Auth {
  static final auth = FirebaseAuth.instance;
  static final customerRef = FirebaseFirestore.instance.collection('customer');
  static final deliveryRef = FirebaseFirestore.instance.collection('delivery');
  static final appManagerRef =
      FirebaseFirestore.instance.collection('appManager');
  static final shopManagerRef =
      FirebaseFirestore.instance.collection('shopManager');
  static final bookingRef = FirebaseFirestore.instance.collection('booking');
  static final shopRef = Auth.shopManagerRef
      .doc(Auth.auth.currentUser!.uid)
      .collection('shop')
      .doc(Auth.auth.currentUser!.uid);
  static final productRef = FirebaseFirestore.instance.collection('products');
  static String dropdownvalue = 'Select Role';
  static var items = [
    'Select Role',
    'App Manager',
    'Shop Manager',
    'Customer',
    'Delivery Person'
  ];
  static final idController = TextEditingController();
  static File? profilePicture;
  static final profilePicturePicker = ImagePicker();

  static Future<void> login(
      String email, String password, BuildContext context) async {
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      if (dropdownvalue == 'Customer') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => NavigationPoint()));
      } else if (dropdownvalue == 'Shop Manager') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ShopManagerHome()));
      } else if (dropdownvalue == 'App Manager') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AppManagerHome()));
      } else if (dropdownvalue == 'Delivery Person') {
        showDetailDialog(context, email, password);
      }
    }).onError((error, stackTrace) {
      Utilities().showMessage(error.toString());
    });
  }

  static Future<void> deliveryAssign(String name, String phone, String email,
      String password, String id, BuildContext context) async {
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      deliveryRef.doc(id).set({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'id': id,
      });
      Utilities().showMessage("Success!");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddDeliveryBoys(),
          ));
    }).onError((error, stackTrace) {
      Utilities().showMessage(error.toString());
    });
  }

  static Future<void> changePassword(BuildContext context,
      String currentPasswordController, String newPasswordController) async {
    User? user = auth.currentUser;

    print(user!.uid);
    // Check if the current password is correct
    String currentPassword = currentPasswordController;
    AuthCredential credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: currentPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);

      // If reauthentication is successful, update the password
      String newPassword = newPasswordController;
      await user.updatePassword(newPassword);

      await customerRef
          .doc(user.uid)
          .update({'password': newPassword});
      // Password updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password updated successfully'),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      // If reauthentication fails, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
        ),
      );
      Navigator.pop(context);
    }
  }

  static Future<void> signUp(String name, String email, String password,
      String password2, BuildContext context) async {
    if (password == password2) {
      Center(
        child: CircularProgressIndicator(
          strokeWidth: 10,
          color: Colors.white,
        ),
      );
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (dropdownvalue == 'Customer') {
          customerRef.doc(auth.currentUser!.uid).set({
            'name': name,
            'email': email,
            'password': password,
            'type': dropdownvalue,
            'uid': auth.currentUser!.uid,
            'phone': "",
            'gender': "",
            'profilepic':
                'https://media.istockphoto.com/id/1462659206/photo/portrait-of-a-man-breathing-fresh-air-in-nature.webp?b=1&s=170667a&w=0&k=20&c=buxk0r8DkG1zuvVy0ob7bdMsBMoucDVMZmnW3z-exmk=',
          });
        } else if (dropdownvalue == 'Shop Manager') {
          shopManagerRef.doc(auth.currentUser!.uid).set({
            'name': name,
            'email': email,
            'password': password,
            'type': dropdownvalue,
            'uid': auth.currentUser!.uid
          });
        } else if (dropdownvalue == 'App Manager') {
          appManagerRef.doc(auth.currentUser!.uid).set({
            'name': name,
            'email': email,
            'password': password,
            'type': dropdownvalue,
            'uid': auth.currentUser!.uid
          });
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }).onError((error, stackTrace) {
        Utilities().showMessage(error.toString());
      });
    } else {
      Utilities().showMessage("Password doesn't match");
    }
  }

  static Future<void> forgotpassword(
    String email,
  ) async {
    auth.sendPasswordResetEmail(email: email.toString()).then((value) {
      Utilities().showMessage('Email sent');
    }).onError((error, stackTrace) {
      Utilities().showMessage(error.toString());
    });
  }

  static Future<void> logout(BuildContext context) async {
    auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  static Future<String> uploadRestroIcon(
      File imageFile, String parlorManagerId) async {
    final ext = imageFile.path.split('.').last;
    log('Extension : ${ext}');
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('restroIcons/${parlorManagerId}.$ext');
    await firebaseStorageRef.putFile(
        imageFile,
        SettableMetadata(
            contentType:
            'image/$ext')); //putting file with type in firebase storage
    final imageUrl = await firebaseStorageRef.getDownloadURL();
    return imageUrl;
  }

  static Future<String> uploadShopIcon(
      File imageFile, String shopManagerId) async {
    final ext = imageFile.path.split('.').last;
    log('Extension : ${ext}');
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('shopIcons/${shopManagerId}.$ext');
    await firebaseStorageRef.putFile(
        imageFile,
        SettableMetadata(
            contentType:
                'image/$ext')); //putting file with type in firebase storage
    final imageUrl = await firebaseStorageRef.getDownloadURL();
    return imageUrl;
  }

  static Future<String> uploadProfilePicture(File imageFile) async {
    final ext = imageFile.path.split('.').last;
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilePictures/${Auth.auth.currentUser!.uid}.$ext');
    await firebaseStorageRef.putFile(
        imageFile, SettableMetadata(contentType: 'image/$ext'));
    final imageUrl = await firebaseStorageRef.getDownloadURL();
    return imageUrl;
  }

  static Future<String> uploadProductImage(File imageFile) async {
    final ext = imageFile.path.split('.').last;
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('products/${Auth.auth.currentUser!.uid}.$ext');
    await firebaseStorageRef.putFile(
        imageFile, SettableMetadata(contentType: 'image/$ext'));
    final imageUrl = await firebaseStorageRef.getDownloadURL();
    return imageUrl;
  }

  static Future<String> uploadParlorIcon(
      File imageFile, String parlorManagerId) async {
    final ext = imageFile.path.split('.').last;
    log('Extension : ${ext}');
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('parlorIcons/${parlorManagerId}.$ext');
    await firebaseStorageRef.putFile(
        imageFile,
        SettableMetadata(
            contentType:
                'image/$ext')); //putting file with type in firebase storage
    final imageUrl = await firebaseStorageRef.getDownloadURL();
    return imageUrl;
  }

  static Future<void> showDetailDialog(
      BuildContext context, String email, String password) {
    final TextEditingController idController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          'Enter your Id',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextFormField(
                        controller: idController,
                        decoration: InputDecoration(hintText: 'Your Id'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.yellow.shade600),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              print("Clicked");

                              // Auth.deliveryRef.doc(id).delete();
                              Navigator.pop(context); // Close the dialog first

                              // Use Navigator.of(context) from the original page to navigate
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => DeliveryHome(
                                    id: idController.text.toString(),
                                    email: email,
                                    password: password,
                                  ),
                                ),
                              );

                              Utilities().showMessage("Done!");
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
