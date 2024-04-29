import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mall/screens/app_manager/view_shop_analysis.dart';
import '../../controller/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../main.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  bool? exists;
  bool? showDateHeader;
  String? orderId, type;
  double sale = 0.0;
  Map<String, List<String>>? map = {};
  Set<ChartData> chartData = {};
  bool isChartReady = false;
  String? shopName, shopIcon;
  bool showChart = false;
  bool showPie = false;
  int c = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth.shopManagerRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          chartData.clear();
          return Scaffold(
            backgroundColor: Color(0xff1D1F33),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Color(0xff1D1F33),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            showChart = true;
                          });
                        },
                        child: Container(
                          height: mq.height * .2,
                          width: mq.width * .6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade900,
                                    Colors.blueGrey.shade200
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight)),
                          child: Center(
                            child: showChart == false
                                ? Text('Click to Analyse')
                                : Text(
                                    'Click on shop name\n   to view analysis',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final sellerId = snapshot.data!.docs[index]['uid'];
                return FutureBuilder(
                  future: checkSubcollectionExistence(sellerId),
                  builder: (context, sp) {
                    if (sp.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    } else if (sp.connectionState == ConnectionState.done) {
                      if (exists == true && map![sellerId]?[1] != null) {
                        return StreamBuilder(
                          stream: type == 'restaurant'
                              ? Auth.shopManagerRef
                                  .doc(sellerId)
                                  .collection('payments')
                                  .snapshots()
                              : Auth.shopManagerRef
                                  .doc(sellerId)
                                  .collection('notifications')
                                  .snapshots(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              map!.forEach((key, value) {
                                chartData.add(ChartData(
                                    shopName: value[1],
                                    sales: double.parse(value[2]),
                                    type: value[0]));
                              });
                              if (index == snapshot.data!.docs.length - 1) {
                                isChartReady = true;
                              }
                              if (isChartReady &&
                                  map!.length == chartData.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      showChart == true
                                          ? SfCartesianChart(
                                              isTransposed: true,
                                              primaryXAxis: CategoryAxis(
                                                labelRotation:
                                                    -45, // Rotate labels by -45 degrees
                                                labelStyle:
                                                    TextStyle(fontSize: 10),
                                              ),
                                              margin: EdgeInsets.all(
                                                  18), // Add margin
                                              series: <CartesianSeries>[
                                                BarSeries<ChartData, String>(
                                                  dataSource: chartData
                                                      .toList(), // Use the uniqueChartData list
                                                  xValueMapper:
                                                      (ChartData data, _) =>
                                                          data.shopName,
                                                  yValueMapper:
                                                      (ChartData data, _) =>
                                                          data.sales,
                                                )
                                              ],
                                              onAxisLabelTapped: (args) {
                                                if (args.axisName ==
                                                    'primaryXAxis') {
                                                  print(args.text);
                                                  map!.forEach((key, value) {
                                                    if (value[1] == args.text) {
                                                      print(value[0]);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ViewShopAnalysis(
                                                                    shopId: key,
                                                                    type: value[0] ==
                                                                            'shop'
                                                                        ? 'shopping'
                                                                        : 'booking',
                                                                    restro: value[0] ==
                                                                            'restaurant'
                                                                        ? true
                                                                        : false,
                                                                    shopName: value[1],
                                                                  )));
                                                    }
                                                  });
                                                }
                                              },
                                            )
                                          : SizedBox(),
                                      showChart == true &&
                                              map!.length == chartData.length
                                          ? SfCircularChart(
                                              series: <CircularSeries>[
                                                  // Render pie chart
                                                  PieSeries<ChartData, String>(
                                                    dataSource: chartData
                                                        .toList(), // Use the uniqueChartData list
                                                    pointColorMapper:
                                                        (ChartData data, _) =>
                                                            data.color,
                                                    xValueMapper:
                                                        (ChartData data, _) =>
                                                            data.shopName,
                                                    yValueMapper:
                                                        (ChartData data, _) =>
                                                            data.sales,
                                                    dataLabelMapper:
                                                        (ChartData data, _) =>
                                                            '${data.shopName}',
                                                    dataLabelSettings:
                                                        DataLabelSettings(
                                                      isVisible:
                                                          true, // Ensure labels are visible
                                                      labelPosition:
                                                          ChartDataLabelPosition
                                                              .inside,
                                                      color: Colors.white,
                                                      showZeroValue: false,
                                                      offset: Offset.zero,
                                                    ),
                                                  )
                                                ],
                                        onDataLabelTapped: (args) {
                                            print(args.text);
                                            map!.forEach((key, value) {
                                              if (value[1] == args.text) {
                                                print(value[0]);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewShopAnalysis(
                                                              shopId: key,
                                                              type: value[0] ==
                                                                  'shop'
                                                                  ? 'shopping'
                                                                  : 'booking',
                                                              restro: value[0] ==
                                                                  'restaurant'
                                                                  ? true
                                                                  : false,
                                                              shopName: value[1],
                                                            )));
                                              }
                                            });
                                        },
                                      )
                                          : SizedBox()
                                    ],
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return SizedBox();
                            }
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
            ),
          );
        } else if (snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
          print('hellppppppppppppo');
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Text('No shops'),
        );
      },
    );
  }

  Future<bool> checkSubcollectionExistence(String shopId) async {
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document = mainCollection.doc(shopId);

    final subCollections = ['shop', 'parlor', 'restaurant'];

    for (final subCollection in subCollections) {
      final CollectionReference subCollectionRef =
          Auth.shopManagerRef.doc(shopId).collection(subCollection);
      final QuerySnapshot querySnapshot = await subCollectionRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic>? data =
              await document.data() as Map<String, dynamic>?;
          if (data != null) {
            List<Map<String, dynamic>> documentsData = [];
            // if (subCollection == 'shop' || subCollection == 'parlor') {
            subCollection == 'restaurant'
                ? await Auth.shopManagerRef
                    .doc(shopId)
                    .collection('payments')
                    .get()
                    .then(
                    (QuerySnapshot querySnapshot) {
                      querySnapshot.docs
                          .forEach((QueryDocumentSnapshot documentSnapshot) {
                        documentsData.add(
                            documentSnapshot.data() as Map<String, dynamic>);
                      });
                    },
                  )
                : await Auth.shopManagerRef
                    .doc(shopId)
                    .collection('notifications')
                    .get()
                    .then(
                    (QuerySnapshot querySnapshot) {
                      querySnapshot.docs
                          .forEach((QueryDocumentSnapshot documentSnapshot) {
                        documentsData.add(
                            documentSnapshot.data() as Map<String, dynamic>);
                      });
                    },
                  );
            sale = 0.0;
            for (int i = 0; i < documentsData.length; i++) {
              if (subCollection == 'parlor') {
                sale += double.parse(documentsData[i]['servicePrice']);
              }
              if (subCollection == 'shop') {
                sale += documentsData[i]['perprice'];
              }
              if (subCollection == 'restaurant') {
                sale += documentsData[i]['amount'];
              }
            }
            exists = true;
            type = subCollection;
            map![shopId] = [subCollection, data['shopName'], sale.toString()];
            print('maaaaaaaaaaaaap${map![shopId]}');
            return true;
            // }
          }
        }
      }
    }

    exists = false;
    type = null;
    return false;
  }
}

class ChartData {
  String shopName;
  double sales;
  Color? color;
  String type;

  ChartData(
      {required this.shopName,
      required this.sales,
      this.color,
      required this.type});
}
