import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;
import '../../controller/auth.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  QuerySnapshot? querySnapshot;
  List<Map<String, dynamic>> salesData = [];
  List<Map<String, dynamic>> bookingData = [];
  List<Map<String, dynamic>> parlorData = [];
  List<Map<String, dynamic>> restroData = [];
  List<Map<String, dynamic>> paymentData = [];

  Future<void> fetchShoppingData() async {
    final querySnapshot = await Auth.appManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('notifications')
        .doc(Auth.auth.currentUser!.uid)
        .collection('shopping')
        .get();
    salesData = await Future.wait(querySnapshot.docs.map((doc) async {
      final subCollectionSnapshot =
          await doc.reference.collection('products').get();
      final subCollectionData = subCollectionSnapshot.docs
          .map((subDoc) => subDoc.data() as Map<String, dynamic>)
          .toList();
      return {
        'shoppingData': doc.data() as Map<String, dynamic>,
        'productsData': subCollectionData,
      };
    }).toList());
  }

  Future<void> fetchBookingData() async {
    final querySnapshot = await Auth.appManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('notifications')
        .doc(Auth.auth.currentUser!.uid)
        .collection('booking')
        .orderBy('bookingId', descending: true)
        .get();

    bookingData = querySnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data();
      return data;
    }).toList();
  }

  Future<void> fetchPaymentData() async {
    final querySnapshot = await Auth.appManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('notifications')
        .doc(Auth.auth.currentUser!.uid)
        .collection('payments')
        .orderBy('paymentId', descending: true)
        .get();

    paymentData = querySnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data();
      return data;
    }).toList();
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Order Id',
      field: 'orderId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Product Id',
      field: 'productId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Seller Id',
      field: 'sellerId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Amount',
      field: 'amount',
      type: PlutoColumnType.number(),
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
      title: 'Delivery Boy',
      field: 'deliveryBoy',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Delivered',
      field: 'delivered',
      type: PlutoColumnType.text(),
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
      fields: ['orderId', 'productId', 'sellerId', 'amount'],
    ),
    PlutoColumnGroup(
      title: 'Delivery Details',
      fields: ['mode', 'status', 'date', 'deliveryBoy', 'delivered'],
    ),
    PlutoColumnGroup(
      title: 'Customer Information',
      fields: ['name', 'phone', 'email'],
    ),
  ];

  final List<PlutoColumn> columns1 = <PlutoColumn>[
    PlutoColumn(
      title: 'Booking Id',
      field: 'bookingId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Booking Date',
      field: 'bookingDate',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Time',
      field: 'time',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Service Date',
      field: 'date',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Status',
      field: 'status',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Service Id',
      field: 'serviceId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Service Name',
      field: 'serviceName',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Service Price',
      field: 'servicePrice',
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
  final List<PlutoColumnGroup> columnGroups1 = [
    PlutoColumnGroup(
      title: 'Booking details',
      fields: ['bookingId', 'bookingDate', 'time', 'date', 'status'],
    ),
    PlutoColumnGroup(
      title: 'Service details',
      fields: ['serviceId', 'serviceName', 'servicePrice'],
    ),
    PlutoColumnGroup(
      title: 'Customer Information',
      fields: ['name', 'phone', 'email'],
    ),
  ];

  final List<PlutoColumn> columns2 = <PlutoColumn>[
    PlutoColumn(
      title: 'Booking Id',
      field: 'bookingId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Booking Date',
      field: 'bookingDate',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Time',
      field: 'time',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Date',
      field: 'date',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Status',
      field: 'status',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Slot Type',
      field: 'slotType',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Guests',
      field: 'guests',
      type: PlutoColumnType.text(),
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
  final List<PlutoColumnGroup> columnGroups2 = [
    PlutoColumnGroup(
      title: 'Booking details',
      fields: [
        'bookingId',
        'bookingDate',
        'time',
        'date',
        'status',
        'slotType',
        'guests'
      ],
    ),
    PlutoColumnGroup(
      title: 'Customer Information',
      fields: ['name', 'phone', 'email'],
    ),
  ];

  final List<PlutoColumn> columns3 = <PlutoColumn>[
    PlutoColumn(
      title: 'Payment Id',
      field: 'paymentId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Amount',
      field: 'amount',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Date',
      field: 'date',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Shop Id',
      field: 'shopId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Shop Name',
      field: 'shopName',
      type: PlutoColumnType.text(),
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
  final List<PlutoColumnGroup> columnGroups3 = [
    PlutoColumnGroup(
      title: 'Payment details',
      fields: [
        'paymentId',
        'amount',
        'date',
      ],
    ),
    PlutoColumnGroup(
      title: 'Shop details',
      fields: ['shopId', 'shopName'],
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
      title: "ClosetHunt",
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Color(0xff1D1F33),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: TextButton(
              child: Text(
                tileTitles[selectedTileIndex],
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showBottomSheet(context);
              },
            ),
          ),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shop),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.book_outlined),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.food_bank),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.currency_rupee),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: fetchShoppingData(),
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
                    List<Map<String, dynamic>> productsData =
                        salesData[i]['productsData'];
                    for (int j = 0; j < productsData.length; j++) {
                      int ms =
                          int.parse(salesData[i]['shoppingData']['orderId']);
                      DateTime dateTime =
                          DateTime.fromMillisecondsSinceEpoch(ms);
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
                          isInRange =
                              currentDate.difference(dateTime).inDays <= 6 &&
                                  currentDate.difference(dateTime).inDays >= 0;
                          break;
                        case 3:
                          isInRange = monthDates.any((date) =>
                              date.year == dateTime.year &&
                              date.month == dateTime.month &&
                              date.day == dateTime.day);
                          break;
                        case 4:
                          isInRange =
                              currentDate.difference(dateTime).inDays <= 29 &&
                                  currentDate.difference(dateTime).inDays >= 0;
                          break;
                        default:
                          isInRange = true;
                      }
                      if (isInRange) {
                        rows.add(
                          PlutoRow(
                            cells: {
                              'orderId':
                                  PlutoCell(value: productsData[j]['orderId']),
                              'productId': PlutoCell(
                                  value: productsData[j]['productId']),
                              'sellerId':
                                  PlutoCell(value: productsData[j]['sellerId']),
                              'amount':
                                  PlutoCell(value: productsData[j]['amount']),
                              'mode': PlutoCell(
                                  value:
                                      productsData[j]['mode'] == 'homeDelivery'
                                          ? 'Home Delivery'
                                          : 'Pick from mall'),
                              'status': PlutoCell(
                                  value: productsData[j]['cancelled'] == true
                                      ? 'Cancelled'
                                      : productsData[j]['delivered'] == true
                                          ? 'Delivered'
                                          : 'Yet to deliver'),
                              'date': PlutoCell(
                                  value:
                                      '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                              'deliveryBoy': PlutoCell(
                                  value: productsData[j]['deliveryBoyId'] ??
                                      'Not assigned'),
                              'delivered': PlutoCell(
                                  value: productsData[j]['delivered']),
                              'name': PlutoCell(value: productsData[j]['name']),
                              'phone':
                                  PlutoCell(value: productsData[j]['phone']),
                              'email':
                                  PlutoCell(value: productsData[j]['email']),
                            },
                          ),
                        );
                      }
                    }
                  }
                  return Container(
                    padding: const EdgeInsets.all(25),
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
            FutureBuilder(
              future: fetchBookingData(),
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
                  parlorData.clear();
                  for (int i = 0; i < bookingData.length; i++) {
                    if (bookingData[i]['serviceId'] != null) {
                      parlorData.add(bookingData[i]);
                    }
                  }
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
                  for (int i = parlorData.length - 1; i >= 0; i--) {
                    int ms = int.parse(parlorData[i]['bookingId']);
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
                        isInRange =
                            currentDate.difference(dateTime).inDays <= 6 &&
                                currentDate.difference(dateTime).inDays >= 0;
                        break;
                      case 3:
                        isInRange = monthDates.any((date) =>
                            date.year == dateTime.year &&
                            date.month == dateTime.month &&
                            date.day == dateTime.day);
                        break;
                      case 4:
                        isInRange =
                            currentDate.difference(dateTime).inDays <= 29 &&
                                currentDate.difference(dateTime).inDays >= 0;
                        break;
                      default:
                        isInRange = true;
                    }
                    if (isInRange) {
                      rows.add(
                        PlutoRow(
                          cells: {
                            'bookingId':
                                PlutoCell(value: parlorData[i]['bookingId']),
                            'bookingDate': PlutoCell(
                                value:
                                    '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                            'time': PlutoCell(
                                value: parlorData[i]['time']
                                    .toString()
                                    .substring(
                                        0,
                                        parlorData[i]['time']
                                                .toString()
                                                .length -
                                            2)),
                            'date': PlutoCell(
                                value:
                                    '${DateTime.parse(parlorData[i]['date']).day}-${DateTime.parse(parlorData[i]['date']).month}-${DateTime.parse(parlorData[i]['date']).year}'),
                            'status': PlutoCell(
                                value:
                                    '${parlorData[i]['serviceId'] == 'cancelled' ? "Cancelled" : "Appointment"} '),
                            'serviceId':
                                PlutoCell(value: parlorData[i]['serviceId']),
                            'serviceName':
                                PlutoCell(value: parlorData[i]['serviceName']),
                            'servicePrice':
                                PlutoCell(value: parlorData[i]['servicePrice']),
                            'name': PlutoCell(value: parlorData[i]['name']),
                            'phone': PlutoCell(value: parlorData[i]['phone']),
                            'email': PlutoCell(value: parlorData[i]['email']),
                          },
                        ),
                      );
                    }
                  }
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: PlutoGrid(
                      columns: columns1,
                      rows: rows,
                      columnGroups: columnGroups1,
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
            FutureBuilder(
              future: fetchBookingData(),
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
                  restroData.clear();
                  for (int i = 0; i < bookingData.length; i++) {
                    if (bookingData[i]['guests'] != null) {
                      restroData.add(bookingData[i]);
                    }
                  }
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
                  for (int i = restroData.length - 1; i >= 0; i--) {
                    int ms = int.parse(restroData[i]['bookingId']);
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
                        isInRange =
                            currentDate.difference(dateTime).inDays <= 6 &&
                                currentDate.difference(dateTime).inDays >= 0;
                        break;
                      case 3:
                        isInRange = monthDates.any((date) =>
                            date.year == dateTime.year &&
                            date.month == dateTime.month &&
                            date.day == dateTime.day);
                        break;
                      case 4:
                        isInRange =
                            currentDate.difference(dateTime).inDays <= 29 &&
                                currentDate.difference(dateTime).inDays >= 0;
                        break;
                      default:
                        isInRange = true;
                    }
                    if (isInRange) {
                      rows.add(
                        PlutoRow(
                          cells: {
                            'bookingId':
                                PlutoCell(value: restroData[i]['bookingId']),
                            'bookingDate': PlutoCell(
                                value:
                                    '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                            'time': PlutoCell(value: restroData[i]['time']),
                            'date': PlutoCell(
                                value:
                                    '${DateTime.parse(restroData[i]['date']).day}-${DateTime.parse(restroData[i]['date']).month}-${DateTime.parse(restroData[i]['date']).year}'),
                            'status': PlutoCell(
                                value:
                                    '${restroData[i]['serviceId'] == 'cancelled' ? "Cancelled" : "Booked"} '),
                            'slotType':
                                PlutoCell(value: restroData[i]['slotType']),
                            'guests': PlutoCell(value: restroData[i]['guests']),
                            'name': PlutoCell(value: restroData[i]['name']),
                            'phone': PlutoCell(value: restroData[i]['phone']),
                            'email': PlutoCell(value: restroData[i]['email']),
                          },
                        ),
                      );
                    }
                  }
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: PlutoGrid(
                      columns: columns2,
                      rows: rows,
                      columnGroups: columnGroups2,
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
            FutureBuilder(
              future: fetchPaymentData(),
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
                  for (int i = restroData.length - 1; i >= 0; i--) {
                    int ms = int.parse(paymentData[i]['paymentId']);
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
                        isInRange =
                            currentDate.difference(dateTime).inDays <= 6 &&
                                currentDate.difference(dateTime).inDays >= 0;
                        break;
                      case 3:
                        isInRange = monthDates.any((date) =>
                            date.year == dateTime.year &&
                            date.month == dateTime.month &&
                            date.day == dateTime.day);
                        break;
                      case 4:
                        isInRange =
                            currentDate.difference(dateTime).inDays <= 29 &&
                                currentDate.difference(dateTime).inDays >= 0;
                        break;
                      default:
                        isInRange = true;
                    }
                    if (isInRange) {
                      rows.add(
                        PlutoRow(
                          cells: {
                            'paymentId':
                                PlutoCell(value: paymentData[i]['paymentId']),
                            'amount':
                                PlutoCell(value: paymentData[i]['amount']),
                            'date': PlutoCell(
                                value:
                                    '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                            'shopId': PlutoCell(
                                value: '${paymentData[i]['shopId']} '),
                            'shopName':
                                PlutoCell(value: paymentData[i]['shopName']),
                            'name': PlutoCell(value: restroData[i]['name']),
                            'phone': PlutoCell(value: restroData[i]['phone']),
                            'email': PlutoCell(value: restroData[i]['email']),
                          },
                        ),
                      );
                    }
                  }
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: PlutoGrid(
                      columns: columns3,
                      rows: rows,
                      columnGroups: columnGroups3,
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade200,
          elevation: 2,
          onPressed: () {
            exportToPdf();
          },
          child: Icon(
            Icons.picture_as_pdf,
            color: Color(0xff1D1F33),
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
