import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/screens/shop_manager/product_order.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mall/controller/auth.dart';
import 'package:mall/screens/shop_manager/add_product.dart';
import 'package:mall/screens/shop_manager/multiple_products.dart';
import 'package:mall/screens/shop_manager/view_product.dart';
import 'package:convert/convert.dart';
import 'package:path_provider/path_provider.dart';
import '../../main.dart';

class ShopDisplay extends StatefulWidget {
  ShopDisplay({super.key});

  @override
  State<ShopDisplay> createState() => _ShopDisplayState();
}

class _ShopDisplayState extends State<ShopDisplay> {
  bool done = false;
  File? shopIcon;
  final shopIconPicker = ImagePicker();
  Stream<QuerySnapshot>? stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = Auth.shopManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('shop')
        .where('shopId', isEqualTo: Auth.auth.currentUser!.uid)
        .snapshots();
  }

  File? _file;
  List<Map<String, dynamic>> _excelData = [];
  List<Map<String, dynamic>> _originalExcelData = [];
  bool col = false;
  List duplicate = [];
  late String shopName;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data!.docs.length);
            return Scaffold(
                backgroundColor: Colors.grey.shade700,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  title: Text("HII"),
                  centerTitle: true,
                  elevation: 0,
                  actions: [
                    done == true
                        ? TextButton(
                        onPressed: () async {
                          if (shopIcon != null) {
                            String imageUrl = await Auth.uploadShopIcon(
                                shopIcon!, Auth.auth.currentUser!.uid);
                            await Auth.shopManagerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('shop')
                                .doc(Auth.auth.currentUser!.uid)
                                .update({
                              'shopIcon': imageUrl,
                            });
                            setState(() {
                              done = !done;
                            });
                            Utilities().showMessage("Icon Updated!");
                          }
                        },
                        child: Text("Done"))
                        : IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.home),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                shopName =
                                snapshot.data!.docs[index]['shopName'];
                                return Card(
                                  color: Colors.blueGrey.shade200,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                      leading: shopIcon != null
                                          ? Image.file(
                                        File(shopIcon!.path).absolute,
                                        fit: BoxFit.cover,
                                        height: 50,
                                        width: 50,
                                      )
                                          : Image.network(
                                          snapshot.data!.docs[index]
                                          ['shopIcon'],
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover),
                                      title: Text(
                                        snapshot.data!.docs[index]['shopName'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.docs[index]['shopId'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      trailing: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: PopupMenuButton(
                                            icon: Icon(Icons.more_vert),
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                  value: 1,
                                                  child: ListTile(
                                                    onTap: () async {
                                                      Navigator.pop(
                                                          context);
                                                      final pickedFile =
                                                      await shopIconPicker.pickImage(
                                                          source:
                                                          ImageSource
                                                              .gallery,
                                                          imageQuality:
                                                          80);

                                                      setState(() {
                                                        if (pickedFile !=
                                                            null) {
                                                          done = !done;
                                                          print(done);
                                                          shopIcon = File(
                                                              pickedFile
                                                                  .path);
                                                        } else {
                                                          print("no");
                                                          Utilities()
                                                              .showMessage(
                                                              "No image selected");
                                                        }
                                                      });
                                                    },
                                                    title:
                                                    Text("Change Icon"),
                                                    leading:
                                                    Icon(Icons.shop),
                                                  )),
                                            ]),
                                      )),
                                );
                              })),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 10,
                        padding: EdgeInsets.all(10),
                        children: [
                          InkWell(
                            onTap: () {
                              showTypeDialog(context);
                            },
                            child: Container(
                              height: 100,
                              width: mq.width / 2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade500,
                                        Colors.blue.shade200
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                              child: Center(
                                child: Text(
                                  'Add Products',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewProduct(
                                        shopName: shopName,
                                      )));
                            },
                            child: Container(
                              height: 100,
                              width: mq.width / 2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.yellow.shade500,
                                        Colors.yellow.shade200
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                              child: Center(
                                child: Text(
                                  'View Products',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderProduct(),
                                  ));
                            },
                            child: Container(
                              height: 100,
                              width: mq.width / 2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.green.shade500,
                                        Colors.green.shade200
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                              child: Center(
                                child: Text(
                                  'Orders',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Auth.logout(context);
                            },
                            child: Container(
                              height: 100,
                              width: mq.width / 2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.red.shade500,
                                        Colors.red.shade200
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                              child: Center(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  File? selectedExcelFile;
  String? path;

  Future<void> showTypeDialog(BuildContext context) {
    DateTime? dateTime;
    return showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: StatefulBuilder(builder: (context, setModalState) {
                return SizedBox(
                  height: mq.height / 5,
                  width: mq.width - 50,
                  child: Column(
                    children: [
                      Text('Select type'),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddProduct()),
                                  (route) => false);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                            width: 200,
                            height: 40,
                            child: Center(
                              child: Text(
                                'Single Product',
                                style:
                                TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showFileDialog(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                            width: 200,
                            height: 40,
                            child: Center(
                              child: Text(
                                'Multiple Products(File)',
                                style:
                                TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              }));
        });
  }

  Future<void> _getFile() async {
    bool correct = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _file = file;
      });

      if (_file!.path.toLowerCase().endsWith('.xlsx')) {
        var bytes = _file!.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        if (excel.tables.keys.isNotEmpty) {
          var sheet = excel.tables[excel.tables.keys.first]!;

          // Extracting row data into a list of maps (key-value pairs)
          for (var row in sheet.rows) {
            //print('key : ${row.first?.value}');
            var rowData = <String, dynamic>{};
            for (var i = 0; i < row.length; i++) {
              //print(row[i]?.value);
              rowData[sheet
                  .cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: i))
                  .value
                  .toString()] = row[i]?.value;
            }
            if (rowData.keys.toString() == rowData.values.toString()) {
              rowData.remove(rowData.keys);
            } else {
              _excelData.add(rowData);
            }
          }
          Map<String, dynamic> map = {};
          List a = [];
          int count;
          for (var m in _excelData) {
            count = 0;
            m.forEach((key, value) {
              switch (key) {
                case 'name':
                  count += 1;
                case 'productId':
                  count += 1;
                case 'imageUrl':
                  count += 1;
                  print("====================");
                case 'imageId':
                  count += 1;
                case 'categoryPath':
                  count += 1;
                case 'price':
                  count += 1;
                case 'sellerName':
                  count += 1;
                case 'sellerId':
                  count += 1;
                case 'deliveryTime':
                  count += 1;
                case 'variantCount':
                  count += 1;
                case 'variantPriceString':
                  count += 1;
                case 'orderLimit':
                  count += 1;
                case 'uploadedBy':
                  count += 1;
                default:
                  correct = false;
                  break;
              }
              map[key] = value;
            });
            if (count == 12) {
              a.add(m);
            } else {
              correct = false;
              break;
            }
          }
          if (correct) {
            for (var i = 0; i < a.length - 1; i++) {
              for (var j = i + 1; j < a.length; j++) {
                //col = true;
                if (a[i]['productId'] == a[j]['productId']) {
                  print(
                      "Duplicate product Id ${a[j]['productId']} found at index $j");
                  //duplicate.add
                } else {
                  //col = false;
                }
              }
            }
          } else {
            showFileDialog(context);
            Utilities().showMessage(
                'Either your file keys are not case sensitive or there are less number of keys according to the given standard , kindly change it');
          }
        }
        if (correct) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MultipleProducts(excelData: _excelData)));
        }
      } else {
        print('Selected file is not an Excel file');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a file'),
      ));
    }
    setState(() {});
  }

  Future<void> showFileDialog(BuildContext context) {
    return showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: SizedBox(
                      child: Column(
                        children: [
                          Container(
                            child: Table(
                              border: TableBorder.all(color: Colors.black),
                              children: [
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Text('Key'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Values'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('name'),
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('blue colored printed Shirt'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('productId'),
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('1234567890'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Text('productDescription'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          'This shirt is made of extra silky fabric material'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('imageUrl'),
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('https://adidas.com/234sdf-3455.jpg'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Text('imageId'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('SAJW738BSD34KNS34'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('categoryPath'),
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Home/Clothing/Shop by Categoory/Shirt'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('price'),
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('899.99'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('sellerName'),
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('saad'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('sellerId'),
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('GFTY65VHGVHJ6743FD'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('deliveryTime'),
                                          Text(
                                            '*',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('2 to 3 days'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Text('variantCount'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('6'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Text('variantPriceString'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('867.76'),
                                    ],
                                  )
                                ]),
                                TableRow(children: [
                                  Column(
                                    children: [
                                      Text('orderLimit'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('6'),
                                    ],
                                  )
                                ]),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Note',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(
                              '1. Your products file should follow the above pattern'),
                          Text(
                              '2. If the keys column will not be written in the above format then products will not be uploaded'),
                          Text(
                              '3. The values of keys marked with * cannot be null'),
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
                                        fontSize: 20,
                                        color: Colors.yellow.shade600),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    _getFile();
                                  },
                                  child: Text(
                                    'Upload',
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ],
                          ),
                        ],
                      )),
                );
              },
            ),
          );
        });
  }
}