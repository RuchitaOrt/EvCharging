import 'package:HyCharge/Screens/ChargingStationsScreen.dart';
import 'package:HyCharge/Screens/Map/MapScreen.dart';
import 'package:HyCharge/Screens/ProfileScreen.dart';
import 'package:HyCharge/Screens/ScanScreen.dart';
import 'package:HyCharge/Screens/Transaction.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';


class MainTab extends StatefulWidget {
  final bool isLoggedIn;
  final int currentIndex;
  final bool iscreditopen;
   static const String route = "/main_screen";
   MainTab({super.key,  this.isLoggedIn=false,  this.currentIndex=0,  this.iscreditopen=false});

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
 
    currentIndex=widget.currentIndex;
    print(widget.isLoggedIn);
     screens = [
     MapScreen(isLogin: widget.isLoggedIn),
     ChargingStationsScreen(),
     ScanScreen(), // Center button screen
     Transaction(creditsOpen: widget.iscreditopen,),
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
  decoration: const BoxDecoration(
    color: CommonColors.white,
    border: Border(
      top: BorderSide(
        color: Color(0xFFE8ECF3),
        width: 1,
      ),
    ),
  ),
  child: BottomAppBar(
    height: 76,
    color: Colors.transparent,
    elevation: 0,
    padding: EdgeInsets.zero,
    shape: const CircularNotchedRectangle(),
    notchMargin: 6,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: navItem(0, CommonImagePath.map, "Map"),
        ),
        Expanded(
          child: navItem(1, CommonImagePath.station, "Hubs"),
        ),

        const SizedBox(width: 68),

        Expanded(
          child: navItem(3, CommonImagePath.transaction, "Wallet"),
        ),
        Expanded(
          child: navItem(4, CommonImagePath.profile, "Profile"),
        ),
      ],
    ),
  ),
),
floatingActionButton: GestureDetector(
  onTap: () {
    setState(() => currentIndex = 2);
  },
  child: SizedBox(
    width: 76,
    height: 82,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Scan circular button
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: CommonColors.blue,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  CommonImagePath.scanner,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 2),

        // Scan label
        Text(
          'Scan',
          style: TextStyle(
            fontSize: 11,
            fontWeight: currentIndex == 2
                ? FontWeight.w600
                : FontWeight.w400,
            color: currentIndex == 2
                ? CommonColors.blue
                : const Color(0xFF778196),
          ),
        ),
      ],
    ),
  ),
),

floatingActionButtonLocation:
    FloatingActionButtonLocation.centerDocked,
// floatingActionButton: GestureDetector(
//   onTap: () {
//     setState(() => currentIndex = 2);
//   },
//   child: Container(
//     width: 64,
//     height: 64,
//     decoration: BoxDecoration(
//       color: CommonColors.white,
//       shape: BoxShape.circle,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.10),
//           blurRadius: 10,
//           offset: const Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Center(
//       child: Container(
//         width: 52,
//         height: 52,
//         decoration: BoxDecoration(
//           color: CommonColors.blue,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: CommonColors.white,
//             width: 2,
//           ),
//         ),
//         child: Center(
//           child: SvgPicture.asset(
//             CommonImagePath.scanner,
//             width: 23,
//             height: 23,
//             colorFilter: const ColorFilter.mode(
//               Colors.white,
//               BlendMode.srcIn,
//             ),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),

// floatingActionButtonLocation:
//     FloatingActionButtonLocation.centerDocked,
    
      ),
    );
  }
Widget navItem(int index, String image, String name) {
  final bool isSelected = currentIndex == index;

  return InkWell(
    onTap: () {
      setState(() {
        currentIndex = index;
      });
    },
    splashColor: CommonColors.blue.withOpacity(0.08),
    highlightColor: Colors.transparent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Blue divider above the selected tab
        Container(
          height: 3,
          width: 32,
          decoration: BoxDecoration(
            color: isSelected
                ? CommonColors.blue
                : Colors.transparent,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(3),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Rounded icon card for the selected tab
        Container(
          width: 50,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE8EEFC)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            image,
            width: 21,
            height: 21,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? CommonColors.blue
                  : const Color(0xFF778196),
              BlendMode.srcIn,
            ),
          ),
        ),

        const SizedBox(height: 2),

        // Selected label becomes blue
        Text(
          name,
          maxLines: 1,
          style: TextStyle(
            fontSize: 11,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? CommonColors.blue
                : const Color(0xFF778196),
          ),
        ),
      ],
    ),
  );
}
  // Widget navItem(int index, String image,String name) {
  //   return InkWell(
  //     onTap: () => setState(() => currentIndex = index),
  //     child: Column(
  //       children: [
  //         SvgPicture.asset(
  //           image,
  //           color: currentIndex == index ? CommonColors.blue : Colors.grey,
  //         ),
  //         Text(name,style: TextStyle(fontSize: 12, color: currentIndex == index ? CommonColors.blue : Colors.grey,),)
  //       ],
  //     ),
  //   );
  // }
}
