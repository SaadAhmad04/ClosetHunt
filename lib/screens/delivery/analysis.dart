import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../controller/auth.dart';
import '../../main.dart';
import 'delivery_home.dart';

class Analysis extends StatefulWidget {
  String? id, appManagerId;
  List? orderIds;
  Map<String, String>? status;
  Analysis({super.key, this.id, this.appManagerId, this.orderIds, this.status});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  double delivered = 0.0;
  double yetToDeliver = 0.0;
  double cancelled = 0.0;
  double total = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.status!.forEach((key, value) {
      if (widget.status![key] == "Cancelled") {
        cancelled += 1;
      } else if (widget.status![key] == "Delivered") {
        delivered += 1;
      } else if (widget.status![key] == "Yet to deliver") {
        yetToDeliver += 1;
      }
    });
    total = cancelled + delivered + yetToDeliver;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.orderIds!.length,
        itemBuilder: (context, index) {
          return StreamBuilder<QuerySnapshot>(
            stream: Auth.appManagerRef
                .doc(widget.appManagerId)
                .collection('notifications')
                .doc(widget.appManagerId)
                .collection('shopping')
                .doc(widget.orderIds![index].toString().substring(
                    0, widget.orderIds![index].toString().length - 1))
                .collection('products')
                .where('deliveryBoyId', isEqualTo: widget.id)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> st) {
              if (st.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (st.hasError) {
                return Center(child: Text('Error: ${st.error}'));
              } else if (st.hasData &&
                  st.data?.docs.length != 0 &&
                  st.data != null) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: st.data?.docs.length,
                  itemBuilder: (context, ind) {
                    int date = int.parse(st.data!.docs[ind]['orderId']
                        .toString()
                        .substring(
                            0,
                            st.data!.docs[ind]['orderId'].toString().length -
                                1));
                    DateTime dateTime =
                        DateTime.fromMillisecondsSinceEpoch(date);
                    return index == widget.orderIds!.length - 1
                        ? Container(
                            height: mq.height,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Colors.purple.shade100,
                                  Colors.brown.shade200
                                ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: mq.height * .1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  DefaultTextStyle(
                                    style: TextStyle(color: Colors.purple , fontSize: 20),
                                      child: Text('Analysis')),
                                  SizedBox(height: mq.height * .1,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PieChart(
                                          dataMap: {
                                            'Total': total,
                                            "Delivered": delivered,
                                            "Yet to deliver": yetToDeliver,
                                            "Cancelled": cancelled
                                          },
                                          legendOptions: LegendOptions(
                                            legendPosition: LegendPosition.right,
                                            showLegendsInRow: false,
                                          ),
                                          animationDuration:
                                              const Duration(milliseconds: 2500),
                                          chartType: ChartType.disc,
                                          ringStrokeWidth: 18,
                                          chartRadius: 150,
                                          colorList: [
                                            Color(0xFF00B0FF),
                                            Color(0xFF388E3C),
                                            Color(0xFFD78000),
                                            Color(0xFFD50000),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        : SizedBox();
                  },
                );
              } else {
                return SizedBox();
              }
            },
          );
        });
  }
}
