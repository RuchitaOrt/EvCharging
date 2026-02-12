import 'dart:typed_data';

import 'package:HyCharge/Services/hardware_master_service.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:flutter/material.dart';

class ImageCacheProvider extends ChangeNotifier {

  final HardwareMasterService _service = HardwareMasterService();
  Uint8List? _imageBytes;
  String? _cachedImageId;
  bool loading = false;

  Uint8List? get image => _imageBytes;

  Future<void> loadProfileImage(String? imageId) async {
    if (imageId == null) return;

    // ✅ already cached & same image
    if (_cachedImageId == imageId && _imageBytes != null) {
      return;
    }

    loading = true;
    notifyListeners();

   Uint8List? imageBytes;
      try {
        imageBytes = await _service.downloadImage(imageId);
      } catch (_) {
        imageBytes = null;
      }

    _imageBytes = imageBytes;
    _cachedImageId = imageId;

    loading = false;
    notifyListeners();
  }

  /// call this AFTER uploading new image
  void setNewImage(Uint8List bytes, String newImageId) {
    _imageBytes = bytes;
    _cachedImageId = newImageId;
    notifyListeners();
  }

  void clear() {
    _imageBytes = null;
    _cachedImageId = null;
  }
}
