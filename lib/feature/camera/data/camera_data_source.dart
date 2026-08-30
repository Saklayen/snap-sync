import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/domain/app_error.dart';
import '../../../core/domain/result.dart';

class CameraDataSource {
  CameraController? _controller;
  Future<Result<CameraController>>? _pending;

  Future<Result<CameraController>> start({bool requestPermission = true}) {
    return _pending ??= _start(requestPermission: requestPermission)
        .whenComplete(() => _pending = null);
  }

  Future<Result<CameraController>> _start({required bool requestPermission}) async {
    final permission = requestPermission
        ? await Permission.camera.request()
        : await Permission.camera.status;

    if (permission.isPermanentlyDenied) {
      return const Failure(CameraError.permissionPermanentlyDenied);
    }
    if (!permission.isGranted) {
      return const Failure(CameraError.permissionDenied);
    }

    final existing = _controller;
    if (existing != null && existing.value.isInitialized) {
      return Success(existing);
    }

    await _disposeController();

    final cameras = await availableCameras();
    final back = cameras.where((c) => c.lensDirection == CameraLensDirection.back);
    if (back.isEmpty) {
      return const Failure(CameraError.noCameraAvailable);
    }

    final controller = CameraController(
      back.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
    } on CameraException {
      await controller.dispose();
      return const Failure(CameraError.hardwareFailure);
    } catch (_) {
      await controller.dispose();
      return const Failure(CameraError.hardwareFailure);
    }

    _controller = controller;
    return Success(controller);
  }

  Future<void> stop() async {
    await _pending;
    await _disposeController();
  }

  Future<void> _disposeController() async {
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }
}
