// import 'package:flutter/material.dart';
//
// import '../../controller/auth.dart';
// import '../../main.dart';
//
// class ViewNotification extends StatefulWidget {
//   String? orderId;
//   String? bookingId;
//   String? customerName;
//   String? customerEmail;
//   String? productId;
//   String? productName;
//   int? qty;
//   String? dateTime;
//   double? amount;
//   String? serviceId;
//   String? serviceName;
//   String? bookingDate;
//   String? time;
//   bool? cancelled;
//   bool restro;
//   int? guests;
//   String? slotType;
//   ViewNotification(
//       {super.key,
//       this.orderId,
//       this.bookingId,
//       this.dateTime,
//       this.productId,
//       this.amount,
//       this.qty,
//       this.customerEmail,
//       this.customerName,
//       this.productName,
//       this.serviceId,
//       this.bookingDate,
//       this.time,
//       this.serviceName,
//       this.cancelled,
//       this.restro = false,
//       this.guests,
//       this.slotType});
//
//   @override
//   State<ViewNotification> createState() => _ViewNotificationState();
// }
//
// class _ViewNotificationState extends State<ViewNotification> {
//   DateTime? dateTime, dateTime2;
//   String? period;
//   int? hr, min;
//
//   @override
//   Widget build(BuildContext context) {
//     mq = MediaQuery.of(context).size;
//     if (widget.bookingDate != null) {
//       dateTime2 = DateTime.parse(widget.bookingDate!);
//       print(dateTime2);
//     } else {
//       int date =
//           int.parse(widget.dateTime!.substring(0, widget.dateTime!.length - 1));
//       dateTime = DateTime.fromMillisecondsSinceEpoch(date);
//       print(dateTime);
//     }
//     if (widget.time != null && widget.restro == true) {
//       String time = widget.time!;
//       hr = int.parse(time.split(":").first);
//       min = int.parse(time.split(":").last);
//       if (hr! >= 13 && hr! < 23) {
//         hr = hr! - 12;
//         period = "pm";
//       } else if (hr == 12) {
//         period = "pm";
//       } else {
//         period = "am";
//       }
//     } else if (widget.time != null && widget.restro == false) {
//       String time = widget.time!;
//       hr = int.parse(time.split(":").first);
//       String m = (time.split(":").last);
//       min = int.parse(m.substring(0, m.length - 3));
//       print(min);
//       if (hr! >= 13 && hr! < 23) {
//         hr = hr! - 12;
//         period = "pm";
//       } else if (hr == 12) {
//         period = "pm";
//       } else {
//         period = "am";
//       }
//     }
//     return widget.bookingId == null
//         ? Scaffold(
//             appBar: AppBar(
//               title: Text('Order details'),
//               centerTitle: true,
//             ),
//             body: Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   side: BorderSide(color: Colors.grey)),
//               margin: EdgeInsets.symmetric(
//                   horizontal: 10, vertical: mq.height * .05),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: mq.height * .05,
//                     ),
//                     Text(
//                       'Order no.${widget.orderId}',
//                       style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18),
//                     ),
//                     widget.cancelled == true
//                         ? Text(
//                             'Cancelled',
//                             style: TextStyle(
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16),
//                           )
//                         : SizedBox(),
//                     SizedBox(
//                       height: mq.height * .05,
//                     ),
//                     ListTile(
//                       shape: UnderlineInputBorder(),
//                       title: Text('Customer name'),
//                       trailing: Text('${widget.customerName}'),
//                     ),
//                     ListTile(
//                       shape: UnderlineInputBorder(),
//                       title: Text('Customer email'),
//                       trailing: Text('${widget.customerEmail}'),
//                     ),
//                     ListTile(
//                       shape: UnderlineInputBorder(),
//                       title: Text('Product Id'),
//                       trailing: Text('${widget.productId}'),
//                     ),
//                     Container(
//                       height: mq.height * .1,
//                       width: mq.width,
//                       child: ListTile(
//                         shape: UnderlineInputBorder(),
//                         title: Text('Product Name'),
//                         trailing: Container(
//                             width: mq.width * .4,
//                             child: Text('${widget.productName}')),
//                       ),
//                     ),
//                     ListTile(
//                       shape: UnderlineInputBorder(),
//                       title: Text('Quantity'),
//                       trailing: Text('${widget.qty.toString()}'),
//                     ),
//                     ListTile(
//                       shape: UnderlineInputBorder(),
//                       title: Text('Date'),
//                       trailing: Text(
//                           '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
//                     ),
//                     ListTile(
//                       title: Text('Amount paid'),
//                       trailing: Text('Rs.${widget.amount.toString()}'),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )
//         : widget.restro == false
//             ? Scaffold(
//                 appBar: AppBar(
//                   title: Text('Booking details'),
//                   centerTitle: true,
//                 ),
//                 body: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.grey)),
//                   margin: EdgeInsets.symmetric(
//                       horizontal: 10, vertical: mq.height * .05),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: mq.height * .05,
//                         ),
//                         Text(
//                           'Booking no.${widget.bookingId}',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18),
//                         ),
//                         widget.cancelled == true
//                             ? Text(
//                                 'Cancelled',
//                                 style: TextStyle(
//                                     color: Colors.red.shade800,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                               )
//                             : SizedBox(),
//                         SizedBox(
//                           height: mq.height * .05,
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Customer name'),
//                           trailing: Text('${widget.customerName}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Customer email'),
//                           trailing: Text('${widget.customerEmail}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Service Id'),
//                           trailing: Text('${widget.serviceId}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Service Name'),
//                           trailing: Text('${widget.serviceName}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Date'),
//                           trailing: Text(
//                               '${dateTime2!.day}-${dateTime2!.month}-${dateTime2!.year}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Time'),
//                           trailing: Text('${hr}:${min} ${period}'),
//                         ),
//                         ListTile(
//                           title: Text('Amount paid'),
//                           trailing: Text('Rs.${widget.amount}'),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             : Scaffold(
//                 appBar: AppBar(
//                   title: Text('Booking details'),
//                   centerTitle: true,
//                 ),
//                 body: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: Colors.grey)),
//                   margin: EdgeInsets.symmetric(
//                       horizontal: 10, vertical: mq.height * .05),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: mq.height * .05,
//                         ),
//                         Text(
//                           'Booking no.${widget.bookingId}',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18),
//                         ),
//                         widget.cancelled == true
//                             ? Text(
//                                 'Cancelled',
//                                 style: TextStyle(
//                                     color: Colors.red.shade800,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                               )
//                             : SizedBox(),
//                         SizedBox(
//                           height: mq.height * .05,
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Customer name'),
//                           trailing: Text('${widget.customerName}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Customer email'),
//                           trailing: Text('${widget.customerEmail}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Date'),
//                           trailing: Text(
//                               '${dateTime2!.day}-${dateTime2!.month}-${dateTime2!.year}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Slot type'),
//                           trailing: Text('${widget.slotType}'),
//                         ),
//                         ListTile(
//                           shape: UnderlineInputBorder(),
//                           title: Text('Time'),
//                           trailing: Text('${hr}:${min} ${period}'),
//                         ),
//                         ListTile(
//                           title: Text('No.of guests'),
//                           trailing: Text('${widget.guests}'),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//   }
// }

