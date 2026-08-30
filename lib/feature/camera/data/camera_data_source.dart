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
  List<CameraDescription> _backCameras = const [];
  CameraDescription? _frontCamera;
  int _activeLensIndex = 0;
  bool _isFrontLens = false;
  FlashMode _flashMode = FlashMode.off;

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
    _backCameras = [
      for (final camera in cameras)
        if (camera.lensDirection == CameraLensDirection.back) camera,
    ];
    final frontCameras = [
      for (final camera in cameras)
        if (camera.lensDirection == CameraLensDirection.front) camera,
    ];
    _frontCamera = frontCameras.isEmpty ? null : frontCameras.first;

    if (_backCameras.isEmpty) {
      return const Failure(CameraError.noCameraAvailable);
    }

    _activeLensIndex = _activeLensIndex.clamp(0, _backCameras.length - 1);

    final front = _frontCamera;
    _isFrontLens = _isFrontLens && front != null;

    final controller = CameraController(
      _isFrontLens ? front! : _backCameras[_activeLensIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    final CameraSession session;
    try {
      await controller.initialize();
      await _applyFlash(controller);
      session = CameraSession(
        controller: controller,
        minZoom: await controller.getMinZoomLevel(),
        maxZoom: await controller.getMaxZoomLevel(),
        lensCount: _backCameras.length,
        activeLensIndex: _activeLensIndex,
        canFlip: _frontCamera != null,
        isFrontLens: _isFrontLens,
        flashMode: _flashMode,
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

  Future<void> setFlash(FlashMode mode) async {
    _flashMode = mode;
    await _applyFlash(_controller);
  }

  Future<void> _applyFlash(CameraController? controller) async {
    try {
      await controller?.setFlashMode(_flashMode);
    } on CameraException {
      return;
    }
  }

  Future<Result<CameraSession>> flipLens() async {
    await _pending;
    _isFrontLens = !_isFrontLens;
    await _disposeController();

    return start(requestPermission: false);
  }

  Future<Result<CameraSession>> selectLens(int index) async {
    if (index == _activeLensIndex && !_isFrontLens) {
      final session = _session;
      if (session != null) return Success(session);
    }

    await _pending;
    _activeLensIndex = index;
    _isFrontLens = false;
    await _disposeController();

    return start(requestPermission: false);
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
