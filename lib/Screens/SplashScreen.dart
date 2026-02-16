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

    // Navigate to onboarding screen after 3 seconds
    // checkUpdate();
    loadData();
    // Future.delayed(const Duration(seconds: 3), () {
    //    FocusScope.of(context).unfocus();
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    //   );
    // });
  }

  // Future<void> checkUpdate() async {
  //   final newVersion = NewVersionPlus(
  //     androidId: "com.ev.charging_app",
  //   );

  //   final status = await newVersion.getVersionStatus();
  //   print(status);
  //   print(status!.canUpdate);
  //   if (status != null && status.canUpdate) {
  //     newVersion.showUpdateDialog(
  //       context: context,
  //       versionStatus: status,
  //       allowDismissal: false, // Force update
  //     );
  //   } else {
  //     navigateToNextScreen();
  //   }
  // }
//   Future<void> loadData() async {
//   await Future.delayed(const Duration(seconds: 3));

//   if (!mounted) return;

//   final isFirstTime = await AuthStorage.isFirstTime();
//   final loggedIn = await AuthStorage.isLoggedIn();

//   print("IS FIRST TIME: $isFirstTime");

//   if (isFirstTime) {
//     await AuthStorage.setFirstTimeDone();

//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (_) => const OnboardingScreen(),
//       ),
//     );
//   } else {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (_) => MainTab(isLoggedIn: loggedIn),
//       ),
//     );
//   }
// }
Future<void> loadData() async {
  await Future.delayed(const Duration(seconds: 3));

  if (!mounted) return;

  final isFirstTime = await AuthStorage.isFirstTime();
  final loggedIn = await AuthStorage.isLoggedIn();

  print("SPLASH -> isFirstTime: $isFirstTime");
  print("SPLASH -> loggedIn: $loggedIn");

  if (isFirstTime) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ),
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainTab(isLoggedIn: loggedIn),
      ),
    );
  }
}

// loadData() async {

//   final isFirstTime = await AuthStorage.isFirstTime();
//   final loggedIn = await AuthStorage.isLoggedIn();
//   print("ISFIRSTTIME");
// print(isFirstTime);
//   if (isFirstTime) {

//     await AuthStorage.setFirstTimeDone();

//    Future.delayed(const Duration(seconds: 3), () {
//        FocusScope.of(context).unfocus();
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//       );
//     });

//   } else {
// FocusScope.of(context).unfocus();
   
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => MainTab(isLoggedIn: loggedIn),
//         ),
//       );
   

//   }
// }

  void navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      FocusScope.of(context).unfocus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
