
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/OnboardingScreen.dart';
import 'package:ev_charging_app/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';

class Routers {
  // Create a static method to configure the router
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case OnboardingScreen.route:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(),
        );
 case MainTab.route:
        return MaterialPageRoute(
          builder: (_) => MainTab(),
        );
 
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }

}
