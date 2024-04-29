import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../controller/auth.dart';
import '../../../main.dart';

class ServiceAnalysis extends StatefulWidget {
  const ServiceAnalysis({super.key});

  @override
  State<ServiceAnalysis> createState() => _ServiceAnalysisState();
}

class _ServiceAnalysisState extends State<ServiceAnalysis> {
  List<ChartData> chartData = [];
  List<Map<String, dynamic>> serviceData = [];
  List<Map<String, dynamic>> salesData = [];

  Future<void> fetchData() async {
    await returnServices();
    await returnSales();
    for (int i = 0; i < serviceData.length; i++) {
      double sale = 0.0;
      for (int j = 0; j < salesData.length; j++) {
        if (salesData[j]['serviceName'] == serviceData[i]['serviceName']) {
          sale += double.parse(salesData[j]['servicePrice']);
        }
      }
      chartData.add(
          ChartData(serviceName: serviceData[i]['serviceName'], sales: sale));
    }
  }

  Future<void> returnServices() async {
    await Auth.shopManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('parlor')
        .doc(Auth.auth.currentUser!.uid)
        .collection('services')
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
          serviceData.add(documentSnapshot.data() as Map<String, dynamic>);
        });
      },
    );
  }

  Future<void> returnSales() async {
    await Auth.shopManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('notifications')
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
          salesData.add(documentSnapshot.data() as Map<String, dynamic>);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Service Analysis',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.purple.shade100,
        body: FutureBuilder<void>(
          future:
              fetchData(), // Call fetchData() to get the data asynchronously
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while data is being fetched
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Display an error message if an error occurs
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              for (int i = 0; i < chartData.length; i++) {
                log(chartData[i].sales.toStringAsFixed(2));
              }
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .2, horizontal: mq.width * .03),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(15)),
                child: SfCartesianChart(
                  isTransposed: true,
                  primaryXAxis: CategoryAxis(
                    labelRotation: -45, // Rotate labels by -45 degrees
                    labelStyle: TextStyle(fontSize: 10),
                  ),
                  margin: EdgeInsets.all(18), // Add margin
                  series: <CartesianSeries>[
                    BarSeries<ChartData, String>(
                      color: Colors.purple,
                      dataSource:
                          chartData.toList(), // Use the uniqueChartData list
                      xValueMapper: (ChartData data, _) => data.serviceName,
                      yValueMapper: (ChartData data, _) => data.sales,
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}

class ChartData {
  String serviceName;
  double sales;
  Color? color;

  ChartData({
    required this.serviceName,
    required this.sales,
    this.color,
  });
}
