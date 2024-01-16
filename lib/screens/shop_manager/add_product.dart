import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/screens/shop_manager/shop_display.dart';
import 'package:mall/screens/shop_manager/shop_manager_home.dart';
import 'package:mall/screens/shop_manager/view_product.dart';
import '../../constant/utils/utilities.dart';
import '../../controller/auth.dart';
import '../../main.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final productNameController = TextEditingController();
  final productIdController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final imageIdController = TextEditingController();
  final productPriceController = TextEditingController();
  final sellerNameController = TextEditingController();
  final sellerIdController = TextEditingController();
  final deliveryTimeController = TextEditingController();
  File? productImage;
  final productImagePicker = ImagePicker();
  bool isProductImageUploaded = false;
  var category = [
    "Select category",
    "Clothing",
    "Shoes",
    "Skin care",
    "accessories",
    "Baby care",
    "Fragrance"
  ];
  String dropDownValue = 'Select category';
  var size = ['Select size', 'S', 'M', 'L', 'XL', 'XXL'];
  var numSizes = [
    'Select size',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13'
  ];
  bool isClothing = false;
  bool isShoes = false;
  String dropDownSize = 'Select size';
  final _formKey = GlobalKey<FormState>();
  var x;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: mq.height / 2,
                        width: mq.width,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft:
                                          Radius.circular(mq.width * .12),
                                      bottomRight:
                                          Radius.circular(mq.width * .12)),
                                  child: productImage != null
                                      ? Image.file(
                                          File(productImage!.path).absolute,
                                          fit: BoxFit.cover,
                                          width: mq.width,
                                          height: mq.height / 2.1,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade400),
                                        ),
                                )),
                            Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: mq.height * .08,
                                      horizontal: mq.width * .04),
                                  child: isProductImageUploaded == false
                                      ? ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            final pickedFile =
                                                await productImagePicker
                                                    .pickImage(
                                                        source:
                                                            ImageSource.gallery,
                                                        imageQuality: 80);
                                            setState(() {
                                              if (pickedFile != null) {
                                                productImage =
                                                    File(pickedFile.path);
                                                isProductImageUploaded = true;
                                              } else {
                                                Utilities().showMessage(
                                                    'No image selected');
                                              }
                                            });
                                          },
                                          icon: Icon(Icons.upload),
                                          label: Text('Upload product image'))
                                      : SizedBox(),
                                )),
                          ],
                        ),
                      ),
                      isProductImageUploaded
                          ? TextButton(
                              onPressed: () async {
                                final pickedFile =
                                    await productImagePicker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 80);
                                setState(() {
                                  if (pickedFile != null) {
                                    productImage = File(pickedFile.path);
                                    isProductImageUploaded = true;
                                  } else {
                                    Utilities()
                                        .showMessage('No image selected');
                                  }
                                });
                              },
                              child: Text(
                                'Change picture',
                                style: TextStyle(fontSize: 18),
                              ))
                          : SizedBox(
                              height: 10,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton(
                            value: dropDownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: category.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue = newValue!;
                                if (dropDownValue == 'Clothing') {
                                  isClothing = true;
                                  isShoes = false;
                                } else if (dropDownValue == 'Shoes') {
                                  isShoes = true;
                                  isClothing = false;
                                } else {
                                  isClothing = false;
                                  isShoes = false;
                                }
                              });
                            },
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          isClothing
                              ? DropdownButton(
                                  value: dropDownSize,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: size.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropDownSize = newValue!;
                                    });
                                  },
                                )
                              : isShoes
                                  ? DropdownButton(
                                      value: dropDownSize,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: numSizes.map((String item) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropDownSize = newValue!;
                                        });
                                      },
                                    )
                                  : SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: productNameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('Product Name'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: productIdController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('Product Id'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter product id';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        minLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9 ]'))
                        ],
                        maxLines: 5,
                        controller: productDescriptionController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('Product Description'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter description';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: imageIdController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9]'))
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('Image id'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter image id';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: productPriceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('Product Price (in Rs.)'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter price';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: sellerNameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('Seller name'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter seller name';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: sellerIdController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9]'))
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('Seller id'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter seller id';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: deliveryTimeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9 ]'))
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text('Delivery Time'),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter delivery time';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      createButtonbar(),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget createButtonbar() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ShopDisplay()));
          },
          child: Container(
            width: mq.width / 2.2,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.orange.shade300,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Center(
              child: Text(
                'Back',
                style: TextStyle(
                    fontSize: 25, color: Colors.white, fontFamily: 'Garamond1'),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              if (dropDownValue != 'Select category') {
                if (dropDownValue == 'Clothing' || dropDownValue == 'Shoes') {
                  x = dropDownSize;
                } else {
                  x = "";
                }
                if (productImage != null) {
                  String imageUrl = await Auth.uploadProductImage(productImage!);
                  print('image ${imageUrl}');
                  Auth.shopManagerRef
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('shop')
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('products')
                      .doc(productIdController.text.toString())
                      .set({
                    'name': productNameController.text.toString(),
                    'usItemId': productIdController.text.toString(),
                    'productDescription':
                        productDescriptionController.text.toString(),
                    'thumbnailUrl': imageUrl,
                    'imageId': imageIdController.text.toString(),
                    'category': dropDownValue.toString(),
                    'size': x.toString(),
                    'price': productPriceController.text.toString(),
                    'sellerName': sellerNameController.text.toString(),
                    'sellerId': sellerIdController.text.toString(),
                    'deliveryTime': deliveryTimeController.text.toString()
                  });
                  // Auth.shopManagerRef
                  //     .doc(Auth.auth.currentUser!.uid)
                  //     .collection('products')
                  //     .doc("${DateTime.now()}")
                  //     .set({
                  //   'image':productImage.toString(),
                  //   'productName': productNameController.text.toString(),
                  //   'productPrice': productPriceController.text.toString(),
                  //   'productDescription':
                  //       productDescriptionController.text.toString(),
                  //   'uid': Auth.auth.currentUser!.uid
                  // });
                }
              }
            }
          },
          child: Container(
            width: mq.width / 2.2,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Center(
              child: Text(
                'Add Product',
                style: TextStyle(
                    fontSize: 25, color: Colors.white, fontFamily: 'Garamond1'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
