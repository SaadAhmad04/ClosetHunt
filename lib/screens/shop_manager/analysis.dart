import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;
import '../../controller/auth.dart';
import '../../main.dart';

class Analysis extends StatefulWidget {
  String? shopName;
  Analysis({Key? key, this.shopName}) : super(key: key);

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  List<Map<String, dynamic>> salesData = [];

  Future<void> fetchData() async {
    final querySnapshot = await Auth.shopManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('notifications')
        .get();
    salesData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Order Id',
      field: 'orderId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Mode',
      field: 'mode',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Status',
      field: 'status',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Date',
      field: 'date',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Product Id',
      field: 'productId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Product Name',
      field: 'productName',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Quantity',
      field: 'quantity',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Price',
      field: 'price',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Per item price',
      field: 'perItemPrice',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Phone',
      field: 'phone',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Email',
      field: 'email',
      type: PlutoColumnType.text(),
    ),
  ];

  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(
      title: 'Order details',
      fields: ['orderId', 'mode', 'status', 'date'],
    ),
    PlutoColumnGroup(
      title: 'Product information',
      fields: ['productId', 'productName', 'quantity', 'price', 'perItemPrice'],
    ),
    PlutoColumnGroup(
      title: 'Customer Information',
      fields: ['name', 'phone', 'email'],
    ),
  ];

  PlutoGridStateManager? stateManager;
  final List<PlutoRow> rows = [];
  int selectedTileIndex = 0;
  final List<String> tileTitles = [
    'Today',
    'This week',
    'Last 7 days',
    'This month',
    'Last 30 days',
    'All'
  ];

  void exportToPdf() async {
    final themeData = pluto_grid_export.ThemeData.withFont(
      base: pluto_grid_export.Font.ttf(
        await rootBundle
            .load('fonts/Open_Sans/OpenSans-Italic-VariableFont_wdth,wght.ttf'),
      ),
      bold: pluto_grid_export.Font.ttf(
        await rootBundle
            .load('fonts/Open_Sans/OpenSans-Italic-VariableFont_wdth,wght.ttf'),
      ),
    );

    var plutoGridPdfExport = pluto_grid_export.PlutoGridDefaultPdfExport(
      title: "${widget.shopName}",
      creator: "ClosetHunt!",
      format: pluto_grid_export.PdfPageFormat.a4.landscape,
      themeData: themeData,
    );

    await pluto_grid_export.Printing.sharePdf(
      bytes: await plutoGridPdfExport.export(stateManager!),
      filename: plutoGridPdfExport.getFilename(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: TextButton(
              child: Text(
                tileTitles[selectedTileIndex],
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                showBottomSheet(context);
              },
            ),
          ),
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              DateTime currentDate = DateTime.now();
              List<DateTime> weekDates = [
                for (int i = 0; i < 7; i++)
                  currentDate
                      .subtract(Duration(days: currentDate.weekday - 1))
                      .add(Duration(days: i)),
              ];

              List<DateTime> monthDates = [
                for (int i = 0; i < 31; i++)
                  DateTime(currentDate.year, currentDate.month, 1)
                      .add(Duration(days: i)),
              ];

              rows.clear();
              for (int i = salesData.length - 1; i >= 0; i--) {
                int ms = int.parse(salesData[i]['date']
                    .toString()
                    .substring(0, salesData[i]['date'].toString().length - 1));
                DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(ms);
                bool isInRange = false;
                switch (selectedTileIndex) {
                  case 0:
                    isInRange = currentDate.year == dateTime.year &&
                        currentDate.month == dateTime.month &&
                        currentDate.day == dateTime.day;
                    break;
                  case 1:
                    isInRange = weekDates.any((date) =>
                    date.year == dateTime.year &&
                        date.month == dateTime.month &&
                        date.day == dateTime.day);
                    break;
                  case 2:
                    isInRange = currentDate.difference(dateTime).inDays <= 6 &&
                        currentDate.difference(dateTime).inDays >= 0;
                    break;
                  case 3:
                    isInRange = monthDates.any((date) =>
                    date.year == dateTime.year &&
                        date.month == dateTime.month &&
                        date.day == dateTime.day);
                    break;
                  case 4:
                    isInRange = currentDate.difference(dateTime).inDays <= 29 &&
                        currentDate.difference(dateTime).inDays >= 0;
                    break;
                  default:
                    isInRange = true;
                }
                if (isInRange) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'orderId': PlutoCell(value: salesData[i]['date']),
                        'mode': PlutoCell(
                            value: salesData[i]['mode'] == 'homeDelivery'
                                ? 'Home Delivery'
                                : 'Pick from mall'),
                        'status': PlutoCell(
                            value: salesData[i]['cancelled'] == true
                                ? 'Cancelled'
                                : 'Paid'),
                        'date': PlutoCell(
                            value:
                                '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                        'productId':
                            PlutoCell(value: salesData[i]['productId']),
                        'productName':
                            PlutoCell(value: salesData[i]['productName']),
                        'quantity': PlutoCell(value: salesData[i]['quantity']),
                        'price': PlutoCell(value: salesData[i]['price']),
                        'perItemPrice':
                            PlutoCell(value: salesData[i]['perprice']),
                        'name': PlutoCell(value: salesData[i]['name']),
                        'phone': PlutoCell(value: salesData[i]['phone']),
                        'email': PlutoCell(value: salesData[i]['email']),
                      },
                    ),
                  );
                }
              }
              return Container(
                padding: const EdgeInsets.all(15),
                child: PlutoGrid(
                  columns: columns,
                  rows: rows,
                  columnGroups: columnGroups,
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    stateManager = event.stateManager;
                    stateManager!.setShowColumnFilter(true);
                  },
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                  },
                  configuration: const PlutoGridConfiguration(),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade200,
          elevation: 2,
          onPressed: () {
            exportToPdf();
          },
          child: Icon(
            Icons.picture_as_pdf,
            color: Colors.purple,
          ),
        ),
      ),
    );
  }

  Future<void> showBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: ListView.builder(
            itemCount: tileTitles.length,
            itemBuilder: (context, index) {
              return ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey)),
                title: Text(tileTitles[index]),
                tileColor:
                    index == selectedTileIndex ? Colors.blue.shade200 : null,
                onTap: () {
                  setState(() {
                    selectedTileIndex = index;
                    rows.clear();
                  });
                  Navigator.pop(context); // Close bottom sheet
                },
              );
            },
          ),
        );
      },
    );
  }
}
