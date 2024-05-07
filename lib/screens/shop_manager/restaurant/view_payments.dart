// import 'package:flutter/material.dart';
// import 'package:mall/controller/auth.dart';
// import 'package:intl/intl.dart';
// import '../../../main.dart';
//
// class ViewPayments extends StatefulWidget {
//   bool? payment;
//   bool? shop;
//   ViewPayments({super.key, this.payment ,  this.shop});
//
//   @override
//   State<ViewPayments> createState() => _ViewPaymentsState();
// }
//
// class _ViewPaymentsState extends State<ViewPayments> {
//   bool? showDateHeader;
//   @override
//   Widget build(BuildContext context) {
//     return widget.payment == true
//         ? StreamBuilder(
//             stream: Auth.shopManagerRef
//                 .doc(Auth.auth.currentUser!.uid)
//                 .collection('payments')
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return SafeArea(
//                   child: Scaffold(
//                     appBar: AppBar(
//                       backgroundColor: Colors.green.shade600,
//                       title: Text('All Payments'),
//                       elevation: 0,
//                       centerTitle: true,
//                     ),
//                     body: ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         int date =
//                             int.parse(snapshot.data!.docs[index]['date']);
//                         // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
//                         DateTime dateTime =
//                             DateTime.fromMillisecondsSinceEpoch(date);
//                         DateTime bookingDate =
//                             DateTime.fromMillisecondsSinceEpoch(int.parse(
//                                 snapshot.data!.docs[index]['paymentId']));
//                         String formattedDate =
//                             DateFormat('dd-MM-yyyy').format(bookingDate);
//                         // Check if the date has changed
//                         if (index != 0) {
//                           if (bookingDate.year ==
//                                   DateTime.fromMillisecondsSinceEpoch(int.parse(
//                                           snapshot.data!.docs[index - 1]
//                                               ['paymentId']))
//                                       .year &&
//                               bookingDate.month ==
//                                   DateTime.fromMillisecondsSinceEpoch(int.parse(
//                                           snapshot.data!.docs[index - 1]
//                                               ['paymentId']))
//                                       .month &&
//                               bookingDate.day ==
//                                   DateTime.fromMillisecondsSinceEpoch(
//                                           int.parse(snapshot.data!.docs[index - 1]['paymentId']))
//                                       .day) {
//                             showDateHeader = false;
//                           } else {
//                             showDateHeader = true;
//                           }
//                         } else {
//                           showDateHeader = true;
//                         }
//                         return Column(
//                           children: [
//                             if (showDateHeader == true)
//                               Row(
//                                 children: [
//                                   SizedBox(
//                                     width: mq.width * .67,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       formattedDate,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: ListTile(
//                                 tileColor: Colors.blue.shade200,
//                                 shape: RoundedRectangleBorder(
//                                     side: BorderSide(color: Colors.white),
//                                     borderRadius: BorderRadius.circular(30)),
//                                 title: Text(
//                                   '${snapshot.data!.docs[index]['name']}',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 subtitle: Text(
//                                   '${snapshot.data!.docs[index]['msg']}',
//                                   style: TextStyle(
//                                       color: Colors.green.shade600,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 trailing: Text(
//                                     'Rs.${snapshot.data!.docs[index]['amount']}'),
//                                 onTap: () {
//                                   viewPaymentDetails(
//                                       snapshot.data!.docs[index]['paymentId'],
//                                       snapshot.data!.docs[index]['amount'],
//                                       dateTime,
//                                       snapshot.data!.docs[index]['name'],
//                                       snapshot.data!.docs[index]['phone'],
//                                       snapshot.data!.docs[index]['msg'],
//                                       snapshot.data!.docs[index]['email']);
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               } else if (snapshot.connectionState == ConnectionState.waiting ||
//                   snapshot.hasError) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else {
//                 return Center(
//                   child: Text('No payments yet'),
//                 );
//               }
//             },
//           )
//         : widget.shop == false ?
//     StreamBuilder(
//             stream: Auth.shopManagerRef
//                 .doc(Auth.auth.currentUser!.uid)
//                 .collection('notifications')
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 double amount = 0;
//                 return SafeArea(
//                   child: Scaffold(
//                     appBar: AppBar(
//                       backgroundColor: Colors.green.shade600,
//                       title: Text('Appointment history'),
//                       elevation: 0,
//                       centerTitle: true,
//                     ),
//                     body: ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         for(int i = 0; i< snapshot.data!.docs.length; i++){
//                           amount += double.parse(snapshot.data!.docs[i]['servicePrice']);
//                         }
//                         print('amount ==============${amount}');
//                         int date =
//                             int.parse(snapshot.data!.docs[index]['bookingId']);
//                         // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
//                         DateTime dateTime =
//                             DateTime.fromMillisecondsSinceEpoch(date);
//                         DateTime bookingDate =
//                             DateTime.fromMillisecondsSinceEpoch(int.parse(
//                                 snapshot.data!.docs[index]['bookingId']));
//                         String formattedDate =
//                             DateFormat('dd-MM-yyyy').format(bookingDate);
//                         // Check if the date has changed
//                         if (index != 0) {
//                           if (bookingDate.year ==
//                                   DateTime.fromMillisecondsSinceEpoch(int.parse(
//                                           snapshot.data!.docs[index - 1]
//                                               ['bookingId']))
//                                       .year &&
//                               bookingDate.month ==
//                                   DateTime.fromMillisecondsSinceEpoch(int.parse(
//                                           snapshot.data!.docs[index - 1]
//                                               ['bookingId']))
//                                       .month &&
//                               bookingDate.day ==
//                                   DateTime.fromMillisecondsSinceEpoch(
//                                           int.parse(snapshot.data!.docs[index - 1]['bookingId']))
//                                       .day) {
//                             showDateHeader = false;
//                           } else {
//                             showDateHeader = true;
//                           }
//                         } else {
//                           showDateHeader = true;
//                         }
//                         return Column(
//                           children: [
//                             if (showDateHeader == true)
//                               Row(
//                                 children: [
//                                   SizedBox(
//                                     width: mq.width * .67,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text('${formattedDate}\n  Rs.${amount}',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: ListTile(
//                                 tileColor: Colors.blue.shade200,
//                                 shape: RoundedRectangleBorder(
//                                     side: BorderSide(color: Colors.white),
//                                     borderRadius: BorderRadius.circular(30)),
//                                 title: Text(
//                                   'Rs.${snapshot.data!.docs[index]['servicePrice']}',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 subtitle: Text(
//                                   '${snapshot.data!.docs[index]['serviceName']}',
//                                   style: TextStyle(
//                                       color: Colors.green.shade600,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 trailing: CircleAvatar(
//                                   child: Text(
//                                       '${snapshot.data!.docs[index]['serviceId']}'),
//                                 ),
//                                 onTap: () {
//                                   viewPaymentDetails(
//                                       snapshot.data!.docs[index]['bookingId'],
//                                       double.parse(snapshot.data!.docs[index]
//                                           ['servicePrice']),
//                                       dateTime,
//                                       snapshot.data!.docs[index]['name'],
//                                       snapshot.data!.docs[index]['phone'],
//                                       snapshot.data!.docs[index]['msg'],
//                                       snapshot.data!.docs[index]['email']);
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               } else if (snapshot.connectionState == ConnectionState.waiting ||
//                   snapshot.hasError) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else {
//                 return Center(
//                   child: Text('No payments yet'),
//                 );
//               }
//             },
//           ) :
//     StreamBuilder(
//       stream: Auth.shopManagerRef
//           .doc(Auth.auth.currentUser!.uid)
//           .collection('notifications')
//           .snapshots(),
//       builder: (context, snapshot) {
//         double amount = 0;
//         if (snapshot.hasData) {
//           return SafeArea(
//             child: Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.green.shade600,
//                 title: Text('Order history'),
//                 elevation: 0,
//                 centerTitle: true,
//               ),
//               body: ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   for(int i = 0; i< snapshot.data!.docs.length; i++){
//                     amount += (snapshot.data!.docs[i]['perprice']);
//                   }
//                   print('amount ==============${amount}');
//                   int date =
//                   int.parse(snapshot.data!.docs[index]['date'].toString().substring(0 , snapshot.data!.docs[index]['date'].toString().length-1));
//                   // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
//                   DateTime dateTime =
//                   DateTime.fromMillisecondsSinceEpoch(date);
//                   DateTime bookingDate =
//                   DateTime.fromMillisecondsSinceEpoch(int.parse(
//                       snapshot.data!.docs[index]['date'].toString().substring(0 , snapshot.data!.docs[index]['date'].toString().length-1)));
//                   String formattedDate =
//                   DateFormat('dd-MM-yyyy').format(bookingDate);
//                   // Check if the date has changed
//                   if (index != 0) {
//                     if (bookingDate.year ==
//                         DateTime.fromMillisecondsSinceEpoch(int.parse(
//                             snapshot.data!.docs[index - 1]
//                             ['date'].toString().substring(0 , snapshot.data!.docs[index-1]['date'].toString().length-1)))
//                             .year &&
//                         bookingDate.month ==
//                             DateTime.fromMillisecondsSinceEpoch(int.parse(
//                                 snapshot.data!.docs[index - 1]
//                                 ['date'].toString().substring(0 , snapshot.data!.docs[index-1]['date'].toString().length-1)))
//                                 .month &&
//                         bookingDate.day ==
//                             DateTime.fromMillisecondsSinceEpoch(
//                                 int.parse(snapshot.data!.docs[index - 1]['date'].toString().substring(0 , snapshot.data!.docs[index-1]['date'].toString().length-1)))
//                                 .day) {
//                       showDateHeader = false;
//                     } else {
//                       showDateHeader = true;
//                     }
//                   } else {
//                     showDateHeader = true;
//                   }
//                   return Column(
//                     children: [
//                       if (showDateHeader == true)
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: mq.width * .67,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text('${formattedDate}\nRs.${amount}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: ListTile(
//                           tileColor: Colors.blue.shade200,
//                           shape: RoundedRectangleBorder(
//                               side: BorderSide(color: Colors.white),
//                               borderRadius: BorderRadius.circular(30)),
//                           title: Text(
//                             'Rs.${snapshot.data!.docs[index]['perprice']}',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text(
//                             '${snapshot.data!.docs[index]['productName']}',
//                             style: TextStyle(
//                                 color: Colors.green.shade600,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(
//                                 '${snapshot.data!.docs[index]['productImage']}'),
//                           ),
//                           onTap: () {
//                             viewPaymentDetails(
//                                 snapshot.data!.docs[index]['date'],
//                                 (snapshot.data!.docs[index]
//                                 ['perprice']),
//                                 dateTime,
//                                 snapshot.data!.docs[index]['name'],
//                                 snapshot.data!.docs[index]['phone'],
//                                 snapshot.data!.docs[index]['msg'],
//                                 snapshot.data!.docs[index]['email'],
//                             productId: snapshot.data!.docs[index]['productId']);
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           );
//         } else if (snapshot.connectionState == ConnectionState.waiting ||
//             snapshot.hasError) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           return Center(
//             child: Text('No payments yet'),
//           );
//         }
//       },
//     );
//   }
//
//   Future<void> viewPaymentDetails(
//       String paymentId,
//       double amount,
//       DateTime dateTime,
//       String customerName,
//       String phone,
//       String msg,
//       String email,
//   {String? productId}) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                 height: mq.height * .65,
//                 width: mq.width,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: Icon(Icons.keyboard_backspace),
//                         ),
//                         SizedBox(
//                           width: mq.width * .04,
//                         ),
//                         Text(
//                           'Payment details',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: mq.height * .02,
//                     ),
//                     ListTile(
//                       title: widget.payment == true
//                           ? Text('Payment Id')
//                           : widget.shop == false ? Text('Booking Id') : Text('Order Id'),
//                       trailing: Text('${paymentId}'),
//                     ),
//                     ListTile(
//                       title: Text('Paid by'),
//                       trailing: Text('${customerName}'),
//                     ),
//                     ListTile(
//                       title: Text('Phone'),
//                       trailing: Text('${phone}'),
//                     ),
//                     ListTile(
//                       title: Text('Email'),
//                       trailing: Text('${email}'),
//                     ),
//                     ListTile(
//                       title: Text('Amount'),
//                       trailing: Text('Rs.${amount}'),
//                     ),
//                     ListTile(
//                       title: Text('Date'),
//                       trailing: Text(
//                           '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
//                     ),
//                     ListTile(
//                       title: Text('Product Id'),
//                       trailing: Text(
//                           '${productId}'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mall/controller/auth.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';

class ViewPayments extends StatefulWidget {
  bool? payment;
  bool? shop;

  ViewPayments({super.key, this.payment, this.shop});

  @override
  State<ViewPayments> createState() => _ViewPaymentsState();
}

class _ViewPaymentsState extends State<ViewPayments> {
  bool? showDateHeader;

  @override
  Widget build(BuildContext context) {
    return widget.payment == true
        ? StreamBuilder(
      stream: Auth.shopManagerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('payments')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.purple[100],
              title: Text('All Payments', style: TextStyle(
                  color: Colors.white70
              ),),
              elevation: 2,
              centerTitle: true,
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                int date =
                int.parse(snapshot.data!.docs[index]['date']);
                // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
                DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(date);
                DateTime bookingDate =
                DateTime.fromMillisecondsSinceEpoch(int.parse(
                    snapshot.data!.docs[index]['paymentId']));
                String formattedDate =
                DateFormat('dd-MM-yyyy').format(bookingDate);
                // Check if the date has changed
                if (index != 0) {
                  if (bookingDate.year ==
                      DateTime
                          .fromMillisecondsSinceEpoch(int.parse(
                          snapshot.data!.docs[index - 1]
                          ['paymentId']))
                          .year &&
                      bookingDate.month ==
                          DateTime
                              .fromMillisecondsSinceEpoch(int.parse(
                              snapshot.data!.docs[index - 1]
                              ['paymentId']))
                              .month &&
                      bookingDate.day ==
                          DateTime
                              .fromMillisecondsSinceEpoch(
                              int.parse(snapshot.data!.docs[index -
                                  1]['paymentId']))
                              .day) {
                    showDateHeader = false;
                  } else {
                    showDateHeader = true;
                  }
                } else {
                  showDateHeader = true;
                }
                return Column(
                  children: [
                    if (showDateHeader == true)
                      Row(
                        children: [
                          SizedBox(
                            width: mq.width * .67,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            tileColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30)),
                            title: Text(
                              '${snapshot.data!.docs[index]['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${snapshot.data!.docs[index]['msg']}',
                              style: TextStyle(
                                color: Colors.purple,
                              ),
                            ),
                            trailing: Text(
                                'Rs.${snapshot.data!.docs[index]['amount']}'),
                            onTap: () {
                              viewPaymentDetails(
                                  snapshot.data!.docs[index]['paymentId'],
                                  snapshot.data!.docs[index]['amount'],
                                  dateTime,
                                  snapshot.data!.docs[index]['name'],
                                  snapshot.data!.docs[index]['phone'],
                                  snapshot.data!.docs[index]['msg'],
                                  snapshot.data!.docs[index]['email']);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text('No payments yet'),
          );
        }
      },
    )
        : widget.shop == false ?
    StreamBuilder(
      stream: Auth.shopManagerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('notifications')
          .orderBy('bookingId', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.length!=0) {

          double amount = 0;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple[50],
              title: Text('Appointment history', style: TextStyle(
                  color: Colors.grey
              ),),
              elevation: 0,
              centerTitle: true,
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  amount +=
                      double.parse(snapshot.data!.docs[i]['servicePrice']);
                }
                print('amount ==============${amount}');
                int date =
                int.parse(snapshot.data!.docs[index]['bookingId']);
                // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
                DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(date);
                DateTime bookingDate =
                DateTime.fromMillisecondsSinceEpoch(int.parse(
                    snapshot.data!.docs[index]['bookingId']));
                String formattedDate =
                DateFormat('dd-MM-yyyy').format(bookingDate);
                // Check if the date has changed
                if (index != 0) {
                  if (bookingDate.year ==
                      DateTime
                          .fromMillisecondsSinceEpoch(int.parse(
                          snapshot.data!.docs[index - 1]
                          ['bookingId']))
                          .year &&
                      bookingDate.month ==
                          DateTime
                              .fromMillisecondsSinceEpoch(int.parse(
                              snapshot.data!.docs[index - 1]
                              ['bookingId']))
                              .month &&
                      bookingDate.day ==
                          DateTime
                              .fromMillisecondsSinceEpoch(
                              int.parse(snapshot.data!.docs[index -
                                  1]['bookingId']))
                              .day) {
                    showDateHeader = false;
                  } else {
                    showDateHeader = true;
                  }
                } else {
                  showDateHeader = true;
                }
                return Column(
                  children: [
                    if (showDateHeader == true)
                      Row(
                        children: [
                          SizedBox(
                            width: mq.width * .67,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${formattedDate}\n  Rs.${amount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 10,
                        child: ListTile(
                          tileColor: Colors.purple.shade200,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(30)),
                          title: Text(
                            'Rs.${snapshot.data!
                                .docs[index]['servicePrice']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${snapshot.data!.docs[index]['serviceName']}',
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: Colors.purple[50],
                            child: Text(
                                '${snapshot.data!.docs[index]['serviceId']}'),
                          ),
                          onTap: () {
                            viewPaymentDetails(
                                snapshot.data!.docs[index]['bookingId'],
                                double.parse(snapshot.data!.docs[index]
                                ['servicePrice']),
                                dateTime,
                                snapshot.data!.docs[index]['name'],
                                snapshot.data!.docs[index]['phone'],
                                snapshot.data!.docs[index]['msg'],
                                snapshot.data!.docs[index]['email']);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text('No payments yet'),
            ),
          );
        }
      },
    ) :
    StreamBuilder(
      stream: Auth.shopManagerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('notifications')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        double amount = 0;
        if (snapshot.hasData) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text('Order history', style: TextStyle(
                  color: Colors.black
              ),),
              elevation: 0,
              centerTitle: true,
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.black,
              ),
            ),
            body: ListView.builder(
              reverse: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  amount += (snapshot.data!.docs[i]['perprice']);
                }
                int date =
                int.parse(snapshot.data!.docs[index]['date']
                    .toString()
                    .substring(0, snapshot.data!.docs[index]['date']
                    .toString()
                    .length - 1));
                // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
                DateTime dateTime =
                DateTime.fromMillisecondsSinceEpoch(date);
                DateTime bookingDate =
                DateTime.fromMillisecondsSinceEpoch(int.parse(
                    snapshot.data!.docs[index]['date'].toString().substring(
                        0, snapshot.data!.docs[index]['date']
                        .toString()
                        .length - 1)));
                String formattedDate =
                DateFormat('dd-MM-yyyy').format(bookingDate);
                // Check if the date has changed
                if (index != 0) {
                  if (bookingDate.year ==
                      DateTime
                          .fromMillisecondsSinceEpoch(int.parse(
                          snapshot.data!.docs[index - 1]
                          ['date'].toString().substring(
                              0, snapshot.data!.docs[index - 1]['date']
                              .toString()
                              .length - 1)))
                          .year &&
                      bookingDate.month ==
                          DateTime
                              .fromMillisecondsSinceEpoch(int.parse(
                              snapshot.data!.docs[index - 1]
                              ['date'].toString().substring(
                                  0, snapshot.data!.docs[index - 1]['date']
                                  .toString()
                                  .length - 1)))
                              .month &&
                      bookingDate.day ==
                          DateTime
                              .fromMillisecondsSinceEpoch(
                              int.parse(snapshot.data!.docs[index - 1]['date']
                                  .toString()
                                  .substring(
                                  0, snapshot.data!.docs[index - 1]['date']
                                  .toString()
                                  .length - 1)))
                              .day) {
                    showDateHeader = false;
                  } else {
                    showDateHeader = true;
                  }
                } else {
                  showDateHeader = true;
                }
                return Column(
                  children: [
                    if (showDateHeader == true)
                      Row(
                        children: [
                          SizedBox(
                            width: mq.width * .6,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${formattedDate}\nRs.${amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        elevation: 10,
                        //shadowColor: Colors.white24,
                        child: ListTile(
                          tileColor: Colors.white70,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20)),
                          title: Text(
                            'Rs.${snapshot.data!.docs[index]['perprice']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${snapshot.data!.docs[index]['productName']}',
                            style: TextStyle(
                              color: Colors.purple.shade300,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${snapshot.data!
                                    .docs[index]['productImage']}'),
                          ),
                          onTap: () {
                            viewPaymentDetails(
                                snapshot.data!.docs[index]['date'],
                                (snapshot.data!.docs[index]
                                ['perprice']),
                                dateTime,
                                snapshot.data!.docs[index]['name'],
                                snapshot.data!.docs[index]['phone'],
                                snapshot.data!.docs[index]['msg'],
                                snapshot.data!.docs[index]['email'],
                                productId: snapshot.data!
                                    .docs[index]['productId']);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text('No payments yet'),
          );
        }
      },
    );
  }

  Future<void> viewPaymentDetails(String paymentId,
      double amount,
      DateTime dateTime,
      String customerName,
      String phone,
      String msg,
      String email,
      {String? productId}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: mq.height * .55,
                width: mq.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.keyboard_backspace),
                        ),
                        SizedBox(
                          width: mq.width * .04,
                        ),
                        Text(
                          'Payment details',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    ListTile(
                      title: widget.payment == true
                          ? Text('Payment Id')
                          : widget.shop == false ? Text('Booking Id') : Text(
                          'Order Id'),
                      trailing: Text('${paymentId}'),
                    ),
                    ListTile(
                      title: Text('Paid by'),
                      trailing: Text('${customerName}'),
                    ),
                    ListTile(
                      title: Text('Phone'),
                      trailing: Text('${phone}'),
                    ),
                    ListTile(
                      title: Text('Email'),
                      trailing: Text('${email}'),
                    ),
                    ListTile(
                      title: Text('Amount'),
                      trailing: Text('Rs.${amount}'),
                    ),
                    ListTile(
                      title: Text('Date'),
                      trailing: Text(
                          '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                    ),
                    ListTile(
                      title: Text('Product Id'),
                      trailing: Text(
                          '${productId}'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}