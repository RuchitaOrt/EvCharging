
import 'dart:io';

import 'package:HyCharge/Provider/AppVersionProvider.dart';
import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/OnboardingScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/UtilityFile.dart';
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
  bool _hasNavigated = false;
  bool _isInitializing = false;
Future<void> _initApp() async {
  rToast("SPLASH INIT START");
 if (_isInitializing) return; // ✅ prevent double call
  _isInitializing = true;

   SplashScreen.deepLinkHandled = false;
  await Future.delayed(const Duration(milliseconds: 300));

  if (!mounted) return;

  final versionProvider =
      Provider.of<AppVersionProvider>(context, listen: false);

  try {
    await versionProvider.checkAppVersion(context);
  } catch (e) {
    rToast("VERSION ERROR: $e");
  }

  // ✅ Force Update Check
  bool forceUpdateHandled = await _handleForceUpdate(versionProvider);
  if (!mounted) return;

  // Only continue if user hasn't navigated yet
  if (!_hasNavigated) {
    while (!MyApp.deepLinkChecked) {
  await Future.delayed(const Duration(milliseconds: 50));
}
    await _continueSplashFlow();
  }
}
Future<void> _initAppAndroid() async {
  rToast("SPLASH INIT START");
 if (_isInitializing) return; // ✅ prevent double call
  _isInitializing = true;

   SplashScreen.deepLinkHandled = false;
  await Future.delayed(const Duration(milliseconds: 300));

  if (!mounted) return;

  final versionProvider =
      Provider.of<AppVersionProvider>(context, listen: false);

  try {
    await versionProvider.checkAppVersion(context);
  } catch (e) {
    rToast("VERSION ERROR: $e");
  }

  // ✅ Force Update Check
  bool forceUpdateHandled = await _handleForceUpdate(versionProvider);
  if (!mounted) return;

  // Only continue if user hasn't navigated yet
  if (!_hasNavigated) {
    while (!MyApp.deepLinkChecked) {
  await Future.delayed(const Duration(milliseconds: 50));
}
    await Platform.isAndroid?_continueSplashFlowAndroid(): _continueSplashFlow();
  }
}

Future<bool> _handleForceUpdate(AppVersionProvider provider) async {
  final data = provider.appVersionData;
  if (data == null) return false;

  final currentVersion = await getCurrentVersion();
  final latestVersion = Platform.isAndroid
      ? data.latestVersionAndroid ?? ""
      : data.latestVersionIos ?? "";

  final updateAvailable = isUpdateAvailable(currentVersion, latestVersion);

  if (updateAvailable) {
    bool? userChoice = await _showForceUpdateDialog(data); // wait for user choice

    // ✅ User chose "Not Now" → do NOT block, but mark flow as handled
    if (userChoice == false) {
      rToast("User skipped update");
      return false;
    } else {
      // Update clicked, splash flow stops until update
      _hasNavigated = true;
      return true;
    }
  }

  return false; // always continue splash flow
}
 Future<void> _continueSplashFlow() async {
  if (_hasNavigated || SplashScreen.deepLinkHandled) return; // prevent double nav

  if (MyApp.pendingChargerId != null) {
    _hasNavigated = true;
    SplashScreen.deepLinkHandled = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChargingEstimateScreen(
          chargerID: MyApp.pendingChargerId,
          isAPPLINK: "1",
        ),
      ),
    );
    return;
  }

  final isFirstTime = await AuthStorage.isFirstTime();

  if (_hasNavigated || SplashScreen.deepLinkHandled) return; // double check

  if (isFirstTime) {
    _hasNavigated = true;
    SplashScreen.deepLinkHandled = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
    return;
  }

  final loggedIn = await AuthStorage.isLoggedIn();

  _hasNavigated = true;
  SplashScreen.deepLinkHandled = true;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => MainTab(isLoggedIn: loggedIn),
    ),
  );
}

