import 'dart:io';

Future<bool> hasInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 3));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
