import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

unAthorizedTokenErrorDialog(BuildContext context, {String? message}) {
  Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () async {
        await APIManager.clearCookies();

        await AuthStorage.clearAuthData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainTab()),
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
            color: CommonColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔌 Icon + Title
               Container(
  width: 42,
  height: 42,
  decoration: const BoxDecoration(
    color: Color(0xFFEEF0F5),
    shape: BoxShape.circle,
  ),
  alignment: Alignment.center,
  child: SvgPicture.asset(
    CommonImagePath.plugdark,
    width: 20,
    height: 20,
    fit: BoxFit.contain,
  ),
),

              const SizedBox(height: 16),
 const Text(
                    "Connect Charger",
                    style: TextStyle(
                      fontSize: 18,
                       fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                   const SizedBox(height: 8),
              /// 📄 Description
              Text(
                message ??
                    "Plug the charging connector into your vehicle to begin charging.",
                textAlign: TextAlign.center,
                style: TextStyle(
                   fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              /// 🚗 Image (replace with your asset)
              Container(
               
                 decoration: BoxDecoration(
                  color: Color(0xFFEEF0F5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 80,right: 80,top: 20,bottom: 20),
                  child: Image.asset(
                    CommonImagePath.carskyblue, // <-- add your image
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔵 Main Button
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10), // ✅ IMPORTANT (creates white border space)
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(12),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black.withOpacity(0.08),
                //       blurRadius: 12,
                //       offset: const Offset(0, 4),
                //     ),
                //   ],
                // ),
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
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child:  Text(
                          "I’ve Connected It",
                          style: TextStyle(fontSize: 14, color: Colors.white, fontFamily: 'Poppins',fontWeight: FontWeight.w800),
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
                        //  Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: CommonColors.black, fontFamily: 'Poppins',),
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
                amount == ""
                    ? "You've consumed ₹${amount ?? ""} (${units ?? ""} unit) so far.\n\n"
                        "Stopping now will end the session and release the charger."
                    : "Stopping now will end the session and release the charger.",
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
Future<bool?> unlockSessionDialog(BuildContext context, {String? message}) {
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
                child:
                    const Icon(Icons.lock_open, color: Colors.blue, size: 28),
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

void showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: gravity ?? ToastGravity.BOTTOM,
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
