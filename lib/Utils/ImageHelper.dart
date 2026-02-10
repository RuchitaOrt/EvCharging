import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<File?> pickProfileImage(BuildContext context) async {
  return showModalBottomSheet<File?>(
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
                Navigator.pop(
                    context, image != null ? File(image.path) : null);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(
                    context, image != null ? File(image.path) : null);
              },
            ),
          ],
        ),
      );
    },
  );
}
