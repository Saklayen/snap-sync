sealed class AppError {
  const AppError();
}

enum CameraError implements AppError {
  permissionDenied,
  permissionPermanentlyDenied,
  noCameraAvailable,
  hardwareFailure,
}

enum NetworkError implements AppError {
  noInternet,
  timeout,
  server,
  unknown,
}

class ApiError implements AppError {
  const ApiError({required this.reason, required this.message});

  final String reason;
  final String message;
}