Future<void> _continueSplashFlowAndroid() async {
   if (_hasNavigated || SplashScreen.deepLinkHandled) return;

  /// ✅ Android + iOS BOTH handled here
  if (GlobalLists.globalChargerId != null) {
    _hasNavigated = true;
  SplashScreen.deepLinkHandled = true;

    final chargerId = GlobalLists.globalChargerId!;
    GlobalLists.globalChargerId = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChargingEstimateScreen(
          chargerID: chargerId,
          isAPPLINK: "1",
        ),
      ),
    );
    return;
  }

  if (MyApp.pendingChargerId != null) {
    _hasNavigated = true;
    SplashScreen.deepLinkHandled = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChargingEstimateScreen(
          chargerID: MyApp.pendingChargerId,
          isAPPLINK: "1",
        ),
      ),
    );
    return;
  }

  /// NORMAL FLOW
  final isFirstTime = await AuthStorage.isFirstTime();

  if (_hasNavigated || SplashScreen.deepLinkHandled) return;

  if (isFirstTime) {
    _hasNavigated = true;
    SplashScreen.deepLinkHandled = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
    return;
  }

  final loggedIn = await AuthStorage.isLoggedIn();

  _hasNavigated = true;
  SplashScreen.deepLinkHandled = true;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => MainTab(isLoggedIn: loggedIn),
    ),
  );
}
// Future<void> _continueSplashFlow() async {
//   if (_hasNavigated || SplashScreen.deepLinkHandled) return; // prevent double nav

//   if (MyApp.pendingChargerId != null) {
//     _hasNavigated = true;
//     SplashScreen.deepLinkHandled = true;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ChargingEstimateScreen(
//           chargerID: MyApp.pendingChargerId,
//           isAPPLINK: "1",
//         ),
//       ),
//     );
//     return;
//   }

//   final isFirstTime = await AuthStorage.isFirstTime();

//   if (_hasNavigated || SplashScreen.deepLinkHandled) return; // double check

//   if (isFirstTime) {
//     _hasNavigated = true;
//     SplashScreen.deepLinkHandled = true;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//     );
//     return;
//   }

//   final loggedIn = await AuthStorage.isLoggedIn();

//   _hasNavigated = true;
//   SplashScreen.deepLinkHandled = true;

//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (_) => MainTab(isLoggedIn: loggedIn),
//     ),
//   );
// }


