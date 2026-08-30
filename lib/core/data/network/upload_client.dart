import '../../domain/result.dart';

typedef UploadProgress = void Function(int bytesSent);

abstract interface class UploadClient {
  Future<Result<String>> upload({
    required String filePath,
    required int totalBytes,
    required UploadProgress onProgress,
  });
}
