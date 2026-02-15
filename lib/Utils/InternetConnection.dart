import 'dart:io' show InternetAddress, SocketException;
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternetConnection() async {
  try {
    if (kIsWeb) {
      //  WEB CHECK
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } else {
      //  MOBILE CHECK (REAL INTERNET)
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    }
  } on SocketException catch (_) {
    return false;
  } catch (_) {
    return false;
  }
}
