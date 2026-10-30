
import 'dart:io';

import 'package:HyCharge/Provider/AppVersionProvider.dart';
import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/Vehicle/MyVehicleScreen.dart';
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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool _hasNavigated = false;
  bool _isInitializing = false;

  late AnimationController _glowController;
  late AnimationController _progressController;

  late Animation<double> _glowAnimation;
  late Animation<double> _progressAnimation;
late final AnimationController _entryController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _textFadeAnim;
late final Animation<double> _breatheAnim;
late final AnimationController _breatheController;
 @override
void dispose() {
  _entryController.dispose();
  _glowController.dispose();
  _progressController.dispose();
  _breatheController.dispose();

  super.dispose();
}
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
      builder: (_) => 
      
       MainTab(isLoggedIn: loggedIn),
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
      builder: (_) => 
    //  VehicleSelectionScreen()
        MainTab(isLoggedIn: loggedIn),
    ),
  );
}


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
Widget _buildAnimatedAppIcon() {
  return AnimatedBuilder(
    animation: Listenable.merge([_pingController, _breatheController, _entryController]),
    builder: (context, child) {
      return Transform.scale(
        scale: _scaleAnim.value, // entrance pop
        child: Opacity(
          opacity: _fadeAnim.value,
          child: SizedBox(
            width: 130, // room for the ring to expand into
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ping ring: scales out + fades, loops
                Transform.scale(
                  scale: _pingScale.value,
                  child: Opacity(
                    opacity: _pingFade.value,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: CommonColors.accent, // opacity comes from _pingFade
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                // Icon tile: white at 10% on navy, gentle breathe
                Transform.scale(
                  scale: _breatheAnim.value,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    child: const Icon(
      Icons.bolt_rounded,
      size: 48,
      color: CommonColors.accent,
    ),
  );
}

// Widget _buildAnimatedAppIcon() {
//     return AnimatedBuilder(
//       animation:
//           Listenable.merge([_glowController, _breatheController, _entryController]),
//       builder: (context, child) {
//         final glow = _glowAnimation.value;

//         return Transform.scale(
//           scale: _scaleAnim.value, // entrance pop
//           child: Opacity(
//             opacity: _fadeAnim.value,
//             child: Transform.scale(
//               scale: _breatheAnim.value, // subtle bolt breathing
//               child: Container(
//                 width: 98,
//                 height: 98,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF293F7B),
//                   borderRadius: BorderRadius.circular(20),
//                   // border: Border.all(
//                   //   color: CommonColors.accent
//                   //       .withOpacity(0.35 + (glow * 0.65)),
//                   //   width: 1 + (glow * 0.8),
//                   // ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: CommonColors.accent
//                           .withOpacity(0.12 + (glow * 0.32)),
//                       blurRadius: 12 + (glow * 54),
//                       spreadRadius: glow * 5,
//                     ),
//                     BoxShadow(
//                       color: CommonColors.accent.withOpacity(glow * 0.12),
//                       blurRadius: 35,
//                       spreadRadius: glow * 2,
//                     ),
//                   ],
//                 ),
//                 alignment: Alignment.center,
//                 child: child,
//               ),
//             ),
//           ),
//         );
//       },
//       child: const Icon(
//         Icons.bolt_rounded,
//         size: 58,
//         color: CommonColors.accent,
//       ),
//     );
//   }


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
late final AnimationController _pingController;
late final Animation<double> _pingScale;
late final Animation<double> _pingFade;

  @override
  void initState() {
    super.initState();

// in initState():
_pingController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 1400),
)..repeat(); // loops, no reverse — it restarts each cycle

_pingScale = Tween<double>(begin: 1.0, end: 1.35).animate(
  CurvedAnimation(parent: _pingController, curve: Curves.easeOut),
);
_pingFade = Tween<double>(begin: 0.35, end: 0.0).animate(
  CurvedAnimation(parent: _pingController, curve: Curves.easeOut),
);

 _entryController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 900),
);
    _scaleAnim = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutBack, // slight overshoot pop
    );
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    );
    // App name appears slightly later (staggered).
    _textFadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _glowAnimation =
        Tween<double>(begin: 0, end: 1).animate(_glowController)
          ..addListener(() => setState(() {}));

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
   _breatheAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
    _entryController.forward();
    _glowController.repeat(reverse: true);
_breatheController.repeat(reverse: true);

// Start initialization only after the entry animation completes.
_startSplashSequence();

// in dispose(): _pingController.dispose();

  //   _glowController.repeat(reverse: true);
  //   _breatheController.repeat(reverse: true);
  // Platform.isAndroid?_initAppAndroid():  _initApp();
    
    
  //  Platform.isAndroid? loadData():loadIOSData();
  }
Future<void> _startSplashSequence() async {
  try {
    // Wait for the 900ms entrance animation to finish.
    await _entryController.forward().orCancel;
  } on TickerCanceled {
    return;
  }

  if (!mounted) return;

  // Only begin app initialization after the animation.
  if (Platform.isAndroid) {
    await _initAppAndroid();
  } else {
    await _initApp();
  }
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
  return Scaffold(
    backgroundColor: const Color(0xFF0F2669), // brand navy
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimatedAppIcon(),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _textFadeAnim, // name + tagline appear after the icon
            child: const Column(
              children: [
                Text(
                  'HyCharge',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Charge smarter, drive further',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xB3FFFFFF), // white at 70%
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          // Pulsing half-width green segment on a faint track
          SizedBox(
            width: 96,
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: ColoredBox(
                color: Colors.white.withOpacity(0.15),
                child: AnimatedBuilder(
                  animation: _glowController, // reuse the glow loop for the pulse
                  builder: (context, _) {
                    return FractionallySizedBox(
                      widthFactor: 0.5,
                      alignment: Alignment(
                        -1.0 + (_glowAnimation.value * 2.0), // slides left → right
                        0,
                      ),
                      child: const ColoredBox(color: CommonColors.accent),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFF0F2669), // brand navy
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           _buildAnimatedAppIcon(),
  //           const SizedBox(height: 24),
  //           // Staggered fade + slide-up for the app name
  //            const Text(
  //               'HyCharge',
  //               style: TextStyle(
  //                 fontFamily: 'Poppins',
  //                 fontSize: 26,
  //                 fontWeight: FontWeight.w700,
  //                 color: Colors.white,
  //                 letterSpacing: 0.5,
  //               ),
  //             ),
  //           // AnimatedBuilder(
          
  //           const SizedBox(height: 48),
  //           // Thin indeterminate progress line
  //           SizedBox(
  //             width: 120,
  //             child: LinearProgressIndicator(
  //               minHeight: 3,
  //               borderRadius: BorderRadius.circular(999),
  //               backgroundColor: Colors.white.withOpacity(0.12),
  //               valueColor:
  //                   AlwaysStoppedAnimation<Color>(CommonColors.accent),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  
}
