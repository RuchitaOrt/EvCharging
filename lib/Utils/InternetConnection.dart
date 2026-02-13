import 'dart:io';

Future<bool> hasInternetConnection() async {
  bool isInternetAvailable = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isInternetAvailable = true;
      }
    } catch (e) {
      print(e.toString());
    }
    return isInternetAvailable;
  
}
