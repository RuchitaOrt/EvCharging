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
