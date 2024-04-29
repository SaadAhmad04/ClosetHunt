// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mall/constant/utils/utilities.dart';
// import 'package:mall/screens/shop_manager/restaurant/restro_upload.dart';
//
// import '../../../controller/auth.dart';
//
// class RestroDisplay extends StatefulWidget {
//   final type;
//
//   RestroDisplay({super.key, required this.type});
//
//   @override
//   State<RestroDisplay> createState() => _RestroDisplayState();
// }
//
// class _RestroDisplayState extends State<RestroDisplay> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Auth.shopManagerRef
//             .doc(Auth.auth.currentUser!.uid)
//             .collection('restaurant')
//             .doc(Auth.auth.currentUser!.uid)
//             .collection('details')
//             .doc(Auth.auth.currentUser!.uid)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             print("Got ${snapshot.data!.data()!['menuList'].length}");
//             return Scaffold(
//               appBar: AppBar(
//                 title: widget.type == "Menu"
//                     ? Text("Your Menu")
//                     : widget.type == "Offers"
//                     ? Text("Your Offers")
//                     : Text("Your Images"),
//               ),
//               body: widget.type == "Menu"
//                   ? snapshot.data!.data()!['menuList'].length > 0
//                   ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GridView.builder(
//                     gridDelegate:
//                     SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         mainAxisSpacing: 15,
//                         crossAxisSpacing: 15),
//                     itemCount:
//                     snapshot.data!.data()!['menuList'].length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {
//                           print(index);
//                           print(snapshot.data!.data()!['menuList']
//                           [index]);
//                           showDisplayImage(
//                               context,
//                               snapshot.data!.data()!['menuList']
//                               [index],
//                               'menuList',
//                               index,
//                               "Menu");
//                         },
//                         child: Container(
//                           child: Image.network(snapshot.data!
//                               .data()!['menuList'][index]),
//                         ),
//                       );
//                     }),
//               )
//                   : Center(child: Text("Menu not uploaded yet"))
//                   : widget.type == "Offers"
//                   ? snapshot.data!.data()!['offerList'].length > 0
//                   ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GridView.builder(
//                     gridDelegate:
//                     SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         mainAxisSpacing: 15,
//                         crossAxisSpacing: 15),
//                     itemCount: snapshot.data!
//                         .data()!['offerList']
//                         .length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {
//                           print(index);
//                           print(snapshot.data!
//                               .data()!['offerList'][index]);
//                           showDisplayImage(
//                               context,
//                               snapshot.data!.data()!['offerList']
//                               [index],
//                               'offerList',
//                               index,
//                               "Offers");
//                         },
//                         child: Container(
//                           child: Image.network(snapshot.data!
//                               .data()!['offerList'][index]),
//                         ),
//                       );
//                     }),
//               )
//                   : Center(child: Text("Offers not uploaded yet"))
//                   : snapshot.data!.data()!['imageList'].length > 0
//                   ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GridView.builder(
//                     gridDelegate:
//                     SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         mainAxisSpacing: 15,
//                         crossAxisSpacing: 15),
//                     itemCount: snapshot.data!
//                         .data()!['imageList']
//                         .length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: () {
//                           print(index);
//                           print(snapshot.data!
//                               .data()!['imageList'][index]);
//                           showDisplayImage(
//                               context,
//                               snapshot.data!.data()!['imageList']
//                               [index],
//                               'imageList',
//                               index,
//                               "Images");
//                         },
//                         child: Container(
//                           child: Image.network(snapshot.data!
//                               .data()!['imageList'][index]),
//                         ),
//                       );
//                     }),
//               )
//                   : Center(child: Text("Images not uploaded yet")),
//               floatingActionButton: FloatingActionButton(
//                 child: Icon(Icons.add),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => RestroUpload(
//                           type: widget.type.toString(),
//                         ),
//                       ));
//                 },
//               ),
//             );
//           } else {
//             return CircularProgressIndicator();
//           }
//         });
//   }
//
//   Future<void> showDisplayImage(BuildContext context, String imageUrl,
//       String Listtype, int index, String Screentype) {
//     //Size mq = MediaQuery.of(context).size;
//     return showDialog(
//         context: this.context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             content: StatefulBuilder(
//               builder: (context, setModalState) {
//                 return SingleChildScrollView(
//                   child: SizedBox(
//                       child: Column(
//                         children: [
//                           Container(
//                             child: Image.network(
//                               imageUrl,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           IconButton(
//                               onPressed: () {
//                                 showDeleteDialog(
//                                     context, imageUrl, Listtype, index, Screentype);
//                               },
//                               icon: Icon(Icons.delete))
//                         ],
//                       )),
//                 );
//               },
//             ),
//           );
//         });
//   }
//
//   Future<void> showDeleteDialog(BuildContext context, String imageUrl,
//       String Listtype, int index, String Screentype) {
//     //Size mq = MediaQuery.of(context).size;
//     return showDialog(
//         context: this.context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             content: StatefulBuilder(
//               builder: (context, setModalState) {
//                 return SingleChildScrollView(
//                   child: SizedBox(
//                       child: Column(
//                         children: [
//                           Text("Are You Sure you want To delete?"),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               TextButton(
//                                   onPressed: () async {
//                                     // Assuming index is the index you want to delete
//                                     int indexToDelete =
//                                         index; // Replace with the actual index you want to delete
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
//                                           documentSnapshot[Listtype] ?? [];
//
//                                       // Check if the index is valid
//                                       if (indexToDelete >= 0 &&
//                                           indexToDelete < currentList.length) {
//                                         // Remove the element at the specified index
//                                         currentList.removeAt(indexToDelete);
//                                         print(currentList);
//                                         // Update the document with the modified list
//                                         await documentReference.update({
//                                           Listtype: currentList,
//                                         });
//
//                                         print(
//                                             'Element at index $indexToDelete deleted successfully.');
//                                         Utilities()
//                                             .showMessage("Deleted Successfully");
//                                         Navigator.pop(context);
//                                         Navigator.pop(context);
//                                         Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   RestroDisplay(type: Screentype),
//                                             ));
//                                       } else {
//                                         print('Invalid index: $indexToDelete');
//                                       }
//                                     } else {
//                                       print('Document does not exist.');
//                                     }
//                                   },
//                                   child: Text('Yes')),
//                               TextButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text('No')),
//                             ],
//                           )
//                         ],
//                       )),
//                 );
//               },
//             ),
//           );
//         });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/screens/shop_manager/restaurant/restro_upload.dart';