Future<void> loadDataCombine() async {
 

  await Future.delayed(const Duration(milliseconds: 300));

  if (!mounted) return;

  try {
   

    final isFirstTime = await AuthStorage.isFirstTime();

   

    if (isFirstTime) {
     

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

  

    final loggedIn = await AuthStorage.isLoggedIn();

    rToast("LOGGED IN: $loggedIn");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainTab(isLoggedIn: loggedIn),
      ),
    );

  } catch (e, stack) {
    rToast("CRASH IN AUTH: $e");
    print(stack);
  }
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
                       {rToast("CLICLED NOT NOW");
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
  Platform.isAndroid?_initAppAndroid():  _initApp();
    
    
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

// import 'dart:io';

// import 'package:HyCharge/Provider/AppVersionProvider.dart';
// import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
// import 'package:HyCharge/Screens/MainTab.dart';
// import 'package:HyCharge/Screens/OnboardingScreen.dart';
// import 'package:HyCharge/Utils/AuthStorage.dart';
// import 'package:HyCharge/Utils/UtilityFile.dart';
// import 'package:HyCharge/Utils/commoncolors.dart';
// import 'package:HyCharge/Utils/commonimages.dart';
// import 'package:HyCharge/Utils/sizeConfig.dart';
// import 'package:HyCharge/main.dart';
// import 'package:HyCharge/model/AppVersionResponse.dart';
// import 'package:HyCharge/widget/GlobalLists.dart';
// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SplashScreen extends StatefulWidget {
//   static const String route = "/splashScreen";

//   const SplashScreen({super.key});
// static bool deepLinkHandled = false;
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   bool _hasNavigated = false;
// Future<void> _initApp() async {
//   rToast("SPLASH INIT START");

//   SplashScreen.deepLinkHandled = false;
//   await Future.delayed(const Duration(milliseconds: 300));

//   if (!mounted) return;

//   final versionProvider =
//       Provider.of<AppVersionProvider>(context, listen: false);

//   try {
//     await versionProvider.checkAppVersion(context);
//   } catch (e) {
//     rToast("VERSION ERROR: $e");
//   }

//   // ✅ Force Update Check
//   bool forceUpdateHandled = await _handleForceUpdate(versionProvider);
//   if (!mounted) return;

//   // Only continue if user hasn't navigated yet
//   if (!_hasNavigated) {
//     await _continueSplashFlow();
//   }
// }

// Future<bool> _handleForceUpdate(AppVersionProvider provider) async {
//   final data = provider.appVersionData;
//   if (data == null) return false;

//   final currentVersion = await getCurrentVersion();
//   final latestVersion = Platform.isAndroid
//       ? data.latestVersionAndroid ?? ""
//       : data.latestVersionIos ?? "";

//   final updateAvailable = isUpdateAvailable(currentVersion, latestVersion);

//   if (updateAvailable) {
//     bool? userChoice = await _showForceUpdateDialog(data); // wait for user choice

//     // ✅ User chose "Not Now" → do NOT block, but mark flow as handled
//     if (userChoice == false) {
//       rToast("User skipped update");
//       return false;
//     } else {
//       // Update clicked, splash flow stops until update
//       _hasNavigated = true;
//       return true;
//     }
//   }

//   return false; // always continue splash flow
// }
// Future<void> _continueSplashFlow() async {
//   if (_hasNavigated || SplashScreen.deepLinkHandled) return; // prevent double nav

//   if (MyApp.pendingChargerId != null) {
//     _hasNavigated = true;
//     SplashScreen.deepLinkHandled = true;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ChargingEstimateScreen(
//           chargerID: MyApp.pendingChargerId,
//           isAPPLINK: "1",
//         ),
//       ),
//     );
//     return;
//   }

//   final isFirstTime = await AuthStorage.isFirstTime();

//   if (_hasNavigated || SplashScreen.deepLinkHandled) return; // double check

//   if (isFirstTime) {
//     _hasNavigated = true;
//     SplashScreen.deepLinkHandled = true;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//     );
//     return;
//   }

//   final loggedIn = await AuthStorage.isLoggedIn();

//   _hasNavigated = true;
//   SplashScreen.deepLinkHandled = true;

//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (_) => MainTab(isLoggedIn: loggedIn),
//     ),
//   );
// }


// Future<void> loadDataCombine() async {
 

//   await Future.delayed(const Duration(milliseconds: 300));

//   if (!mounted) return;

//   try {
   

//     final isFirstTime = await AuthStorage.isFirstTime();

   

//     if (isFirstTime) {
     

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//       );
//       return;
//     }

  

//     final loggedIn = await AuthStorage.isLoggedIn();

//     rToast("LOGGED IN: $loggedIn");

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => MainTab(isLoggedIn: loggedIn),
//       ),
//     );

//   } catch (e, stack) {
//     rToast("CRASH IN AUTH: $e");
//     print(stack);
//   }
// }

// Future<String> getCurrentVersion() async {
//   final packageInfo = await PackageInfo.fromPlatform();
  
//   String version = packageInfo.version;       // e.g. 1.2.0
//   String buildNumber = packageInfo.buildNumber; // e.g. 12

//   print("Version: $version");
//   print("Build Number: $buildNumber");

//   return version;
// }
// Future<bool> _showForceUpdateDialog(AppVersionData data) async {
//   return await showDialog<bool>(
//         context: context,
//         barrierDismissible: false,
//         barrierColor: Colors.black.withOpacity(0.3),
//         builder: (_) => WillPopScope(
//           onWillPop: () async => false,
//           child: Center(
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     /// Icon
//                     Container(
//                       height: 70,
//                       width: 70,
//                       decoration: BoxDecoration(
//                         color: const Color(0xff2B3E2B).withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Image.asset("assets/images/logoios.jpg"),
//                     ),

//                     const SizedBox(height: 16),

//                     const Text(
//                       "Update Available",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     Text(
//                       data.message ?? "Please update the app.",
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 20),

                    
                    
