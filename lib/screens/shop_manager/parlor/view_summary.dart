import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;
import '../../../controller/auth.dart';

class ViewSummary extends StatefulWidget {
  String? shopName;
  ViewSummary({super.key, this.shopName});

  @override
  State<ViewSummary> createState() => _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  List<Map<String, dynamic>> bookingData = [];

  Future<void> fetchData() async {
    final querySnapshot = await Auth.shopManagerRef
        .doc(Auth.auth.currentUser!.uid)
        .collection('notifications')
        .get();
    bookingData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Booking Id',
      field: 'bookingId',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Appointment Date',
      field: 'appointmentDate',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Appointment Time',
      field: 'appointmentTime',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Booking Date',
      field: 'bookingDate',
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

  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(
      title: 'Booking details',
      fields: [
        'bookingId',
        'appointmentDate',
        'appointmentTime',
        'bookingDate'
      ],
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
              for (int i = bookingData.length - 1; i >= 0; i--) {
                int ms = int.parse(bookingData[i]['bookingId']);
                DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(ms);
                DateTime appointmentDate =
                    DateTime.parse(bookingData[i]['date']);
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
                        'bookingId':
                            PlutoCell(value: bookingData[i]['bookingId']),
                        'appointmentDate': PlutoCell(
                            value:
                                '${appointmentDate.day}-${appointmentDate.month}-${appointmentDate.year}'),
                        'appointmentTime': PlutoCell(
                            value: bookingData[i]['time'].toString().substring(
                                0,
                                bookingData[i]['time'].toString().length - 2)),
                        'bookingDate': PlutoCell(
                            value:
                                '${dateTime.day}-${dateTime.month}-${dateTime.year}'),
                        'serviceId':
                            PlutoCell(value: bookingData[i]['serviceId']),
                        'serviceName':
                            PlutoCell(value: bookingData[i]['serviceName']),
                        'servicePrice':
                            PlutoCell(value: bookingData[i]['servicePrice']),
                        'name': PlutoCell(value: bookingData[i]['name']),
                        'phone': PlutoCell(value: bookingData[i]['phone']),
                        'email': PlutoCell(value: bookingData[i]['email']),
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
