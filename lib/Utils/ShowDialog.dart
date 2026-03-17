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
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Connect Gun",style: TextStyle(color: CommonColors.black,fontSize: 14),),
        content: Text(message ?? "Please connect gun to the vehicle",style: TextStyle(color: CommonColors.blue,fontSize: 13),),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
            child: const Text("YES",style: TextStyle(color: CommonColors.white,fontSize: 12),),
            onPressed: () {
              Navigator.pop(context, true); // return true
            },
          ),
        ],
      );
    },
  );
}



//Stop session

  Future<bool?> stopSessionDialog(BuildContext context, {String? message}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Stop Session",
          style: TextStyle(color: CommonColors.black, fontSize: 14),
        ),
        content: Text(
          message ?? "Are you sure you want to stop the session?",
          style: TextStyle(color: CommonColors.blue, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CommonColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "YES",
              style: TextStyle(color: CommonColors.white, fontSize: 12),
            ),
            onPressed: () {
              Navigator.pop(context, true); // ✅ YES
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CommonColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "NO",
              style: TextStyle(color: CommonColors.blue, fontSize: 12),
            ),
            onPressed: () {
              Navigator.pop(context, false); // ✅ NO
            },
          ),
        ],
      );
    },
  );
}

//unlock session


  Future<bool?> unlockSessionDialog(BuildContext context, {String? message}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "UnLock Session",
          style: TextStyle(color: CommonColors.black, fontSize: 14),
        ),
        content: Text(
          message ?? "Are you sure you want to unlock the session?",
          style: TextStyle(color: CommonColors.blue, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CommonColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "YES",
              style: TextStyle(color: CommonColors.white, fontSize: 12),
            ),
            onPressed: () {
              Navigator.pop(context, true); // ✅ YES
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CommonColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "NO",
              style: TextStyle(color: CommonColors.blue, fontSize: 12),
            ),
            onPressed: () {
              Navigator.pop(context, false); // ✅ NO
            },
          ),
        ],
      );
    },
  );
}
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