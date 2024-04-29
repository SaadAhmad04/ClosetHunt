// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/screens/customer/shopping/my_orders.dart';
//
// import '../../../constant/utils/utilities.dart';
// import '../../../controller/auth.dart';
// import '../../../controller/firebase_api.dart';
// import '../../../main.dart';
//
// class OrderStatus extends StatefulWidget {
//   String? orderId;
//   String? deliveryTime;
//   String? mode;
//   String? name;
//   String? image;
//   String? price;
//   int? qty;
//   double? perprice;
//   DateTime? dateTime;
//   String? sellerId;
//   bool? cancelled;
//   bool? assigned;
//   bool? delivered;
//   String? dateOfDelivery;
//   String? dateOfPickup;
//
//   OrderStatus(
//       {Key? key,
//         this.orderId,
//         this.deliveryTime,
//         this.mode,
//         this.name,
//         this.image,
//         this.price,
//         this.perprice,
//         this.qty,
//         this.dateTime,
//         this.sellerId,
//         this.cancelled,
//         this.assigned,
//         this.delivered,
//         this.dateOfDelivery,
//         this.dateOfPickup})
//       : super(key: key);
//
//   @override
//   State<OrderStatus> createState() => _OrderStatusState();
// }
//
// class _OrderStatusState extends State<OrderStatus> {
//   DateTime? dateTime;
//   int? _currentStep;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.assigned == true
//         ? widget.delivered == true
//         ? _currentStep = 2
//         : _currentStep = 1
//         : _currentStep = 0;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.dateOfDelivery != null) {
//       int date = int.parse(widget.dateOfDelivery!);
//       dateTime = DateTime.fromMillisecondsSinceEpoch(date);
//     } else if (widget.dateOfPickup != null) {
//       int date = int.parse(widget.dateOfPickup!);
//       dateTime = DateTime.fromMillisecondsSinceEpoch(date);
//     }
//     DateTime pickUpDate = widget.dateTime!.add(Duration(days: 3));
//     return Scaffold(
//       body: widget.mode == 'homeDelivery'
//           ? SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: Container(
//           height: mq.height,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [Color(0xFFe8d6e8), Colors.white],
//                 stops: const [0.5, 0.9],
//                 begin: Alignment.topLeft,
//                 end: Alignment.topRight),
//           ),
//           child: Column(
//             //mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: mq.height * .1),
//               widget.cancelled == false
//                   ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   height:
//                   20, // Set a fixed height for the RotatedBox
//                   child: LinearProgressIndicator(
//                     value: (_currentStep! + 1) /
//                         3, // Assuming 3 steps in total
//                     minHeight: 10,
//                     backgroundColor: Colors.grey[300],
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                         Color(0xff974C7C)),
//                   ),
//                 ),
//               )
//                   : SizedBox(),
//               SizedBox(height: 12),
//               widget.cancelled == false
//                   ? Container(
//                 //color: Colors.transparent,
//                   height: mq.height / 8,
//                   child: Image.asset("images/check.png"))
//                   : Container(
//                   height: mq.height / 8,
//                   child: Image.asset("images/cross.png")),
//               SizedBox(height: 12),
//               widget.cancelled == false
//                   ? Text(
//                 _currentStep == 0
//                     ? 'Order Placed'
//                     : _currentStep == 1
//                     ? 'Out for delivery'
//                     : 'Delivered',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               )
//                   : SizedBox(),
//               //SizedBox(height: 5),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SizedBox(
//                     height: mq.height * .04,
//                   ),
//                   Text(
//                     'Order Id : ${widget.orderId}',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                         fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: mq.height * .02,
//                   ),
//                   Card(
//                     elevation: 10,
//                     shadowColor: Color(0xff974c7c),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     child: ListTile(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           side: BorderSide(color: Colors.blueGrey)),
//                       visualDensity: VisualDensity(vertical: 4),
//                       title: Text('${widget.name}'),
//                       leading: CircleAvatar(
//                           backgroundImage:
//                           NetworkImage('${widget.image}')),
//                       trailing: Text('${widget.price}'),
//                       subtitle: Text('${widget.qty}'),
//                     ),
//                   ),
//                   SizedBox(
//                     height: mq.height * .02,
//                   ),
//                   ListTile(
//                       title: Text('Date'),
//                       trailing: Text(
//                         "${widget.dateTime!.day}-${widget.dateTime!.month}-${widget.dateTime!.year}",
//                       )),
//                   ListTile(
//                     title: Text('Price'),
//                     trailing: Text('Rs.${widget.price.toString()}'),
//                   ),
//                   ListTile(
//                     title: Text('Quantity'),
//                     trailing: Text(widget.qty.toString()),
//                   ),
//                   ListTile(
//                     title: Text('GST'),
//                     trailing: Text(
//                         'Rs.${((widget.perprice!) * 0.18).toStringAsFixed(2)}'),
//                   ),
//                   ListTile(
//                     title: Text('Total'),
//                     trailing: Text(
//                         'Rs.${((widget.perprice!) * 0.18 + widget.perprice!).toStringAsFixed(2)}'),
//                   ),
//                   widget.delivered == true
//                       ? ListTile(
//                     title: Text('Delivered on'),
//                     trailing: Text(
//                         '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
//                   )
//                       : SizedBox(),
//                 ],
//               )
//             ],
//           ),
//         ),
//       )
//           : SingleChildScrollView(
//         child: Container(
//           height: mq.height,
//           child: Column(
//             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                   margin: EdgeInsets.only(top: mq.height * .04),
//                   //color: Colors.black,
//                   height: mq.height / 8,
//                   child: Image.asset("images/cross.png")),
//               SizedBox(
//                 height: mq.height * .01,
//               ),
//               Text(
//                 'Order Id: ${widget.orderId}',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     fontSize: 18),
//               ),
//               SizedBox(
//                 height: mq.height * .03,
//               ),
//               Card(
//                 elevation: 10,
//                 shadowColor: Color(0xff974c7c),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: ListTile(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.blueGrey)),
//                   visualDensity: VisualDensity(vertical: 4),
//                   title: Text('${widget.name}'),
//                   leading: CircleAvatar(
//                       backgroundImage: NetworkImage('${widget.image}')),
//                   trailing: Text('${widget.price}'),
//                   subtitle: Text('${widget.qty}'),
//                 ),
//               ),
//               SizedBox(
//                 height: mq.height * .02,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: widget.cancelled == false
//                     ? widget.delivered == true
//                     ? SizedBox()
//                     : Text(
//                   'Note - You have to pick your order within 3 days from the mall. If you will not pick up your order within 3 days , your order will be automatically cancelled. Thankyou',
//                   style: TextStyle(
//                       color: Colors.red.shade800,
//                       fontWeight: FontWeight.bold),
//                 )
//                     : Text(
//                   "Note - You can't pick your order as it is cancelled either automatically or by yourself. Thankyou",
//                   style: TextStyle(
//                       color: Colors.red.shade800,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               ListTile(
//                   title: Text('Order date'),
//                   trailing: Text(
//                     "${widget.dateTime!.day}-${widget.dateTime!.month}-${widget.dateTime!.year}",
//                   )),
//               ListTile(
//                   title: Text('Pick up date (max)'),
//                   trailing: Text(
//                     "${pickUpDate.day}-${pickUpDate.month}-${pickUpDate.year}",
//                   )),
//               ListTile(
//                 title: Text('Price'),
//                 trailing: Text('Rs.${widget.price.toString()}'),
//               ),
//               ListTile(
//                 title: Text('Quantity'),
//                 trailing: Text(widget.qty.toString()),
//               ),
//               ListTile(
//                 title: Text('GST'),
//                 trailing: Text('Rs.${double.parse(widget.price!) * 0.1}'),
//               ),
//               ListTile(
//                 title: Text('Total'),
//                 trailing: Text(
//                     'Rs.${double.parse(widget.price!) * 0.1 + widget.perprice!}'),
//               ),
//               widget.delivered == true
//                   ? ListTile(
//                 title: Text('Picked up on'),
//                 trailing: Text(
//                     '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
//               )
//                   : SizedBox(),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: widget.cancelled == true
//           ? Container(
//         width: mq.width,
//         height: mq.height * .1,
//         decoration: BoxDecoration(
//           color: Color(0xff974C7C),
//         ),
//         child: Center(
//           child: Text(
//             'This order has been cancelled.',
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//         ),
//       )
//           : widget.delivered == true
//           ? (widget.dateOfDelivery != null)
//           ? Container(
//         width: mq.width,
//         height: mq.height * .1,
//         decoration: BoxDecoration(
//           color: Colors.green.shade400,
//         ),
//         child: Center(
//           child: Text(
//             'Delivered',
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//         ),
//       )
//           : Container(
//         width: mq.width,
//         height: mq.height * .1,
//         decoration: BoxDecoration(
//           color: Colors.green.shade400,
//         ),
//         child: Center(
//           child: Text(
//             'Picked up',
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//         ),
//       )
//           : InkWell(
//         onTap: () {
//           showCancelDialog(context);
//         },
//         child: Container(
//           width: mq.width,
//           height: mq.height * .1,
//           decoration: BoxDecoration(
//             color: Color(0xff974C7C),
//           ),
//           child: Center(
//             child: Text(
//               'Click Here To Cancel.',
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> showCancelDialog(BuildContext context) async {
//     String? appManagerId, appManagerToken;
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                 height: mq.height / 6,
//                 width: mq.width,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Are you sure you want to cancel this order ? '),
//                     SizedBox(
//                       height: mq.height * .06,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             height: 40,
//                             width: 80,
//                             child: Center(
//                               child: Text(
//                                 'No',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             decoration: BoxDecoration(
//                                 color: Color(0xff974C7C),
//                                 borderRadius: BorderRadius.circular(20)),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         InkWell(
//                           onTap: () async {
//                             await Auth.customerRef
//                                 .doc(Auth.auth.currentUser!.uid)
//                                 .collection('orders')
//                                 .doc(widget.orderId)
//                                 .update({'cancelled': true});
//                             final snapshot = await Auth.shopManagerRef
//                                 .doc(widget.sellerId)
//                                 .get();
//                             String token = snapshot.data()?['token'];
//                             await Auth.appManagerRef.get().then(
//                                   (QuerySnapshot querySnapshot) {
//                                 for (QueryDocumentSnapshot documentSnapshot
//                                 in querySnapshot.docs) {
//                                   Map<String, dynamic> keyValuePairs =
//                                   documentSnapshot.data()
//                                   as Map<String, dynamic>;
//                                   appManagerId = keyValuePairs['uid'];
//                                   appManagerToken = keyValuePairs['token'];
//                                 }
//                               },
//                             );
//                             // bool exists = await checkSubcollectionExistence(
//                             //     appManagerId!, widget.orderId!);
//                             FirebaseApi.cancelBooking(
//                                 uid: widget.sellerId,
//                                 orderId: widget.orderId,
//                                 token: token);
//                             FirebaseApi.cancelBooking(
//                                 uid: appManagerId,
//                                 orderId: widget.orderId,
//                                 token: appManagerToken,
//                                 // exists: exists,
//                                 forAppManager: true)
//                                 .then((value) {
//                               Utilities().showMessage('Order Cancelled');
//                               Navigator.pushAndRemoveUntil(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => MyOrders()),
//                                       (route) => false);
//                             });
//                           },
//                           child: Container(
//                             height: 40,
//                             width: 80,
//                             child: Center(
//                               child: Text(
//                                 'Yes',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             decoration: BoxDecoration(
//                                 color: Color(0xff8D8E36),
//                                 borderRadius: BorderRadius.circular(20)),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Future<bool> checkSubcollectionExistence(
//       String appManagerId, String orderId) async {
//     final CollectionReference mainCollection = Auth.appManagerRef
//         .doc(appManagerId)
//         .collection('notifications')
//         .doc(appManagerId)
//         .collection('shopping');
//     final DocumentReference document =
//     mainCollection.doc(orderId.substring(0, orderId.length - 1));
//     final CollectionReference subCollection1 = document.collection('products');
//     try {
//       final QuerySnapshot querySnapshot1 = await subCollection1.get();
//       return querySnapshot1.docs.isNotEmpty;
//     } catch (e) {
//       print('Error checking subcollections existence: $e');
//       return false;
//     }
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/customer/shopping/my_orders.dart';

import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import '../../../controller/firebase_api.dart';
import '../../../main.dart';

class OrderStatus extends StatefulWidget {
  String? orderId;
  String? deliveryTime;
  String? mode;
  String? name;
  String? image;
  String? price;
  int? qty;
  double? perprice;
  DateTime? dateTime;
  String? sellerId;
  bool? cancelled;
  bool? assigned;
  bool? delivered;
  String? dateOfDelivery;
  String? dateOfPickup;

  OrderStatus(
      {Key? key,
        this.orderId,
        this.deliveryTime,
        this.mode,
        this.name,
        this.image,
        this.price,
        this.perprice,
        this.qty,
        this.dateTime,
        this.sellerId,
        this.cancelled,
        this.assigned,
        this.delivered,
        this.dateOfDelivery,
        this.dateOfPickup})
      : super(key: key);

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  DateTime? dateTime;
  int? _currentStep;

  @override
  void initState() {
    super.initState();
    widget.assigned == true
        ? widget.delivered == true
        ? _currentStep = 2
        : _currentStep = 1
        : _currentStep = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dateOfDelivery != null) {
      int date = int.parse(widget.dateOfDelivery!);
      dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    } else if (widget.dateOfPickup != null) {
      int date = int.parse(widget.dateOfPickup!);
      dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    }
    DateTime pickUpDate = widget.dateTime!.add(Duration(days: 3));
    return Scaffold(
      body: widget.mode == 'homeDelivery'
          ? SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: mq.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFe8d6e8), Colors.white],
                stops: const [0.5, 0.9],
                begin: Alignment.topLeft,
                end: Alignment.topRight),
          ),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: mq.height * .1),
                widget.cancelled == false
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height:
                    20, // Set a fixed height for the RotatedBox
                    child: LinearProgressIndicator(
                      value: (_currentStep! + 1) /
                          3, // Assuming 3 steps in total
                      minHeight: 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff974C7C)),
                    ),
                  ),
                )
                    : SizedBox(),
                SizedBox(height: 12),
                widget.cancelled == false
                    ? Container(
                  //color: Colors.transparent,
                    height: mq.height / 8,
                    child: Image.asset("images/check.png"))
                    : Container(
                    height: mq.height / 8,
                    child: Image.asset("images/cross.png")),
                // SizedBox(height: 10),
                widget.cancelled == false
                    ? Text(
                  _currentStep == 0
                      ? 'Order Placed'
                      : _currentStep == 1
                      ? 'Out for delivery'
                      : 'Delivered',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                    : SizedBox(),
                //SizedBox(height: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: mq.height * .04,
                    ),
                    Text(
                      'Order Id : ${widget.orderId}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    Card(
                      elevation: 10,
                      shadowColor: Color(0xff974c7c),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.blueGrey)),
                        visualDensity: VisualDensity(vertical: 4),
                        title: Text('${widget.name}'),
                        leading: CircleAvatar(
                            backgroundImage:
                            NetworkImage('${widget.image}')),
                        trailing: Text('${widget.price}'),
                        subtitle: Text('${widget.qty}'),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    ListTile(
                        title: Text('Date'),
                        trailing: Text(
                          "${widget.dateTime!.day}-${widget.dateTime!.month}-${widget.dateTime!.year}",
                        )),
                    ListTile(
                      title: Text('Price'),
                      trailing: Text('Rs.${widget.price.toString()}'),
                    ),
                    ListTile(
                      title: Text('Quantity'),
                      trailing: Text(widget.qty.toString()),
                    ),
                    ListTile(
                      title: Text('GST'),
                      trailing: Text(
                          'Rs.${((widget.perprice!) * 0.18).toStringAsFixed(2)}'),
                    ),
                    ListTile(
                      title: Text('Total'),
                      trailing: Text(
                          'Rs.${((widget.perprice!) * 0.18 + widget.perprice!).toStringAsFixed(2)}'),
                    ),
                    widget.delivered == true
                        ? ListTile(
                      title: Text('Delivered on'),
                      trailing: Text(
                          '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
                    )
                        : SizedBox(),
                  ],
                )
              ],
            ),
          ),
        ),
      )
          : SingleChildScrollView(
        child: Container(
          height: mq.height,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  margin: EdgeInsets.only(top: mq.height * .04),
                  //color: Colors.black,
                  height: mq.height / 8,
                  child: Image.asset("images/cross.png")),
              SizedBox(
                height: mq.height * .01,
              ),
              Text(
                'Order Id: ${widget.orderId}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
              ),
              SizedBox(
                height: mq.height * .03,
              ),
              Card(
                elevation: 10,
                shadowColor: Color(0xff974c7c),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.blueGrey)),
                  visualDensity: VisualDensity(vertical: 4),
                  title: Text('${widget.name}'),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage('${widget.image}')),
                  trailing: Text('${widget.price}'),
                  subtitle: Text('${widget.qty}'),
                ),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.cancelled == false
                    ? widget.delivered == true
                    ? SizedBox()
                    : Text(
                  'Note - You have to pick your order within 3 days from the mall. If you will not pick up your order within 3 days , your order will be automatically cancelled. Thankyou',
                  style: TextStyle(
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.bold),
                )
                    : Text(
                  "Note - You can't pick your order as it is cancelled either automatically or by yourself. Thankyou",
                  style: TextStyle(
                      color: Colors.red.shade800,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                  title: Text('Order date'),
                  trailing: Text(
                    "${widget.dateTime!.day}-${widget.dateTime!.month}-${widget.dateTime!.year}",
                  )),
              ListTile(
                  title: Text('Pick up date (max)'),
                  trailing: Text(
                    "${pickUpDate.day}-${pickUpDate.month}-${pickUpDate.year}",
                  )),
              ListTile(
                title: Text('Price'),
                trailing: Text('Rs.${widget.price.toString()}'),
              ),
              ListTile(
                title: Text('Quantity'),
                trailing: Text(widget.qty.toString()),
              ),
              ListTile(
                title: Text('GST'),
                trailing: Text('Rs.${double.parse(widget.price!) * 0.1}'),
              ),
              ListTile(
                title: Text('Total'),
                trailing: Text(
                    'Rs.${double.parse(widget.price!) * 0.1 + widget.perprice!}'),
              ),
              widget.delivered == true
                  ? ListTile(
                title: Text('Picked up on'),
                trailing: Text(
                    '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.cancelled == true
          ? Container(
        width: mq.width,
        height: mq.height * .1,
        decoration: BoxDecoration(
          color: Color(0xff974C7C),
        ),
        child: Center(
          child: Text(
            'This order has been cancelled.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      )
          : widget.delivered == true
          ? (widget.dateOfDelivery != null)
          ? Container(
        width: mq.width,
        height: mq.height * .1,
        decoration: BoxDecoration(
          color: Colors.green.shade400,
        ),
        child: Center(
          child: Text(
            'Delivered',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      )
          : Container(
        width: mq.width,
        height: mq.height * .1,
        decoration: BoxDecoration(
          color: Colors.green.shade400,
        ),
        child: Center(
          child: Text(
            'Picked up',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      )
          : InkWell(
        onTap: () {
          showCancelDialog(context);
        },
        child: Container(
          width: mq.width,
          height: mq.height * .1,
          decoration: BoxDecoration(
            color: Color(0xff974C7C),
          ),
          child: Center(
            child: Text(
              'Click Here To Cancel.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showCancelDialog(BuildContext context) async {
    String? appManagerId, appManagerToken;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: mq.height / 6,
                width: mq.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Are you sure you want to cancel this order ? '),
                    SizedBox(
                      height: mq.height * .06,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xff974C7C),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            await Auth.customerRef
                                .doc(Auth.auth.currentUser!.uid)
                                .collection('orders')
                                .doc(widget.orderId)
                                .update({'cancelled': true});
                            final snapshot = await Auth.shopManagerRef
                                .doc(widget.sellerId)
                                .get();
                            String token = snapshot.data()?['token'];
                            await Auth.appManagerRef.get().then(
                                  (QuerySnapshot querySnapshot) {
                                for (QueryDocumentSnapshot documentSnapshot
                                in querySnapshot.docs) {
                                  Map<String, dynamic> keyValuePairs =
                                  documentSnapshot.data()
                                  as Map<String, dynamic>;
                                  appManagerId = keyValuePairs['uid'];
                                  appManagerToken = keyValuePairs['token'];
                                }
                              },
                            );
                            // bool exists = await checkSubcollectionExistence(
                            //     appManagerId!, widget.orderId!);
                            FirebaseApi.cancelBooking(
                                uid: widget.sellerId,
                                orderId: widget.orderId,
                                token: token);
                            FirebaseApi.cancelBooking(
                                uid: appManagerId,
                                orderId: widget.orderId,
                                token: appManagerToken,
                                // exists: exists,
                                forAppManager: true)
                                .then((value) {
                              Utilities().showMessage('Order Cancelled');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyOrders()),
                                      (route) => false);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 80,
                            child: Center(
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xff8D8E36),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> checkSubcollectionExistence(
      String appManagerId, String orderId) async {
    final CollectionReference mainCollection = Auth.appManagerRef
        .doc(appManagerId)
        .collection('notifications')
        .doc(appManagerId)
        .collection('shopping');
    final DocumentReference document =
    mainCollection.doc(orderId.substring(0, orderId.length - 1));
    final CollectionReference subCollection1 = document.collection('products');
    try {
      final QuerySnapshot querySnapshot1 = await subCollection1.get();
      return querySnapshot1.docs.isNotEmpty;
    } catch (e) {
      print('Error checking subcollections existence: $e');
      return false;
    }
  }
}