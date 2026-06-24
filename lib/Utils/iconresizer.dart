import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getResizedMarker(
    String assetPath, {
      required int width,
    }) async {
  final ByteData data = await rootBundle.load(assetPath);
  final Uint8List bytes = data.buffer.asUint8List();

  final ui.Codec codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: width,
  );

  final ui.FrameInfo frame = await codec.getNextFrame();
  final ByteData? resizedBytes =
  await frame.image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(
    resizedBytes!.buffer.asUint8List(),
  );
}

Future<BitmapDescriptor> createCurrentLocationMarker() async {
  const int canvasSize = 180;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final center = Offset(
    canvasSize / 2,
    canvasSize / 2,
  );

  /// OUTER LIGHT ORANGE CIRCLE
  final outerPaint = Paint()
    ..color = const ui.Color.fromARGB(255, 212, 242, 214).withOpacity(0.35);

  canvas.drawCircle(
    center,
    75,
    outerPaint,
  );

  /// INNER ORANGE CIRCLE
  final innerPaint = Paint()
    ..color = const ui.Color.fromARGB(255, 134, 234, 152);

  canvas.drawCircle(
    center,
    50,
    innerPaint,
  );

  /// LOAD CAR IMAGE
  final ByteData data =
      await rootBundle.load(CommonImagePath.vehicle9);

  final Uint8List bytes = data.buffer.asUint8List();

  final codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: 85, // Increased from 55
    targetHeight: 85,
  );

  final frame = await codec.getNextFrame();
  final image = frame.image;

  /// DRAW CAR IMAGE IN CENTER
  canvas.drawImage(
    image,
    Offset(
      center.dx - image.width / 2,
      center.dy - image.height / 2,
    ),
    Paint(),
  );

  final picture = recorder.endRecording();

  final img = await picture.toImage(
    canvasSize,
    canvasSize,
  );

  final pngBytes = await img.toByteData(
    format: ui.ImageByteFormat.png,
  );

  return BitmapDescriptor.fromBytes(
    pngBytes!.buffer.asUint8List(),
  );
}
// Future<BitmapDescriptor> createCurrentLocationMarker() async {
//   const int size = 120;

//   final recorder = ui.PictureRecorder();
//   final canvas = Canvas(recorder);

//   // Orange circle
//   final Paint circlePaint = Paint()
//     ..color = const ui.Color.fromARGB(255, 238, 124, 17);

//   canvas.drawCircle(
//     const Offset(size / 2, size / 2),
//     size / 2,
//     circlePaint,
//   );

//   // Car image
//   final ByteData data =
//       await rootBundle.load(CommonImagePath.vehicle9);

//   final Uint8List bytes = data.buffer.asUint8List();

//   final codec = await ui.instantiateImageCodec(
//     bytes,
//     targetWidth: 70,
//   );

//   final frame = await codec.getNextFrame();

//   final image = frame.image;

//   canvas.drawImage(
//     image,
//     Offset(
//       (size - image.width) / 2,
//       (size - image.height) / 2,
//     ),
//     Paint(),
//   );

//   final picture = recorder.endRecording();

//   final img = await picture.toImage(size, size);

//   final pngBytes =
//       await img.toByteData(format: ui.ImageByteFormat.png);

//   return BitmapDescriptor.fromBytes(
//     pngBytes!.buffer.asUint8List(),
//   );
// }