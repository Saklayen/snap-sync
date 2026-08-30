import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/domain/app_error.dart';
import '../../../core/domain/result.dart';
import 'capture_storage.dart';
import 'camera_session.dart';

class CameraDataSource {
  CameraDataSource(this._storage);

  final CaptureStorage _storage;
  CameraController? _controller;
  CameraSession? _session;
  Future<Result<CameraSession>>? _pending;
  double? _queuedZoom;
  bool _isApplyingZoom = false;

  Future<Result<CameraSession>> start({bool requestPermission = true}) {
    return _pending ??= _start(requestPermission: requestPermission)
        .whenComplete(() => _pending = null);
  }

  Future<Result<CameraSession>> _start({required bool requestPermission}) async {
    final permission = requestPermission
        ? await Permission.camera.request()
        : await Permission.camera.status;

    if (permission.isPermanentlyDenied) {
      return const Failure(CameraError.permissionPermanentlyDenied);
    }
    if (!permission.isGranted) {
      return const Failure(CameraError.permissionDenied);
    }

    final existing = _session;
    if (existing != null && existing.controller.value.isInitialized) {
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

    final CameraSession session;
    try {
      await controller.initialize();
      session = CameraSession(
        controller: controller,
        minZoom: await controller.getMinZoomLevel(),
        maxZoom: await controller.getMaxZoomLevel(),
      );
    } on CameraException {
      await controller.dispose();
      return const Failure(CameraError.hardwareFailure);
    } catch (_) {
      await controller.dispose();
      return const Failure(CameraError.hardwareFailure);
    }

    _controller = controller;
    _session = session;
    return Success(session);
  }

  Future<void> setZoom(double level) async {
    _queuedZoom = level;
    if (_isApplyingZoom) return;

    _isApplyingZoom = true;
    while (_queuedZoom != null) {
      final next = _queuedZoom!;
      _queuedZoom = null;
      try {
        await _controller?.setZoomLevel(next);
      } on CameraException {
        break;
      }
    }
    _isApplyingZoom = false;
  }

  Future<void> focusAt(Offset point) async {
    try {
      await _controller?.setFocusPoint(point);
      await _controller?.setExposurePoint(point);
      await _controller?.setFocusMode(FocusMode.locked);
    } on CameraException {
      return;
    }
  }

  Future<Result<String>> capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Failure(CameraError.captureFailed);
    }

    try {
      final shot = await controller.takePicture();
      return Success(await _storage.persist(shot.path));
    } on CameraException {
      return const Failure(CameraError.captureFailed);
    } on FileSystemException {
      return const Failure(CameraError.captureFailed);
    }
  }

  Future<void> releaseFocus() async {
    try {
      await _controller?.setFocusMode(FocusMode.auto);
      await _controller?.setFocusPoint(null);
      await _controller?.setExposurePoint(null);
    } on CameraException {
      return;
    }
  }

  Future<void> stop() async {
    await _pending;
    await _disposeController();
  }

  Future<void> _disposeController() async {
    final controller = _controller;
    _controller = null;
    _session = null;
    _queuedZoom = null;
    await controller?.dispose();
  }
}
