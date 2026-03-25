import 'dart:io';

import 'package:HyCharge/Provider/AppVersionProvider.dart';
import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/OnboardingScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/AppVersionResponse.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  static const String route = "/splashScreen";

  const SplashScreen({super.key});
static bool deepLinkHandled = false;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
// Future<void> _initApp() async {
//  WidgetsBinding.instance.addPostFrameCallback((_) async {

//     if (SplashScreen.deepLinkHandled) return; // 🔥 STOP EARLY

//     final versionProvider =
//         Provider.of<AppVersionProvider>(context, listen: false);

//     await versionProvider.checkAppVersion(context);

//     // final shouldBlock = await _handleForceUpdate(versionProvider);

//     // if (!shouldBlock && !SplashScreen.deepLinkHandled) {
//       // Platform.isAndroid ? loadData() : loadIOSData();
//       Future.delayed(const Duration(seconds: 3), () {
//   if (!SplashScreen.deepLinkHandled && mounted) {
//     print("Fallback → loading normal flow");
//     loadDataCombine();
//   }
// });
//       // loadDataCombine();
//     // }
//   });
// // WidgetsBinding.instance.addPostFrameCallback((_) async {
    
// //   final versionProvider =
// //       Provider.of<AppVersionProvider>(context, listen: false);
// // await versionProvider.checkAppVersion(context);

// //   final shouldBlock = await _handleForceUpdate(versionProvider);

// //   if (!shouldBlock) {
// //     Platform.isAndroid ? loadData() : loadIOSData();
// //    }
// // });
 
// }
Future<void> _initApp() async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {

    final versionProvider =
        Provider.of<AppVersionProvider>(context, listen: false);

    await versionProvider.checkAppVersion(context);

    /// 🔥 WAIT until deep link check completes
    int retry = 0;
  while (!MyApp.deepLinkChecked) {
  await Future.delayed(const Duration(milliseconds: 100));
}

    /// ✅ If deep link already navigated → stop
    if (SplashScreen.deepLinkHandled) {
      print("Deep link handled → skip splash");
      return;
    }

    /// ✅ Normal flow
    await Future.delayed(const Duration(seconds: 2));

    if (!SplashScreen.deepLinkHandled && mounted) {
      loadDataCombine();
    }
  });
}
Future<void> loadDataCombine() async {
  await Future.delayed(const Duration(seconds: 2));

  if (!mounted) return;

  /// 🔥 STOP if deep link already handled
  if (SplashScreen.deepLinkHandled) {
    print("Deep link → skip splash");
    return;
  }

  final isFirstTime = await AuthStorage.isFirstTime();

  if (isFirstTime) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  } else {
    final loggedIn = await AuthStorage.isLoggedIn();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainTab(isLoggedIn: loggedIn),
      ),
    );
  }
}
Future<bool> _handleForceUpdate(AppVersionProvider provider) async {
  final data = provider.appVersionData;

  if (data == null) return false;

  final currentVersion = await getCurrentVersion();

  final latestVersion = Platform.isAndroid
      ? data.latestVersionAndroid ?? ""
      : data.latestVersionIos ?? "";

  final updateAvailable =
      isUpdateAvailable(currentVersion, latestVersion);

  if (updateAvailable) {
    await _showForceUpdateDialog(data); // 👈 WAIT here
  }

  return false; // allow navigation AFTER user action
}
Future<String> getCurrentVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  
  String version = packageInfo.version;       // e.g. 1.2.0
  String buildNumber = packageInfo.buildNumber; // e.g. 12

  print("Version: $version");
  print("Build Number: $buildNumber");

  return version;
}
Future<bool> _showForceUpdateDialog(AppVersionData data) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Icon
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xff2B3E2B).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("assets/images/logoios.jpg"),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Update Available",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      data.message ?? "Please update the app.",
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    
                    
                    /// UPDATE
                 SizedBox(
  width: double.infinity,
  height: 45,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: CommonColors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    onPressed: () async {
      final url = Platform.isAndroid
          ? data.androidStoreUrl ??
              "https://play.google.com/store/apps/details?id=com.ev.charging_app"
          : data.iosStoreUrl ??
              "https://apps.apple.com/in/app/hycharge-ev-charging/id6759601972";

      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }

      Navigator.pop(context, true);
    },
    child: const Text(
      "Update",
      style: TextStyle(
        color: CommonColors.cardWhite,
        fontSize: 12,
      ),
    ),
  ),
),
SizedBox(height: 10,),
                     GestureDetector(
                       onTap: ()
                       {
                          Navigator.pop(context, false); // 👈 user skips
                       },
                       child: const Text("Not Now",style: TextStyle(color: CommonColors.hintGrey),)),

                  ],
                ),
              ),
            ),
          ),
        ),
      ) ??
      false;
}

