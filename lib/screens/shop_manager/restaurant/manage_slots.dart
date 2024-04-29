// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../../../constant/utils/utilities.dart';
// import '../../../controller/auth.dart';
//
// class ManageSlots extends StatefulWidget {
//   const ManageSlots({Key? key}) : super(key: key);
//
//   @override
//   State<ManageSlots> createState() => _ManageSlotsState();
// }
//
// class _ManageSlotsState extends State<ManageSlots> {
//   TimeOfDay? time;
//   List<String> lunchTimeList = [];
//   List<String> dinnerTimeList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Manage Your Slots"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Card(
//             child: ListTile(
//               title: Text('Lunch'),
//               trailing: PopupMenuButton(
//                 icon: Icon(
//                   Icons.more_vert,
//                   size: 20,
//                 ),
//                 itemBuilder: (context) => [
//                   PopupMenuItem(
//                     value: 1,
//                     child: ListTile(
//                       title: Text('View Slots'),
//                       onTap: () {
//                         viewSlots(context, 'lunchTime');
//                       },
//                     ),
//                   ),
//                   PopupMenuItem(
//                     value: 1,
//                     child: ListTile(
//                       title: Text('Set Slots'),
//                       onTap: () async {
//                         time = await pickTime();
//                         if (time != null) {
//                           String formattedTime = formatTime(time!);
//                           print(formattedTime);
//
//                           lunchTimeList.add(formattedTime);
//                           setState(() {});
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           lunchTimeList.length > 0
//               ? Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: TextButton.icon(
//                 onPressed: () async {
//                   //print("New Image URLs: $newImageUrls");
//                   // Fetch the existing menuList
//                   List<String> existingLunchSlots = [];
//                   var docSnapshot = await Auth.shopManagerRef
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('restaurant')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('details')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .get();
//
//                   if (docSnapshot.exists) {
//                     var data = docSnapshot.data() as Map<String, dynamic>;
//                     if (data.containsKey('lunchTime') &&
//                         data['lunchTime'] is List) {
//                       existingLunchSlots =
//                       List<String>.from(data['lunchTime']);
//                     }
//                   }
//                   print("Typee $existingLunchSlots");
//                   List<String> updatedLunchSlots = [];
//                   // Append the new image URLs to the existing menuList
//                   updatedLunchSlots =
//                   List<String>.from(existingLunchSlots)
//                     ..addAll(lunchTimeList);
//                   // Update the document with the updated menuList
//
//                   await Auth.shopManagerRef
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('restaurant')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('details')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .update({
//                     'lunchTime': updatedLunchSlots,
//                   });
//                   Utilities().showMessage("Time Slot Added");
//                   lunchTimeList = [];
//                   setState(() {});
//                 },
//                 icon: Icon(Icons.add),
//                 label: Text("Add"),
//               ),
//             ),
//           )
//               : SizedBox(),
//           Card(
//             child: ListTile(
//               title: Text('Dinner'),
//               trailing: PopupMenuButton(
//                 icon: Icon(
//                   Icons.more_vert,
//                   size: 20,
//                 ),
//                 itemBuilder: (context) => [
//                   PopupMenuItem(
//                     value: 1,
//                     child: ListTile(
//                       title: Text('View Slots'),
//                       onTap: () {
//                         viewSlots(context, 'dinnerTime');
//                       },
//                     ),
//                   ),
//                   PopupMenuItem(
//                     value: 1,
//                     child: ListTile(
//                       title: Text('Set Slots'),
//                       onTap: () async {
//                         time = await pickTime();
//                         if (time != null) {
//                           String formattedTime = formatTime(time!);
//                           print(formattedTime);
//                           dinnerTimeList.add(formattedTime);
//                           setState(() {});
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           dinnerTimeList.length > 0
//               ? Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: TextButton.icon(
//                 onPressed: () async {
//                   //print("New Image URLs: $newImageUrls");
//                   // Fetch the existing menuList
//                   List<String> existingDinnerSlots = [];
//                   var docSnapshot = await Auth.shopManagerRef
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('restaurant')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('details')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .get();
//
//                   if (docSnapshot.exists) {
//                     var data = docSnapshot.data() as Map<String, dynamic>;
//                     if (data.containsKey('dinnerTime') &&
//                         data['dinnerTime'] is List) {
//                       existingDinnerSlots =
//                       List<String>.from(data['dinnerTime']);
//                     }
//                   }
//                   print("Typee $existingDinnerSlots");
//                   List<String> updatedDinnerSlots = [];
//                   // Append the new image URLs to the existing menuList
//                   updatedDinnerSlots =
//                   List<String>.from(existingDinnerSlots)
//                     ..addAll(dinnerTimeList);
//                   // Update the document with the updated menuList
//
//                   await Auth.shopManagerRef
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('restaurant')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('details')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .update({
//                     'dinnerTime': updatedDinnerSlots,
//                   });
//                   Utilities().showMessage("Time Slot Added");
//                   dinnerTimeList = [];
//                   setState(() {});
//                 },
//                 icon: Icon(Icons.add),
//                 label: Text("Add"),
//               ),
//             ),
//           )
//               : SizedBox(),
//           SizedBox(
//             height: 20,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<TimeOfDay?> pickTime() async {
//     return showTimePicker(context: context, initialTime: TimeOfDay.now());
//   }
//
//   String formatTime(TimeOfDay timeOfDay) {
//     // Format the TimeOfDay object as "HH:mm"
//     String hour = timeOfDay.hour.toString().padLeft(2, '0');
//     String minute = timeOfDay.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }
//
//   Future<void> viewSlots(BuildContext context, String timeList) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           content: StatefulBuilder(
//             builder: (context, setModalState) {
//               return SizedBox(
//                 height: 300,
//                 child: StreamBuilder(
//                   stream: Auth.shopManagerRef
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('restaurant')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('details')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       List<String> LunchTimeList = [];
//                       List<String> DinnerTimeList = [];
//                       timeList == "lunchTime"
//                           ? LunchTimeList =
//                       List<String>.from(snapshot.data?[timeList] ?? [])
//                           : DinnerTimeList =
//                       List<String>.from(snapshot.data?[timeList] ?? []);
//
//                       List<Widget> timeWidgets =
//                       []; // New list to hold Card widgets
//
//                       for (int i = 0;
//                       i <
//                           (timeList == "lunchTime"
//                               ? LunchTimeList.length
//                               : DinnerTimeList.length);
//                       i++) {
//                         String time = timeList == "lunchTime"
//                             ? LunchTimeList[i]
//                             : DinnerTimeList[i];
//                         timeWidgets.add(
//                           Card(
//                             color: Colors.blueGrey,
//                             child: ListTile(
//                               trailing: IconButton(
//                                   icon: Icon(Icons.delete),
//                                   onPressed: () async {
//                                     int indexToDelete =
//                                         i; // Replace with the actual index you want to delete
//
// // Get the reference to the document
//                                     DocumentReference documentReference = Auth
//                                         .shopManagerRef
//                                         .doc(Auth.auth.currentUser!.uid)
//                                         .collection('restaurant')
//                                         .doc(Auth.auth.currentUser!.uid)
//                                         .collection('details')
//                                         .doc(Auth.auth.currentUser!.uid);
//
// // Retrieve the current document
//                                     DocumentSnapshot documentSnapshot =
//                                     await documentReference.get();
//
// // Check if the document exists
//                                     if (documentSnapshot.exists) {
//                                       // Get the current list from the document
//                                       List<dynamic> currentList =
//                                           documentSnapshot[timeList] ?? [];
//
//                                       // Check if the index is valid
//                                       if (indexToDelete >= 0 &&
//                                           indexToDelete < currentList.length) {
//                                         // Remove the element at the specified index
//                                         currentList.removeAt(indexToDelete);
//                                         print(currentList);
//                                         // Update the document with the modified list
//                                         await documentReference.update({
//                                           timeList: currentList,
//                                         });
//
//                                         print(
//                                             'Element at index $indexToDelete deleted successfully.');
//                                         Utilities().showMessage(
//                                             "Deleted Successfully");
//                                       }
//                                     }
//                                   }),
//                               title: Text(time),
//                             ),
//                           ),
//                         );
//                       }
//
//                       return SingleChildScrollView(
//                         child: Column(
//                           children: timeWidgets,
//                         ),
//                       );
//                     } else {
//                       return Text("Sorry, no data available");
//                     }
//                   },
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant/utils/utilities.dart';
import '../../../controller/auth.dart';
import '../../../main.dart';

class ManageSlots extends StatefulWidget {
  const ManageSlots({Key? key}) : super(key: key);

  @override
  State<ManageSlots> createState() => _ManageSlotsState();
}

class _ManageSlotsState extends State<ManageSlots> {
  TimeOfDay? time;
  List<String> lunchTimeList = [];
  List<String> dinnerTimeList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.purple[100],
        title: Text("Manage Your Slots"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Text('Lunch'),
                trailing: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        title: Text('View Slots'),
                        onTap: () {
                          viewSlots(context, 'lunchTime');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        title: Text('Set Slots'),
                        onTap: () async {
                          time = await pickTime();
                          if (time != null) {
                            String formattedTime = formatTime(time!);
                            print(formattedTime);

                            lunchTimeList.add(formattedTime);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          lunchTimeList.length > 0
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () async {
                  //print("New Image URLs: $newImageUrls");
                  // Fetch the existing menuList
                  List<String> existingLunchSlots = [];
                  var docSnapshot = await Auth.shopManagerRef
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('restaurant')
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('details')
                      .doc(Auth.auth.currentUser!.uid)
                      .get();

                  if (docSnapshot.exists) {
                    var data = docSnapshot.data() as Map<String, dynamic>;
                    if (data.containsKey('lunchTime') &&
                        data['lunchTime'] is List) {
                      existingLunchSlots =
                      List<String>.from(data['lunchTime']);
                    }
                  }
                  print("Typee $existingLunchSlots");
                  List<String> updatedLunchSlots = [];
                  // Append the new image URLs to the existing menuList
                  updatedLunchSlots =
                  List<String>.from(existingLunchSlots)
                    ..addAll(lunchTimeList);
                  // Update the document with the updated menuList

                  await Auth.shopManagerRef
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('restaurant')
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('details')
                      .doc(Auth.auth.currentUser!.uid)
                      .update({
                    'lunchTime': updatedLunchSlots,
                  });
                  Utilities().showMessage("Time Slot Added");
                  lunchTimeList = [];
                  setState(() {});
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.purple,
                ),
                label: Text(
                  "Add",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
          )
              : SizedBox(),
          Image.asset("images/pizza.gif"),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Text('Dinner'),
                trailing: PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        title: Text('View Slots'),
                        onTap: () {
                          viewSlots(context, 'dinnerTime');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        title: Text('Set Slots'),
                        onTap: () async {
                          time = await pickTime();
                          if (time != null) {
                            String formattedTime = formatTime(time!);
                            print(formattedTime);
                            dinnerTimeList.add(formattedTime);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          dinnerTimeList.length > 0
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () async {
                  //print("New Image URLs: $newImageUrls");
                  // Fetch the existing menuList
                  List<String> existingDinnerSlots = [];
                  var docSnapshot = await Auth.shopManagerRef
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('restaurant')
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('details')
                      .doc(Auth.auth.currentUser!.uid)
                      .get();

                  if (docSnapshot.exists) {
                    var data = docSnapshot.data() as Map<String, dynamic>;
                    if (data.containsKey('dinnerTime') &&
                        data['dinnerTime'] is List) {
                      existingDinnerSlots =
                      List<String>.from(data['dinnerTime']);
                    }
                  }
                  print("Typee $existingDinnerSlots");
                  List<String> updatedDinnerSlots = [];
                  // Append the new image URLs to the existing menuList
                  updatedDinnerSlots =
                  List<String>.from(existingDinnerSlots)
                    ..addAll(dinnerTimeList);
                  // Update the document with the updated menuList

                  await Auth.shopManagerRef
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('restaurant')
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('details')
                      .doc(Auth.auth.currentUser!.uid)
                      .update({
                    'dinnerTime': updatedDinnerSlots,
                  });
                  Utilities().showMessage("Time Slot Added");
                  dinnerTimeList = [];
                  setState(() {});
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.purple,
                ),
                label: Text(
                  "Add",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
          )
              : SizedBox(),
        ],
      ),
    );
  }

  Future<TimeOfDay?> pickTime() async {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  String formatTime(TimeOfDay timeOfDay) {
    // Format the TimeOfDay object as "HH:mm"
    String hour = timeOfDay.hour.toString().padLeft(2, '0');
    String minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> viewSlots(BuildContext context, String timeList) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return SizedBox(
                height: 300,
                child: StreamBuilder(
                  stream: Auth.shopManagerRef
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('restaurant')
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('details')
                      .doc(Auth.auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<String> LunchTimeList = [];
                      List<String> DinnerTimeList = [];
                      timeList == "lunchTime"
                          ? LunchTimeList =
                      List<String>.from(snapshot.data?[timeList] ?? [])
                          : DinnerTimeList =
                      List<String>.from(snapshot.data?[timeList] ?? []);

                      List<Widget> timeWidgets =
                      []; // New list to hold Card widgets

                      for (int i = 0;
                      i <
                          (timeList == "lunchTime"
                              ? LunchTimeList.length
                              : DinnerTimeList.length);
                      i++) {
                        String time = timeList == "lunchTime"
                            ? LunchTimeList[i]
                            : DinnerTimeList[i];
                        timeWidgets.add(
                          Card(
                            color: Colors.purple[200],
                            child: ListTile(
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    int indexToDelete =
                                        i; // Replace with the actual index you want to delete

// Get the reference to the document
                                    DocumentReference documentReference = Auth
                                        .shopManagerRef
                                        .doc(Auth.auth.currentUser!.uid)
                                        .collection('restaurant')
                                        .doc(Auth.auth.currentUser!.uid)
                                        .collection('details')
                                        .doc(Auth.auth.currentUser!.uid);

// Retrieve the current document
                                    DocumentSnapshot documentSnapshot =
                                    await documentReference.get();

// Check if the document exists
                                    if (documentSnapshot.exists) {
                                      // Get the current list from the document
                                      List<dynamic> currentList =
                                          documentSnapshot[timeList] ?? [];

                                      // Check if the index is valid
                                      if (indexToDelete >= 0 &&
                                          indexToDelete < currentList.length) {
                                        // Remove the element at the specified index
                                        currentList.removeAt(indexToDelete);
                                        print(currentList);
                                        // Update the document with the modified list
                                        await documentReference.update({
                                          timeList: currentList,
                                        });

                                        print(
                                            'Element at index $indexToDelete deleted successfully.');
                                        Utilities().showMessage(
                                            "Deleted Successfully");
                                      }
                                    }
                                  }),
                              title: Text(time),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Column(
                          children: timeWidgets,
                        ),
                      );
                    } else {
                      return Text("Sorry, no data available");
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
}