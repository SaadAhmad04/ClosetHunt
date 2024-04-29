// import 'dart:convert';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/controller/auth.dart';
// import '../../../../constant/utils/utilities.dart';
// import '../../../../main.dart';
// import '../../../../model/serviceModel.dart';
// import 'payment.dart';
//
// class ViewServices extends StatefulWidget {
//   String shopId;
//   String shopName;
//   String shopIcon;
//
//   ViewServices({
//     super.key,
//     required this.shopId,
//     required this.shopName,
//     required this.shopIcon,
//   });
//
//   @override
//   State<ViewServices> createState() => _ViewServicesState();
// }
//
// class _ViewServicesState extends State<ViewServices> {
//   Future<bool> checkSubcollectionExistence(String shopId) async {
//     final CollectionReference mainCollection = Auth.shopManagerRef;
//     final DocumentReference document =
//     mainCollection.doc(shopId).collection('parlor').doc(shopId);
//     final CollectionReference subCollection = document.collection('services');
//
//     try {
//       final QuerySnapshot querySnapshot = await subCollection.get();
//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       print('Error checking subcollection existence: $e');
//       return false;
//     }
//   }
//
//   DateTime? date;
//   TimeOfDay? time;
//   ServiceModel? serviceModel;
//
//   @override
//   Widget build(BuildContext context) {
//     final spinkit = SpinKitRotatingCircle(
//       itemBuilder: (BuildContext context, int index) {
//         return DecoratedBox(
//           decoration: BoxDecoration(
//             color: Color(0xff974C7C),
//           ),
//         );
//       },
//     );
//     return FutureBuilder<bool?>(
//       future: checkSubcollectionExistence(widget.shopId),
//       builder: (BuildContext context, AsyncSnapshot<bool?> snap) {
//         if (snap.connectionState == ConnectionState.waiting) {
//           return spinkit;
//         }
//
//         bool exists = snap.data ?? false;
//
//         if (exists && snap.connectionState == ConnectionState.done) {
//           return StreamBuilder(
//             stream: Auth.shopManagerRef
//                 .doc(widget.shopId)
//                 .collection('parlor')
//                 .doc(widget.shopId)
//                 .collection('services')
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data != null) {
//                 return SafeArea(
//                   child: Scaffold(
//                       body: Stack(
//                         children: [
//                           Container(
//                             height: mq.height,
//                             child: Image.network(
//                               "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(50.0),
//                                   bottomRight: Radius.circular(50.0),
//                                 ),
//                                 child: Container(
//                                   height: mq.height * 0.29,
//                                   width: mq.width,
//                                   decoration: BoxDecoration(
//                                     color: Colors.pink[200],
//                                     border: Border.all(color: Colors.white),
//                                   ),
//                                   child: widget.shopIcon != null
//                                       ? Image.network(
//                                     widget.shopIcon,
//                                     fit: BoxFit.cover,
//                                   )
//                                       : Image.network(
//                                     "https://static.vecteezy.com/system/resources/thumbnails/022/714/667/small_2x/women-s-shoes-with-high-heels-and-paint-splatter-fashion-copyspace-background-ai-generated-photo.jpg",
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   child: ShaderMask(
//                                     shaderCallback: (Rect bounds) {
//                                       return LinearGradient(
//                                         colors: [Colors.pink, Colors.black],
//                                       ).createShader(bounds);
//                                     },
//                                     child: Text(
//                                       widget.shopName,
//                                       style: TextStyle(
//                                         fontSize: 30.0,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount: snapshot.data!.docs.length,
//                                   itemBuilder: (context, index) {
//                                     String serviceId =
//                                     snapshot.data!.docs[index]['serviceId'];
//                                     String serviceName =
//                                     snapshot.data!.docs[index]['serviceName'];
//                                     String servicePrice =
//                                     snapshot.data!.docs[index]['servicePrice'];
//                                     return Card(
//                                       elevation: 10,
//                                       shadowColor: Color(0xff974c7c),
//                                       //color: Colors.blueGrey,
//                                       child: ListTile(
//                                         tileColor: Colors.white,
//                                         title: Text(serviceName),
//                                         subtitle: servicePrice != ""
//                                             ? Text('Rs.${servicePrice}')
//                                             : Text('Price not defined'),
//                                         trailing: MaterialButton(
//                                           onPressed: () async {
//                                             var test = snapshot.data!.docs[index];
//                                             Map<String, dynamic>? data =
//                                             test.data();
//                                             String jsonString = jsonEncode(data);
//                                             serviceModel =
//                                                 serviceModelFromJson(jsonString);
//                                             if (serviceModel!
//                                                 .servicePrice!.isNotEmpty) {
//                                               date = await pickDate();
//                                               if (date != null) {
//                                                 time = await pickTime();
//                                                 print(time!.hour);
//                                                 if (time!.hour >= 11 &&
//                                                     time!.hour <= 23) {
//                                                   confirmAppointment(
//                                                       serviceModel!, date, time);
//                                                 } else {
//                                                   Utilities().showMessage(
//                                                       'The time you selected is not available. Kindly select another time slot');
//                                                 }
//                                               }
//                                             } else {
//                                               confirmAppointment(serviceModel!);
//                                             }
//                                           },
//                                           child: Text(
//                                             'Take Appointment',
//                                             style: TextStyle(color: Colors.white),
//                                           ),
//                                           shape: RoundedRectangleBorder(),
//                                           color: Color(0xff8d8e36),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )),
//                 );
//               } else if (snapshot.connectionState == ConnectionState.waiting ||
//                   snapshot.data == null) {
//                 return Center(
//                   child: spinkit,
//                 );
//               } else {
//                 return Scaffold(
//                   body: Container(
//                     color: Colors.redAccent,
//                     child: Center(
//                       child: Text('No services available'),
//                     ),
//                   ),
//                 );
//               }
//             },
//           );
//         } else {
//           return Scaffold(
//               body: Stack(children: [
//                 Container(
//                   height: mq.height,
//                   child: Image.network(
//                     "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Center(
//                   child: Container(
//                     child: Image.asset(
//                       "images/error.gif",
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                       height: mq.height / 2,
//                       child: Center(
//                           child: Text(
//                             "Services not Defined Yet!",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 22,
//                                 color: Colors.redAccent),
//                           ))),
//                 ),
//               ]));
//         }
//       },
//     );
//   }
//
//   Future<DateTime?> pickDate() async {
//     return showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime.now(),
//         lastDate: DateTime(3000));
//   }
//
//   Future<TimeOfDay?> pickTime() async {
//     return showTimePicker(context: context, initialTime: TimeOfDay.now());
//   }
//
//   Future<void> confirmAppointment(ServiceModel serviceModel,
//       [DateTime? date, TimeOfDay? time]) {
//     int counter = 0;
//     String period = "";
//     bool loading = false;
//     time?.period.index == 0 ? period = "am" : period = "pm";
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               content: StatefulBuilder(builder: (context, setModalState) {
//                 return SizedBox(
//                   height: mq.height / 4.2,
//                   width: mq.width - 50,
//                   child: serviceModel.servicePrice!.isNotEmpty
//                       ? Column(
//                     children: [
//                       Text(
//                         'Confirm Appointmnet',
//                         style: TextStyle(
//                             color: Color(0xff974C7C),
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: mq.height * .05),
//                       Text(
//                           'Your appointment of "${serviceModel.serviceName}" on "${date?.day}-${date?.month}-${date?.year}" at "${time?.hourOfPeriod}:${time?.minute} ${period}" will be booked. Are you sure ? '),
//                       SizedBox(
//                         height: mq.height * .05,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                     color: Color(0xFFC8A2C8),
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(25))),
//                                 width: 100,
//                                 height: 40,
//                                 child: Center(
//                                   child: Text(
//                                     'No',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.white),
//                                   ),
//                                 )),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               setModalState(() {
//                                 loading = true;
//                               });
//                               List<Map<String, dynamic>> documentsData =
//                               [];
//                               await Auth.customerRef.get().then(
//                                     (QuerySnapshot querySnapshot) {
//                                   querySnapshot.docs.forEach(
//                                           (QueryDocumentSnapshot
//                                       documentSnapshot) {
//                                         documentsData.add(documentSnapshot
//                                             .data() as Map<String, dynamic>);
//                                       });
//                                 },
//                               );
//                               for (int i = 0;
//                               i < documentsData.length;
//                               i++) {
//                                 bool exists =
//                                 await checkSubcollectionExistence2(
//                                     documentsData[i]['uid']);
//                                 List<Map<String, dynamic>>
//                                 documentsData2 = [];
//                                 print(
//                                     '${exists}=============${documentsData[i]['uid']}');
//                                 if (exists) {
//                                   counter++;
//                                   await Auth.customerRef
//                                       .doc(documentsData[i]['uid'])
//                                       .collection('bookings')
//                                       .doc(widget.shopId)
//                                       .collection('parlor')
//                                       .where('date',
//                                       isEqualTo: date.toString())
//                                       .where('time',
//                                       isEqualTo:
//                                       "${time!.hour}:${time.minute} ${period}")
//                                       .get()
//                                       .then(
//                                         (QuerySnapshot querySnapshot) {
//                                       querySnapshot.docs.forEach(
//                                               (QueryDocumentSnapshot
//                                           documentSnapshot) {
//                                             documentsData2.add(
//                                                 documentSnapshot.data()
//                                                 as Map<String, dynamic>);
//                                           });
//                                     },
//                                   );
//                                   setModalState(() {
//                                     loading = false;
//                                   });
//                                   Navigator.pop(context);
//                                   if (documentsData2.isNotEmpty) {
//                                     print(
//                                         'sssssssssssssssssssss${documentsData2}');
//                                     Utilities().showMessage(
//                                         'This slot is already booked,  kindly select another date and time');
//                                   } else {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => Payment(
//                                               amount: double.parse(
//                                                   serviceModel
//                                                       .servicePrice
//                                                       .toString())
//                                                   .roundToDouble(),
//                                               date: date,
//                                               serviceModel:
//                                               serviceModel,
//                                               time:
//                                               "${time!.hour}:${time.minute} ${period}",
//                                               shopId: widget.shopId,
//                                               shopName:
//                                               widget.shopName,
//                                               isAppointment: true,
//                                             )));
//                                   }
//                                 }
//                               }
//                               if (counter == 0) {
//                                 setModalState(() {
//                                   loading = false;
//                                 });
//                                 Navigator.pop(context);
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Payment(
//                                           amount: double.parse(
//                                               serviceModel
//                                                   .servicePrice
//                                                   .toString())
//                                               .roundToDouble(),
//                                           date: date,
//                                           serviceModel: serviceModel,
//                                           time:
//                                           "${time!.hour}:${time.minute} ${period}",
//                                           shopId: widget.shopId,
//                                           shopName: widget.shopName,
//                                           isAppointment: true,
//                                         )));
//                               }
//                             },
//                             child: Container(
//                                 decoration: BoxDecoration(
//                                     color: Color(0xff8d8e36),
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(25))),
//                                 width: 100,
//                                 height: 40,
//                                 child: Center(
//                                   child: loading == true
//                                       ? CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                       : Text(
//                                     'Yes',
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.white),
//                                   ),
//                                 )),
//                           ),
//                         ],
//                       )
//                     ],
//                   )
//                       : Column(
//                     children: [
//                       Text(
//                         "Can't book appointment",
//                         style: TextStyle(
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: mq.height * .05),
//                       Text(
//                           'Your appointment of "${serviceModel.serviceName}" cannot be booked because its price is not declared yet. Kindly wait so that the price gets updated.'),
//                       SizedBox(
//                         height: mq.height * .05,
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.all(
//                                     Radius.circular(25))),
//                             width: 100,
//                             height: 40,
//                             child: Center(
//                               child: Text(
//                                 'Okay',
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white),
//                               ),
//                             )),
//                       ),
//                     ],
//                   ),
//                 );
//               }));
//         });
//   }
//
//   Future<bool> checkSubcollectionExistence2(String customerId) async {
//     final CollectionReference mainCollection = Auth.customerRef;
//     final DocumentReference document = mainCollection.doc(customerId);
//     final CollectionReference subCollection = document.collection('bookings');
//
//     try {
//       final QuerySnapshot querySnapshot = await subCollection.get();
//       return querySnapshot.docs.isNotEmpty;
//     } catch (e) {
//       print('Error checking subcollection existence: $e');
//       return false;
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/controller/auth.dart';
import '../../../../constant/utils/utilities.dart';
import '../../../../main.dart';
import '../../../../model/serviceModel.dart';
import 'payment.dart';

