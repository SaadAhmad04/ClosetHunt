import 'package:flutter/material.dart';
import 'package:mall/screens/customer/booking/parlor/parlor_appointment.dart';
import 'package:mall/screens/customer/booking/parlor/view_parlors.dart';

import '../../../main.dart';

class BookingHome extends StatefulWidget {
  const BookingHome({super.key});

  @override
  State<BookingHome> createState() => _BookingHomeState();
}

class _BookingHomeState extends State<BookingHome> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height / 1.278,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink.shade50, Colors.purple.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: mq.height * .04, horizontal: mq.width - 280),
            child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(colors: [Colors.pink, Colors.purple])
                      .createShader(bounds);
                },
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 35.0,
                    color: Colors.white,
                  ),
                )),
          ),
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: mq.height / 1.3,
              width: mq.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.purple.shade200, Colors.pink.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: mq.height / 6, horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewParlors()));
                  },
                  child: Container(
                    height: mq.height / 5.5,
                    width: mq.width - 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                            colors: [Colors.pink.shade50, Colors.pink.shade200],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/parlor.png',
                          height: 80,
                          width: 100,
                        ),
                        Center(
                          child: Text(
                            'Parlor',
                            style: TextStyle(
                                fontSize: 25,
                                wordSpacing: 2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mq.height * .05,),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: mq.height / 5.5,
                    width: mq.width - 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                            colors: [Colors.pink.shade50, Colors.pink.shade200],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/theater.png',
                          height: 80,
                          width: 100,
                        ),
                        Center(
                          child: Text(
                            'Cinema',
                            style: TextStyle(
                                fontSize: 25,
                                wordSpacing: 2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;

    final path = Path();
    path.lineTo(0, height);
    path.quadraticBezierTo(
        width / 2, //point 3
        height - 150, //point 3
        width, //point 4
        height //point 4
        );
    path.lineTo(width, 0); //point 5
    path.quadraticBezierTo(width, height / 5, width - 500, height - 480);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
