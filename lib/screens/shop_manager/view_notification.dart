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
      this.cancelled});

  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  DateTime? dateTime, dateTime2;

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
    return widget.bookingId == null
        ? Scaffold(
            appBar: AppBar(
              title: Text('Order details'),
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
                      'Order no.${widget.orderId}',
                      style: TextStyle(
                          color: Colors.black,
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
                      title: Text('Product Id'),
                      trailing: Text('${widget.productId}'),
                    ),
                    Container(
                      height: mq.height * .1,
                      width: mq.width,
                      child: ListTile(
                        shape: UnderlineInputBorder(),
                        title: Text('Product Name'),
                        trailing: Container(
                            width: mq.width * .4,
                            child: Text('${widget.productName}')),
                      ),
                    ),
                    ListTile(
                      shape: UnderlineInputBorder(),
                      title: Text('Quantity'),
                      trailing: Text('${widget.qty.toString()}'),
                    ),
                    ListTile(
                      shape: UnderlineInputBorder(),
                      title: Text('Date'),
                      trailing: Text(
                          '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
                    ),
                    ListTile(
                      title: Text('Amount paid'),
                      trailing: Text('Rs.${widget.amount.toString()}'),
                    )
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
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
                      trailing: Text('${widget.time}'),
                    ),
                    ListTile(
                      title: Text('Amount paid'),
                      trailing: Text('Rs.${widget.amount}'),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
