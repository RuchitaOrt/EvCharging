import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart';

import 'APIManager.dart';

class Utility extends ChangeNotifier {
  //Global data
  //Utility is a Singleton Class
  Utility._privateConstructor();
  static final Utility _instance = Utility._privateConstructor();

  factory Utility() {
    return _instance;
  }
 Future<void> loadAPIConfig() async {
    try {
      final value = await rootBundle.loadString('assets/API-Configuration.json');
      APIManager().loadConfiguration(value);
      print("API config loaded successfully");
    } catch (e) {
      print("Error loading API config: $e");
    }
  }
  // void loadAPIConfig(BuildContext context) {
    
  //   DefaultAssetBundle.of(context)
  //       .loadString('assets/API-Configuration.json')
  //       .then((value) {
  //     APIManager().loadConfiguration(value);
  //   }).catchError((error) {
  //     print('error loading json');
  //   });
  // }

  bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^(?:[+0]9)?[0-9]{10,}$');
    return regex.hasMatch(input) && input.length >= 10;
  }

  bool isValidUsername(String input) {
    return input.length >= 8;
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  // bool validatePasswordFields(TextEditingController passTEC,
  //     TextEditingController cPassTEC, BuildContext context) {
  //   bool passwordMatched = (passTEC.text == cPassTEC.text);
  //   if (passwordMatched == false) {
  //     // ToastUtils.showCustomToast(
  //     //     context, AppAlerts.passMismatch, AppColors.errorColor);
  //   }
  //   return passwordMatched;
  // }

  // bool validatePassword(String value) {
  //   String pattern =
  //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  //   RegExp regExp = new RegExp(pattern);
  //   return regExp.hasMatch(value) && value.length >= 8;
  // }

  String getFileName(String path) {
    return basename(path);
  }

  String getDirName(String path) {
    return dirname(path);
  }

  bool isValidValue(var val) {
    if (val == null) {
      return false;
    }
    return true;
  }

  String setValue(var val) {
    if (val == null) {
      return '';
    }
    return val;
  }

  Function(String) pinCodeValidator = (String val) {
    if (val.isEmpty) {
      return 'Enter Pincode';
    } else if (val.length < 6) {
      return 'Enter Valid Pincode';
    }
    return null;
  };

  Function(String) mobileNoValidator = (String mobileNo) {
    if (mobileNo.isEmpty) {
      return 'Enter Mobile Number';
    } else if (mobileNo.length < 10) {
      return 'Enter Valid Mobile Number';
    }
    return null;
  };

  Function(String) emailValidator = (String value) {
    if (value.isEmpty) {
      return 'Enter Email ID';
    } else if (!Utility().isValidEmail(value)) {
      return 'Enter Valid Email ID';
    }
    return null;
  };

  String getPlatformName() {
    String osName = Platform.operatingSystem;
    print('OS name $osName');
    if (osName == "android") {
      return "Android";
    } else if (osName == "ios") {
      return "iOS";
    }
    return osName;
  }

  showAlert(BuildContext ctx, String title, String message) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Text("$title"),
            content: Text("$message"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  logoutUser(BuildContext ctx) {
    // SPManager().clear().then((value) {
    //   GlobalLists().clearAll();
    //   // temporary redirect to login screen
    //   // navigator.push(MaterialPageRoute(builder: (BuildContext context) => MobileLogin()));
    //   // Navigator.of(ctx)
    //   //     .pushNamedAndRemoveUntil('/mobilLogin', (Route<dynamic> route) => false);

    //   Navigator.pushAndRemoveUntil(
    //       ctx,
    //       MaterialPageRoute(builder: (context) => MobileLogin()),
    //       ModalRoute.withName("/mobilLogin"));
    // });
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
