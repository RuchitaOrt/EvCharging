import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMaps({
  required double latitude,
  required double longitude,
}) async {
  final Uri uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
  );

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
}
