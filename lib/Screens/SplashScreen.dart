import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/OnboardingScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';

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

  loadData() async {
    final isFirstTime = await AuthStorage.isFirstTime();
    final loggedIn = await AuthStorage.isLoggedIn();

    if (!mounted) return;

    if (isFirstTime) {
      await AuthStorage.setFirstTimeDone();

      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;

        FocusScope.of(context).unfocus();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      });

    } else {

      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;

        FocusScope.of(context).unfocus();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainTab(isLoggedIn: loggedIn),
          ),
        );
      });

    }
  }

  void navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      FocusScope.of(context).unfocus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox.expand(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width > 900 ? 500 : width,
            ),
            child: Image.asset(
              'assets/images/firstscreen.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
