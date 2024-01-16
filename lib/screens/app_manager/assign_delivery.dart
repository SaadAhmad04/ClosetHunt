import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controller/auth.dart';
import '../../main.dart';

class AssignDelivery extends StatefulWidget {
  const AssignDelivery({super.key});

  @override
  State<AssignDelivery> createState() => _AssignDeliveryState();
}

class _AssignDeliveryState extends State<AssignDelivery> {

  int? date;
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delivery_dining),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.local_mall),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StreamBuilder(
                stream: Auth.appManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('notifications')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('shopping')
                    .where('mode', isEqualTo: 'homeDelivery')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          String name = snapshot.data?.docs[index]['name'];
                          if (snapshot.data?.docs[index]['productId'] == "") {
                            date = int.parse(
                                snapshot.data?.docs[index]['orderId']);
                            dateTime =
                                DateTime.fromMillisecondsSinceEpoch(date!);
                          } else {
                            int date = int.parse(snapshot
                                .data!.docs[index]['date']
                                .toString()
                                .substring(
                                0,
                                snapshot.data!.docs[index]['date']
                                    .toString()
                                    .length -
                                    1));
                            dateTime =
                                DateTime.fromMillisecondsSinceEpoch(date);
                          }
                          bool assigned =
                              snapshot.data?.docs[index]['assigned'];
                          return ListTile(
                            tileColor: assigned
                                ? Colors.green.shade100
                                : Colors.grey.shade100,
                            onLongPress: () {
                              assigned
                                  ? showPopupMenu(
                                      context,
                                      date.toString(),
                                      snapshot.data?.docs[index]
                                          ['deliveryBoyId'])
                                  : SizedBox();
                            },
                            shape: RoundedRectangleBorder(),
                            title: Text('${name}'),
                            subtitle: Text(
                                '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
                            trailing: assigned
                                ? Text(
                                    '${snapshot.data?.docs[index]['deliveryBoyId']}')
                                : PopupMenuButton(
                                    icon: Icon(Icons.assignment,
                                        color: Colors.grey),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: ListTile(
                                        title: Text('Assign delivery boy'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          assignDeliveryBoy(
                                              context, date.toString());
                                        },
                                      ))
                                    ],
                                  ),
                          );
                        });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text('No orders to assign!!'),
                    );
                  }
                },
              ),
              StreamBuilder(
                stream: Auth.appManagerRef
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('notifications')
                    .doc(Auth.auth.currentUser!.uid)
                    .collection('shopping')
                    .where('mode', isEqualTo: 'pickFromMall')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          String name = snapshot.data?.docs[index]['name'];
                          if (snapshot.data?.docs[index]['productId'] == "") {
                            int date = int.parse(
                                snapshot.data?.docs[index]['orderId']);
                            dateTime =
                                DateTime.fromMillisecondsSinceEpoch(date);
                          } else {
                            int date = int.parse(snapshot
                                .data!.docs[index]['date']
                                .toString()
                                .substring(
                                    0,
                                    snapshot.data!.docs[index]['date']
                                            .toString()
                                            .length -
                                        1));
                            dateTime =
                                DateTime.fromMillisecondsSinceEpoch(date);
                          }
                          return ListTile(
                            title: Text('${name}'),
                            subtitle: Text(
                                '${dateTime!.day}-${dateTime!.month}-${dateTime!.year}'),
                          );
                        });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text('No orders to assign!!'),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }

  Future<void> assignDeliveryBoy(BuildContext context, String orderId,
      {String? deliveryBoyId}) async {
    String selectedDeliveryBoy = "Select delivery boy";
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: mq.height / 4,
                width: mq.width,
                child: StreamBuilder(
                  stream: Auth.deliveryRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot =
                          snapshot.data as QuerySnapshot;
                      List<String> data = querySnapshot.docs
                          .map((doc) => doc['id'] as String)
                          .toList();
                      if (!data.contains("Select delivery boy")) {
                        // Add the hint only if it's not already present
                        data.insert(0, "Select delivery boy");
                      }
                      return Column(
                        children: [
                          DropdownButton(
                            // Initial Value
                            value: selectedDeliveryBoy,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: data.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDeliveryBoy = newValue!;
                              });
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              await Auth.appManagerRef
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('notifications')
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('shopping')
                                  .doc(orderId)
                                  .update({
                                'assigned': true,
                                'deliveryBoyId': selectedDeliveryBoy
                              });
                            },
                            child: Container(
                              height: 35,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                  'Okay',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
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

  void showPopupMenu(
      BuildContext context, String orderId, String deliveryBoyId) async {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(0, 0), // You can adjust the position based on your needs
        overlay.localToGlobal(overlay.size.bottomLeft(Offset(0, 0))),
      ),
      Offset.fromDirection(mq.height / 2, mq.width / 2) & overlay.size,
    );

    await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 1,
          child: ListTile(
            title: Text('Change delivery boy'),
            onTap: () {
              Navigator.pop(context);
              assignDeliveryBoy(context, orderId, deliveryBoyId: deliveryBoyId);
            },
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
