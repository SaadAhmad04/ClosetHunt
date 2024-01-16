import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mall/screens/auth_ui/login_screen.dart';

class ShowError extends StatefulWidget {
  final String _msg;

  ShowError(this._msg);

  @override
  State<ShowError> createState() => _ShowErrorState();
}

class _ShowErrorState extends State<ShowError> with TickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget._msg);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Lottie.asset('animations/error.json'),
        FadeTransition(
            opacity: _animation,
            child: Text(
              widget._msg,
              style: TextStyle(color: Colors.white, fontSize: 25),
            )),
        SizedBox(height: 15,),
        InkWell(
          onTap: () {
            Navigator.push(context , MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: Container(
            height: 30,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Colors.transparent),
                    backgroundColor: Colors.transparent),
                onPressed: () {
                  Navigator.push(context , MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                label: Text(
                  'Go back!!',
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.chevron_left_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
