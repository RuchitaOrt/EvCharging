import 'package:ev_charging_app/Screens/ChargingHistoryScreen.dart';
import 'package:ev_charging_app/Screens/EditProfileScreen.dart';
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/MyVehicleScreen.dart';
import 'package:ev_charging_app/Screens/NotificationScreen.dart';
import 'package:ev_charging_app/Screens/SupportScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/widget/LogoutConfirmationSheet.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      
      appBar:
      CommonAppBar(title: "Profile",onBack: ()  {
Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainTab()),
      );
      },),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(color: CommonColors.neutral50, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
            Stack(
  clipBehavior: Clip.none, // allows edit button to overflow
  children: [
    // Profile Image
    ClipRRect(
      borderRadius: BorderRadius.circular(60), // make circular
      child: Image.asset(
        CommonImagePath.profileImage,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ),
    ),

    // Edit Icon bottom-right
    Positioned(
      bottom: -4,
      right: -4,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: CommonColors.neutral50,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Image.asset(CommonImagePath.edit)
      ),
    ),
  ],
),

              const SizedBox(height: 10),
              const Text('Puerto Rico', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('youremail@domain.com • +91 234 567 89', style: TextStyle(color: Colors.black54)),
            ]),
          ),
          const SizedBox(height: 18),
          // list tiles
          Container(
            decoration: BoxDecoration(color: CommonColors.neutral50, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
             _profileTile(
 CommonImagePath.profileIcon,
  'Edit Profile',
  () {
    Navigator.push(
      routeGlobalKey.currentContext!,
      MaterialPageRoute(builder: (context) => EditProfileScreen()),
    );
  },
),

              _profileTile( CommonImagePath.chargingHistory, 'Charging History',() {
    Navigator.push(
      routeGlobalKey.currentContext!,
      MaterialPageRoute(builder: (context) => ChargingHistoryScreen()),
    );
  },),
              _profileTile( CommonImagePath.paymentOption, 'Payment Options',() {
    // Navigator.push(
    //   routeGlobalKey.currentContext!,
    //   MaterialPageRoute(builder: (context) => EditProfileScreen()),
    // );
  },),
              _profileTile( CommonImagePath.vehicle, 'Vehicle Information',() {
    Navigator.push(
      routeGlobalKey.currentContext!,
      MaterialPageRoute(builder: (context) => MyVehicleScreen()),
    );
  },),
              _profileTile( CommonImagePath.notification, 'Notification',() {
    Navigator.push(
      routeGlobalKey.currentContext!,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
  },),
              _profileTile( CommonImagePath.share, 'Share',() {
    // Navigator.push(
    //   routeGlobalKey.currentContext!,
    //   MaterialPageRoute(builder: (context) => EditProfileScreen()),
    // );
  },),
              _profileTile( CommonImagePath.setting, 'Settings',() {
    Navigator.push(
      routeGlobalKey.currentContext!,
      MaterialPageRoute(builder: (context) => SupportScreen()),
    );
  },),
              _profileTile( CommonImagePath.logout, 'Log out',() {
     showModalBottomSheet(
                    backgroundColor: CommonColors.white,
  context: context,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
  isScrollControlled: true,
  builder: (_) => ConfirmationSheet(
    singleButton: "",
    imagePath: CommonImagePath.logout, // Your SVG/PNG
    isSingleButton: false,
    onBackToHome: ()
    {
      
    },
    onCancel: () => Navigator.pop(context),
    onLogout: () {
      Navigator.pop(context);
      // Handle logout logic
    }, firstbutton: 'Cancel',
    secondButton: 'Logout',
    subHeading: '',
  ),
);
  },),
  Padding(
    padding: const EdgeInsets.only(bottom: 40),
    child: Center(child: Text("Version: 1.0.0",
     style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),)),
  )
            ]),
          )
        ]),
      ),
    );
  }
Widget _profileTile(String icon, String title, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Image.asset(icon,width: 20,height: 20,),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey)
        ],
      ),
    ),
  );
}

}