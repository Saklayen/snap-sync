import 'package:dio/dio.dart';

import '../../domain/app_error.dart';
import '../../domain/result.dart';
import 'upload_client.dart';

class DioUploadClient implements UploadClient {
  DioUploadClient(this._dio, {required this.endpoint});

  final Dio _dio;
  final String endpoint;

  @override
  Future<Result<String>> upload({
    required String filePath,
    required int totalBytes,
    required UploadProgress onProgress,
  }) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: form,
        onSendProgress: (sent, _) => onProgress(sent),
      );

      return Success('${response.data?['id']}');
    } on DioException catch (error) {
      return Failure(_errorFor(error));
    }
  }
}

NetworkError _errorFor(DioException error) => switch (error.type) {
      DioExceptionType.connectionError => NetworkError.noInternet,
      DioExceptionType.connectionTimeout => NetworkError.timeout,
      DioExceptionType.sendTimeout => NetworkError.timeout,
      DioExceptionType.receiveTimeout => NetworkError.timeout,
      DioExceptionType.badResponse => NetworkError.server,
      _ => NetworkError.unknown,
    };
