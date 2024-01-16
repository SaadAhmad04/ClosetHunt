import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/controller/auth.dart';
import 'package:intl/intl.dart';
import 'package:mall/screens/customer/booking/parlor/confirm_booking.dart';
import 'package:mall/screens/customer/payment.dart';

import '../../../../constant/utils/utilities.dart';
import '../../../../main.dart';
import '../../../../model/serviceModel.dart';

class ViewServices extends StatefulWidget {
  String? shopId;
  String? shopName;
  ViewServices({super.key, this.shopId, this.shopName});

  @override
  State<ViewServices> createState() => _ViewServicesState();
}

class _ViewServicesState extends State<ViewServices> {
  DateTime? date;
  TimeOfDay? time;
  ServiceModel? serviceModel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.shopManagerRef
            .doc(widget.shopId)
            .collection('parlor')
            .doc(widget.shopId)
            .collection('services')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('${widget.shopName}'),
                centerTitle: true,
              ),
              body: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String serviceId = snapshot.data!.docs[index]['serviceId'];
                  String serviceName =
                      snapshot.data!.docs[index]['serviceName'];
                  String servicePrice =
                      snapshot.data!.docs[index]['servicePrice'];
                  return ListTile(
                    title: Text(serviceName),
                    subtitle: servicePrice != ""
                        ? Text('Rs.${servicePrice}')
                        : Text('Price not defined'),
                    trailing: MaterialButton(
                      onPressed: () async {
                        var test = snapshot.data!.docs[index];
                        Map<String, dynamic>? data = test.data();
                        String jsonString = jsonEncode(data);
                        serviceModel = serviceModelFromJson(jsonString);
                        print('eeeeeeeeee${serviceModel!.servicePrice}');
                        if (serviceModel!.servicePrice != null) {
                          date = await pickDate();
                          print(date);
                          time = await pickTime();
                          print(time);
                          if (date != null && time != null) {
                            confirmAppointment(serviceModel!, date, time);
                          }
                        } else {
                          confirmAppointment(serviceModel!);
                        }
                      },
                      child: Text(
                        'Take Appointment',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(),
                      color: Colors.blue,
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text('No services available'),
            );
          }
        });
  }

  Future<DateTime?> pickDate() async {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000));
  }

  Future<TimeOfDay?> pickTime() async {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  Future<void> confirmAppointment(ServiceModel serviceModel,
      [DateTime? date, TimeOfDay? time]) {
    String period = "";
    Map<String, dynamic>? keyValuePairs;
    time?.period.index == 0 ? period = "am" : period = "pm";
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: StatefulBuilder(builder: (context, setModalState) {
                return SizedBox(
                  height: mq.height / 3.2,
                  width: mq.width - 50,
                  child: serviceModel.servicePrice != null
                      ? Column(
                          children: [
                            Text(
                              'Confirm Appointmnet',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: mq.height * .05),
                            Text(
                                'Your appointment of "${serviceModel.serviceName}" on "${date?.day}-${date?.month}-${date?.year}" at "${time?.hourOfPeriod}:${time?.minute} ${period}" will be booked. Are you sure ? '),
                            SizedBox(
                              height: mq.height * .05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.yellow.shade700,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      width: 100,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await Auth.customerRef.get().then(
                                      (QuerySnapshot querySnapshot) async {
                                        for (QueryDocumentSnapshot documentSnapshot
                                            in querySnapshot.docs) {
                                           keyValuePairs =
                                             await documentSnapshot.data()
                                                  as Map<String, dynamic>;
                                        }
                                      },
                                    );
                                    print(keyValuePairs);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //                 Payment(
                                    //                 amount: double.parse(
                                    //                     serviceModel.servicePrice.toString()).roundToDouble() ,
                                    //             date: date,
                                    //             serviceModel: serviceModel,
                                    //             time: "${time!.hour}:${time.minute} ${period}",
                                    //             shopId: widget.shopId,
                                    //             shopName: widget.shopName,
                                    //             isAppointment: true,)
                                    // ));
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      width: 100,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                              ],
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              "Can't book appointment",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: mq.height * .05),
                            Text(
                                'Your appointment of "${serviceModel.serviceName}" cannot be booked because its price is not declared yet. Kindly wait so that the price gets updated.'),
                            SizedBox(
                              height: mq.height * .05,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  width: 100,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                );
              }));
        });
  }
}
