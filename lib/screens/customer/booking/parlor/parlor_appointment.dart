import 'package:flutter/material.dart';

class ParlorAppointment extends StatefulWidget {
  const ParlorAppointment({super.key});

  @override
  State<ParlorAppointment> createState() => _ParlorAppointmentState();
}

class _ParlorAppointmentState extends State<ParlorAppointment> {

  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book your appointment'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async{
                  dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2400));
                  setState(() {});
                },
                child: Text('Choose Date')),
          )
        ],
      ),
    );
  }
}
