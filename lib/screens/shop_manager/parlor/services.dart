// import 'package:flutter/material.dart';
// import 'package:mall/constant/utils/utilities.dart';
// import 'package:mall/constant/widget/roundButton.dart';
//
// import '../../../controller/auth.dart';
//
// class Services extends StatefulWidget {
//   const Services({super.key});
//
//   @override
//   State<Services> createState() => _ServicesState();
// }
//
// class _ServicesState extends State<Services> {
//   Set id = {};
//   List idi = [];
//   int max = 0;
//   final priceController = TextEditingController();
//   Stream? stream;
//   final searchController = TextEditingController();
//   List<Servicess> services = [
//     Servicess('Haircuts', '1'),
//     Servicess('Hair Styling', '2'),
//     Servicess('Hair coloring', '3'),
//     Servicess('Highlights and lowlights', '4'),
//     Servicess('Hair extensions', '5'),
//     Servicess('Perms and relaxers', '6'),
//     Servicess('Keratin treatments', '7'),
//     Servicess('Manicures', '8'),
//     Servicess('Pedicures', '9'),
//     Servicess('Gel polish application', '10'),
//     Servicess('Nail extensions (acrylic, gel, or fiberglass)', '11'),
//     Servicess('Nail art and designs', '12'),
//     Servicess('Nail repairs', '13'),
//     Servicess('Facials', '14'),
//     Servicess('Cleansing and exfoliation', '15'),
//     Servicess('Chemical peels', '16'),
//     Servicess('Microdermabrasion', '17'),
//     Servicess('Acne treatment', '18'),
//     Servicess('Anti-aging treatments', '19'),
//     Servicess('Bridal makeup', '20'),
//     Servicess('Special occasion makeup', '21'),
//     Servicess('Everyday makeup application', '22'),
//     Servicess('Makeup consultations', '23'),
//     Servicess('Airbrush makeup', '24'),
//     Servicess('Waxing (eyebrows, lip, chin, legs, bikini, etc.)', '25'),
//     Servicess('Threading', '26'),
//     Servicess('Sugaring', '27'),
//     Servicess('Laser hair removal', '28'),
//     Servicess('Eyebrow shaping', '29'),
//     Servicess('Eyelash extensions', '30'),
//     Servicess('Eyebrow and eyelash tinting', '31'),
//     Servicess('Lash lift and perm', '32'),
//     Servicess('Spray tanning', '33'),
//     Servicess('Tanning bed sessions', '34'),
//     Servicess('Permanent makeup (micropigmentation)', '35'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.pink[200],
//           title: Text('Services'),
//           actions: [
//             IconButton(
//                 onPressed: () async {
//                   for (int i = 0; i < services.length; i++) {
//                     if (services[i].isChecked && !id.contains(services[i].id)) {
//                       print("${services[i].ServiceName}");
//                       await Auth.shopManagerRef
//                           .doc(Auth.auth.currentUser!.uid)
//                           .collection('parlor')
//                           .doc(Auth.auth.currentUser!.uid)
//                           .collection('services')
//                           .doc(services[i].id)
//                           .set({
//                         'serviceName': services[i].ServiceName,
//                         'serviceId': services[i].id,
//                         'servicePrice': ""
//                       });
//                     }
//                   }
//                   Utilities().showMessage("Services Added");
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Services(),
//                       ));
//                   setState(() {});
//                 },
//                 icon: Icon(Icons.check)),
//           ],
//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(100.0),
//             // Adjust the height as needed
//             child: Column(
//               children: [
//                 TabBar(tabs: [
//                   Tab(icon: Icon(Icons.remove_red_eye)),
//                   Tab(icon: Icon(Icons.add)),
//                 ]),
//                 Padding(
//                   padding: EdgeInsets.all(5.0),
//                   child: TextField(
//                     controller: searchController,
//                     onChanged: (String value) {
//                       setState(() {});
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search services...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             Container(
//               child: StreamBuilder(
//                   stream: Auth.shopManagerRef
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('parlor')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('services')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData && snapshot.data != null) {
//                       return ListView.builder(
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             String namee =
//                             snapshot.data!.docs[index]['serviceName'];
//                             for (int i = 0;
//                             i < snapshot.data!.docs.length;
//                             i++) {
//                               idi.add(snapshot.data!.docs[i]['serviceId']);
//                             }
//                             String price =
//                             snapshot.data!.docs[index]['servicePrice'];
//                             print('Price = ${price}');
//                             return searchController.text.isEmpty
//                                 ? Card(
//                               child: ListTile(
//                                 trailing: PopupMenuButton<String>(
//                                   onSelected: (value) {
//                                     print('Selected: $value');
//                                   },
//                                   itemBuilder: (BuildContext context) {
//                                     return [
//                                       PopupMenuItem<String>(
//                                         onTap: () {
//                                           showTypeDialog(
//                                               context, index, idi[index]);
//                                         },
//                                         child: Text('Update Price'),
//                                       ),
//                                       PopupMenuItem<String>(
//                                         onTap: () async {
//                                           await Auth.shopManagerRef
//                                               .doc(Auth
//                                               .auth.currentUser!.uid)
//                                               .collection('parlor')
//                                               .doc(Auth
//                                               .auth.currentUser!.uid)
//                                               .collection('services')
//                                               .doc(snapshot
//                                               .data!.docs[index]
//                                           ['serviceId'])
//                                               .delete();
//                                           Utilities().showMessage(
//                                               "Service Deleted");
//                                           Navigator.pushReplacement(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     Services(),
//                                               ));
//                                         },
//                                         child: Text('Delete'),
//                                       ),
//                                     ];
//                                   },
//                                 ),
//                                 visualDensity: VisualDensity(vertical: 4),
//                                 title: Text(
//                                     "Service name: ${snapshot.data!.docs[index]['serviceName']}"),
//                                 subtitle: Text(
//                                     "Service id: ${snapshot.data!.docs[index]['serviceId']}\nService Price : ${price} (in Rs)"),
//                               ),
//                             )
//                                 : namee.toLowerCase().contains(searchController
//                                 .text
//                                 .toLowerCase()
//                                 .toString())
//                                 ? Card(
//                                 child: ListTile(
//                                     trailing: IconButton(
//                                       icon: Icon(Icons.more_vert),
//                                       onPressed: () {
//                                         showTypeDialog(
//                                             context, index, idi[index]);
//                                       },
//                                     ),
//                                     title: Text(
//                                         "Service name: ${snapshot.data!.docs[index]['serviceName']}"),
//                                     subtitle: Text(
//                                         "Service id: ${snapshot.data!.docs[index]['serviceId']}")))
//                                 : SizedBox();
//                           });
//                     } else if (snapshot.connectionState ==
//                         ConnectionState.waiting &&
//                         snapshot.data != null) {
//                       print('-----------------------------');
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else {
//                       print('0000000000000000000000000');
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("No Services Available!!"),
//                         ],
//                       );
//                     }
//                   }),
//             ),
//             Container(
//                 child: StreamBuilder(
//                   stream: Auth.shopManagerRef
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('parlor')
//                       .doc(Auth.auth.currentUser!.uid)
//                       .collection('services')
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       print(snapshot.data!.docs.length);
//                       return ListView.builder(
//                         itemCount: services.length,
//                         shrinkWrap: true,
//                         itemBuilder: (BuildContext context, int index) {
//                           for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                             if (snapshot.data!.docs[i]['serviceName'] ==
//                                 services[index].ServiceName) {
//                               services[index].isChecked = true;
//                               id.add(services[index].id);
//                             }
//                           }
//                           print("as;dkfhasjfhjashfjlhf $id");
//                           return searchController.text.isEmpty
//                               ? id.contains(services[index].id)
//                               ? SizedBox()
//                               : CheckboxListTile(
//                               title: Text(services[index].ServiceName),
//                               value: services[index].isChecked,
//                               checkboxShape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               checkColor: Colors.blue,
//                               activeColor: Colors.white,
//                               onChanged: (bool? val) async {
//                                 services[index].isChecked = val!;
//                                 setState(() {});
//                               })
//                               : services[index].ServiceName.toLowerCase().contains(
//                               searchController.text
//                                   .toLowerCase()
//                                   .toString())
//                               ? CheckboxListTile(
//                               checkboxShape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               checkColor: Colors.blue,
//                               activeColor: Colors.white,
//                               title: Text(services[index].ServiceName),
//                               value: services[index].isChecked,
//                               onChanged: (bool? val) {
//                                 setState(() {
//                                   services[index].isChecked = val!;
//                                 });
//                               })
//                               : SizedBox();
//                         },
//                       );
//                     } else {
//                       return ListView.builder(
//                         itemCount: services.length,
//                         shrinkWrap: true,
//                         itemBuilder: (BuildContext context, int index) {
//                           return searchController.text.isEmpty
//                               ? CheckboxListTile(
//                               title: Text(services[index].ServiceName),
//                               value: services[index].isChecked,
//                               onChanged: (bool? val) {
//                                 setState(() async {
//                                   services[index].isChecked = val!;
//                                 });
//                               })
//                               : services[index].ServiceName.toLowerCase().contains(
//                               searchController.text
//                                   .toLowerCase()
//                                   .toString())
//                               ? CheckboxListTile(
//                               title: Text(services[index].ServiceName),
//                               value: services[index].isChecked,
//                               onChanged: (bool? val) {
//                                 setState(() async {
//                                   services[index].isChecked = val!;
//                                 });
//                               })
//                               : SizedBox();
//                         },
//                       );
//                     }
//                   },
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> showTypeDialog(BuildContext context, int index, String ids) {
//     setState(() {});
//     Size mq = MediaQuery.of(context).size;
//     DateTime? dateTime;
//     return showDialog(
//         context: this.context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               content: StatefulBuilder(builder: (context, setModalState) {
//                 return SizedBox(
//                   height: mq.height / 4.5,
//                   width: mq.width - 50,
//                   child: Column(
//                     children: [
//                       Text('${ids.toString()}'),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                           ),
//                           width: 300,
//                           height: 40,
//                           child: Center(
//                               child: TextField(
//                                 controller: priceController,
//                                 keyboardType: TextInputType.number,
//                                 decoration:
//                                 InputDecoration(hintText: 'Enter Price'),
//                               ))),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: RoundButton(
//                           title: 'Click',
//                           onTap: () async {
//                             if (priceController.text.isNotEmpty) {
//                               await Auth.shopManagerRef
//                                   .doc(Auth.auth.currentUser!.uid)
//                                   .collection('parlor')
//                                   .doc(Auth.auth.currentUser!.uid)
//                                   .collection('services')
//                                   .doc(ids.toString())
//                                   .update({
//                                 'servicePrice': priceController.text.toString()
//                               });
//                             }
//                             priceController.text = "";
//                             Navigator.pop(context);
//                             setState(() {});
//                           },
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               }));
//         });
//   }
// }
//
// class Servicess {
//   final String ServiceName;
//   final String id;
//   bool isChecked;
//
//   Servicess(this.ServiceName, this.id, {this.isChecked = false});
// }

