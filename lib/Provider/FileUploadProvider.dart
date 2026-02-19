import 'dart:io';

import 'package:HyCharge/Services/file_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:HyCharge/model/UploadResponse.dart';


class UploadProvider extends ChangeNotifier {
  final FileUploadService _uploadService = FileUploadService();
 File? selectedImage;
  bool isUploading = false;
  UploadResponse? response;
 

  void setImage(File file) {
    selectedImage = file;
    notifyListeners();
  }
 
  String? error;

Future<UploadResponse?> upload({
  required File file,
  String? remarks,
  bool? isDP
}) async {
  isUploading = true;
  error = null;
  response = null;
  notifyListeners();

  final res = await _uploadService.uploadFile(
    file: file,
    remarks: remarks,
    isDP: isDP
  );

  isUploading = false;

  if (res.success) {
    response = res;
  } else {
    error = res.message ?? "Upload failed";
    response = res; // keep response even on failure (optional but useful)
  }

  notifyListeners();
  return response;
}


  void reset() {
    isUploading = false;
    response = null;
    error = null;
    notifyListeners();
  }
}
