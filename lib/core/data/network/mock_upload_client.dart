import 'dart:math';

import '../../domain/app_error.dart';
import '../../domain/result.dart';
import 'upload_client.dart';

class MockUploadClient implements UploadClient {
  MockUploadClient({Random? random}) : _random = random ?? Random();

  static const _steps = 10;
  static const _stepDelay = Duration(milliseconds: 220);
  static const _failureRate = 0.35;

  final Random _random;

  @override
  Future<Result<String>> upload({
    required String filePath,
    required int totalBytes,
    required UploadProgress onProgress,
  }) async {
    final failsAt = _random.nextDouble() < _failureRate
        ? _random.nextInt(_steps - 1) + 1
        : _steps + 1;

    for (var step = 1; step <= _steps; step++) {
      await Future<void>.delayed(_stepDelay);

      if (step == failsAt) {
        return Failure(
          _random.nextBool() ? NetworkError.noInternet : NetworkError.timeout,
        );
      }

      onProgress(totalBytes * step ~/ _steps);
    }

    return Success('mock-${DateTime.now().microsecondsSinceEpoch}');
  }
}
