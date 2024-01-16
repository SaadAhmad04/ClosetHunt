import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mall/screens/app_manager/booking/parlor/parlor_home.dart';

import '../../../controller/auth.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Bookings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Gamezone'),
            leading: CircleAvatar(child: Image.asset('images/video-game.png')),
            trailing: Icon(Icons.chevron_right),
            subtitle: Text('View'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Parlor'),
            leading: CircleAvatar(child: Image.asset('images/parlor.png')),
            trailing: Icon(Icons.chevron_right),
            subtitle: Text('View'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ParlorHome()));
            },
          ),
          ListTile(
            title: Text('Restaurant'),
            leading: CircleAvatar(child: Image.asset('images/restaurant.png')),
            trailing: Icon(Icons.chevron_right),
            subtitle: Text('View'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Cinema'),
            leading: CircleAvatar(child: Image.asset('images/theater.png')),
            trailing: Icon(Icons.chevron_right),
            subtitle: Text('View'),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
