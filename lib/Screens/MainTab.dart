import 'package:ev_charging_app/Screens/ChargingStationsScreen.dart';
import 'package:ev_charging_app/Screens/Map/MapScreen.dart';
import 'package:ev_charging_app/Screens/ProfileScreen.dart';
import 'package:ev_charging_app/Screens/ScanScreen.dart';
import 'package:ev_charging_app/Screens/Transaction.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainTab extends StatefulWidget {
  final bool isLoggedIn;
   static const String route = "/main_screen";
   MainTab({super.key,  this.isLoggedIn=false});

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {

  int currentIndex = 0;
  List screens=[];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.isLoggedIn);
     screens = [
     MapScreen(isLogin: widget.isLoggedIn),
     ChargingStationsScreen(),
     ScanScreen(), // Center button screen
    const Transaction(),
    const ProfileScreen(),
  ];
  }
  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        if (currentIndex == 0) {
          // Show exit confirmation dialog
          bool exit = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Exit App'),
                  content: const Text('Are you sure you want to exit the app?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel',style: TextStyle(color: CommonColors.blue),)),
                    TextButton(
                        onPressed: () {
                        SystemNavigator.pop();
                        },
                        child: const Text('Exit',style: TextStyle(color: CommonColors.blue),)),
                  ],
                ),
              ) ??
              false;
          return exit; // true = exit app, false = stay
        } else {
          // Navigate back to MapScreen tab
          setState(() => currentIndex = 0);
          return false; // prevent default pop
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: screens[currentIndex],
      
         bottomNavigationBar: Container(
        decoration: BoxDecoration(
      color: CommonColors.white,
      border: const Border(
        top: BorderSide(
          color: Colors.black12, // light shadow line
          width: 1,
        ),
      ),
        ),
        child: BottomAppBar(
      height: 70,
      color: Colors.transparent,
      elevation: 0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(0, CommonImagePath.map, "Map"),
           const SizedBox(width: 10),
          navItem(1, CommonImagePath.station, "Hubs"),
          const SizedBox(width: 40),
          navItem(3, CommonImagePath.transaction, "Wallet"),
          navItem(4, CommonImagePath.profile, "Profile"),
        ],
      ),
        ),
      ),
    
floatingActionButton: GestureDetector(
     onTap: () {
      setState(() => currentIndex = 2); 
        },
  child: Container(
    width: 60,   // Outer white circle
    height: 60,
    decoration: BoxDecoration(
     color: CommonColors.white,
      shape: BoxShape.circle,
  
    ),
    child: Center(
      child: Container(
        width: 48,   // Inner blue circle (reduced size)
        height: 48,
        decoration: const BoxDecoration(
          color: CommonColors.blue,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            CommonImagePath.scanner,
            width: 22,    // smaller icon (perfect size)
            height: 22,
          ),
        ),
      ),
    ),
  ),
),


        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget navItem(int index, String image,String name) {
    return InkWell(
      onTap: () => setState(() => currentIndex = index),
      child: Column(
        children: [
          SvgPicture.asset(
            image,
            color: currentIndex == index ? CommonColors.blue : Colors.grey,
          ),
          Text(name,style: TextStyle(fontSize: 12, color: currentIndex == index ? CommonColors.blue : Colors.grey,),)
        ],
      ),
    );
  }
}
