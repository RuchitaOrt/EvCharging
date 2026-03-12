import 'dart:io';

import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/OnboardingScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String route = "/splashScreen";

  const SplashScreen({super.key});
static bool deepLinkHandled = false;
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

    /// Splash Delay
    await Future.delayed(
      Duration(seconds: Platform.isIOS ? 1 : 3),
    );
print("returned");
    // if (!mounted) return;
 if (!mounted || SplashScreen.deepLinkHandled) return; // ✅ Skip if deep link handled
 print("returning");
    /// Check First Time User
    final isFirstTime = await AuthStorage.isFirstTime();
    print("SPLASH -> isFirstTime: $isFirstTime");

    if (isFirstTime) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );

    } else {

      /// Check Login Status
      final loggedIn = await AuthStorage.isLoggedIn();
      print("SPLASH -> loggedIn: $loggedIn");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainTab(isLoggedIn: loggedIn),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/firstscreen.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
