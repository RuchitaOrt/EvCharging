  import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/SplashScreen.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';



    unAthorizedTokenErrorDialog(BuildContext context, {String? message}) {

  

    Widget okButton = ElevatedButton(
        child: Text("OK"),
        onPressed: () async {
           await APIManager.clearCookies();

         await AuthStorage.clearAuthData(); 
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => MainTab
    ()),
  );
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ev Charging"),
      content: Text(message!),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
Future<bool?> gunConnectorDialog(BuildContext context, {String? message}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: CommonColors.neutral200,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: CommonColors.neutral200,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// 🔌 Icon + Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Image.asset(
                "assets/images/plug.png", // <-- add your image
                height: 25,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 6,),
                
                  const Text(
                    "Connect Charger",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// 📄 Description
              Text(
                message ??
                    "Plug the charging connector into your vehicle to begin charging.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              /// 🚗 Image (replace with your asset)
              Image.asset(
                "assets/images/charging_car.png", // <-- add your image
                height: 160,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              /// 🔵 Main Button
             Container(
  // margin: const EdgeInsets.symmetric(horizontal: 10),
  padding: const EdgeInsets.only(left: 10,right: 10,top: 10), // ✅ IMPORTANT (creates white border space)
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: CommonColors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "I’ve Connected It",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      const SizedBox(height: 10),

              /// ❌ Cancel
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: CommonColors.blue),
                ),
              ),
    ],
  ),
),

              
            ],
          ),
        ),
      );
    },
  );
}



//Stop session

//   Future<bool?> stopSessionDialog(BuildContext context, {String? message}) {
//   return showDialog<bool>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text(
//           "Stop Session",
//           style: TextStyle(color: CommonColors.black, fontSize: 14),
//         ),
//         content: Text(
//           message ?? "Are you sure you want to stop the session?",
//           style: TextStyle(color: CommonColors.blue, fontSize: 13),
//         ),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: CommonColors.blue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "YES",
//               style: TextStyle(color: CommonColors.white, fontSize: 12),
//             ),
//             onPressed: () {
//               Navigator.pop(context, true); // ✅ YES
//             },
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: CommonColors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "NO",
//               style: TextStyle(color: CommonColors.blue, fontSize: 12),
//             ),
//             onPressed: () {
//               Navigator.pop(context, false); // ✅ NO
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
Future<bool?> stopSessionDialog(BuildContext context,
    {String? amount, String? units}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA), // light grey like UI
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// ⚠️ Warning Icon
              Container(
                padding: const EdgeInsets.all(12),
               
                child: const Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 45),
              ),

              const SizedBox(height: 12),

              /// Title
              const Text(
                "Stop Charging?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// Description
              Text(
              amount==""?  "You've consumed ₹${amount ?? ""} (${units ?? ""} unit) so far.\n\n"
                "Stopping now will end the session and release the charger.": "Stopping now will end the session and release the charger.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔴 Stop Charging Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.stop_circle, color: Colors.white),
                    label: const Text(
                      "Stop Charging",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// ⚪ Continue Charging Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.lock_outline, color: Colors.grey),
                    label: const Text(
                      "Continue Charging",
                      style: TextStyle(color: Colors.black87),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
//unlock session
Future<bool?> unlockSessionDialog(BuildContext context,
    {String? message}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// 🔓 Unlock Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_open,
                    color: Colors.blue, size: 28),
              ),

              const SizedBox(height: 12),

              /// Title
              const Text(
                "Unlock Charging?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// Description
              Text(
                message ??
                    "Are you sure you want to unlock the session?\n\n"
                    "This will allow the connector to be removed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔓 Unlock Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.lock_open, color: Colors.white),
                    label: const Text(
                      "Unlock Charging",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true); // ✅ YES
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// ❌ Cancel / Stay Locked
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.lock_outline, color: Colors.grey),
                    label: const Text(
                      "Continue Charging",
                      style: TextStyle(color: Colors.black87),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false); // ❌ NO
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

//   Future<bool?> unlockSessionDialog(BuildContext context, {String? message}) {
//   return showDialog<bool>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text(
//           "UnLock Session",
//           style: TextStyle(color: CommonColors.black, fontSize: 14),
//         ),
//         content: Text(
//           message ?? "Are you sure you want to unlock the session?",
//           style: TextStyle(color: CommonColors.blue, fontSize: 13),
//         ),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: CommonColors.blue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "YES",
//               style: TextStyle(color: CommonColors.white, fontSize: 12),
//             ),
//             onPressed: () {
//               Navigator.pop(context, true); // ✅ YES
//             },
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: CommonColors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text(
//               "NO",
//               style: TextStyle(color: CommonColors.blue, fontSize: 12),
//             ),
//             onPressed: () {
//               Navigator.pop(context, false); // ✅ NO
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
   void showToast(String message) {
    Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black.withOpacity(0.7),
    textColor: Colors.white,
    fontSize: 12.0,
  );
  }
  infoNormalDialog(BuildContext context, {String? message}) {
    Widget okButton = ElevatedButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ev-charging"),
      content: Text(message!),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }