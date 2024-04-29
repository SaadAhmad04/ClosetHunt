// import 'package:flutter/material.dart';
// import 'package:mall/controller/firebase_api.dart';
// import 'package:mall/constant/widget/roundButton.dart';
// import 'package:mall/screens/customer/booking/my_bookings.dart';
//
// import '../../../../controller/auth.dart';
// import '../../../../model/serviceModel.dart';
//
// class ConfirmBooking extends StatefulWidget {
//   String? shopId;
//   String? bookingId;
//   ServiceModel? serviceModel;
//   DateTime? date;
//   String? time;
//
//   ConfirmBooking(
//       {super.key,
//         this.shopId,
//         this.bookingId,
//         this.serviceModel,
//         this.date,
//         this.time});
//
//   @override
//   State<ConfirmBooking> createState() => _ConfirmBookingState();
// }
//
// class _ConfirmBookingState extends State<ConfirmBooking> {
//   String? appManagerId;
//   String? appManagerToken;
//   List shopKeeperToken = [];
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     print('service : ${widget.serviceModel!.serviceName}');
//     return StreamBuilder(
//         stream: Auth.customerRef.doc(Auth.auth.currentUser!.uid).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             String customerName = snapshot.data?['name'];
//             String phone = snapshot.data?['phone'];
//             String email = snapshot.data?['email'];
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('Booking Confirmed'),
//                 centerTitle: true,
//               ),
//               body: Column(
//                 children: [
//                   StreamBuilder(
//                     stream: Auth.appManagerRef.snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         return ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             appManagerToken =
//                             snapshot.data!.docs[index]['token'];
//                             appManagerId = snapshot.data!.docs[index]['uid'];
//                             return Center(
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                         'Wait while we are confirming your appointment'),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       } else {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//                     },
//                   ),
//                   StreamBuilder(
//                     stream: Auth.shopManagerRef.doc(widget.shopId).snapshots(),
//                     builder: (context, snapshot) {
//                       shopKeeperToken.add(snapshot.data?['token']);
//                       print('tooooooooooooooooook ${shopKeeperToken}');
//                       return Center(
//                         child: RoundButton(
//                             title: 'Click here',
//                             loading: isLoading,
//                             onTap: () {
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               FirebaseApi.myNotification(
//                                   customerName,
//                                   appManagerToken!,
//                                   'New appointment booked',
//                                   Auth.auth.currentUser!.uid,
//                                   phone,
//                                   email,
//                                   appManagerId!,
//                                   bookingId: widget.bookingId,
//                                   date: widget.date.toString(),
//                                   time: widget.time,
//                                   shopId: widget.shopId,
//                                   serviceModel: widget.serviceModel);
//                               FirebaseApi.shopNotification(
//                                   customerName,
//                                   shopKeeperToken!,
//                                   'New appointment booked',
//                                   Auth.auth.currentUser!.uid,
//                                   phone,
//                                   email,
//                                   [],
//                                   bookingId: widget.bookingId,
//                                   date: widget.date.toString(),
//                                   time: widget.time,
//                                   shopId: widget.shopId,
//                                   serviceModel: widget.serviceModel)
//                                   .then((value) {
//                                 setState(() {
//                                   isLoading = false;
//                                 });
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => MyBookings()));
//                               });
//                             }),
//                       );
//                     },
//                   )
//                 ],
//               ),
//             );
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         });
//   }
// }

import 'package:flutter/material.dart';
import 'package:mall/controller/firebase_api.dart';
import 'package:mall/constant/widget/roundButton.dart';
import 'package:mall/screens/customer/booking/my_bookings.dart';

import '../../../../controller/auth.dart';
import '../../../../model/serviceModel.dart';

class ConfirmBooking extends StatefulWidget {
  String? shopId;
  String? bookingId;
  ServiceModel? serviceModel;
  DateTime? date;
  String? time;
  String? staff;

  ConfirmBooking(
      {super.key,
        this.shopId,
        this.bookingId,
        this.serviceModel,
        this.date,
        this.time,
      this.staff});

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  String? appManagerId;
  String? appManagerToken;
  List shopKeeperToken = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print('service : ${widget.serviceModel!.serviceName}');
    return StreamBuilder(
        stream: Auth.customerRef.doc(Auth.auth.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String customerName = snapshot.data?['name'];
            String phone = snapshot.data?['phone'];
            String email = snapshot.data?['email'];
            return Scaffold(
              appBar: AppBar(
                title: Text('Booking Confirmed'),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  StreamBuilder(
                    stream: Auth.appManagerRef.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            appManagerToken =
                            snapshot.data!.docs[index]['token'];
                            appManagerId = snapshot.data!.docs[index]['uid'];
                            return Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Wait while we are confirming your appointment'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: Auth.shopManagerRef.doc(widget.shopId).snapshots(),
                    builder: (context, snapshot) {
                      shopKeeperToken.add(snapshot.data?['token']);
                      return Center(
                        child: RoundButton(
                            title: 'Click here',
                            loading: isLoading,
                            onTap: () {
                              setState(() {
                                isLoading = true;
                              });
                              FirebaseApi.myNotification(
                                  customerName,
                                  appManagerToken!,
                                  'New appointment booked',
                                  Auth.auth.currentUser!.uid,
                                  phone,
                                  email,
                                  appManagerId!,
                                  bookingId: widget.bookingId,
                                  date: widget.date.toString(),
                                  time: widget.time,
                                  shopId: widget.shopId,
                                  serviceModel: widget.serviceModel);
                              FirebaseApi.shopNotification(
                                  customerName,
                                  shopKeeperToken!,
                                  'New appointment booked',
                                  Auth.auth.currentUser!.uid,
                                  phone,
                                  email,
                                  [],
                                  bookingId: widget.bookingId,
                                  date: widget.date.toString(),
                                  time: widget.time,
                                  shopId: widget.shopId,
                                  serviceModel: widget.serviceModel)
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyBookings()));
                              });
                            }),
                      );
                    },
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}