import 'package:flutter/material.dart';
import 'package:mall/constant/utils/utilities.dart';
import 'package:mall/constant/widget/roundButton.dart';

import '../../../controller/auth.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  Set id = {};
  List idi = [];
  int max = 0;
  final priceController = TextEditingController();
  Stream? stream;
  final searchController = TextEditingController();
  List<Servicess> services = [
    Servicess('Haircuts', '1'),
    Servicess('Hair Styling', '2'),
    Servicess('Hair coloring', '3'),
    Servicess('Highlights and lowlights', '4'),
    Servicess('Hair extensions', '5'),
    Servicess('Perms and relaxers', '6'),
    Servicess('Keratin treatments', '7'),
    Servicess('Manicures', '8'),
    Servicess('Pedicures', '9'),
    Servicess('Gel polish application', '10'),
    Servicess('Nail extensions (acrylic, gel, or fiberglass)', '11'),
    Servicess('Nail art and designs', '12'),
    Servicess('Nail repairs', '13'),
    Servicess('Facials', '14'),
    Servicess('Cleansing and exfoliation', '15'),
    Servicess('Chemical peels', '16'),
    Servicess('Microdermabrasion', '17'),
    Servicess('Acne treatment', '18'),
    Servicess('Anti-aging treatments', '19'),
    Servicess('Bridal makeup', '20'),
    Servicess('Special occasion makeup', '21'),
    Servicess('Everyday makeup application', '22'),
    Servicess('Makeup consultations', '23'),
    Servicess('Airbrush makeup', '24'),
    Servicess('Waxing (eyebrows, lip, chin, legs, bikini, etc.)', '25'),
    Servicess('Threading', '26'),
    Servicess('Sugaring', '27'),
    Servicess('Laser hair removal', '28'),
    Servicess('Eyebrow shaping', '29'),
    Servicess('Eyelash extensions', '30'),
    Servicess('Eyebrow and eyelash tinting', '31'),
    Servicess('Lash lift and perm', '32'),
    Servicess('Spray tanning', '33'),
    Servicess('Tanning bed sessions', '34'),
    Servicess('Permanent makeup (micropigmentation)', '35'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[50],
          title: Text('Services'),
          actions: [
            IconButton(
                onPressed: () async {
                  for (int i = 0; i < services.length; i++) {
                    if (services[i].isChecked && !id.contains(services[i].id)) {
                      print("${services[i].ServiceName}");
                      await Auth.shopManagerRef
                          .doc(Auth.auth.currentUser!.uid)
                          .collection('parlor')
                          .doc(Auth.auth.currentUser!.uid)
                          .collection('services')
                          .doc(services[i].id)
                          .set({
                        'serviceName': services[i].ServiceName,
                        'serviceId': services[i].id,
                        'servicePrice': ""
                      });
                    }
                  }
                  Utilities().showMessage("Services Added");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Services(),
                      ));
                  setState(() {});
                },
                icon: Icon(Icons.check)),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            // Adjust the height as needed
            child: Column(
              children: [
                TabBar(
                    indicatorColor: Colors.purple,
                    //dividerColor: Colors.purple,
                    tabs: [
                      Tab(
                        child: Image.asset('images/eyes.gif'),
                      ),
                      Tab(
                        child: Image.asset('images/add.gif'),
                      ),
                    ]),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextField(
                    cursorColor: Colors.purple,
                    controller: searchController,
                    onChanged: (String value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      enabled: true,
                      hoverColor: Colors.purple,
                      focusColor: Colors.purple,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                      prefixIconColor: Colors.purple,
                      contentPadding:
                      EdgeInsets.only(top: -15, left: 5, right: 1),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Search services...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder(
                  stream: Auth.shopManagerRef
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('parlor')
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('services')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            String namee =
                            snapshot.data!.docs[index]['serviceName'];
                            for (int i = 0;
                            i < snapshot.data!.docs.length;
                            i++) {
                              idi.add(snapshot.data!.docs[i]['serviceId']);
                            }
                            String price =
                            snapshot.data!.docs[index]['servicePrice'];
                            print('Price = ${price}');
                            return searchController.text.isEmpty
                                ? Card(
                              elevation: 10,
                              shadowColor: Colors.black,
                              color: Colors.white60,
                              child: ListTile(
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    print('Selected: $value');
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        onTap: () {
                                          showTypeDialog(
                                              context, index, idi[index]);
                                        },
                                        child: Text('Update Price'),
                                      ),
                                      PopupMenuItem<String>(
                                        onTap: () async {
                                          await Auth.shopManagerRef
                                              .doc(Auth
                                              .auth.currentUser!.uid)
                                              .collection('parlor')
                                              .doc(Auth
                                              .auth.currentUser!.uid)
                                              .collection('services')
                                              .doc(snapshot
                                              .data!.docs[index]
                                          ['serviceId'])
                                              .delete();
                                          Utilities().showMessage(
                                              "Service Deleted");
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Services(),
                                              ));
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ];
                                  },
                                ),
                                visualDensity: VisualDensity(vertical: 4),
                                title: Text(
                                    "Service name: ${snapshot.data!.docs[index]['serviceName']}"),
                                subtitle: Text(
                                    "Service id: ${snapshot.data!.docs[index]['serviceId']}\nService Price : ${price} (in Rs)"),
                              ),
                            )
                                : namee.toLowerCase().contains(searchController
                                .text
                                .toLowerCase()
                                .toString())
                                ? Card(
                                child: ListTile(
                                    trailing: IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        showTypeDialog(
                                            context, index, idi[index]);
                                      },
                                    ),
                                    title: Text(
                                        "Service name: ${snapshot.data!.docs[index]['serviceName']}"),
                                    subtitle: Text(
                                        "Service id: ${snapshot.data!.docs[index]['serviceId']}")))
                                : SizedBox();
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting &&
                        snapshot.data != null) {
                      print('-----------------------------');
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      print('0000000000000000000000000');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Services Available!!"),
                        ],
                      );
                    }
                  }),
            ),
            Container(
                child: StreamBuilder(
                  stream: Auth.shopManagerRef
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('parlor')
                      .doc(Auth.auth.currentUser!.uid)
                      .collection('services')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data!.docs.length);
                      return ListView.builder(
                        itemCount: services.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            if (snapshot.data!.docs[i]['serviceName'] ==
                                services[index].ServiceName) {
                              services[index].isChecked = true;
                              id.add(services[index].id);
                            }
                          }
                          print("as;dkfhasjfhjashfjlhf $id");
                          return searchController.text.isEmpty
                              ? id.contains(services[index].id)
                              ? SizedBox()
                              : CheckboxListTile(
                              title: Text(services[index].ServiceName),
                              value: services[index].isChecked,
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              checkColor: Colors.blue,
                              activeColor: Colors.white,
                              onChanged: (bool? val) async {
                                services[index].isChecked = val!;
                                setState(() {});
                              })
                              : services[index].ServiceName.toLowerCase().contains(
                              searchController.text
                                  .toLowerCase()
                                  .toString())
                              ? CheckboxListTile(
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              checkColor: Colors.blue,
                              activeColor: Colors.white,
                              title: Text(services[index].ServiceName),
                              value: services[index].isChecked,
                              onChanged: (bool? val) {
                                setState(() {
                                  services[index].isChecked = val!;
                                });
                              })
                              : SizedBox();
                        },
                      );
                    } else {
                      return ListView.builder(
                        itemCount: services.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return searchController.text.isEmpty
                              ? CheckboxListTile(
                              title: Text(services[index].ServiceName),
                              value: services[index].isChecked,
                              onChanged: (bool? val) {
                                setState(() async {
                                  services[index].isChecked = val!;
                                });
                              })
                              : services[index].ServiceName.toLowerCase().contains(
                              searchController.text
                                  .toLowerCase()
                                  .toString())
                              ? CheckboxListTile(
                              title: Text(services[index].ServiceName),
                              value: services[index].isChecked,
                              onChanged: (bool? val) {
                                setState(() async {
                                  services[index].isChecked = val!;
                                });
                              })
                              : SizedBox();
                        },
                      );
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  Future<void> showTypeDialog(BuildContext context, int index, String ids) {
    setState(() {});
    Size mq = MediaQuery.of(context).size;
    DateTime? dateTime;
    return showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: StatefulBuilder(builder: (context, setModalState) {
                return SizedBox(
                  height: mq.height / 4.1,
                  width: mq.width - 50,
                  child: Column(
                    children: [
                      Text('${ids.toString()}'),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          width: 300,
                          height: 40,
                          child: Center(
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                decoration:
                                InputDecoration(hintText: 'Enter Price'),
                              ))),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RoundButton(
                          title: 'Click',
                          onTap: () async {
                            if (priceController.text.isNotEmpty) {
                              await Auth.shopManagerRef
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('parlor')
                                  .doc(Auth.auth.currentUser!.uid)
                                  .collection('services')
                                  .doc(ids.toString())
                                  .update({
                                'servicePrice': priceController.text.toString()
                              });
                            }
                            priceController.text = "";
                            Navigator.pop(context);
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                );
              }));
        });
  }
}

class Servicess {
  final String ServiceName;
  final String id;
  bool isChecked;

  Servicess(this.ServiceName, this.id, {this.isChecked = false});
}
