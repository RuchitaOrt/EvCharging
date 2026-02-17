import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:HyCharge/Services/file_upload_service.dart';
import 'package:HyCharge/model/UploadResponse.dart';

class UploadProvider extends ChangeNotifier {
  final FileUploadService _uploadService = FileUploadService();

  dynamic selectedImage;
  Uint8List? webImageBytes;

  bool isUploading = false;
  UploadResponse? response;
  String? error;

  /// ✅ Set Image Correctly
  Future<void> setImage(dynamic file) async {
    if (kIsWeb) {
      if (file is Uint8List) {
        webImageBytes = file;
        selectedImage = file;
      } else {
        throw Exception("Web image must be Uint8List");
      }
    } else {
      selectedImage = file; // File for mobile
    }

    notifyListeners();
  }

  /// ✅ Upload
  Future<UploadResponse?> upload({
    required dynamic file,
    String? remarks,
  }) async {
    isUploading = true;
    error = null;
    response = null;
    notifyListeners();

    final res = await _uploadService.uploadFile(
      file: file,
      remarks: remarks,
    );

    isUploading = false;

    if (res.success) {
      response = res;
    } else {
      log('❌ Upload Failed: ${res.message}');
      error = res.message ?? "Upload failed";
      response = res;
    }

    notifyListeners();
    return response;
  }

  void reset() {
    isUploading = false;
    response = null;
    error = null;
    webImageBytes = null;
    selectedImage = null;
    notifyListeners();
  }
}
