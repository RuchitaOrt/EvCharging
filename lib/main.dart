import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
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

import 'package:HyCharge/Provider/charging_hub_provider.dart';
import 'package:HyCharge/Provider/hardware_master_provider.dart';
import 'package:HyCharge/Provider/user_vehicle_provider.dart';
import 'package:HyCharge/Routers/routers.dart';

import 'package:HyCharge/Screens/SplashScreen.dart';
import 'package:HyCharge/Services/ChargingHistorySessionProvider.dart';
import 'package:HyCharge/Utils/UtilityFile.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:provider/provider.dart';

import 'Provider/MapOverViewProvider.dart';
import 'Provider/NavigationProvider.dart';
import 'Screens/Controller/driver_map_controller.dart';
import 'Screens/Controller/map_controller.dart';
import 'Screens/Controller/map_overview_controller.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> routeGlobalKey = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
// ✅ NEW OFFICIAL API (replaces useAndroidViewSurface)
  AndroidGoogleMapsFlutter.useAndroidViewSurface = true;

  // await Firebase.initializeApp();
  await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "YOUR_API_KEY",
    appId: "YOUR_APP_ID",
    messagingSenderId: "SENDER_ID",
    projectId: "PROJECT_ID",
    storageBucket: "PROJECT_ID.appspot.com",
  ),
);

  await Utility().loadAPIConfig();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp() : super();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    final mapDriverController = DriverMapController();
    final mapOverViewController = OverViewMapController();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => UserVehicleProvider()),
        ChangeNotifierProvider(create: (_) => ChargingHubProvider()),
        ChangeNotifierProvider(create: (_) => ChargingHubReviewProvider()),
        // ChangeNotifierProvider(create: (_) => ChargingHistorySessionProvider()),
        ChangeNotifierProvider(create: (_) => ChargingEstimateProvider()),
        ChangeNotifierProvider(create: (_) => ChargingGunStatusProvider()),
        ChangeNotifierProvider(create: (_) => ChargingGunStatusProvider()),
        ChangeNotifierProvider(create: (_) => ActiveSessionProvider()),
        ChangeNotifierProvider(create: (_) => ChargingProvider()),
        ChangeNotifierProvider(create: (_) => DeleteAccountProvider()),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider(create: (_) => ImageCacheProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(
          create: (_) => HardwareMasterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HubProvider(mapController),
        ),
        ChangeNotifierProvider(
          create: (_) => WalletProvider(),
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
          navigatorObservers: [routeObserver],
          title: 'HyCharge',
          debugShowCheckedModeBanner: false,
          navigatorKey: routeGlobalKey,
          theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: CommonColors.blue,
            ),
            textSelectionTheme: TextSelectionThemeData(
              selectionColor:
                  CommonColors.blue.withOpacity(0.3), // background highlight
              selectionHandleColor: CommonColors.blue, // draggable handle
              cursorColor: CommonColors.blue, // fallback cursor
            ),
          ),
          initialRoute: SplashScreen.route,
          onGenerateRoute: Routers.generateRoute,
        ),
      ),
    );
  }
}
