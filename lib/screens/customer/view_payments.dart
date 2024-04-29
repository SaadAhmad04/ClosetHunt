// import 'package:flutter/material.dart';
//
// import '../../main.dart';
//
// class ViewPayments extends StatefulWidget {
//   String? paymentId;
//   double? amount;
//   String? shopName;
//   String? phone;
//   String? name;
//   String? email;
//
//   ViewPayments(
//       {super.key,
//         this.shopName,
//         this.amount,
//         this.phone,
//         this.paymentId,
//         this.email,
//         this.name});
//
//   @override
//   State<ViewPayments> createState() => _ViewPaymentsState();
// }
//
// class _ViewPaymentsState extends State<ViewPayments> {
//   DateTime? dateTime;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     int date = int.parse(widget.paymentId!);
//     dateTime = DateTime.fromMillisecondsSinceEpoch(date);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade200,
//       body: Card(
//         margin: EdgeInsets.symmetric(
//             horizontal: mq.width * .05, vertical: mq.height * .18),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//             side: BorderSide(color: Colors.blue.shade600)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Payment details',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18),
//             ),
//             SizedBox(
//               height: mq.height * .02,
//             ),
//             ListTile(
//               title: Text('Payment Id'),
//               trailing: Text('${widget.paymentId}'),
//             ),
//             ListTile(
//               title: Text('Paid by'),
//               trailing: Text('${widget.name}'),
//             ),
//             ListTile(
//               title: Text('Email'),
//               trailing: Text('${widget.email}'),
//             ),
//             ListTile(
//               title: Text('Amount'),
//               trailing: Text('Rs.${widget.amount}'),
//             ),
//             ListTile(
//               title: Text('Date'),
//               trailing:
//               Text('${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
//             ),
//             ListTile(
//               title: Text('Time'),
//               trailing: Text(
//                   '${dateTime!.hour}:${dateTime!.minute}:${dateTime!.second}'),
//             ),
//             ListTile(
//               title: Text('Shop Name'),
//               trailing: Text('${widget.shopName}'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../main.dart';

class ViewPayments extends StatefulWidget {
  String? paymentId;
  double? amount;
  String? shopName;
  String? phone;
  String? name;
  String? email;

  ViewPayments(
      {super.key,
        this.shopName,
        this.amount,
        this.phone,
        this.paymentId,
        this.email,
        this.name});

  @override
  State<ViewPayments> createState() => _ViewPaymentsState();
}

class _ViewPaymentsState extends State<ViewPayments> {
  DateTime? dateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int date = int.parse(widget.paymentId!);
    dateTime = DateTime.fromMillisecondsSinceEpoch(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade200,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
              ),
            )),
        child: Card(
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .05, vertical: mq.height * .18),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.blue.shade600)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Payment details',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              ListTile(
                title: Text('Payment Id'),
                trailing: Text('${widget.paymentId}'),
              ),
              ListTile(
                title: Text('Paid by'),
                trailing: Text('${widget.name}'),
              ),
              ListTile(
                title: Text('Email'),
                trailing: Text('${widget.email}'),
              ),
              ListTile(
                title: Text('Amount'),
                trailing: Text('Rs.${widget.amount}'),
              ),
              ListTile(
                title: Text('Date'),
                trailing: Text(
                    '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
              ),
              ListTile(
                title: Text('Time'),
                trailing: Text(
                    '${dateTime!.hour}:${dateTime!.minute}:${dateTime!.second}'),
              ),
              ListTile(
                title: Text('Shop Name'),
                trailing: Text('${widget.shopName}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}