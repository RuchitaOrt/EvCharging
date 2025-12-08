import 'package:ev_charging_app/Routers/routers.dart';
import 'package:ev_charging_app/Screens/OnboardingScreen.dart';
import 'package:ev_charging_app/Screens/SplashScreen.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

final GlobalKey<NavigatorState> routeGlobalKey = GlobalKey();
Future<void> main() async {
 
WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
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
      );
  }
}
