
import 'dart:async';
import 'dart:io';

import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Provider/AppVersionProvider.dart';
import 'package:HyCharge/Provider/AuthProvider.dart';
import 'package:HyCharge/Provider/ChargingEstimateProvider.dart';
import 'package:HyCharge/Provider/ChargingGunStatusProvider.dart';
import 'package:HyCharge/Provider/ChargingHubReviewProvider.dart';
import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Provider/DeleteAccountProvider.dart';
import 'package:HyCharge/Provider/FileUploadProvider.dart';
import 'package:HyCharge/Provider/HubProvider.dart';
import 'package:HyCharge/Provider/ImageCacheProvider.dart';
import 'package:HyCharge/Provider/LoginProvider.dart';
import 'package:HyCharge/Provider/PaymentProvider.dart';
import 'package:HyCharge/Provider/ProfileProvider.dart';
import 'package:HyCharge/Provider/VehicleProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Provider/charger_details_provider.dart';
import 'package:HyCharge/Provider/charging_hub_provider.dart';
import 'package:HyCharge/Provider/hardware_master_provider.dart';
import 'package:HyCharge/Provider/user_vehicle_provider.dart';

import 'package:HyCharge/Routers/routers.dart';
import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
import 'package:HyCharge/Screens/SplashScreen.dart';

import 'package:HyCharge/Services/ChargingHistorySessionProvider.dart';
import 'package:HyCharge/Utils/UtilityFile.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/widget/GlobalLists.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';

import 'Provider/MapOverViewProvider.dart';
import 'Provider/NavigationProvider.dart';
import 'Screens/Controller/driver_map_controller.dart';
import 'Screens/Controller/map_controller.dart';
import 'Screens/Controller/map_overview_controller.dart';

import 'package:app_links/app_links.dart';
import 'package:fluttertoast/fluttertoast.dart';
void rToast(String message) {
  print("🔥 DEBUG: $message");

  // Fluttertoast.cancel(); // clear old toasts

  // Fluttertoast.showToast(
  //   msg: "🔥 $message",
  //   toastLength: Toast.LENGTH_LONG,
  //   gravity: ToastGravity.CENTER, // 👈 VERY IMPORTANT (center = always visible)
  //   timeInSecForIosWeb: 3,
  // );
}
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> routeGlobalKey = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 if (Platform.isAndroid) {
  AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
}

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

 
   MyApp.pendingChargerId = null;
MyApp.deepLinkChecked = false;
SplashScreen.deepLinkHandled = false;
 await Utility().loadAPIConfig();

   runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static String? pendingChargerId;
static bool deepLinkChecked = false;
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

void _navigateToEstimateIOS(String chargerId) {
   MyApp.pendingChargerId = chargerId;
 if (_hasNavigated) return;

  _hasNavigated = true;

 

  rToast("STORE PENDING NAVIGATION");

 
}

 void _handleDeepLink(Uri uri) {
  print("Deep link received: $uri");

  if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == "c") {
    final chargerId = uri.pathSegments.length > 1
        ? uri.pathSegments[1]
        : null;

    if (chargerId == null || chargerId.isEmpty) {
      rToast("INVALID CHARGER ID");
      return;
    }

    rToast("CHARGER ID: $chargerId");

   
      // _navigateToEstimateIOS(chargerId);
   if (Platform.isIOS) {
      // ✅ KEEP YOUR EXISTING FLOW (UNCHANGED)
      _navigateToEstimateIOS(chargerId);
    } else {
      // ✅ ANDROID FIX
      _navigateToEstimateAndroid(chargerId);
    }
  } else {
    rToast("INVALID LINK FORMAT");
  }
}
void _navigateToEstimateAndroid(String chargerId) {
  GlobalLists.globalChargerId = chargerId;
}
// void _navigateToEstimateAndroid(String chargerId) {
//   final navigator = routeGlobalKey.currentState;

//   if (navigator != null) {
//     navigator.push(
//       MaterialPageRoute(
//         builder: (_) => ChargingEstimateScreen(
//           chargerID: chargerId,
//           isAPPLINK: "1",
//         ),
//       ),
//     );
//   } else {
//     // ✅ FALLBACK for cold start (IMPORTANT)
//     GlobalLists.globalChargerId = chargerId;
//   }
// }

  Uri? _lastUri;
  bool _hasNavigated = false;
Future<void> _initDeepLinks() async {
  _appLinks = AppLinks();

  try {
    /// ✅ HANDLE INITIAL LINK (COLD START)
    final Uri? initialLink = await _appLinks.getInitialLink();

    if (initialLink != null) {
      rToast("INITIAL LINK: $initialLink");
      _handleDeepLink(initialLink);
    } else {
      rToast("NO INITIAL LINK");
    }
  } catch (e) {
    rToast("DEEPLINK ERROR: $e");
  }

  /// ✅ STREAM (FOREGROUND / BACKGROUND)
  _linkSubscription = _appLinks.uriLinkStream.listen((Uri uri) {
    rToast("STREAM LINK: $uri");
    _handleDeepLink(uri);
  });

  /// ✅ ALWAYS MARK COMPLETE
  // MyApp.deepLinkChecked = true;
  // Future.delayed(const Duration(milliseconds: 800), () {
  MyApp.deepLinkChecked = true;
  rToast("DEEPLINK CHECK COMPLETE");
// });
}

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    /// ✅ iOS navigation listener (SAFE PLACE)
  
  
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    final mapController = MapController();
    final mapDriverController = DriverMapController();
    final mapOverViewController = OverViewMapController();

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChargerDetailsProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => UserVehicleProvider()),
        ChangeNotifierProvider(create: (_) => ChargingHubProvider()),
        ChangeNotifierProvider(create: (_) => ChargingHubReviewProvider()),
        ChangeNotifierProvider(create: (_) => ChargingEstimateProvider()),
        ChangeNotifierProvider(create: (_) => ChargingGunStatusProvider()),
        ChangeNotifierProvider(create: (_) => ActiveSessionProvider()),
        ChangeNotifierProvider(create: (_) => ChargingProvider()),
        ChangeNotifierProvider(create: (_) => DeleteAccountProvider()),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider(create: (_) => ImageCacheProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => HardwareMasterProvider()),
ChangeNotifierProvider(create: (_) => AppVersionProvider()),
        ChangeNotifierProvider(
          create: (_) => HubProvider(mapController),
        ),

        ChangeNotifierProvider(
          create: (_) => NavigationProvider(mapDriverController),
        ),

        ChangeNotifierProvider(
          create: (_) => MapOverViewProvider(mapOverViewController),
        ),
      ],
      child: SafeArea(
        bottom: true,
        child: MaterialApp(
          navigatorKey: routeGlobalKey,
          navigatorObservers: [routeObserver],
          title: 'HyCharge',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
            progressIndicatorTheme:
                const ProgressIndicatorThemeData(color: CommonColors.blue),
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: CommonColors.blue.withOpacity(0.3),
              selectionHandleColor: CommonColors.blue,
              cursorColor: CommonColors.blue,
            ),
          ),
 builder: (context, child) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        body: Center(
          child: Text(
          "ERROR:\n${details.exception}\n\nSTACK:\n${details.stack} ",
          style: const TextStyle(fontSize: 12),
        ),
        ),
      );
    };
    return child!;
  },
          initialRoute: SplashScreen.route,
          onGenerateRoute: Routers.generateRoute,
        ),
      ),
    );
  }
}
