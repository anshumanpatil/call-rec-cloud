import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class UploadResponse {
  UploadResponse({
    required this.message,
    required this.folder,
    required this.fileName,
    required this.path,
  });

  final String message;
  final String folder;
  final String fileName;
  final String path;

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      message: (json['message'] as String?) ?? 'file uploaded successfully',
      folder: (json['folder'] as String?) ?? '',
      fileName: (json['filename'] as String?) ?? '',
      path: (json['path'] as String?) ?? '',
    );
  }
}

class FileUploadService {
  FileUploadService({Dio? dio, required String baseUrl})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));

  final Dio _dio;

  Future<UploadResponse> uploadFile({
    required String folderName,
    required File file,
  }) async {
    final formData = FormData.fromMap({
      'foldername': folderName,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : 'upload.bin',
      ),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/upload',
      data: formData,
    );

    final data = response.data;
    if (data == null) {
      throw const FileUploadException('Upload failed: empty server response');
    }

    return UploadResponse.fromJson(data);
  }

  Future<UploadResponse> uploadBytes({
    required String folderName,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final formData = FormData.fromMap({
      'foldername': folderName,
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      'http://192.168.1.10:5656/upload',
      data: formData,
    );

    final data = response.data;
    if (data == null) {
      throw const FileUploadException('Upload failed: empty server response');
    }

    return UploadResponse.fromJson(data);
  }

  Future<List<UploadResponse>> uploadFiles({
    required String folderName,
    required List<File> files,
  }) async {
    final uploads = <UploadResponse>[];
    for (final file in files) {
      uploads.add(await uploadFile(folderName: folderName, file: file));
    }
    return uploads;
  }
}

class FileUploadException implements Exception {
  const FileUploadException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