//                     /// UPDATE
//                  SizedBox(
//   width: double.infinity,
//   height: 45,
//   child: ElevatedButton(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: CommonColors.blue,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     ),
//     onPressed: () async {
//       final url = Platform.isAndroid
//           ? data.androidStoreUrl ??
//               "https://play.google.com/store/apps/details?id=com.ev.charging_app"
//           : data.iosStoreUrl ??
//               "https://apps.apple.com/in/app/hycharge-ev-charging/id6759601972";

//       final uri = Uri.parse(url);

//       if (await canLaunchUrl(uri)) {
//         await launchUrl(
//           uri,
//           mode: LaunchMode.externalApplication,
//         );
//       }

//       Navigator.pop(context, true);
//     },
//     child: const Text(
//       "Update",
//       style: TextStyle(
//         color: CommonColors.cardWhite,
//         fontSize: 12,
//       ),
//     ),
//   ),
// ),
// SizedBox(height: 10,),
//                      GestureDetector(
//                        onTap: ()
//                        {rToast("CLICLED NOT NOW");
//                           Navigator.pop(context, false); // 👈 user skips
//                        },
//                        child: const Text("Not Now",style: TextStyle(color: CommonColors.hintGrey),)),

//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ) ??
//       false;
// }

// bool isUpdateAvailable(String current, String latest) {
//   List<int> currentParts =
//       current.split('.').map(int.parse).toList();
//   List<int> latestParts =
//       latest.split('.').map(int.parse).toList();

//   for (int i = 0; i < latestParts.length; i++) {
//     if (latestParts[i] > currentParts[i]) return true;
//     if (latestParts[i] < currentParts[i]) return false;
//   }
//   return false;
// }
//   @override
//   void initState() {
//     super.initState();
//     _initApp();
    
    
//   //  Platform.isAndroid? loadData():loadIOSData();
//   }

//   Future<void> loadIOSData() async {
//   await Future.delayed(Duration(seconds: 1));

//   if (!mounted) return;

//   /// 🔥 HARD STOP (same as Android)
//   if (SplashScreen.deepLinkHandled) {
//     print("iOS deep link active → stopping splash flow");
//     return;
//   }

//   /// ✅ DEEP LINK FLOW FIRST
//   if (GlobalLists.isDeepLinkFlow &&
//       GlobalLists.globalChargerId != null) {

//     final chargerId = GlobalLists.globalChargerId!;

//     /// CLEAR
//     // GlobalLists.globalChargerId = null;
//     // GlobalLists.isDeepLinkFlow = false;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ChargingEstimateScreen(
//           chargerID: chargerId,
//           isAPPLINK: "1",
//         ),
//       ),
//     );
//     Future.microtask(() {
//   GlobalLists.globalChargerId = null;
//   GlobalLists.isDeepLinkFlow = false;
// });

//     return; // 🚨 VERY IMPORTANT
//   }

//   /// ❌ DO NOT CONTINUE IF DEEP LINK
//   if (GlobalLists.isDeepLinkFlow) return;

//   /// NORMAL FLOW
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


// Future<void> loadData() async {
//   await Future.delayed(Duration(seconds: 3));

//   if (!mounted) return;

//   /// 🔥 HARD STOP if deep link triggered
//   if (SplashScreen.deepLinkHandled) {
//     print("Deep link flow active → skipping splash navigation");
//     return;
//   }

//   final isFirstTime = await AuthStorage.isFirstTime();

//   if (isFirstTime) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const OnboardingScreen()),
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

//   @override
//   Widget build(BuildContext context) {

//     SizeConfig().init(context);

//     return Scaffold(
//       body: SizedBox.expand(
//         child: Image.asset(
//           'assets/images/firstscreen.png',
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
