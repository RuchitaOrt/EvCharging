// import 'package:url_launcher/url_launcher.dart';

// Future<void> openGoogleMaps({
//   required double latitude,
//   required double longitude,
// }) async {
//   final Uri uri = Uri.parse(
//     'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
//   );

//   await launchUrl(
//     uri,
//     mode: LaunchMode.externalApplication,
//   );
// }
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

Future<void> openMaps({
  required double latitude,
  required double longitude,
}) async {

  Uri mapUrl;

  if (Platform.isIOS) {
    // Apple Maps
    mapUrl = Uri.parse(
      "http://maps.apple.com/?daddr=$latitude,$longitude",
    );
  } else {
    // Google Maps
    mapUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude",
    );
  }

  if (await canLaunchUrl(mapUrl)) {
    await launchUrl(
      mapUrl,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not open maps';
  }
}

Future<void> openContactPage() async {
  final Uri url = Uri.parse("https://hycharge.in/contact-us");

  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // opens in browser
    );
  } else {
    throw 'Could not launch $url';
  }
}