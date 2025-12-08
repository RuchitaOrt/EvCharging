import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
     appBar:
      CommonAppBar(title: "Notifications",),
      
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notificationCard(
            title: "Charging Started",
            desc: "Your vehicle has started charging at Hitech EV Station. Current rate: 4.00 kW.",
            time: "14h",
            primary: "View Session",
            image: CommonImagePath.greencharge,
            dismiss:"Dismiss"
          ),
          _notificationCard(
            title: "Charging Complete",
            desc: "Your charging session is complete. 32 kW added to your battery.",
            time: "14h",
            primary: "View Receipt",
            image: CommonImagePath.chargingcomplete,
            dismiss:""
          ),
          _notificationCard(
            title: "Special Offer",
            desc: "Get 20% off your next charge at PowerLit stations this weekend. Code: WEEKEND20",
            time: "14h",
            primary: "Redeem",
            image: CommonImagePath.specialoffer,
            dismiss:"Dismiss"
          ),
        ],
      ),
    );
  }
  Widget _notificationCard({
  required String title,
  required String desc,
  required String time,
  required String primary,
  required String image,
  required String dismiss
}) {
  return Container(
    padding: const EdgeInsets.only(left: 2,right: 16,bottom: 16),
   
    // decoration: BoxDecoration(
    //   color: CommonColors.neutral50,
    //   // border: Border.all(color: Colors.grey.shade300),
    //   // borderRadius: BorderRadius.circular(14),
    // ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ICON
       Padding(
         padding: const EdgeInsets.only(top: 16),
         child: Image.asset(image),
       ),
        const SizedBox(width: 12),

        // FULL COLUMN
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // TITLE + TIME
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(time, style: const TextStyle(color: Colors.grey)),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // DESCRIPTION
              Text(
                desc,
                style: const TextStyle(color: Colors.black87, height: 1.4),
              ),

              const SizedBox(height: 12),

              // BUTTONS
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      primary,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 10),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      dismiss,
                      style: TextStyle(color: CommonColors.blue),
                    ),
                  ),
                ],
              ),
              Divider(color: CommonColors.hintGrey,thickness: 0.2,)
            ],
          ),
        )
      ],
    ),
  );
}

//   Widget _notificationCard({
//   required String title,
//   required String desc,
//   required String time,
//   required String primary,
// }) {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     margin: const EdgeInsets.only(bottom: 14),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border.all(color: Colors.grey.shade300),
//       borderRadius: BorderRadius.circular(14),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//            Icon(Icons.bolt, color: Colors.green, size: 28),
        
//             Expanded(
//               child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
//             ),
//             Text(time, style: const TextStyle(color: Colors.grey)),
//           ],
//         ),
//         const SizedBox(height: 10),

//         Text(desc, style: const TextStyle(color: Colors.black87)),
//         const SizedBox(height: 12),

//         Row(
//           children: [
//             ElevatedButton(
//                style: ElevatedButton.styleFrom(
//                     backgroundColor: CommonColors.blue,
//                     foregroundColor: CommonColors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: BorderSide(
//                         color: CommonColors.blue.withOpacity(0.4),
//                         width: 0.8,
//                       ),
//                     ),
//                   ),
//               onPressed: () {},
//               child: Text(primary,style: TextStyle(color: CommonColors.white),),
//             ),
//             const SizedBox(width: 10),
//             TextButton(onPressed: () {}, child: const Text("Dismiss",style: TextStyle(color: CommonColors.blue),)),
//           ],
//         )
//       ],
//     ),
//   );
// }

}