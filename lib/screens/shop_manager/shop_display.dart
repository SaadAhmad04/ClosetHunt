import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/screens/shop_manager/product_order.dart';
import 'package:mall/screens/shop_manager/restaurant/view_payments.dart';
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
import 'package:pie_chart/pie_chart.dart';
import '../../main.dart';
import 'analysis.dart';

class ShopDisplay extends StatefulWidget {
  ShopDisplay({super.key});

  @override
  State<ShopDisplay> createState() => _ShopDisplayState();
}

class _ShopDisplayState extends State<ShopDisplay> {
  bool showPieChart = false;
  bool done = false;
  File? shopIcon;
  final shopIconPicker = ImagePicker();
  Stream<QuerySnapshot>? stream;
  double total = 0.0;
  double sales = 0.0;
  double profit = 0.0;
  double commission = 0.0;
  int cancelled = 0;

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
    final spinkit = SpinKitDancingSquare(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.purple,
          ),
        );
      },
    );
    Size mq = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              //backgroundColor: Colors.grey.shade700,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Dashboard",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                //centerTitle: true,
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
                          child: Text(
                            "Done",
                            style: TextStyle(color: Colors.purple),
                          ))
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Image.asset("images/homeicon.gif"))),
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
                              shopName = snapshot.data!.docs[index]['shopName'];
                              return Container(
                                //color: Colors.blue,
                                height: 200,
                                child: Card(
                                  elevation: 10,
                                  shadowColor: Colors.black,
                                  color: Colors.white70,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          height: mq.height * .15,
                                          width: mq.width * .3,
                                          color: Colors.white,
                                          child: shopIcon != null
                                              ? Image.file(
                                                  File(shopIcon!.path).absolute,
                                                  fit: BoxFit.cover,
                                                  // height: 150,
                                                  width: 50,
                                                )
                                              : Image.network(
                                                  snapshot.data!.docs[index]
                                                      ['shopIcon'],
                                                  // height: 150,
                                                  width: 50,
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      Container(
                                        //color: Colors.blue,
                                        height: 140,
                                        width: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 140, top: 10),
                                                //color: Colors.blue,
                                                width: 30,
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_vert),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                              value: 1,
                                                              child: ListTile(
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  final pickedFile = await shopIconPicker.pickImage(
                                                                      source: ImageSource
                                                                          .gallery,
                                                                      imageQuality:
                                                                          80);

                                                                  setState(() {
                                                                    if (pickedFile !=
                                                                        null) {
                                                                      done =
                                                                          !done;
                                                                      print(
                                                                          done);
                                                                      shopIcon =
                                                                          File(pickedFile
                                                                              .path);
                                                                    } else {
                                                                      print(
                                                                          "no");
                                                                      Utilities()
                                                                          .showMessage(
                                                                              "No image selected");
                                                                    }
                                                                  });
                                                                },
                                                                title: Text(
                                                                    "Change Icon"),
                                                                leading: Icon(
                                                                    Icons.shop),
                                                              )),
                                                        ]),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['shopName'],
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['shopId'],
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .library_add_check_rounded,
                                                        color: Colors.purple,
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      ),
                                                      Text(
                                                        "Shop Is Verified",
                                                        style: TextStyle(
                                                          //fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                    StreamBuilder(
                        stream: Auth.shopManagerRef
                            .doc(Auth.auth.currentUser!.uid)
                            .collection('notifications')
                            .snapshots(),
                        builder: (context, snap) {
                          total = 0.0;
                          sales = 0.0;
                          cancelled = 0;
                          profit = 0.0;
                          commission = 0.0;
                          if (snap.hasData) {
                            List<DocumentSnapshot> documents = snap.data!.docs;
                            documents.forEach((doc) {
                              Map<String, dynamic> data =
                                  doc.data() as Map<String, dynamic>;
                              String price = data['price'];
                              total += double.parse(price);
                              sales += data['cancelled'] == false
                                  ? double.parse(price)
                                  : 0;
                              cancelled = data['cancelled'] == true
                                  ? cancelled + 1
                                  : cancelled;
                              profit = data['cancelled'] == false
                                  ? sales - sales * .1
                                  : profit;
                              print('Sales======${sales}');
                              print('Profit======${profit}');
                            });
                            return Container(
                              decoration: BoxDecoration(
                                  //color: Colors.white,
                                  color: Colors.purple[50],
                                  borderRadius: BorderRadius.circular(20)),
                              height: mq.height * .35,
                              width: mq.width * .95,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.summarize_outlined,
                                          color: Colors.purple,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Summary",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: mq.width * .4,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                showPieChart = !showPieChart;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                showPieChart == false
                                                    ? Text(
                                                        "Visualize",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.purple),
                                                      )
                                                    : Text(
                                                        "Illustrate",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.purple),
                                                      ),
                                                Icon(
                                                  showPieChart == false
                                                      ? Icons.pie_chart
                                                      : Icons
                                                          .wrap_text_outlined,
                                                  size: 13,
                                                  color: Colors.purple,
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                    showPieChart == false
                                        ? SizedBox(
                                            height: 30,
                                          )
                                        : SizedBox(),
                                    showPieChart == false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "${snap.data!.docs.length}",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Total Orders",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Rs.${total.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Total Amount",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Rs.${sales.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Sales",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        : PieChart(
                                            dataMap: {
                                              'Total Amount': total,
                                              "Sales ": sales,
                                              "Profit": profit,
                                              "Commission": sales - profit
                                            },
                                            legendOptions: LegendOptions(
                                              legendPosition:
                                                  LegendPosition.right,
                                              showLegendsInRow: false,
                                            ),
                                            animationDuration: const Duration(
                                                milliseconds: 2500),
                                            chartType: ChartType.disc,
                                            ringStrokeWidth: 18,
                                            chartRadius: 150,
                                            colorList: [
                                              Color(0xFF00B0FF),
                                              Color(0xFFD78000),
                                              Color(0xFF388E3C),
                                              Color(0xFFD50000),
                                            ],
                                          ),
                                    showPieChart == false
                                        ? SizedBox(
                                            height: 35,
                                          )
                                        : SizedBox(),
                                    showPieChart == false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "${cancelled}",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Orders cancelled",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Rs.${profit.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Profit",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "Rs.${(sales - profit).toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Commission",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10.0),
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: Colors.black,
                          elevation: 10,
                          child: ListTile(
                            onTap: () {
                              showTypeDialog(context);
                            },
                            tileColor: Colors.white24,
                            leading: Icon(
                              Icons.add,
                              color: Colors.purple,
                            ),
                            title: Text("Add Products"),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                showTypeDialog(context);
                              },
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: Colors.black,
                          elevation: 10,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewProduct(
                                            shopName: shopName,
                                          )));
                            },
                            tileColor: Colors.white24,
                            leading: Icon(
                              Icons.view_comfy_alt_outlined,
                              color: Colors.purple,
                            ),
                            title: Text("View Products"),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewProduct(
                                              shopName: shopName,
                                            )));
                              },
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: Colors.black,
                          elevation: 10,
                          child: ListTile(
                            tileColor: Colors.white24,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderProduct(),
                                  ));
                            },
                            leading: Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.purple,
                            ),
                            title: Text("Orders"),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderProduct(),
                                    ));
                              },
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: Colors.black,
                          elevation: 10,
                          child: ListTile(
                            tileColor: Colors.white24,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Analysis(shopName: shopName,),
                                  ));
                            },
                            leading: Icon(
                              Icons.summarize_outlined,
                              color: Colors.purple,
                            ),
                            title: Text("Summary"),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Analysis(
                                        shopName: shopName,
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: Colors.black,
                          elevation: 10,
                          child: ListTile(
                            onTap: () {
                              Auth.logout(context);
                            },
                            tileColor: Colors.white24,
                            leading: Icon(
                              Icons.logout,
                              color: Colors.purple,
                            ),
                            title: Text("Logout"),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Auth.logout(context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Visit App Manager For any Queries',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPayments(
                                payment: false,
                                shop: true,
                              )));
                },
                elevation: 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.history,
                  color: Colors.purple,
                ),
              ),
            );
          } else {
            return Center(
              child: spinkit,
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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.purple),
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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.purple),
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
                case 'size':
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
                default:
                  correct = false;
                  break;
              }
              map[key] = value;
            });
            if (count == 13) {
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
                                  Text('Size'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('L(for cloths)\n7(for footwears)'),
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