class ViewServices extends StatefulWidget {
  String shopId;
  String shopName;
  String shopIcon;

  ViewServices({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.shopIcon,
  });

  @override
  State<ViewServices> createState() => _ViewServicesState();
}

class _ViewServicesState extends State<ViewServices> {
  Future<bool> checkSubcollectionExistence(String shopId) async {
    final CollectionReference mainCollection = Auth.shopManagerRef;
    final DocumentReference document =
        mainCollection.doc(shopId).collection('parlor').doc(shopId);
    final CollectionReference subCollection = document.collection('services');

    try {
      final QuerySnapshot querySnapshot = await subCollection.get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking subcollection existence: $e');
      return false;
    }
  }

  DateTime? date;
  TimeOfDay? time;
  ServiceModel? serviceModel;
  String? selectedStaff;

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitRotatingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xff974C7C),
          ),
        );
      },
    );
    return FutureBuilder<bool?>(
      future: checkSubcollectionExistence(widget.shopId),
      builder: (BuildContext context, AsyncSnapshot<bool?> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return spinkit;
        }

        bool exists = snap.data ?? false;

        if (exists && snap.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: Auth.shopManagerRef
                .doc(widget.shopId)
                .collection('parlor')
                .doc(widget.shopId)
                .collection('services')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return SafeArea(
                  child: Scaffold(
                      body: Stack(
                    children: [
                      Container(
                        height: mq.height,
                        child: Image.network(
                          "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                            ),
                            child: Container(
                              height: mq.height * 0.29,
                              width: mq.width,
                              decoration: BoxDecoration(
                                color: Colors.pink[200],
                                border: Border.all(color: Colors.white),
                              ),
                              child: widget.shopIcon != null
                                  ? Image.network(
                                      widget.shopIcon,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      "https://static.vecteezy.com/system/resources/thumbnails/022/714/667/small_2x/women-s-shoes-with-high-heels-and-paint-splatter-fashion-copyspace-background-ai-generated-photo.jpg",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: [Colors.pink, Colors.black],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  widget.shopName,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                String serviceId =
                                    snapshot.data!.docs[index]['serviceId'];
                                String serviceName =
                                    snapshot.data!.docs[index]['serviceName'];
                                String servicePrice =
                                    snapshot.data!.docs[index]['servicePrice'];
                                return Card(
                                  elevation: 10,
                                  shadowColor: Color(0xff974c7c),
                                  //color: Colors.blueGrey,
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    title: Text(serviceName),
                                    subtitle: servicePrice != ""
                                        ? Text('Rs.${servicePrice}')
                                        : Text('Price not defined'),
                                    trailing: MaterialButton(
                                      onPressed: () async {
                                        var test = snapshot.data!.docs[index];
                                        Map<String, dynamic>? data =
                                            test.data();
                                        String jsonString = jsonEncode(data);
                                        serviceModel =
                                            serviceModelFromJson(jsonString);
                                        if (serviceModel!
                                            .servicePrice!.isNotEmpty) {
                                          date = await pickDate();
                                          if (date != null) {
                                            time = await pickTime();
                                            print(time!.hour);
                                            if (time!.hour >= 11 &&
                                                time!.hour <= 23) {
                                              await chooseStaff(context);
                                              if (selectedStaff !=
                                                  'Select staff') {
                                                confirmAppointment(
                                                    serviceModel!,
                                                    date,
                                                    time,
                                                    selectedStaff);
                                              } else {
                                                selectedStaff = 'none';
                                                confirmAppointment(
                                                    serviceModel!,
                                                    date,
                                                    time,
                                                    selectedStaff);
                                              }
                                            } else {
                                              Utilities().showMessage(
                                                  'The time you selected is not available. Kindly select another time slot');
                                            }
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
                                      color: Color(0xff8d8e36),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == null) {
                return Center(
                  child: spinkit,
                );
              } else {
                return Scaffold(
                  body: Container(
                    color: Colors.redAccent,
                    child: Center(
                      child: Text('No services available'),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return Scaffold(
              body: Stack(children: [
            Container(
              height: mq.height,
              child: Image.network(
                "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                child: Image.asset(
                  "images/error.gif",
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: mq.height / 2,
                  child: Center(
                      child: Text(
                    "Services not Defined Yet!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.redAccent),
                  ))),
            ),
          ]));
        }
      },
    );
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

  Future<void> chooseStaff(BuildContext context) async {
    selectedStaff = "Select staff";
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: mq.height / 4.5,
                width: mq.width,
                child: StreamBuilder(
                  stream: Auth.shopManagerRef
                      .doc(widget.shopId)
                      .collection('staff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot =
                          snapshot.data as QuerySnapshot;
                      List<String> data = querySnapshot.docs
                          .map((doc) => doc['name'] as String)
                          .toList();
                      if (!data.contains("Select staff")) {
                        // Add the hint only if it's not already present
                        data.insert(0, "Select staff");
                      }
                      return Column(
                        children: [
                          Text('Do you want to select the staff ?'),
                          DropdownButton(
                            // Initial Value
                            value: selectedStaff,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: data.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedStaff = newValue!;
                              });
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 35,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow.shade800,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: mq.width * .1),
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 35,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> confirmAppointment(ServiceModel serviceModel,
      [DateTime? date, TimeOfDay? time, String? staff]) {
    int counter = 0;
    String period = "";
    bool loading = false;
    print(staff);
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
                  height: mq.height / 3.8,
                  width: mq.width - 50,
                  child: serviceModel.servicePrice!.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              'Confirm Appointmnet',
                              style: TextStyle(
                                  color: Color(0xff974C7C),
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
                                          color: Color(0xFFC8A2C8),
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
                                    setModalState(() {
                                      loading = true;
                                    });
                                    List<Map<String, dynamic>> documentsData =
                                        [];
                                    await Auth.customerRef.get().then(
                                      (QuerySnapshot querySnapshot) {
                                        querySnapshot.docs.forEach(
                                            (QueryDocumentSnapshot
                                                documentSnapshot) {
                                          documentsData.add(documentSnapshot
                                              .data() as Map<String, dynamic>);
                                        });
                                      },
                                    );
                                    for (int i = 0;
                                        i < documentsData.length;
                                        i++) {
                                      bool exists =
                                          await checkSubcollectionExistence2(
                                              documentsData[i]['uid']);
                                      List<Map<String, dynamic>>
                                          documentsData2 = [];
                                      if (exists) {
                                        counter++;
                                        await Auth.customerRef
                                            .doc(documentsData[i]['uid'])
                                            .collection('bookings')
                                            .doc(widget.shopId)
                                            .collection('parlor')
                                            .where('date',
                                                isEqualTo: date.toString())
                                            .where('time',
                                                isEqualTo:
                                                    "${time!.hour}:${time.minute} ${period}")
                                            .get()
                                            .then(
                                          (QuerySnapshot querySnapshot) {
                                            querySnapshot.docs.forEach(
                                                (QueryDocumentSnapshot
                                                    documentSnapshot) {
                                              documentsData2.add(
                                                  documentSnapshot.data()
                                                      as Map<String, dynamic>);
                                            });
                                          },
                                        );
                                        setModalState(() {
                                          loading = false;
                                        });
                                        Navigator.pop(context);
                                        if (documentsData2.isNotEmpty) {
                                          Utilities().showMessage(
                                              'This slot is already booked,  kindly select another date and time');
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Payment(
                                                        amount: double.parse(
                                                                serviceModel
                                                                    .servicePrice
                                                                    .toString())
                                                            .roundToDouble(),
                                                        date: date,
                                                        serviceModel:
                                                            serviceModel,
                                                        time:
                                                            "${time!.hour}:${time.minute} ${period}",
                                                        shopId: widget.shopId,
                                                        shopName:
                                                            widget.shopName,
                                                        isAppointment: true,
                                                        staff: staff,
                                                      )));
                                        }
                                      }
                                    }
                                    if (counter == 0) {
                                      setModalState(() {
                                        loading = false;
                                      });
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Payment(
                                                    amount: double.parse(
                                                            serviceModel
                                                                .servicePrice
                                                                .toString())
                                                        .roundToDouble(),
                                                    date: date,
                                                    serviceModel: serviceModel,
                                                    time:
                                                        "${time!.hour}:${time.minute} ${period}",
                                                    shopId: widget.shopId,
                                                    shopName: widget.shopName,
                                                    isAppointment: true,
                                                    staff: staff,
                                                  )));
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff8d8e36),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      width: 100,
                                      height: 40,
                                      child: Center(
                                        child: loading == true
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
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

  Future<bool> checkSubcollectionExistence2(String customerId) async {
    final CollectionReference mainCollection = Auth.customerRef;
    final DocumentReference document = mainCollection.doc(customerId);
    final CollectionReference subCollection = document.collection('bookings');

    try {
      final QuerySnapshot querySnapshot = await subCollection.get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking subcollection existence: $e');
      return false;
    }
  }
}
