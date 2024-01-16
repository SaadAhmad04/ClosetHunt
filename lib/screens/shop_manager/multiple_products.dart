import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:mall/screens/shop_manager/checking_duplicate.dart';
import 'dart:convert';
import 'dart:io';

import '../../controller/auth.dart';

class MultipleProducts extends StatefulWidget {
  List<Map<String, dynamic>> excelData = [];

  MultipleProducts({super.key, required this.excelData});

  @override
  State<MultipleProducts> createState() => _MultipleProductsState();
}

var productIdsList = [];
Map<String, dynamic> map = {};
List a = [];

class _MultipleProductsState extends State<MultipleProducts> {
  List product = [];
  bool set = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var m in widget.excelData) {
      print('m = ${m}');
      m.forEach((key, value) {
        map[key] = value;
      });
      a.add(m);
    }
    for (int i = 0; i < a.length; i++) {
      productIdsList.add(a[i]['productId']);
    }
    print(productIdsList);
  }

  //List indexx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: widget.col==true ?Colors.red: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.excelData.length.toString()),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.excelData != null
                      ? "File Name: "
                      : "No file is selected",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: widget.excelData.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("LIST IS ${productIdsList}");

                    bool hasMatch = productIdsList
                        .contains(widget.excelData[index]['productId']);
                    print(hasMatch);
                    if (hasMatch) {
                      if (productIdsList
                          .indexOf(widget.excelData[index]['productId']) ==
                          index) {
                        hasMatch = false;
                      } else {
                        hasMatch = true;
                      }
                    }

                    print(widget.excelData[index]['productId']);
                    return Card(
                      color: hasMatch ? Colors.red : Colors.white,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.excelData[index].entries
                              .map(
                                (entry) => Text('${entry.key}: ${entry.value}'),
                          )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CheckDuplicates(excelData: widget.excelData),
              ));
          // StreamBuilder(
          //   stream: Auth.productRef.snapshots(),
          //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     print('======= ');
          //     for (int i = 0; i < snapshot.data!.docs.length; i++) {
          //       var a = snapshot.data!.docs[i].id;
          //       product.add(a);
          //     }
          //     return Center(child: CircularProgressIndicator());
          //   },
          // );
          // print(product);
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }
}