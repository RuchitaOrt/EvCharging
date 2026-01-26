  import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/SplashScreen.dart';
import 'package:ev_charging_app/Utils/APIManager.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';



    unAthorizedTokenErrorDialog(BuildContext context, {String? message}) {

  

    Widget okButton = ElevatedButton(
        child: Text("OK"),
        onPressed: () async {
           await APIManager.clearCookies();

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => MainTab
    ()),
  );
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hyworth Land Survey"),
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

   void showToast(String message) {
    Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
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
      title: Text("Hyworth Land Survey"),
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