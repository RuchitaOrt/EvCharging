import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/UploadResponse.dart';

class FileUploadService {
  final APIManager _apiManager = APIManager();

  Future<UploadResponse> uploadFile({
    required dynamic file,
    String? remarks,
    bool? isDP
  }) async {
    try {
      FormData formData;

      /// 🌐 WEB
      if (kIsWeb) {
        if (file is! Uint8List) {
          throw Exception("Web upload expects Uint8List");
        }

        formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(
            file,
            filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.png',
          ),
          "remarks": remarks ?? "",
        });
      }

      /// 📱 ANDROID / IOS
      else {
        final fileName = file.path.split('/').last;

        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
          "remarks": remarks ?? "",
        });
      }

      final response = await _apiManager.dio.post(
        _apiManager.apiEndPoint(API.fileUpload),
        data: formData,
      );

      if (response.statusCode == 200) {
        return UploadResponse.fromJson(response.data);
      }

      return UploadResponse(
        success: false,
        message: response.data?['message'] ?? "Upload failed",
      );
    } catch (e) {
      log('❌ Upload Error: $e');
      return UploadResponse(success: false, message: e.toString());
    }
  }
}
