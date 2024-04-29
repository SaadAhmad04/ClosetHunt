// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:mall/screens/customer/customer_home.dart';
// import 'package:mall/screens/customer/rive/sideMenu.dart';
// import 'package:rive/rive.dart';
//
// class NavigationPoint extends StatefulWidget {
//   const NavigationPoint({Key? key}) : super(key: key);
//
//   @override
//   State<NavigationPoint> createState() => _NavigationPointState();
// }
//
// class _NavigationPointState extends State<NavigationPoint>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> animation;
//   late Animation<double> scalAnimation;
//
//   late RiveAnimationController _riveController;
//   bool isSideMenuClosed = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     animation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.fastOutSlowIn,
//       ),
//     );
//
//     scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.fastOutSlowIn,
//       ),
//     );
//
//     // Initialize the Rive controller
//     // Initialize the Rive controller
//     _riveController = SimpleAnimation(
//       'YourAnimationName',
//       mix: 1, // Set mix value as needed
//       autoplay: true,
//     );
//
// // Start the animation
//
//     // Start the animation
//     _riveController.isActive = true;
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       extendBody: true,
//       body: Stack(
//         children: [
//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 200),
//             curve: Curves.fastOutSlowIn,
//             width: 288,
//             left: isSideMenuClosed ? -288 : 0,
//             height: MediaQuery.of(context).size.height,
//             child: const SideMenu(),
//           ),
//           Transform(
//             alignment: Alignment.center,
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.001)
//               ..rotateY(animation.value - 40 * animation.value * pi / 180),
//             child: Transform.translate(
//               offset: Offset(animation.value * 265, 0),
//               child: Transform.scale(
//                 scale: scalAnimation.value,
//                 child: const ClipRRect(
//                   borderRadius: BorderRadius.all(Radius.circular(24)),
//                   child: CustomerHome(),
//                 ),
//               ),
//             ),
//           ),
//           AnimatedPositioned(
//             duration: Duration(milliseconds: 200),
//             curve: Curves.fastOutSlowIn,
//             left: isSideMenuClosed ? 0 : 220,
//             top: 16,
//             child: SafeArea(
//               child: GestureDetector(
//                 onTap: () {
//                   print(_riveController.isActive);
//                   if (_riveController != null) {
//                     _riveController.isActive = !_riveController.isActive;
//                     if (isSideMenuClosed) {
//                       _animationController.forward();
//                     } else {
//                       _animationController.reverse();
//                     }
//                     setState(() {
//                       isSideMenuClosed = _riveController.isActive;
//                     });
//                   }
//                 },
//                 child: Container(
//                     margin: const EdgeInsets.only(left: 16),
//                     height: 40,
//                     width: 40,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                           image: NetworkImage(
//                               "https://cdn-icons-png.flaticon.com/512/3603/3603154.png")),
//                       color: Colors.transparent,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           offset: Offset(0, 3),
//                           blurRadius: 8,
//                         )
//                       ],
//                     ),
//                     child: RiveAnimation.network(
//                       'Your Animation URL',
//                       controllers: [_riveController],
//                     )),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mall/screens/customer/customer_home.dart';
import 'package:mall/screens/customer/rive/sideMenu.dart';
import 'package:rive/rive.dart';

class NavigationPoint extends StatefulWidget {
  const NavigationPoint({Key? key}) : super(key: key);

  @override
  State<NavigationPoint> createState() => _NavigationPointState();
}

class _NavigationPointState extends State<NavigationPoint>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scalAnimation;

  late RiveAnimationController _riveController;
  bool isSideMenuClosed = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
      setState(() {});
    });

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    // Initialize the Rive controller
    // Initialize the Rive controller
    _riveController = SimpleAnimation(
      'YourAnimationName',
      mix: 1, // Set mix value as needed
      autoplay: true,
    );

// Start the animation

    // Start the animation
    _riveController.isActive = true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: const SideMenu(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 40 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  child: CustomerHome(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClosed ? 0 : 220,
            top: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  print(_riveController.isActive);
                  if (_riveController != null) {
                    _riveController.isActive = !_riveController.isActive;
                    if (isSideMenuClosed) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                    setState(() {
                      isSideMenuClosed = _riveController.isActive;
                    });
                  }
                },
                child: Container(
                    margin: const EdgeInsets.only(left: 16, top: 0.2),
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/3603/3603154.png")),
                      //     "images/menu.gif",
                      //   ),
                      //   fit: BoxFit.cover,
                      // ),
                      // color: Colors.pink,
                      // shape: BoxShape.circle,
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black12,
                      //     offset: Offset(0, 3),
                      //     blurRadius: 8,
                      //   )
                      // ],
                    ),
                    child: RiveAnimation.network(
                      'Your Animation URL',
                      controllers: [_riveController],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}