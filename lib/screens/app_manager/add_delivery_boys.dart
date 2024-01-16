import 'package:flutter/material.dart';
import 'package:mall/constant/widget/roundButton.dart';
import 'package:mall/screens/app_manager/app_manager_home.dart';

import '../../constant/utils/utilities.dart';
import '../../controller/auth.dart';
import '../../main.dart';

class AddDeliveryBoys extends StatefulWidget {
  const AddDeliveryBoys({super.key});

  @override
  State<AddDeliveryBoys> createState() => _AddDeliveryBoysState();
}

class _AddDeliveryBoysState extends State<AddDeliveryBoys> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Delivery Boy(s)"),
      ),
      body: StreamBuilder(
          stream: Auth.deliveryRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.docs.length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      print(index);
                      print("kjkhjkh");
                      print(snapshot.data?.docs[index]['id']);
                      print(snapshot.data?.docs.length);
                      int i = int.parse(snapshot.data?.docs[index]['id']) + 1;
                      id = i.toString();
                      print("the id is ${id}");
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text(snapshot.data!.docs[index]['name']),
                        subtitle: Text(snapshot.data!.docs[index]['phone']),
                        // trailing: IconButton(
                        //     icon: Icon(Icons.more_vert),
                        //     onPressed: () {
                        //       showDetailDialog(
                        //           context,
                        //           snapshot.data!.docs[index]['name'],
                        //           snapshot.data!.docs[index]['email'],
                        //           snapshot.data!.docs[index]['id'],
                        //           snapshot.data!.docs[index]['phone']);
                        //     }),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                                  title: Text('View Details'),
                                ))
                          ],
                        ),
                      );
                    });
              } else {
                return Center(
                  child: Text('No delivery boys !! Click "+" to add one'),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: Text('Error loading delivery boys'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addDeliveryBoy(context, id == null ? '1' : id!);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> addDeliveryBoy(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: mq.height * .8,
                width: mq.width,
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: id,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.numbers)),
                          ),
                          SizedBox(
                            height: mq.height * .05,
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                                hintText: "abc",
                                label: Text("Your Name"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                prefixIcon:
                                    Icon(Icons.drive_file_rename_outline)),
                          ),
                          SizedBox(
                            height: mq.height * .05,
                          ),
                          TextFormField(
                            controller: phController,
                            decoration: InputDecoration(
                                hintText: "+91 829 234 676",
                                label: Text("Ph. No."),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.phone)),
                          ),
                          SizedBox(
                            height: mq.height * .05,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                hintText: "abc@gmail.com",
                                label: Text("Email"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.email)),
                          ),
                          SizedBox(
                            height: mq.height * .05,
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                                label: Text("Password"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                prefixIcon: Icon(Icons.password)),
                          ),
                          SizedBox(
                            height: mq.height * .05,
                          ),
                          RoundButton(
                              title: "Submit",
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  Auth.deliveryAssign(
                                      nameController.text.toString(),
                                      phController.text.toString(),
                                      emailController.text.toString(),
                                      passwordController.text.toString(),
                                      id.toString(),
                                      context);
                                  setState(() {});
                                }
                              })
                        ],
                      )),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> showDetailDialog(
      BuildContext context, String name, String email, String id, String phno) {
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          'Details',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Text('Id :  ${id}'),
                      Text('Name :  ${name}'),
                      Text('Email : ${email}'),
                      Text('Ph. No. : ${phno}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Back',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.yellow.shade600),
                              )),
                          TextButton(
                              onPressed: () {
                                Auth.deliveryRef.doc(id).delete();
                                Navigator.pop(context);
                                Utilities().showMessage("Deleted!");
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(fontSize: 20),
                              )),
                        ],
                      ),
                    ],
                  )),
                );
              },
            ),
          );
        });
  }
}
