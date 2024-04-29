import 'package:flutter/material.dart';
import 'package:mall/screens/app_manager/app_manager_home.dart';
import 'package:mall/screens/auth_ui/login_screen.dart';
import 'package:mall/screens/shop_manager/shop_manager_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/customer/rive/NavigationPoint.dart';
import '../screens/delivery/delivery_home.dart';
import 'auth.dart';

class SplashServices {
  String? type;

  void isLogin(BuildContext context) async {
    if (Auth.auth.currentUser != null) {
      final pref = await SharedPreferences.getInstance();
      if (await pref?.getString('type') == 'Customer') {
        type = "Customer";
        Future.delayed(
            Duration(seconds: 5),
                () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationPoint(),
                )));
      } else if (await pref?.getString('type') == 'Shop Manager') {
        type = "Shop Keeper";
        Future.delayed(
            Duration(seconds: 5),
                () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ShopManagerHome())));
      } else if (await pref?.getString('type') == 'App Manager') {
        type = "App Manager";
        Future.delayed(
            Duration(seconds: 5),
                () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AppManagerHome())));
      } else if (await pref?.getString('type') == 'Delivery Person') {
        type = "Delivery Person";
        Future.delayed(
            Duration(seconds: 5),
                () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeliveryHome(
                      email: pref?.getString('email'),
                      password: pref?.getString('password'),
                      id: pref?.getString('id'),
                    ))));
      }
    } else {
      Future.delayed(
          Duration(seconds: 5),
              () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              )));
    }
  }
}