import 'package:flutter/material.dart';

import '../../controller/auth.dart';
import '../../main.dart';

class ViewNotification extends StatefulWidget {
  String? orderId;
  String? bookingId;
  String? customerName;
  String? customerEmail;
  String? productId;
  String? productName;
  int? qty;
  String? dateTime;
  double? amount;
  String? serviceId;
  String? serviceName;
  String? bookingDate;
  String? time;
  bool? cancelled;
  bool restro;
  int? guests;
  String? slotType;

  ViewNotification(
      {super.key,
        this.orderId,
        this.bookingId,
        this.dateTime,
        this.productId,
        this.amount,
        this.qty,
        this.customerEmail,
        this.customerName,
        this.productName,
        this.serviceId,
        this.bookingDate,
        this.time,
        this.serviceName,
        this.cancelled,
        this.restro = false,
        this.guests,
        this.slotType});

  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  DateTime? dateTime, dateTime2;
  String? period;
  int? hr, min;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    if (widget.bookingDate != null) {
      dateTime2 = DateTime.parse(widget.bookingDate!);
      print(dateTime2);
    } else {
      int date =
      int.parse(widget.dateTime!.substring(0, widget.dateTime!.length - 1));
      dateTime = DateTime.fromMillisecondsSinceEpoch(date);
      print(dateTime);
    }
    if (widget.time != null && widget.restro == true) {
      String time = widget.time!;
      hr = int.parse(time.split(":").first);
      min = int.parse(time.split(":").last);
      if (hr! >= 13 && hr! < 23) {
        hr = hr! - 12;
        period = "pm";
      } else if (hr == 12) {
        period = "pm";
      } else {
        period = "am";
      }
    } else if (widget.time != null && widget.restro == false) {
      String time = widget.time!;
      hr = int.parse(time.split(":").first);
      String m = (time.split(":").last);
      min = int.parse(m.substring(0, m.length - 3));
      print(min);
      if (hr! >= 13 && hr! < 23) {
        hr = hr! - 12;
        period = "pm";
      } else if (hr == 12) {
        period = "pm";
      } else {
        period = "am";
      }
    }
    return widget.bookingId == null
        ? Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Order details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.purple)),
        margin: EdgeInsets.symmetric(
            horizontal: 10, vertical: mq.height * .05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: mq.height * .05,
              ),
              Text(
                'Order no.${widget.orderId}',
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              widget.cancelled == true
                  ? Text(
                'Cancelled',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
                  : SizedBox(),
              SizedBox(
                height: mq.height * .05,
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text(
                  'Customer name',
                  style: TextStyle(color: Colors.purple),
                ),
                trailing: Text('${widget.customerName}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text(
                  'Customer email',
                  style: TextStyle(color: Colors.purple),
                ),
                trailing: Text('${widget.customerEmail}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text(
                  'Product Id',
                  style: TextStyle(color: Colors.purple),
                ),
                trailing: Text('${widget.productId}'),
              ),
              Container(
                height: mq.height * .1,
                width: mq.width,
                child: ListTile(
                  shape: UnderlineInputBorder(),
                  title: Text(
                    'Product Name',
                    style: TextStyle(color: Colors.purple),
                  ),
                  trailing: Container(
                      width: mq.width * .5,
                      child: Text('${widget.productName}')),
                ),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text(
                  'Quantity',
                  style: TextStyle(color: Colors.purple),
                ),
                trailing: Text('${widget.qty.toString()}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text(
                  'Date',
                  style: TextStyle(color: Colors.purple),
                ),
                trailing: Text(
                    '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
              ),
              ListTile(
                title: Text(
                  'Amount paid',
                  style: TextStyle(color: Colors.purple),
                ),
                trailing: Text('Rs.${widget.amount.toString()}'),
              )
            ],
          ),
        ),
      ),
    )
        : widget.restro == false
        ? Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text('Booking details'),
        centerTitle: true,
      ),
      body: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey)),
        margin: EdgeInsets.symmetric(
            horizontal: 10, vertical: mq.height * .05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: mq.height * .05,
              ),
              Text(
                'Booking no.${widget.bookingId}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              widget.cancelled == true
                  ? Text(
                'Cancelled',
                style: TextStyle(
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
                  : SizedBox(),
              SizedBox(
                height: mq.height * .05,
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Customer name'),
                trailing: Text('${widget.customerName}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Customer email'),
                trailing: Text('${widget.customerEmail}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Service Id'),
                trailing: Text('${widget.serviceId}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Service Name'),
                trailing: Text('${widget.serviceName}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Date'),
                trailing: Text(
                    '${dateTime2!.day}-${dateTime2!.month}-${dateTime2!.year}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Time'),
                trailing: Text('${hr}:${min} ${period}'),
              ),
              ListTile(
                title: Text('Amount paid'),
                trailing: Text('Rs.${widget.amount}'),
              )
            ],
          ),
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text('Booking details'),
        centerTitle: true,
      ),
      body: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey)),
        margin: EdgeInsets.symmetric(
            horizontal: 10, vertical: mq.height * .05),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: mq.height * .05,
              ),
              Text(
                'Booking no.${widget.bookingId}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              widget.cancelled == true
                  ? Text(
                'Cancelled',
                style: TextStyle(
                    color: Colors.red.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
                  : SizedBox(),
              SizedBox(
                height: mq.height * .05,
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Customer name'),
                trailing: Text('${widget.customerName}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Customer email'),
                trailing: Text('${widget.customerEmail}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Date'),
                trailing: Text(
                    '${dateTime2!.day}-${dateTime2!.month}-${dateTime2!.year}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Slot type'),
                trailing: Text('${widget.slotType}'),
              ),
              ListTile(
                shape: UnderlineInputBorder(),
                title: Text('Time'),
                trailing: Text('${hr}:${min} ${period}'),
              ),
              ListTile(
                title: Text('No.of guests'),
                trailing: Text('${widget.guests}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}