// import 'package:flutter/material.dart';
// import 'package:mall/controller/auth.dart';
// import 'package:mall/screens/customer/rive/NavigationPoint.dart';
// import 'package:mall/screens/customer/view_payments.dart';
//
// import '../../main.dart';
//
// class MyPayments extends StatefulWidget {
//   const MyPayments({super.key});
//
//   @override
//   State<MyPayments> createState() => _MyPaymentsState();
// }
//
// class _MyPaymentsState extends State<MyPayments> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: Auth.customerRef
//           .doc(Auth.auth.currentUser!.uid)
//           .collection('payments')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Scaffold(
//             extendBodyBehindAppBar: true,
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0.0,
//               title: ShaderMask(
//                   shaderCallback: (Rect bounds) {
//                     return LinearGradient(colors: [Colors.pink, Colors.black])
//                         .createShader(bounds);
//                   },
//                   child: Text(
//                     'My Payments',
//                     style: TextStyle(
//                       fontSize: 22.0,
//                       color: Colors.white,
//                     ),
//                   )),
//               centerTitle: true,
//               leading: BackButton(
//                 color: Color(0xff974c7c),
//                 onPressed: () {
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => NavigationPoint()),
//                           (route) => false);
//                 },
//               ),
//             ),
//             body: Stack(
//               children: [
//                 Container(
//                   height: mq.height,
//                   child: Image.network(
//                     "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Card(
//                         elevation: 10,
//                         shadowColor: Color(0xff974c7c),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         child: ListTile(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               side: BorderSide(color: Colors.black)),
//                           leading: CircleAvatar(
//                             backgroundColor: Color(0xff8D8E36),
//                             backgroundImage: NetworkImage(
//                                 '${snapshot.data!.docs[index]['shopIcon']}'),
//                           ),
//                           title:
//                           Text('${snapshot.data!.docs[index]['shopName']}'),
//                           subtitle: Text(
//                               'Rs.${snapshot.data!.docs[index]['amount']}'),
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ViewPayments(
//                                       paymentId: snapshot.data!.docs[index]
//                                       ['paymentId'],
//                                       shopName: snapshot.data!.docs[index]
//                                       ['shopName'],
//                                       email: snapshot.data!.docs[index]
//                                       ['email'],
//                                       amount: snapshot.data!.docs[index]
//                                       ['amount'],
//                                       phone: snapshot.data!.docs[index]
//                                       ['phone'],
//                                       name: snapshot.data!.docs[index]
//                                       ['customerName'],
//                                     )));
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         } else if (!snapshot.hasData ||
//             snapshot.hasError ||
//             snapshot.connectionState == ConnectionState.waiting) {
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
// }

import 'package:flutter/material.dart';
import 'package:mall/controller/auth.dart';
import 'package:mall/screens/customer/rive/NavigationPoint.dart';
import 'package:mall/screens/customer/view_payments.dart';

import '../../main.dart';

class MyPayments extends StatefulWidget {
  const MyPayments({super.key});

  @override
  State<MyPayments> createState() => _MyPaymentsState();
}

class _MyPaymentsState extends State<MyPayments> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth.customerRef
          .doc(Auth.auth.currentUser!.uid)
          .collection('payments')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(colors: [Colors.pink, Colors.black])
                        .createShader(bounds);
                  },
                  child: Text(
                    'My Payments',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  )),
              centerTitle: true,
              leading: BackButton(
                color: Color(0xff974c7c),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NavigationPoint()),
                          (route) => false);
                },
              ),
            ),
            body: Stack(
              children: [
                Container(
                  height: mq.height,
                  child: Image.network(
                    "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        shadowColor: Color(0xff974c7c),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black)),
                          leading: CircleAvatar(
                            backgroundColor: Color(0xff8D8E36),
                            backgroundImage: NetworkImage(
                                '${snapshot.data!.docs[index]['shopIcon']}'),
                          ),
                          title:
                          Text('${snapshot.data!.docs[index]['shopName']}'),
                          subtitle: Text(
                              'Rs.${snapshot.data!.docs[index]['amount']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewPayments(
                                      paymentId: snapshot.data!.docs[index]
                                      ['paymentId'],
                                      shopName: snapshot.data!.docs[index]
                                      ['shopName'],
                                      email: snapshot.data!.docs[index]
                                      ['email'],
                                      amount: snapshot.data!.docs[index]
                                      ['amount'],
                                      phone: snapshot.data!.docs[index]
                                      ['phone'],
                                      name: snapshot.data!.docs[index]
                                      ['customerName'],
                                    )));
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData ||
            snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
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
}