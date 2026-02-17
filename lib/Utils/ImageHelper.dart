import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<dynamic> pickProfileImage(BuildContext context) async {
  return showModalBottomSheet<dynamic>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Photo"),
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);

                if (image == null) {
                  Navigator.pop(context, null);
                  return;
                }

                if (kIsWeb) {
                  // ✅ Read bytes directly from XFile for web
                  final Uint8List bytes = await image.readAsBytes();
                  Navigator.pop(context, bytes);
                } else {
                  // Return File for mobile
                  Navigator.pop(context, File(image.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);

                if (image == null) {
                  Navigator.pop(context, null);
                  return;
                }

                if (kIsWeb) {
                  // Read bytes directly from XFile for web
                  final Uint8List bytes = await image.readAsBytes();
                  Navigator.pop(context, bytes);
                } else {
                  // Return File for mobile
                  Navigator.pop(context, File(image.path));
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
