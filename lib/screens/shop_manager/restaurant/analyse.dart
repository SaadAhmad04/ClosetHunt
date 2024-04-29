import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../../controller/auth.dart';
import '../../../main.dart';

class Analyse extends StatefulWidget {
  const Analyse({super.key});

  @override
  State<Analyse> createState() => _AnalyseState();
}

class _AnalyseState extends State<Analyse> {
  List<ChartData> chartData = [];
  DateTime? currentDate, threeMonthsAgo;
  List<Map<String, dynamic>> serviceData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDate = DateTime.now();
  }

  Future<void> returnServices() async {
    currentDate = DateTime.now();
    threeMonthsAgo = currentDate?.subtract(Duration(days: 90));
    await Auth.shopManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('payments')
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
          serviceData.add(documentSnapshot.data() as Map<String, dynamic>);
        });
      },
    );
    double payment = 0.0;
    DateTime? date;
    for (int i = 0; i < serviceData.length; i++) {
      int ms = int.parse(serviceData[i]['date']);
      date = DateTime.fromMillisecondsSinceEpoch(ms);
      if(date.isAfter(threeMonthsAgo!) || date.isAtSameMomentAs(threeMonthsAgo!)){
        payment += serviceData[i]['amount'];
        chartData.add(ChartData(dates: date, payment: payment));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Analysis',
          style: TextStyle(color: Colors.purple.shade500, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.purple.shade50,
      body: FutureBuilder(
        future: returnServices(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          else{
            return Card(
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .2, horizontal: mq.width * .08),
                child: SfCartesianChart(
                  primaryYAxis: NumericAxis(),
                    primaryXAxis: DateTimeAxis(
                        minimum: threeMonthsAgo,
                        maximum: currentDate,
                        interval: 0.18,
                        intervalType: DateTimeIntervalType.months),
                    series: <CartesianSeries<ChartData, DateTime>>[
                      // Renders line chart
                      LineSeries<ChartData, DateTime>(
                        color: Colors.purple.shade200,
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.dates,
                          yValueMapper: (ChartData data, _) => data.payment)
                    ]));
          }
        }
      ),
    );
  }
}

class ChartData {
  DateTime dates;
  double payment;
  Color? color;

  ChartData({
    required this.dates,
    required this.payment,
    this.color,
  });
}
