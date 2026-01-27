import 'package:ev_charging_app/Provider/AuthProvider.dart';
import 'package:ev_charging_app/Provider/HubProvider.dart';
import 'package:ev_charging_app/Provider/LoginProvider.dart';
import 'package:ev_charging_app/Provider/ProfileProvider.dart';
import 'package:ev_charging_app/Provider/VehicleProvider.dart';
import 'package:ev_charging_app/Provider/WalletProvider.dart';
import 'package:ev_charging_app/Provider/car_manufacturer_provider.dart';
import 'package:ev_charging_app/Provider/charging_hub_provider.dart';
import 'package:ev_charging_app/Provider/hardware_master_provider.dart';
import 'package:ev_charging_app/Provider/user_vehicle_provider.dart';
import 'package:ev_charging_app/Routers/routers.dart';

import 'package:ev_charging_app/Screens/SplashScreen.dart';
import 'package:ev_charging_app/Utils/UtilityFile.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Provider/MapOverViewProvider.dart';
import 'Provider/NavigationProvider.dart';
import 'Screens/Controller/map_controller.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> routeGlobalKey = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Utility().loadAPIConfig();
//await DatabaseHelper.instance.deleteOldDatabase();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => UserVehicleProvider()),
        ChangeNotifierProvider(create: (_) => ChargingHubProvider()),
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
          create: (_) => NavigationProvider(mapController),
        ),
        ChangeNotifierProvider(
          create: (_) => MapOverViewProvider(mapController),
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        title: 'Ev Charging',
        debugShowCheckedModeBanner: false,
        navigatorKey: routeGlobalKey,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
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
    );
  }
}