import '../../../controller/auth.dart';

class RestroDisplay extends StatefulWidget {
  final type;

  RestroDisplay({super.key, required this.type});

  @override
  State<RestroDisplay> createState() => _RestroDisplayState();
}

class _RestroDisplayState extends State<RestroDisplay> {
  final spinkit = SpinKitDancingSquare(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.purple,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth.shopManagerRef
            .doc(Auth.auth.currentUser!.uid)
            .collection('restaurant')
            .doc(Auth.auth.currentUser!.uid)
            .collection('details')
            .doc(Auth.auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("Got ${snapshot.data!.data()!['menuList'].length}");
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.purple[100],
                elevation: 0,
                centerTitle: true,
                title: widget.type == "Menu"
                    ? Text(
                  "Your Menu",
                  style: TextStyle(color: Colors.white70),
                )
                    : widget.type == "Offers"
                    ? Text("Your Offers",
                    style: TextStyle(color: Colors.white70))
                    : Text("Your Images",
                    style: TextStyle(color: Colors.white70)),
              ),
              body: widget.type == "Menu"
                  ? snapshot.data!.data()!['menuList'].length > 0
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                    itemCount:
                    snapshot.data!.data()!['menuList'].length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print(index);
                          print(snapshot.data!.data()!['menuList']
                          [index]);
                          showDisplayImage(
                              context,
                              snapshot.data!.data()!['menuList']
                              [index],
                              'menuList',
                              index,
                              "Menu");
                        },
                        child: Container(
                          child: Image.network(snapshot.data!
                              .data()!['menuList'][index]),
                        ),
                      );
                    }),
              )
                  : Center(child: Text("Menu not uploaded yet"))
                  : widget.type == "Offers"
                  ? snapshot.data!.data()!['offerList'].length > 0
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                    itemCount: snapshot.data!
                        .data()!['offerList']
                        .length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print(index);
                          print(snapshot.data!
                              .data()!['offerList'][index]);
                          showDisplayImage(
                              context,
                              snapshot.data!.data()!['offerList']
                              [index],
                              'offerList',
                              index,
                              "Offers");
                        },
                        child: Container(
                          child: Image.network(snapshot.data!
                              .data()!['offerList'][index]),
                        ),
                      );
                    }),
              )
                  : Center(child: Text("Offers not uploaded yet"))
                  : snapshot.data!.data()!['imageList'].length > 0
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                    itemCount: snapshot.data!
                        .data()!['imageList']
                        .length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print(index);
                          print(snapshot.data!
                              .data()!['imageList'][index]);
                          showDisplayImage(
                              context,
                              snapshot.data!.data()!['imageList']
                              [index],
                              'imageList',
                              index,
                              "Images");
                        },
                        child: Container(
                          child: Image.network(snapshot.data!
                              .data()!['imageList'][index]),
                        ),
                      );
                    }),
              )
                  : Center(child: Text("Images not uploaded yet")),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.purple,
                child: Icon(
                  Icons.add,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestroUpload(
                          type: widget.type.toString(),
                        ),
                      ));
                },
              ),
            );
          } else {
            return Center(child: spinkit);
          }
        });
  }

  Future<void> showDisplayImage(BuildContext context, String imageUrl,
      String Listtype, int index, String Screentype) {
    //Size mq = MediaQuery.of(context).size;
    return showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: SizedBox(
                      child: Column(
                        children: [
                          Container(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showDeleteDialog(
                                    context, imageUrl, Listtype, index, Screentype);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      )),
                );
              },
            ),
          );
        });
  }

  Future<void> showDeleteDialog(BuildContext context, String imageUrl,
      String Listtype, int index, String Screentype) {
    //Size mq = MediaQuery.of(context).size;
    return showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  child: SizedBox(
                      child: Column(
                        children: [
                          Text("Are You Sure you want To delete?"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    // Assuming index is the index you want to delete
                                    int indexToDelete =
                                        index; // Replace with the actual index you want to delete

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
                                          documentSnapshot[Listtype] ?? [];

                                      // Check if the index is valid
                                      if (indexToDelete >= 0 &&
                                          indexToDelete < currentList.length) {
                                        // Remove the element at the specified index
                                        currentList.removeAt(indexToDelete);
                                        print(currentList);
                                        // Update the document with the modified list
                                        await documentReference.update({
                                          Listtype: currentList,
                                        });

                                        print(
                                            'Element at index $indexToDelete deleted successfully.');
                                        Utilities()
                                            .showMessage("Deleted Successfully");
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RestroDisplay(type: Screentype),
                                            ));
                                      } else {
                                        print('Invalid index: $indexToDelete');
                                      }
                                    } else {
                                      print('Document does not exist.');
                                    }
                                  },
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.red),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.purple),
                                  )),
                            ],
                          )
                        ],
                      )),
                );
              },
            ),
          );
        });
  }
}