bool isUpdateAvailable(String current, String latest) {
  List<int> currentParts =
      current.split('.').map(int.parse).toList();
  List<int> latestParts =
      latest.split('.').map(int.parse).toList();

  for (int i = 0; i < latestParts.length; i++) {
    if (latestParts[i] > currentParts[i]) return true;
    if (latestParts[i] < currentParts[i]) return false;
  }
  return false;
}
  @override
  void initState() {
    super.initState();
    _initApp();
  //  Platform.isAndroid? loadData():loadIOSData();
  }

  Future<void> loadIOSData() async {
  await Future.delayed(Duration(seconds: 1));

  if (!mounted) return;

  /// 🔥 HARD STOP (same as Android)
  if (SplashScreen.deepLinkHandled) {
    print("iOS deep link active → stopping splash flow");
    return;
  }

  /// ✅ DEEP LINK FLOW FIRST
  if (GlobalLists.isDeepLinkFlow &&
      GlobalLists.globalChargerId != null) {

    final chargerId = GlobalLists.globalChargerId!;

    /// CLEAR
    // GlobalLists.globalChargerId = null;
    // GlobalLists.isDeepLinkFlow = false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChargingEstimateScreen(
          chargerID: chargerId,
          isAPPLINK: "1",
        ),
      ),
    );
    Future.microtask(() {
  GlobalLists.globalChargerId = null;
  GlobalLists.isDeepLinkFlow = false;
});

    return; // 🚨 VERY IMPORTANT
  }

  /// ❌ DO NOT CONTINUE IF DEEP LINK
  if (GlobalLists.isDeepLinkFlow) return;

  /// NORMAL FLOW
  final isFirstTime = await AuthStorage.isFirstTime();

  if (isFirstTime) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ),
    );
  } else {
    final loggedIn = await AuthStorage.isLoggedIn();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainTab(isLoggedIn: loggedIn),
      ),
    );
  }
}
// Future<void> loadIOSData() async {
//   await Future.delayed(
//     Duration(seconds: Platform.isIOS ? 1 : 3),
//   );

//   if (!mounted) return;

//   /// ✅ Check Deep Link FIRST
//  if (GlobalLists.globalChargerId != null) {
//   final chargerId = GlobalLists.globalChargerId!;

//   /// ✅ CLEAR AFTER USING
//   GlobalLists.globalChargerId = null;

//   SplashScreen.deepLinkHandled = true;

//   /// ✅ USE CONTEXT (NOT global navigator)
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (_) => ChargingEstimateScreen(
//         chargerID: chargerId,
//         isAPPLINK: "1",
//       ),
//     ),
//   );

//   return;
// }
//   /// Normal flow
//   final isFirstTime = await AuthStorage.isFirstTime();

//   if (isFirstTime) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const OnboardingScreen(),
//       ),
//     );
//   } else {
//     final loggedIn = await AuthStorage.isLoggedIn();

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => MainTab(isLoggedIn: loggedIn),
//       ),
//     );
//   }
// }



Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 3));

  if (!mounted) return;

  /// 🔥 HARD STOP if deep link triggered
  if (SplashScreen.deepLinkHandled) {
    print("Deep link flow active → skipping splash navigation");
    return;
  }

  final isFirstTime = await AuthStorage.isFirstTime();

  if (isFirstTime) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  } else {
    final loggedIn = await AuthStorage.isLoggedIn();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainTab(isLoggedIn: loggedIn),
      ),
    );
  }
}
//   Future<void> loadData() async {

//     /// Splash Delay
//     await Future.delayed(
//       Duration(seconds: Platform.isIOS ? 1 : 3),
//     );
// print("returned");
//     // if (!mounted) return;
//  if (!mounted || SplashScreen.deepLinkHandled) return; // ✅ Skip if deep link handled
//  print("returning");
//     /// Check First Time User
//     final isFirstTime = await AuthStorage.isFirstTime();
//     print("SPLASH -> isFirstTime: $isFirstTime");

//     if (isFirstTime) {

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const OnboardingScreen(),
//         ),
//       );

//     } else {

//       /// Check Login Status
//       final loggedIn = await AuthStorage.isLoggedIn();
//       print("SPLASH -> loggedIn: $loggedIn");

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => MainTab(isLoggedIn: loggedIn),
//         ),
//       );
//     }
//   }

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
