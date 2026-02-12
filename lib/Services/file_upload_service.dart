import 'dart:io';
import 'package:dio/dio.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/UploadResponse.dart';

class FileUploadService {
  final APIManager _apiManager = APIManager();

  Future<UploadResponse> uploadFile({
    required File file,
    String? remarks,
  }) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        "remarks": remarks ?? "",
      });

      final response = await _apiManager.dio.post(
        _apiManager.apiEndPoint(API.fileUpload),
        data: formData,
        options: Options(
          headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        return UploadResponse.fromJson(response.data);
      }

      return UploadResponse(
        success: false,
        message: response.data?['message'] ?? "Upload failed",
      );
    } on DioException catch (e) {
      return UploadResponse(
        success: false,
        message: e.response?.data?['message'] ??
            e.message ??
            "Upload error",
      );
    } catch (e) {
      return UploadResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}
