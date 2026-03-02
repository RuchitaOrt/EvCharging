
import 'dart:io';

import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/OnboardingScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  static const String route = "/splashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed( Duration(seconds:
   Platform.isIOS? 1:3));

    if (!mounted) return;

    final isFirstTime = await AuthStorage.isFirstTime();

    print("SPLASH -> isFirstTime: $isFirstTime");

    if (isFirstTime) {
     
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    } else {
     
      final loggedIn = await AuthStorage.isLoggedIn();
      print("SPLASH -> loggedIn: $loggedIn");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainTab(isLoggedIn: loggedIn),
        ),
      );
    }
  }

  void navigateToNextScreen() {
    Future.delayed( Duration(seconds: Platform.isIOS? 1:3), () {
      FocusScope.of(context).unfocus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
     SizeConfig().init(context);
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/firstscreen.png',
          fit: BoxFit.cover, // makes the image full screen
        ),
      ),
    );
  }
}
