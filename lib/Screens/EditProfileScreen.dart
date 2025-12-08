import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: CommonColors.neutral50,
      
    appBar:
      CommonAppBar(title: "Edit Profile",),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Image + Edit Icon
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
          color: CommonColors.neutral200,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Image.asset(CommonImagePath.edit)
      ),
    ),
  ],
),
            const SizedBox(height: 30),

            _inputField("Full Name", "Pratik Bhotia"),
            const SizedBox(height: 20),

            _inputField("Address *", "F no. 462, Inside Surbhi Pride Apt,\nMadhapur, Hyderabad, Telangana"),
            const SizedBox(height: 20),

            _inputField("Phone Number", "+91 6578-236-5798"),
          ],
        ),
      ),
    );
  }
  Widget _inputField(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
   TextField(
  maxLines: label == "Address *" ? 3 : 1,
  decoration: InputDecoration(
    filled: true,
    fillColor: CommonColors.neutral50,
    contentPadding: const EdgeInsets.all(12),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.25), // very light border
        width: 1,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.50), // slightly stronger on focus
        width: 1,
      ),
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.25),
        width: 1,
      ),
    ),
  ),
  controller: TextEditingController(text: value),
)

    ],
  );
}
}
