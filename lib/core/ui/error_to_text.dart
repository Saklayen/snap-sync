import '../domain/app_error.dart';

String messageFor(AppError error) => switch (error) {
      CameraError() => _cameraMessage(error),
      NetworkError() => _networkMessage(error),
      ApiError() => error.message,
    };

String _cameraMessage(CameraError error) => switch (error) {
      CameraError.permissionDenied =>
        'Camera access is off, so photos cannot be captured.',
      CameraError.permissionPermanentlyDenied =>
        'Camera access is turned off. Enable it in Settings to capture photos.',
      CameraError.noCameraAvailable => 'No back camera was found on this device.',
      CameraError.hardwareFailure => 'The camera could not be started. Try again.',
      CameraError.captureFailed => 'The photo could not be saved. Try again.',
    };

String _networkMessage(NetworkError error) => switch (error) {
      NetworkError.noInternet => 'No internet connection, so uploads are paused.',
      NetworkError.timeout => 'The server took too long to respond.',
      NetworkError.server => 'The server could not accept the upload right now.',
      NetworkError.unknown => 'The upload could not be completed.',
    };
